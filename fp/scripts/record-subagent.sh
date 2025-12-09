#!/bin/bash
# FP PostToolUse hook - record subagent invocations
# Logs when a subagent is spawned and what it's tasked with

input=$(cat)
tool_input=$(echo "$input" | jq -r '.tool_input')
session_id=$(echo "$input" | jq -r '.session_id')

# Only log if .fp directory exists
if [ ! -d ".fp" ]; then
  exit 0
fi

# Extract subagent details
subagent_type=$(echo "$tool_input" | jq -r '.subagent_type // "unknown"')
description=$(echo "$tool_input" | jq -r '.description // "no description"')
prompt=$(echo "$tool_input" | jq -r '.prompt // ""')

# Get agent name from session_id via global agents file
agents_file="${HOME}/.fiberplane/agents.toml"
agent_name=""
if [ -f "$agents_file" ] && [ -n "$session_id" ]; then
  agent_name=$(grep "\"$session_id\"" "$agents_file" 2>/dev/null | sed 's/.*= *"\([^"]*\)".*/\1/')
fi

if [ -z "$agent_name" ]; then
  agent_name="unknown"
fi

# Truncate prompt if too long (keep first 500 chars)
if [ ${#prompt} -gt 500 ]; then
  prompt="${prompt:0:500}..."
fi

# Escape special characters for JSON
prompt=$(echo "$prompt" | jq -Rs '.')
description=$(echo "$description" | jq -Rs '.')

# Append to activity log
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
echo "{\"type\":\"subagent_spawned\",\"timestamp\":\"$timestamp\",\"author\":\"$agent_name\",\"data\":{\"subagent_type\":\"$subagent_type\",\"description\":$description,\"prompt\":$prompt}}" >> .fp/activity.jsonl
