#!/bin/bash
# PreToolUse hook for TodoWrite/Task - reminds agent to post updates to Linear

STATE_FILE=".claude-linear-agent.json"

# Only inject reminder if linear-agent workflow is active
if [ -f "$STATE_FILE" ]; then
  PHASE=$(grep -o '"phase":\s*"[^"]*"' "$STATE_FILE" | sed 's/"phase":\s*"//' | sed 's/"$//')
  LINEAR_ID=$(grep -o '"linearId":\s*"[^"]*"' "$STATE_FILE" | sed 's/"linearId":\s*"//' | sed 's/"$//')

  # Only remind during coding phase when actively implementing
  if [ "$PHASE" = "coding" ]; then
    cat << EOF
{
  "decision": "allow",
  "hookSpecificOutput": {
    "additionalContext": "[Linear Update Required] 1) Update issue status if changed (e.g. mark In Progress, Done). 2) Post a comment to $LINEAR_ID: what you're doing and why (2-3 sentences max). Example: 'Starting auth middleware. Need to validate JWT tokens before route handlers run.'"
  }
}
EOF
    exit 0
  fi
fi

# If no state file or not in coding phase, just allow without reminder
echo '{"decision": "allow"}'
exit 0
