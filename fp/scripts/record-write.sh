#!/bin/bash
# FP PostToolUse hook - record file writes
# Let fp handle .fp discovery - it will silently skip if not found

input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')
tool_input=$(echo "$input" | jq -r '.tool_input')
session_id=$(echo "$input" | jq -r '.session_id')

# Extract file path from tool input (handles different property names)
file_path=$(echo "$tool_input" | jq -r '.file_path // .filePath // empty')

if [ -z "$file_path" ]; then
  exit 0
fi

# Get agent name from session_id via global agents file
agents_file="${HOME}/.fiberplane/agents.toml"
agent_name=""
if [ -f "$agents_file" ] && [ -n "$session_id" ]; then
  agent_name=$(grep "\"$session_id\"" "$agents_file" 2>/dev/null | sed 's/.*= *"\([^"]*\)".*/\1/')
fi

if [ -z "$agent_name" ]; then
  exit 0
fi

# Determine operation type based on tool
case "$tool_name" in
  "Write")
    operation="create"
    ;;
  "Edit"|"MultiEdit")
    operation="edit"
    ;;
  *)
    operation="edit"
    ;;
esac

# Record the file write
export FP_AGENT_NAME="$agent_name"
fp agent record-write "$file_path" --operation "$operation" 2>/dev/null
