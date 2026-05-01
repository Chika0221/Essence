import os
import uuid
import json
import asyncio
import tempfile
import shutil
from typing import Dict, Any, List

from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import StreamingResponse
from faster_whisper import WhisperModel
from pydub import AudioSegment

app = FastAPI(title="Record Essence API")

# JOBデータ全部入れるやーつ
JOBS: Dict[str, Dict[str, Any]] = {}

print("Loading whisper model...")
whisper_model = WhisperModel("small", device="cpu", compute_type="int8")

# --- helpers ---------------------------------------------------------

def emit_sse(event: str, data: Dict[str, Any]) -> str:
    return f"event: {event}\ndata: {json.dumps(data, ensure_ascii=False)}\n\n"

def split_audio_stub(path: str, chunk_ms: int = 5 * 60 * 1000) -> List[str]:
    audio = AudioSegment.from_file(path)
    chunk_paths: List[str] = []

    for start in range(0, len(audio),chunk_ms):
        end = min(start + chunk_ms, len(audio))
        chunk = audio[start:end]
        temp_chunk = tempfile.NamedTemporaryFile(delete=False, suffix=".wav")
        temp_chunk_path = temp_chunk.name
        temp_chunk.close()

        chunk.export(temp_chunk_path, format="wav")
        chunk_paths.append(temp_chunk_path)
    
    return [path]

def summarize_stub(text: str, mode: str) -> str:
    """要約のスタブです。実際のOllama呼び出しに置き換えてください。"""
    if mode == "minutes":
        return f"[議事録風]\n{text[:200]}..."
    if mode == "actions":
        return f"[要点+アクション]\n{text[:200]}..."
    return f"[箇条書き]\n{text[:200]}..."

async def transcribe_and_stream(job_id: str) -> None:
    job = JOBS[job_id]
    mode = job["mode"]
    target_path = job["target_path"]

    JOBS[job_id]["status"] = "running"
    chunks = split_audio_stub(target_path)

    all_transcripts = []
    all_summaries = []

    for idx, chunk_path in enumerate(chunks, start=1):
        # whisperによる文字起こし
        segments, _ = whisper_model.transcribe(chunk_path, beam_size=5)
        chunk_text = "".join([seg.text for seg in segments])
        all_transcripts.append(chunk_text)

        # 文字起こし結果を送信
        job["events"].append(("transcript", {
            "chunk_index": idx,
            "text": chunk_text
        }))

        # チャンクごとの要約
        chunk_summary = summarize_stub(chunk_text, mode)
        all_summaries.append(chunk_summary)

        # 部分的な要約を送信
        job["events"].append(("summary_partial", {
            "chunk_index": idx,
            "summary": chunk_summary
        }))

        await asyncio.sleep(0)  # イベントループに処理を戻す

    # 最終要約 (統合)
    final_summary = summarize_stub("\n".join(all_summaries), mode)

    job["result"] = {
        "mode": mode,
        "transcript": "\n".join(all_transcripts),
        "summary": final_summary
    }
    job["events"].append(("done", job["result"]))
    job["status"] = "done"

# --- endpoints ---

@app.post("/api/v1/process-audio")
async def process_audio(
    file: UploadFile = File(...),
    mode: str = "minutes"
):
    valid_extensions = (".wav", ".m4a", ".mp3", ".aac")
    filename = file.filename or ""
    if not filename.lower().endswith(valid_extensions):
        raise HTTPException(status_code=400, detail="Unsupported file type.")

    # ファイルを一時保存
    try:
        with tempfile.NamedTemporaryFile(delete=False, suffix=os.path.splitext(filename)[1]) as temp_input:
            shutil.copyfileobj(file.file, temp_input)
            temp_input_path = temp_input.name
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Save failed: {e}")

    # AACからWAVに変換
    target_path = temp_input_path
    if filename.lower().endswith(".aac"):
        audio = AudioSegment.from_file(temp_input_path, format="aac")
        temp_wav = tempfile.NamedTemporaryFile(delete=False, suffix=".wav")
        target_path = temp_wav.name
        temp_wav.close()
        audio.export(target_path, format="wav")

    job_id = str(uuid.uuid4())
    JOBS[job_id] = {
        "status": "queued",
        "mode": mode,
        "target_path": target_path,
        "events": [],
        "result": None,
    }

    # バックグラウンドタスクの開始
    asyncio.create_task(transcribe_and_stream(job_id))

    return {"job_id": job_id, "status": "queued"}

@app.get("/api/v1/stream/{job_id}")
async def stream(job_id: str):
    if job_id not in JOBS:
        raise HTTPException(status_code=404, detail="Job not found.")

    async def event_generator():
        last_index = 0
        while True:
            job = JOBS[job_id]
            # 新しいイベントを送信
            while last_index < len(job["events"]):
                event, data = job["events"][last_index]
                last_index += 1
                yield emit_sse(event, data)

            if job["status"] == "done":
                break

            await asyncio.sleep(0.2)

    return StreamingResponse(event_generator(), media_type="text/event-stream")

@app.get("/api/v1/result/{job_id}")
async def result(job_id: str):
    if job_id not in JOBS:
        raise HTTPException(status_code=404, detail="Job not found.")
    job = JOBS[job_id]
    if job["status"] != "done":
        return {"status": job["status"]}
    return {"status": "done", "result": job["result"]}