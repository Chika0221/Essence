import os
import tempfile
from fastapi import FastAPI, UploadFile, File, HTTPException
from pydantic import BaseModel
from faster_whisper import WhisperModel
import ollama

app = FastAPI(title="Essential Recorder API")

# --- 初期化設定 ---
# Whisperモデルの読み込み（初回のみダウンロードが走ります）
# CPU環境でも動くように "base" または "small" を指定、compute_type="int8"で軽量化
print("音声認識モデルをロード中...")
whisper_model = WhisperModel("base", device="cpu", compute_type="int8")

# Ollamaで使用するモデル名（事前に pull しておいたものを指定）
LLM_MODEL_NAME = "qwen2.5" 

@app.post("/api/v1/process-audio")
async def process_audio(file: UploadFile = File(...)):
    """
    音声ファイルを受け取り、文字起こしと重要事項抽出を行うエンドポイント
    """
    if not file.filename or not file.filename.endswith(('.wav', '.m4a', '.mp3')):
        raise HTTPException(status_code=400, detail="対応していないファイル形式です。")

    # 1. 音声ファイルを一時保存
    try:
        with tempfile.NamedTemporaryFile(delete=False, suffix=".wav") as temp_audio:
            temp_audio.write(await file.read())
            temp_audio_path = temp_audio.name
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"ファイルの保存に失敗しました: {e}")

    try:
        # 2. faster-whisper で文字起こし
        print("文字起こしを開始します...")
        segments, info = whisper_model.transcribe(temp_audio_path, beam_size=5, language="ja")
        
        raw_text = ""
        for segment in segments:
            raw_text += segment.text + " "
            
        if not raw_text.strip():
            raise HTTPException(status_code=400, detail="音声をテキストに変換できませんでした。")

        # 3. Ollama (ローカルLLM) で重要事項を抽出
        print("LLMによる重要事項の抽出を開始します...")
        prompt = f"""
        以下のテキストは会議やメモの音声文字起こしです。
        この内容から、(1)結論 (2)重要なポイント (3)具体的なTodoリスト を抽出し、Markdown形式で出力してください。
        
        【テキスト】
        {raw_text}
        """
        
        response = ollama.chat(model=LLM_MODEL_NAME, messages=[
            {
                'role': 'system',
                'content': 'あなたは超優秀な秘書です。提供されたテキストから重要なエッセンスだけを抽出します。'
            },
            {
                'role': 'user',
                'content': prompt
            }
        ])
        
        essential_summary = response['message']['content']

        # 4. 結果を返却
        return {
            "status": "success",
            "raw_text": raw_text.strip(),
            "essential_summary": essential_summary
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"処理中にエラーが発生しました: {e}")
        
    finally:
        # 処理が終わったら一時ファイルを削除
        if os.path.exists(temp_audio_path):
            os.remove(temp_audio_path)