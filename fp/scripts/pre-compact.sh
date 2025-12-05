#!/bin/bash
# FP PreCompact hook - preserve current issue context

# Check if .fp directory exists
if [ ! -d ".fp" ]; then
  exit 0
fi

# Output condensed context for current work
fp context --current --format compact 2>/dev/null
