import os
import uuid
import json
import asyncio

import shutil
from typing import Dict, Any, List

from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import StreamingResponse
from faster_whisper import WhisperModel


app = FastAPI(title="Record Essence API")



print("Loading whisper model...")
whisper_model = WhisperModel("small", device="cpu", compute_type="int8")

# --- helpers ---------------------------------------------------------









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

