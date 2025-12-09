#!/bin/bash
# FP PostToolUse hook - create issue from approved plan
# Triggered on ExitPlanMode tool use

set -e

input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')

# Only handle ExitPlanMode
if [ "$tool_name" != "ExitPlanMode" ]; then
  exit 0
fi

# Get plan content from tool input
plan=$(echo "$input" | jq -r '.tool_input.plan // empty')

if [ -z "$plan" ]; then
  exit 0
fi

# Extract title from first # heading
title=$(echo "$plan" | grep -m1 '^# ' | sed 's/^# //')

if [ -z "$title" ]; then
  title="Plan"
fi

# Check if there's a current issue being worked on
current_issue=$(fp agent current-issue 2>/dev/null || echo "")

# Create issue - as child if current issue exists, otherwise top-level
if [ -n "$current_issue" ]; then
  fp issue create --title "$title" --description "$plan" --parent "$current_issue"
else
  fp issue create --title "$title" --description "$plan"
fi
