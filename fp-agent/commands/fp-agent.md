# FP Agent - Quick Reference

Use `fp` CLI to manage local project issues and plans.

## Key Commands
- `fp tree` - See issue hierarchy and find work
- `fp issue list --status todo` - Find available tasks
- `fp issue show <id>` - View issue details
- `fp context <id>` - Load issue + hot files
- `fp comment <id> "message"` - Log progress
- `fp log` - View activity history

## Workflow
```bash
# 1. Find work
fp tree
fp issue list --status todo

# 2. Claim and start (uses your agent name from environment)
fp issue update --status in-progress --assignee $FP_AGENT_NAME FP-1

# 3. Log progress as you work
fp comment FP-1 "Completed X, starting Y"

# 4. Complete
fp issue update --status done FP-1
fp comment FP-1 "Done: [summary]"
```

## For Agents
- `fp agent whoami` - Your identity
- `fp context --current` - Current in-progress work
- Always log progress with `fp comment` before ending session

See `/fp-workflow` and `/fp-planning` skills for detailed workflows.
