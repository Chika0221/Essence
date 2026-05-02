import subprocess
from fastapi import *
# from fastapi.testclient import TestClient
from contextlib import asynccontextmanager
import ollama

LLM_MODEL_NAME = "granite4.1:3b"
ollama_proc = None

@asynccontextmanager
async def lifespan(app: FastAPI):
    global ollama_proc
    ollama_proc = subprocess.Popen(["ollama", "serve"])
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

app = FastAPI(title="ollama API", lifespan=lifespan)


@app.post("/api/v1/ollama")
async def chat_llm(msg: str):

    raw_text = ""

    response = ollama.chat(model=LLM_MODEL_NAME,messages=[
        {
            "role": "user",
            "content": msg
        }
    ])

    raw_text = response["message"]["content"]

    return raw_text