---
allowed-tools: Bash(fp:*), Bash(which:*), Bash(test:*)
description: Load fp context and pick a task to work on
---

# FP Agent - Interactive Task Picker

## Environment Check

- **fp CLI installed**: !`which fp > /dev/null 2>&1 && echo "✓ Yes" || echo "✗ No"`
- **Project initialized**: !`test -d .fp && echo "✓ Yes" || echo "✗ No"`

## Instructions

Based on the environment check above, follow ONE of these paths:

### Path A: fp CLI not installed

If fp CLI is NOT installed, inform the user:

> The `fp` CLI is not installed. To install it:
> ```bash
> curl -fsSL https://setup.fiberplane.com/install.sh | sh -s
> ```
> After installation, run `/fp` again.

Do NOT proceed further.

### Path B: Project not initialized

If fp CLI is installed but `.fp` directory doesn't exist, ask the user:

> This project hasn't been initialized with fp. Would you like to initialize it?

If yes, run `fp init` and then proceed to Path C.

### Path C: Ready to work (fp installed + project initialized)

First, ensure you have your agent name. If `$FP_AGENT_NAME` is not set (e.g., in subagents), get it:
```bash
FP_AGENT_NAME=$(fp agent whoami 2>&1 | grep "Name:" | awk '{print $2}')
```

Then run these commands to load context:

```bash
fp tree                              # Show issue hierarchy
fp context --current --format compact # Current work (if any)
fp issue list --status open          # Active tasks
fp issue list --status done          # Completed tasks
```

Then **use AskUserQuestion** to ask the user what they want to do:
- Present the open tasks as options (use the issue IDs and titles from the commands above)
- Include "Continue current work" (if there's open work)
- Include "Create a new task"
- Include "Plan new work" (for breaking down a feature/project into tasks)

**Based on selection**:
   - **Continue current work**: Load full context with `fp context --current`
   - **Pick a task**: Mark it open with `fp issue update --status open <id>`, then load context with `fp context <id>`
   - **Create new task**: Use AskUserQuestion to gather title/description, then `fp issue create`
   - **Plan new work**: Invoke the `fp-planning` skill to help break down the work into a hierarchy of issues

**After task is selected**, use TodoWrite to create a todo list based on the issue description.

## Quick Reference

Once working on a task:
- `fp comment <id> "message"` - Log progress (do this frequently!)
- `fp issue update --status done <id>` - Mark complete
- `fp issue diff <id>` - See changes since task started
- `fp issue files <id>` - List changed files
- `fp context <id>` - Reload issue context

See `fp-workflow` and `fp-planning` skills for detailed patterns.
