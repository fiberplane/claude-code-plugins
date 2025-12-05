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

1. **Load current context**:

!`fp tree 2>/dev/null || echo "No issues yet"`

!`fp context --current --format compact 2>/dev/null || echo "No current work in progress"`

2. **Show available tasks**:

!`fp issue list --status todo 2>/dev/null || echo "No todo tasks"`

3. **Use AskUserQuestion** to ask the user which task to work on:
   - Present the todo tasks as options (use the issue IDs and titles from the list above)
   - Include an option to "Create new task"
   - Include an option to "Continue current work" (if there's in-progress work)

4. **Based on selection**:
   - If continuing current work: Load full context with `fp context --current`
   - If picking a task: Claim it with `fp issue update --status in-progress --assignee "$FP_AGENT_NAME" <id>`, then load context
   - If creating new: Use AskUserQuestion to gather title/description, then `fp issue create`

5. **After task is selected**, use TodoWrite to create a todo list based on the issue description and hot files.

## Quick Reference

Once working on a task:
- `fp comment <id> "message"` - Log progress (do this frequently!)
- `fp issue update --status done <id>` - Mark complete
- `fp context <id>` - Reload issue context

See `fp-workflow` and `fp-planning` skills for detailed patterns.
