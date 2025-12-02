# FP Agent - Quick Reference

Use `fp` CLI to manage local project issues and plans.

## Getting Started
```bash
fp init                    # Initialize .fp/ in your project
fp issue create --title "My Feature"  # Create an issue
```

## Key Commands
- `fp issue list` - List all issues
- `fp issue show <id>` - Show issue details
- `fp tree` - Visualize issue hierarchy
- `fp context <id>` - Load issue + hot files for context
- `fp comment <id> "message"` - Log progress
- `fp log` - View activity history

## For Agents
- `fp agent whoami` - Your identity
- `fp context --current` - Current in-progress work
- Always log progress with `fp comment` before ending session

See `/fp-workflow` and `/fp-planning` skills for detailed workflows.
