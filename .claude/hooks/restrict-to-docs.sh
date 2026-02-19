#!/bin/bash
#
# Claude Code PreToolUse hook - docs/ 以外への書き込みを制限する
# Edit/Write ツールが docs/ ディレクトリ外のファイルを操作しようとした場合にブロックする
#

INPUT=$(cat)

# ツール名と対象ファイルパスを取得
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')
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
echo "ブロック: docs/ ディレクトリ外のファイルは編集できません。"
echo "対象ファイル: $FILE_PATH"
echo "許可されている範囲: $DOCS_DIR"
exit 2
