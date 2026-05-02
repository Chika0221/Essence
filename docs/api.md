# Record Essence API

Base URL: http://<host>

## 概要
このAPIは2つのワークフローを提供します。
- HTTPアップロード: 録音完了後の音声を処理し、SSEで部分結果を配信。
- WebSocketストリーミング: 録音中にWAVチャンクを送信し、文字起こしと要約をリアルタイムで受信。

## HTTP API

### POST /api/v1/process-audio
音声ファイルをアップロードしてバックグラウンド処理を開始します。

Request
- Content-Type: multipart/form-data
- Fields:
  - file: 音声ファイル (.wav, .m4a, .mp3, .aac)
  - mode (任意): 要約モード (既定: minutes)

Example (curl)
```
curl -X POST "http://<host>/api/v1/process-audio?mode=minutes" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@/path/to/audio.wav"
```

Response (200)
{
  "job_id": "<uuid>",
  "status": "queued"
}

Errors
- 400: Unsupported file type
- 500: Save failed

### GET /api/v1/stream/{job_id}
部分結果のSSEストリームです。

Response headers
- Content-Type: text/event-stream

SSEフォーマット
- 1イベントは以下の形式で送られます。
  - event: <event_name>
  - data: <json>
  - 空行で区切り

Example (SSE raw)
```
event: transcript
data: {"chunk_index":1,"text":"..."}

event: summary_partial
data: {"chunk_index":1,"summary":"..."}

event: done
data: {"mode":"minutes","transcript":"...","summary":"..."}

```

Events
- transcript
  {
    "chunk_index": 1,
    "text": "..."
  }
- summary_partial
  {
    "chunk_index": 1,
    "summary": "..."
  }
- done
  {
    "mode": "minutes",
    "transcript": "...",
    "summary": "..."
  }

### GET /api/v1/result/{job_id}
最終結果を取得します。

Response (running)
{
  "status": "running"
}

Response (done)
{
  "status": "done",
  "result": {
    "mode": "minutes",
    "transcript": "...",
    "summary": "..."
  }
}

Errors
- 404: Job not found

## WebSocket API

### WS /ws/stream?mode=minutes
録音中のWAVチャンクを送信し、部分結果を受け取ります。

接続
- URL: ws://<host>/ws/stream?mode=minutes
- modeはクエリで指定可能。途中で変更する場合はconfigメッセージを送信。

WAV要件
- 推奨: PCM16LE, 16kHz, mono
- 1チャンクは2〜3分程度
- 1チャンクは「完全なWAVファイル」として送信
- 連結したストリームWAVではなく、チャンクごとに独立したWAVにする

Client -> Server
- Binary: WAVチャンクのバイト列 (推奨: PCM16LE, 16kHz, mono)
- Text: "finish" または JSON {"type":"finish"}
- 任意の設定: JSON {"type":"config","mode":"minutes"}

Client -> Server (JSON例)
```
{"type":"config","mode":"minutes"}
```
```
{"type":"finish"}
```

Server -> Client (JSON)
- transcript
  {
    "event": "transcript",
    "chunk_index": 1,
    "text": "..."
  }
- summary_partial
  {
    "event": "summary_partial",
    "chunk_index": 1,
    "summary": "..."
  }
- done
  {
    "event": "done",
    "result": {
      "mode": "minutes",
      "transcript": "...",
      "summary": "..."
    }
  }

処理フロー例
1. WebSocketに接続
2. 2〜3分分のWAVチャンクをバイナリ送信
3. サーバから transcript / summary_partial を受信
4. 2〜3分ごとに同様に送信を継続
5. 録音終了時に "finish" を送信
6. done を受信して完了

補足
- チャンク送信間隔は2〜3分を想定しています。
- チャンク境界の精度を上げたい場合は、少しだけ重複を入れて送信してください。
