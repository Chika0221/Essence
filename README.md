# Essence

録音した音声を文字起こしし、会議やメモから重要事項を抽出するためのアプリケーションです。

Flutter製のクライアントと、Python + FastAPIで構築したローカルAPIから構成されます。音声認識には `faster-whisper`、要約・重要事項の抽出にはローカルLLM実行環境の Ollama を使用する設計です。

> **開発状況**: 現在のFlutter画面は初期のカウンターサンプルをベースにしたプロトタイプです。音声録音・履歴管理などのUI機能は、今後仕様書に沿って実装予定です。一方、音声ファイルを受け取り、文字起こしと重要事項抽出を行うローカルAPIの基本処理は実装されています。

## 主な機能

- 音声ファイル（`.wav`、`.m4a`、`.mp3`）の受け付け
- `faster-whisper` による日本語音声の文字起こし
- Ollama と `qwen2.5` による重要事項の抽出
- 結論・重要なポイント・具体的なTodoをMarkdown形式で生成
- 音声データを一時ファイルとして処理し、処理後に削除
- Flutterによるクロスプラットフォームアプリ基盤

## システム構成

```text
Flutterアプリ
    │ 音声ファイルをHTTP POST
    ▼
FastAPI ローカルAPI
    ├─ faster-whisper：音声認識
    └─ Ollama：要約・重要事項抽出
```

### 使用技術

| 分類 | 技術 |
| --- | --- |
| クライアント | Flutter / Dart |
| API | Python / FastAPI |
| 音声認識 | faster-whisper |
| ローカルLLM | Ollama / qwen2.5 |
| テスト | Flutter widget test |

## ディレクトリ構成

```text
.
├── Infrastructure/
│   └── api/
│       └── record_essence_api.py  # FastAPIによる音声処理API
├── docs/
│   └── specification.md           # システム仕様書
├── lib/
│   └── main.dart                  # Flutterアプリのエントリーポイント
├── test/
│   └── widget_test.dart           # Flutterウィジェットテスト
├── pubspec.yaml                   # Flutter依存関係・プロジェクト設定
└── README.md
```

## 必要な環境

- Flutter SDK
- Dart SDK（`pubspec.yaml` の指定に対応するバージョン）
- Python 3.10 以降を推奨
- Ollama
- Ollamaに `qwen2.5` モデルをインストール済みであること

## セットアップ

### 1. リポジトリを取得

```bash
git clone https://github.com/Chika0221/Essence.git
cd Essence
```

### 2. Flutterプロジェクトをセットアップ

```bash
flutter pub get
```

アプリを起動するには、接続されたデバイスまたは利用可能なデスクトップ環境で次を実行します。

```bash
flutter run
```

### 3. Python APIのセットアップ

API用の仮想環境を作成し、必要なパッケージをインストールします。

```bash
cd Infrastructure/api
python -m venv .venv
```

#### macOS / Linux

```bash
source .venv/bin/activate
pip install fastapi uvicorn python-multipart faster-whisper ollama
```

#### Windows PowerShell

```powershell
.venv\Scripts\Activate.ps1
pip install fastapi uvicorn python-multipart faster-whisper ollama
```

### 4. Ollamaの準備

Ollamaを起動し、APIで使用するモデルを取得します。

```bash
ollama pull qwen2.5
```

### 5. FastAPIを起動

```bash
uvicorn record_essence_api:app --reload --host 127.0.0.1 --port 8000
```

初回起動時には `faster-whisper` のモデル読み込みまたはダウンロードが発生する場合があります。

## API仕様

### `POST /api/v1/process-audio`

音声ファイルを受け取り、文字起こしと重要事項抽出を実行します。

#### リクエスト

`multipart/form-data` 形式で `file` フィールドに音声ファイルを指定します。

```bash
curl -X POST http://127.0.0.1:8000/api/v1/process-audio \
  -F "file=@meeting.wav"
```

#### 成功レスポンス

```json
{
  "status": "success",
  "raw_text": "本日は会議の内容です...",
  "essential_summary": "## 結論\n...\n## Todo\n- [ ] 資料を作成する"
}
```

対応している拡張子は `.wav`、`.m4a`、`.mp3` です。ファイル形式が不正な場合や、音声からテキストを取得できない場合はエラーを返します。

## 今後の実装予定

`docs/specification.md` に定義されている以下の機能を順次実装する予定です。

- マイクからの録音開始・停止
- 録音時間や録音状態の表示
- 録音音声のFlutterからFastAPIへの送信
- 文字起こし中・要約中などの処理ステータス表示
- 重要事項と文字起こし全文の結果画面
- 結果のローカル保存と履歴一覧
- テキストのクリップボードへのコピー
- 結果の削除・管理機能

## テスト

Flutterのテストを実行できます。

```bash
flutter test
```

現在は、初期画面のカウンターがボタン操作で増加することを確認するウィジェットテストが含まれています。

## プライバシー

本プロジェクトは、音声認識と要約処理をローカル環境で完結させることを目標としています。現在のAPI実装では、受信した音声を一時ファイルとして処理し、処理完了後に削除します。

ただし、完全なオフライン動作やデータ保存方針は開発中です。利用環境や今後追加される機能によって動作が変わる可能性があります。

## 仕様書

詳細なシステム要件・API仕様・画面設計については、以下を参照してください。

- [システム仕様書](docs/specification.md)
