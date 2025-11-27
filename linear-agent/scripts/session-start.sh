#!/bin/bash
# Session start hook for linear-agent plugin
# Injects context to trigger the linear-agent skill workflow

STATE_FILE=".claude-linear-agent.json"

# Check if state file exists in current project
if [ -f "$STATE_FILE" ]; then
  PHASE=$(grep -o '"phase":\s*"[^"]*"' "$STATE_FILE" | sed 's/"phase":\s*"//' | sed 's/"$//')
  LINEAR_ID=$(grep -o '"linearId":\s*"[^"]*"' "$STATE_FILE" | sed 's/"linearId":\s*"//' | sed 's/"$//')

  case "$PHASE" in
    "planning")
      cat << EOF
{
  "hookSpecificOutput": {
    "additionalContext": "Linear agent state detected (phase: planning). Project/Issue ID: $LINEAR_ID. The linear-agent skill should activate to continue breaking down the brief into Linear issues."
  }
}
EOF
      ;;
    "scaffolding")
      cat << EOF
{
  "hookSpecificOutput": {
    "additionalContext": "Linear agent state detected (phase: scaffolding). Project/Issue ID: $LINEAR_ID. The linear-agent skill should activate to create the scaffold - test stubs, types, and directory structure for all features."
  }
}
EOF
      ;;
    "coding")
      cat << EOF
{
  "hookSpecificOutput": {
    "additionalContext": "Linear agent state detected (phase: coding). Project/Issue ID: $LINEAR_ID. The linear-agent skill should activate to continue implementing features - fetch issues from Linear, select next task, and implement."
  }
}
EOF
      ;;
    *)
      # Unknown phase, let skill figure it out
      cat << EOF
{
  "hookSpecificOutput": {
    "additionalContext": "Linear agent state detected. Project/Issue ID: $LINEAR_ID. The linear-agent skill should activate."
  }
}
EOF
      ;;
  esac
fi

exit 0
