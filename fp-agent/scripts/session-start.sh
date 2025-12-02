#!/bin/bash
# FP SessionStart hook - register agent and load context

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id')

# Check if .fp directory exists
if [ ! -d ".fp" ]; then
  exit 0
fi

# Register agent and get identity
agent_name=$(fp agent register --session-id "$session_id" --format name-only 2>/dev/null)

# Persist agent name for subsequent fp commands via CLAUDE_ENV_FILE
if [ -n "$CLAUDE_ENV_FILE" ] && [ -n "$agent_name" ]; then
  echo "export FP_AGENT_NAME=$agent_name" >> "$CLAUDE_ENV_FILE"
fi

# Output context as system message
if [ -n "$agent_name" ]; then
  fp context --session-start --agent "$agent_name" 2>/dev/null
fi
