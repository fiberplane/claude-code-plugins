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
    if [ "$HAS_SLACK" = "true" ]; then
      cat << EOF
{
  "decision": "allow",
  "hookSpecificOutput": {
    "additionalContext": "[Linear + Slack Update Required] 1) Update issue status if changed. 2) Post a comment to $LINEAR_ID: what you're doing and why (2-3 sentences). 3) Post same update to Slack via curl to the webhook URL in state file."
  }
}
EOF
    else
      cat << EOF
{
  "decision": "allow",
  "hookSpecificOutput": {
    "additionalContext": "[Linear Update Required] 1) Update issue status if changed (e.g. mark In Progress, Done). 2) Post a comment to $LINEAR_ID: what you're doing and why (2-3 sentences max)."
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
