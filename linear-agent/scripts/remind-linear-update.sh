#!/bin/bash
# PreToolUse hook for TodoWrite - reminds agent to post updates to Linear and Slack

STATE_FILE=".claude-linear-agent.json"

# Only inject reminder if linear-agent workflow is active
if [ -f "$STATE_FILE" ]; then
  PHASE=$(grep -o '"phase":\s*"[^"]*"' "$STATE_FILE" | sed 's/"phase":\s*"//' | sed 's/"$//')
  LINEAR_ID=$(grep -o '"linearId":\s*"[^"]*"' "$STATE_FILE" | sed 's/"linearId":\s*"//' | sed 's/"$//')
  HAS_SLACK=$(grep -q '"slackWebhookUrl"' "$STATE_FILE" && echo "true" || echo "false")

  # Only remind during coding phase when actively implementing
  if [ "$PHASE" = "coding" ]; then
    SLACK_URL=$(grep -o '"slackWebhookUrl":\s*"[^"]*"' "$STATE_FILE" | sed 's/"slackWebhookUrl":\s*"//' | sed 's/"$//')
    if [ "$HAS_SLACK" = "true" ]; then
      cat << EOF
{
  "hookSpecificOutput": {
    "additionalContext": "[ACTION REQUIRED] You just updated todos. BEFORE doing anything else: 1) Post comment to Linear issue $LINEAR_ID with this update. 2) Post to Slack - webhook URL is: $SLACK_URL"
  }
}
EOF
    else
      cat << EOF
{
  "hookSpecificOutput": {
    "additionalContext": "[ACTION REQUIRED] You just updated todos. BEFORE doing anything else, post a comment to Linear issue $LINEAR_ID with this update."
  }
}
EOF
    fi
    exit 0
  fi
fi

# If no state file or not in coding phase, just allow without reminder
echo '{"decision": "allow"}'
exit 0
