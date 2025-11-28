#!/bin/bash
# Post a message to Slack using the webhook URL from state file
# Usage: slack-update.sh "Your message here"

STATE_FILE=".claude-linear-agent.json"
MESSAGE="$1"

if [ -z "$MESSAGE" ]; then
  echo "Usage: slack-update.sh \"message\"" >&2
  exit 1
fi

if [ ! -f "$STATE_FILE" ]; then
  echo "Error: $STATE_FILE not found" >&2
  exit 1
fi

WEBHOOK_URL=$(grep -o '"slackWebhookUrl":\s*"[^"]*"' "$STATE_FILE" | sed 's/"slackWebhookUrl":\s*"//' | sed 's/"$//')

if [ -z "$WEBHOOK_URL" ]; then
  echo "Error: slackWebhookUrl not found in $STATE_FILE" >&2
  exit 1
fi

curl -s -X POST -H 'Content-Type: application/json' \
  --data "{\"text\":\"$MESSAGE\"}" \
  "$WEBHOOK_URL"
