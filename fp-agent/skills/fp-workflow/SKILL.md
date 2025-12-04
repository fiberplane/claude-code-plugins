---
name: FP Workflow
description: This skill should be used when the user asks to "start working on issue", "what should I work on", "pick up task", "continue work", "find next task", "hand off", or "end session". Provides agent work session patterns for the FP CLI including claiming work, logging progress, status transitions, and session handoffs.
---

# FP Workflow Skill

**Agent work session patterns for the FP CLI**

## Core Workflow Concepts

### Issue Status Lifecycle

Issues flow through these states:
1. **Todo** - Ready to start (all dependencies resolved)
2. **InProgress** - Currently being worked on
3. **InReview** - Work complete, awaiting review
4. **Done** - Completed and reviewed
5. **Blocked** - Cannot proceed (dependencies not met, or external blocker)

### Work Session Flow

```
1. Session Start → Identify yourself
2. Find Work → Discover next actionable task
3. Claim Work → Mark issue as InProgress
4. Do Work → Implement, test, iterate
5. Log Progress → Add comments as you go
6. Complete → Mark as InReview or Done
7. Hand Off → Log final status before session ends
```

## Essential Commands

### 1. Identify Yourself

**Check who you are:**
```bash
fp agent whoami
```

This tells you your agent name (e.g., "swift-falcon"). Your identity is set automatically when your session starts.

### 2. Find Next Task

**See the full issue tree:**
```bash
fp tree
```

This shows all issues with their hierarchy, status, dependencies, and assignees.

**List available tasks:**
```bash
fp issue list --status Todo
```

**Find issues assigned to you:**
```bash
fp issue list --assignee <your-agent-name>
```

**Check what's in progress:**
```bash
fp issue list --status InProgress
```

**Analyze dependencies:**
When looking at the tree output, identify tasks that:
- Have no dependencies, OR
- Have all dependencies in "Done" status
- Are in "Todo" status
- Have no assignee (or are assigned to you)

### 3. Claim Work

**Start working on an issue:**
```bash
fp issue update --status in-progress --assignee <your-agent-name> FP-2
```

**Log that you're starting:**
```bash
fp comment FP-2 "Starting work on this task. First step: [describe what you'll do]"
```

### 4. Log Progress

**Add comments as you make progress:**
```bash
fp comment FP-2 "Completed schema design. Added User, Session, Token models to src/models/"
```

**Update hot files as you discover them:**
```bash
fp issue update --files "src/models/user.ts,src/models/session.ts,src/models/token.ts" FP-2
```

### 5. Mark Completion

**When work is done and ready for review:**
```bash
fp issue update --status in-review FP-2
fp comment FP-2 "Implementation complete. All tests passing. Ready for review."
```

**When work is fully done (no review needed):**
```bash
fp issue update --status done FP-2
fp comment FP-2 "Task completed. [Summary of what was done]"
```

### 6. Handle Blockers

**If you discover a blocker:**
```bash
fp issue update --status blocked FP-2
fp comment FP-2 "Blocked: [describe the blocker and what's needed to unblock]"
```

Consider creating a new issue for the blocker:
```bash
fp issue create --title "Fix missing database migration" --parent FP-2
```

## Best Practices

### Starting a Session

1. **Check your identity:**
   ```bash
   fp agent whoami
   ```

2. **Review recent activity:**
   ```bash
   fp log --limit 10
   ```

3. **Check the current state:**
   ```bash
   fp tree
   ```

4. **Look for your in-progress work:**
   ```bash
   fp issue list --status in-progress --assignee <your-name>
   ```

5. **If continuing work, load context:**
   ```bash
   fp context FP-2
   ```
   This shows the issue details and content of all hot files.

### During Work

1. **Comment frequently** - At minimum:
   - When you start a task
   - When you complete a significant milestone
   - When you discover important information
   - When you encounter problems

2. **Update hot files** as you discover relevant code:
   ```bash
   fp issue update --files "file1.ts,file2.ts,file3.ts" FP-2
   ```

3. **Keep status current**:
   - Move to `in-progress` when you start
   - Move to `blocked` if stuck
   - Move to `in-review` when done

### Ending a Session

1. **Log your progress:**
   ```bash
   fp comment FP-2 "End of session. Completed: [list]. Next steps: [list]"
   ```

2. **Update status appropriately:**
   - If done: `--status in-review` or `--status done`
   - If partially done: keep as `in-progress` with clear comment
   - If blocked: `--status blocked` with explanation

3. **Don't leave issues in limbo** - Always leave a comment explaining state

## Common Patterns

### Pattern: Pick Up Where You Left Off

```bash
# 1. Check what you were working on
fp agent whoami
fp issue list --status in-progress --assignee <your-name>

# 2. Load context for the issue
fp context FP-5

# 3. Review recent activity
fp log FP-5 --limit 5

# 4. Continue work and log
fp comment FP-5 "Resuming work. Current focus: [what you're doing]"
```

### Pattern: Taking Over From Another Agent

```bash
# 1. Identify the issue
fp issue show FP-3

# 2. Review what was done
fp log FP-3

# 3. Load full context
fp context FP-3

# 4. Claim the work
fp issue update --assignee <your-name> FP-3
fp comment FP-3 "Taking over from [previous-agent]. Will continue with: [next steps]"
```

### Pattern: Discovering Dependencies

```bash
# You're working on FP-5 and realize it needs FP-2 to be done first

# 1. Add the dependency
fp issue update --depends "FP-2" FP-5

# 2. Block yourself
fp issue update --status blocked FP-5
fp comment FP-5 "Blocked on FP-2: Need schema definitions before implementing business logic"

# 3. Work on FP-2 instead if possible, or find another task
fp tree  # Find next actionable task
```

### Pattern: Breaking Down Work

```bash
# While working on FP-4, you realize it's too big

# 1. Create sub-issues
fp issue create --title "Authentication middleware" --parent FP-4
fp issue create --title "Authorization checks" --parent FP-4
fp issue create --title "Token refresh logic" --parent FP-4

# 2. Document in parent
fp comment FP-4 "Broke down into sub-tasks: FP-10, FP-11, FP-12. Will work on these sequentially."

# 3. Work on sub-issues instead
fp issue update --status in-progress --assignee <your-name> FP-10
```

### Pattern: Reporting Test Failures

```bash
# Tests failed during implementation

# 1. Log the failure
fp comment FP-6 "Tests failing: [describe failures]. Investigating root cause."

# 2. Keep as InProgress while fixing
# (Don't move to Done/InReview with failing tests)

# 3. Once fixed
fp comment FP-6 "Fixed test failures. All tests now passing. [Explain what was fixed]"
fp issue update --status in-review FP-6
```

## Anti-Patterns (Avoid These)

### ❌ Starting work without claiming
```bash
# BAD: Start working without updating status
# This causes confusion for other agents

# GOOD: Always claim the work first
fp issue update --status in-progress --assignee <your-name> FP-2
fp comment FP-2 "Starting work"
```

### ❌ Silent progress (no comments)
```bash
# BAD: Work on issue for 2 hours without any comments
# Context is lost if session compacts

# GOOD: Comment at key milestones
fp comment FP-2 "Created base models"
# ... work ...
fp comment FP-2 "Added validation logic"
# ... work ...
fp comment FP-2 "All tests passing"
```

### ❌ Leaving work in ambiguous state
```bash
# BAD: End session without final comment
fp issue update --status in-progress FP-2  # Still in progress, but what's the state?

# GOOD: Clear handoff
fp comment FP-2 "End of session. Completed auth middleware. TODO: Add rate limiting. File: src/middleware/auth.ts is 80% done."
fp issue update --status in-progress FP-2
```

### ❌ Ignoring dependencies
```bash
# BAD: Start FP-5 without checking if FP-2 is done
fp issue update --status in-progress FP-5
# Later discover you need things from FP-2...

# GOOD: Check dependencies first
fp tree  # See that FP-5 depends on FP-2
fp issue show FP-2  # Check FP-2 status
# If FP-2 is not Done, work on it first or find another task
```

### ❌ Forgetting to update hot files
```bash
# BAD: Work on many files but never update the issue
# Next agent has no idea which files are relevant

# GOOD: Update hot files as you go
fp issue update --files "src/auth/login.ts,src/auth/signup.ts,src/middleware/auth.ts" FP-2
```

## Integration with Context Commands

### Loading Context for Work

Use `fp context` to get all issue details plus file contents:

```bash
# Load context for specific issue
fp context FP-2

# Load with child issues
fp context FP-2 --include-children

# Machine-readable format (for processing)
fp context FP-2 --format json
```

### Session Start Context

When your session starts, the SessionStart hook automatically runs:
```bash
fp context --session-start --session-id <id>
```

This provides:
- Your agent identity
- Current in-progress issues
- Recent activity summary

### Pre-Compact Context

Before context compaction, the PreCompact hook runs:
```bash
fp context --current --format compact
```

This preserves critical information about what you were working on.

## Querying Activity

### View Recent Activity
```bash
# Last 20 activities (default)
fp log

# Last 50 activities
fp log --limit 50

# Activity for specific issue
fp log FP-2

# Activity by specific agent
fp log --author swift-falcon

# Your own activity
fp agent whoami  # Note your name
fp log --author <your-name>
```

### Understanding Activity Log

The activity log shows:
- Timestamp
- Author (agent or user)
- Issue ID
- Action type and details

Use this to:
- Understand what happened while you were away
- See who worked on what
- Track status transitions
- Find recent comments

## Quick Reference

### Start Session Checklist
- [ ] `fp agent whoami` - Know who you are
- [ ] `fp tree` - See the full picture
- [ ] `fp log --limit 10` - Check recent activity
- [ ] `fp issue list --status in-progress --assignee <me>` - Resume my work

### During Work Checklist
- [ ] Claim work with `--status in-progress --assignee <me>`
- [ ] Comment when starting, at milestones, when done
- [ ] Update hot files as you discover them
- [ ] Keep status current (in-progress → in-review → done)

### End Session Checklist
- [ ] Add final comment with progress and next steps
- [ ] Update status appropriately
- [ ] Ensure all changes are logged
- [ ] Don't leave work in ambiguous state

## Troubleshooting

### "I don't know what to work on"
```bash
fp tree                          # See full picture
fp issue list --status todo      # See available tasks
# Pick tasks with no dependencies or all dependencies Done
```

### "Issue is blocked but I'm not sure why"
```bash
fp issue show FP-X               # Check dependencies
fp log FP-X                      # Read comments for context
# Look for the Blocked status change and comment explaining why
```

### "Lost context after compaction"
```bash
fp context FP-X                  # Reload issue + hot files
fp log FP-X --limit 10           # Read recent activity
fp tree                          # Understand issue hierarchy
```

### "Multiple agents working on same codebase"
```bash
fp log --limit 20                # See recent activity
fp issue list --status in-progress # See what's claimed
# Don't start work on in-progress issues assigned to others
# If you must take over, comment explaining why
```

## Summary

The FP workflow is designed for seamless agent collaboration:

1. **Always identify yourself** with `fp agent whoami`
2. **Find actionable work** using `fp tree` and dependency analysis
3. **Claim before starting** with status updates and assignment
4. **Log progress frequently** with comments
5. **Update metadata** (hot files, dependencies) as you learn
6. **Hand off cleanly** with clear final comments and appropriate status

This ensures context preservation across sessions and enables multiple agents to collaborate effectively on the same codebase.
