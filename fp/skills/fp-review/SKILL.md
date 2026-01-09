---
name: FP Review
description: This skill should be used when the user asks to "review commits", "assign commits to issues", "end session", "wrap up work", "clean up tracking", or "make sure commits are tracked". Provides commit-to-issue assignment workflow for ensuring all work is properly attributed to issues.
---

# FP Review Skill

**Commit-to-issue assignment workflow for the FP CLI**

## Purpose

At the end of a work session (or when asked to review), ensure that:
1. All commits made during the session are assigned to the correct issues
2. Each completed issue has its associated commits tracked
3. The VCS history accurately reflects which work belonged to which issue

## When to Use

- End of a work session
- When user asks to "review" or "clean up"
- Before handing off to another agent
- When multiple issues were worked on and commits need sorting

## Review Workflow

### Step 1: Gather Context

First, understand what was worked on:

```bash
# See which issues are in-progress or recently done
fp issue list --status in-progress
fp issue list --status done

# See the issue tree for context
fp tree

# Check recent commits (jj or git)
jj log --limit 20   # or: git log --oneline -20
```

### Step 2: Launch Subagent for Commit Analysis

Use the Task tool to spawn a subagent that will analyze and assign commits:

```
Task: Analyze recent commits and assign them to the correct fp issues.

Instructions for subagent:
1. List recent commits with their changed files:
   - jj log --limit 20 (or git log --oneline -20)
   - For each commit, run jj show <id> (or git show <hash> --stat)

2. Load issue context:
   - fp issue list --status in-progress
   - fp issue list --status done
   - For each relevant issue: fp context <id>

3. Match commits to issues by comparing:
   - Files changed in commit vs files mentioned in issue description
   - Commit message content vs issue title/description
   - Whether the code changes implement the issue's requirements

4. Assign commits to issues:
   - fp issue assign <issue-id> --rev <commit-hash>
   - Can assign multiple: fp issue assign <id> --rev hash1,hash2

5. Report results:
   - Which commits were assigned to which issues
   - Any commits that don't clearly match (flag for user)
   - Suggestions if commits should be split (one commit spans multiple issues)
```

### Step 3: Verify Assignments

After the subagent completes, verify the assignments:

```bash
# Check each issue's tracked changes
fp issue diff FP-X --stat
fp issue files FP-X

# Verify the tree shows proper tracking
fp tree
```

### Step 4: Handle Edge Cases

**Commit spans multiple issues:**
- Assign to the primary issue
- Consider suggesting the user split future commits
- Note in issue comment if needed

**Commit doesn't match any issue:**
- Create a new issue for the work if it's substantial
- Or assign to a catch-all/maintenance issue
- Or leave unassigned if truly orphan work

**Working copy has uncommitted changes:**
Commit first, then assign. If the user wants to review changes visually before committing, suggest they run:
```
fp review
```
This opens a web-based diff viewer. The user can run this command themselves to inspect changes and provide feedback.

## Integration with Workflow

This skill complements `fp-workflow`:

```
fp-workflow                          fp-review
    │                                    │
    ├── Start Session                    │
    ├── Claim Issue (in-progress)        │
    ├── Code → Commit → Log              │
    ├── Complete Issue (done)            │
    │                                    │
    └── End Session ──────────────────►  │
                                         ├── Gather context
                                         ├── Launch subagent
                                         ├── Verify assignments
                                         └── Handle edge cases
```

## Quick Reference

### Commands Used

```bash
# View issues
fp issue list --status in-progress
fp issue list --status done
fp tree

# View commits
jj log --limit 20          # Jujutsu
git log --oneline -20      # Git

# View commit details
jj show <commit-id>        # Jujutsu
git show <hash> --stat     # Git

# Assign commits to issues
fp issue assign FP-X --rev abc123
fp issue assign FP-X --rev abc,def,ghi

# Verify assignments
fp issue diff FP-X --stat
fp issue files FP-X

# Review uncommitted changes (user runs this, opens web UI)
# Suggest: fp review
```

### Review Checklist

- [ ] List in-progress and done issues
- [ ] Review recent commits
- [ ] Launch subagent to analyze and assign commits
- [ ] Verify each issue has correct commits assigned
- [ ] Handle any unmatched commits
- [ ] Commit any uncommitted changes first (suggest user run `fp review` to inspect)

## Anti-Patterns

### ❌ Skipping review at end of session
```bash
# BAD: End session without ensuring commits are tracked
fp comment FP-2 "Done for today"
# Commits may not be assigned to issues!

# GOOD: Run review before ending
# Use fp-review skill to assign commits
fp comment FP-2 "Done for today. All commits assigned."
```

### ❌ Assigning all commits to one issue
```bash
# BAD: Bulk assign without checking
fp issue assign FP-1 --rev abc,def,ghi,jkl
# Some commits might belong to different issues!

# GOOD: Analyze each commit and assign appropriately
```

### ❌ Ignoring unmatched commits
```bash
# BAD: Leave commits unassigned
# Future agents won't know what work was done

# GOOD: Either assign to relevant issue or create new issue
fp issue create --title "Misc cleanup" 
fp issue assign FP-99 --rev xyz
```
