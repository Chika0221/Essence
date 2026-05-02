import os
import shutil
import uuid
import asyncio
import tempfile
import subprocess
import json
from typing import Dict, Any
from fastapi import FastAPI, UploadFile, File, HTTPException, WebSocket, WebSocketDisconnect
from fastapi.responses import StreamingResponse
from faster_whisper import WhisperModel
from pydub import AudioSegment
from contextlib import asynccontextmanager

from helpers.helper import emit_sse, remove_temp_files, split_audio, summarize


ollama_proc = None
whisper_model: WhisperModel

# JOBデータ全部入れるやーつ
JOBS: Dict[str, Dict[str, Any]] = {}

async def transcribe_and_stream(job_id: str) -> None:
    job = JOBS[job_id]
    mode = job["mode"]
    target_path = job["target_path"]

    JOBS[job_id]["status"] = "running"
    chunks = await asyncio.to_thread(split_audio, target_path)

    all_transcripts = []
    all_summaries = []

    print("文字起こし開始...")

    for idx, chunk_path in enumerate(chunks, start=1):

        # whisperによる文字起こし
        def _transcribe_chunk(path: str) -> str:
            segments, _ = whisper_model.transcribe(path, beam_size=5, vad_filter=True)
            return "".join([seg.text for seg in segments])

        chunk_text = await asyncio.to_thread(_transcribe_chunk, chunk_path)
        all_transcripts.append(chunk_text)

        # 文字起こし結果を送信
        job["events"].append(("transcript", {
            "chunk_index": idx,
            "text": chunk_text
        }))

        # チャンクごとの要約
        chunk_summary = await asyncio.to_thread(summarize, chunk_text, mode, "map")
        all_summaries.append(chunk_summary)

        # 部分的な要約を送信
        job["events"].append(("summary_partial", {
            "chunk_index": idx,
            "summary": chunk_summary
        }))

        await asyncio.sleep(0)  # イベントループに処理を戻す

    # 最終要約 (統合)
    final_summary = await asyncio.to_thread(summarize, "\n".join(all_summaries), mode, "reduce")

    job["result"] = {
        "mode": mode,
        "transcript": "\n".join(all_transcripts),
        "summary": final_summary
    }
    job["events"].append(("done", job["result"]))
    job["status"] = "done"


    # 処理が終わったら一時ファイルを削除
    await asyncio.to_thread(remove_temp_files, chunks + [target_path])


def write_temp_wav(data: bytes) -> str:
    temp_chunk = tempfile.NamedTemporaryFile(delete=False, suffix=".wav")
    temp_chunk.write(data)
    temp_chunk_path = temp_chunk.name
    temp_chunk.close()
    return temp_chunk_path



# API起動時、終了時の処理
@asynccontextmanager
async def lifespan(app: FastAPI):
    global ollama_proc
    global whisper_model

    print("ollama起動中...")
    ollama_proc = subprocess.Popen(["ollama", "serve"])
    print("音声認識モデルをロード中...")
    whisper_model = WhisperModel("base", device="cpu", compute_type="int8")

    try:
        yield
    finally:

        print("API終了")
        if ollama_proc and ollama_proc.poll() is None:
            ollama_proc.terminate()
            try:
                ollama_proc.wait(timeout=5)
            except subprocess.TimeoutExpired:
                ollama_proc.kill()


app = FastAPI(title="Record Essence API", lifespan=lifespan)


@app.get("/")
def read_root():
    return {"Hello": "World"}


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
        os.remove(temp_input_path)  # Clean up original AAC file

    job_id = str(uuid.uuid4())
    JOBS[job_id] = {
        "status": "queued",
        "mode": mode,
        "target_path": target_path,
        "events": [],
        "result": None,
    }

    print(f"status: queued, mode: {mode},target_path: {target_path},")

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


@app.websocket("/ws/stream")
async def ws_stream(websocket: WebSocket, mode: str = "minutes"):
    await websocket.accept()

    chunk_index = 0
    all_transcripts = []
    all_summaries = []
    temp_paths = []

    try:
        while True:
            message = await websocket.receive()

            if message.get("type") == "websocket.disconnect":
                break

            if message.get("bytes"):
                chunk_index += 1
                chunk_path = write_temp_wav(message["bytes"])
                temp_paths.append(chunk_path)

                def _transcribe_chunk(path: str) -> str:
                    segments, _ = whisper_model.transcribe(path, beam_size=5, vad_filter=True)
                    return "".join([seg.text for seg in segments])

                chunk_text = await asyncio.to_thread(_transcribe_chunk, chunk_path)
                all_transcripts.append(chunk_text)

                await websocket.send_json({
                    "event": "transcript",
                    "chunk_index": chunk_index,
                    "text": chunk_text
                })

                chunk_summary = await asyncio.to_thread(summarize, chunk_text, mode, "map")
                all_summaries.append(chunk_summary)

                await websocket.send_json({
                    "event": "summary_partial",
                    "chunk_index": chunk_index,
                    "summary": chunk_summary
                })

                await asyncio.sleep(0)
                continue

            if message.get("text"):
                text = message["text"].strip()
                if text.lower() == "finish":
                    break
                try:
                    payload = json.loads(text)
                except json.JSONDecodeError:
                    payload = None

                if isinstance(payload, dict):
                    if payload.get("type") == "finish":
                        break
                    if payload.get("type") == "config" and "mode" in payload:
                        mode = payload["mode"]

    except WebSocketDisconnect:
        pass
    finally:
        final_summary = ""
        if all_summaries:
            final_summary = await asyncio.to_thread(summarize, "\n".join(all_summaries), mode, "reduce")

        result = {
            "mode": mode,
            "transcript": "\n".join(all_transcripts),
            "summary": final_summary
        }

        try:
            await websocket.send_json({"event": "done", "result": result})
        except Exception:
            pass
        await asyncio.to_thread(remove_temp_files, temp_paths)

