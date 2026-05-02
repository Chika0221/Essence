import json
import os
import ollama
from typing import Dict, Any, List
from pydub import AudioSegment
import tempfile

LLM_MODEL_NAME = "granite4.1:3b"
# PROMPTS_PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "prompts.json"))
PROMPTS_PATH = "helpers/prompts.json"
_PROMPTS_CACHE: Dict[str, Any] = {}


def load_prompts() -> Dict[str, Any]:
    global _PROMPTS_CACHE
    if _PROMPTS_CACHE == {}:
        with open(PROMPTS_PATH, "r", encoding="utf-8") as f:
            _PROMPTS_CACHE = json.load(f)
    return _PROMPTS_CACHE


def get_mode_prompt(mode: str, stage: str) -> Dict[str, str]:
    prompts = load_prompts()
    modes = prompts.get("modes", {})
    if mode not in modes:
        raise ValueError(f"Unsupported mode: {mode}")
    if stage not in ("map", "reduce"):
        raise ValueError(f"Unsupported stage: {stage}")
    return modes[mode]

# Streamメッセージ整形
def emit_sse(event: str, data: Dict[str, Any]) -> str:
    return f"event: {event}\ndata: {json.dumps(data, ensure_ascii=False)}\n\n"


# 音声分割
def split_audio(path: str, chunk_ms: int = 5 * 60 * 1000) -> List[str]:

    print("音声ファイルの分割...")

    audio = AudioSegment.from_file(path)
    chunk_paths: List[str] = []

    for start in range(0, len(audio),chunk_ms):
        print("分割ゥ!!")
        end = min(start + chunk_ms, len(audio))
        chunk = audio[start:end]
        temp_chunk = tempfile.NamedTemporaryFile(delete=False, suffix=".wav")
        temp_chunk_path = temp_chunk.name
        temp_chunk.close()

        chunk.export(temp_chunk_path, format="wav")
        chunk_paths.append(temp_chunk_path)

    return chunk_paths


# 要約
def summarize(text: str, mode: str, stage: str = "map") -> str:

    mode_prompt = get_mode_prompt(mode, stage)
    role_prompt = mode_prompt.get("role", "")
    if stage == "reduce":
        instruction = mode_prompt.get("reduce_prompt", "")
    else:
        instruction = mode_prompt.get("map_prompt", "")

    user_message = f"{instruction}\n\n---\n{text}"

    messages = []
    if role_prompt:
        messages.append({"role": "system", "content": role_prompt})
    messages.append({"role": "user", "content": user_message})

    response = ollama.chat(model=LLM_MODEL_NAME, messages=messages)

    raw_text = response["message"]["content"]

    return raw_text


def remove_temp_files(temp_paths: List[str]):
    for path in temp_paths:
        if os.path.exists(path):
            os.remove(path)