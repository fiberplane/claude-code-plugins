#!/bin/bash
# PreToolUse hook for TodoWrite - reminds agent to also update Linear

STATE_FILE=".claude-linear-agent.json"

# Only inject reminder if linear-agent workflow is active
if [ -f "$STATE_FILE" ]; then
  PHASE=$(grep -o '"phase":\s*"[^"]*"' "$STATE_FILE" | sed 's/"phase":\s*"//' | sed 's/"$//')

  # Only remind during coding phase when actively implementing
  if [ "$PHASE" = "coding" ]; then
    cat << 'EOF'
{
  "decision": "allow",
  "hookSpecificOutput": {
    "additionalContext": "[Linear Agent Reminder] You're updating the todo list - also add a comment to the current Linear issue with this progress update. Keep Linear in sync with your work."
  }
}
EOF
    exit 0
  fi
fi

# If no state file or not in coding phase, just allow without reminder
echo '{"decision": "allow"}'
exit 0
