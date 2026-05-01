import os
import shutil
import tempfile

from fastapi import *
from faster_whisper import *
from pydub import AudioSegment

app = FastAPI(title="Record Essence API")

print("音声認識モデルのロード...")
whisper_model = WhisperModel("base", device = "cpu", compute_type = "int8")


@app.post("/api/v1/process-audio")
async def process_audio(file: UploadFile = File(...)):
    # 拡張子のバリデーション
    filename = file.filename or ""
    valid_extensions = (".wav", ".m4a", ".mp3", ".aac")
    
    if not filename.lower().endswith(valid_extensions):
        raise HTTPException(status_code=400, detail="対応していないファイル形式です。")

    # 1. 音声ファイルを一時保存
    try:
        with tempfile.NamedTemporaryFile(delete=False, suffix=os.path.splitext(filename)[1]) as temp_input:
            shutil.copyfileobj(file.file, temp_input)
            temp_input_path = temp_input.name
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"ファイルの保存に失敗: {e}")


    try:
        target_path = temp_input_path

        # 2. AACの場合はWAVに変換（Whisperで処理するため）
        if filename.lower().endswith(".aac"):
            print("AAC形式を変換中...")
            audio = AudioSegment.from_file(temp_input_path, format="aac")
            temp_wav = tempfile.NamedTemporaryFile(delete=False, suffix=".wav")
            target_path = temp_wav.name
            temp_wav.close()
            audio.export(target_path, format="wav")

        # 3. 文字起こし
        print("文字起こしを開始します...")
        segments, info = whisper_model.transcribe(target_path, beam_size=5)
        raw_text = "".join([segment.text for segment in segments])

        return {"status": "success", "text": raw_text}
    finally:
        # 一時ファイルの削除
        if os.path.exists(temp_input_path):
            os.remove(temp_input_path)
        if 'temp_wav' in locals() and os.path.exists(target_path):
            os.remove(target_path)


@app.post("/api/v1/abstract")
async def abstract():
    pass
