from fastapi import *
import ollama

LLM_MODEL_NAME = "functiongemma:270m"

app = FastAPI(title="ollama API")


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