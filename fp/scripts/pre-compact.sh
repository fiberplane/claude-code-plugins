#!/bin/bash
# FP PreCompact hook - preserve current issue context and remind about progress

# Check if .fp directory exists
if [ ! -d ".fp" ]; then
  exit 0
fi

# Output condensed context for current work
fp context --current --format compact 2>/dev/null

# Reminder about logging progress
echo ""
echo "REMINDER: Before context compacts, ensure you have:"
echo "- Logged progress with 'fp comment <id> \"...\"'"
echo "- Committed your changes"
