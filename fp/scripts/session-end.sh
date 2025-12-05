#!/bin/bash
# FP SessionEnd hook - record session end

# Only record session end if .fp directory exists
# Note: agentEnd uses FP_AGENT_NAME and FP_SESSION_ID from environment
if [ -d ".fp" ]; then
  fp agent end 2>/dev/null
fi
