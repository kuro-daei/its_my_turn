#!/bin/bash
#
# Claude Code TaskCompleted hook - Slack notification
# タスク完了時に Slack に通知を送る
#

# プロジェクトの .env から環境変数を読み込む
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
if [ -f "$PROJECT_DIR/.env" ]; then
  set -a
  source "$PROJECT_DIR/.env"
  set +a
fi

# stdin から hook イベントデータを読み取る
INPUT=$(cat)

TASK_SUBJECT=$(echo "$INPUT" | jq -r '.task_subject // "タスク"')
TASK_ID=$(echo "$INPUT" | jq -r '.task_id // ""')

# Webhook URL (環境変数から取得)
SLACK_WEBHOOK="${SLACK_WEBHOOK_URL}"

if [ -z "$SLACK_WEBHOOK" ]; then
  # 環境変数がない場合はスキップ
  exit 0
fi

PAYLOAD=$(cat <<EOF
{
  "text": "Task Completed: $TASK_SUBJECT",
  "blocks": [
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Task Completed*\n*Subject:* $TASK_SUBJECT\n*ID:* $TASK_ID"
      }
    }
  ]
}
EOF
)

curl -s -X POST "$SLACK_WEBHOOK" \
  -H 'Content-Type: application/json' \
  -d "$PAYLOAD" > /dev/null 2>&1

exit 0
