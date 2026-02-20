#!/bin/bash
#
# Claude Code PreToolUse hook - サブエージェントのみ docs/ 外への書き込みを制限する
# メインエージェントは全ファイル編集可能
#

INPUT=$(cat)

# transcript_path でメイン/サブを判定
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // ""')

# メインエージェントならスルー（何でも編集OK）
if [[ "$TRANSCRIPT_PATH" != *"/subagents/"* ]]; then
  exit 0
fi

# --- 以下はサブエージェントのみ ---

# 対象ファイルパスを取得
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')

# file_path がない場合はスルー
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# プロジェクトルートを取得
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
DOCS_DIR="$PROJECT_DIR/docs"

# 相対パスを絶対パスに変換
if [[ "$FILE_PATH" != /* ]]; then
  FILE_PATH="$PROJECT_DIR/$FILE_PATH"
fi

# docs/ 配下かどうかチェック
if [[ "$FILE_PATH" == "$DOCS_DIR"/* ]] || [[ "$FILE_PATH" == "$DOCS_DIR" ]]; then
  exit 0
fi

# docs/ 外への書き込みをブロック
echo "ブロック: サブエージェントは docs/ ディレクトリ外のファイルを編集できません。"
echo "対象ファイル: $FILE_PATH"
echo "許可されている範囲: $DOCS_DIR"
exit 2
