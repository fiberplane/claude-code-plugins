# fp

Local-first project management for AI agents using the fp CLI.

## Overview

fp provides structured issue tracking that's:
- **Local-first**: All data stored in `~/.fiberplane/projects/` with config in `.fp/`
- **Hierarchy-aware**: Parent/child issues with dependency tracking
- **Review-integrated**: Web UI for reviewing diffs with AI-generated comments
- **Worktree-friendly**: Works with git worktrees and jj workspaces

## Prerequisites

Install the `fp` CLI:
```bash
curl -fsSL https://setup.fp.dev/install.sh | sh -s
```

## Usage

1. Initialize a project:
```bash
fp init --prefix MYPROJ
```

2. Create issues and plans:
```bash
fp issue create --title "Add feature X" 
# creates issue MYPROJ-aqfx

# use minimal unique prefix to reference the issue:
fp issue create --title "Implement data layer" --parent MYPROJ-a
```

3. Track work:
```bash
fp issue update --status in-progress MYPROJ-a
fp comment MYPROJ-a "Started implementation..."
fp issue update --status done MYPROJ-a
```

4. Review work:
```bash
# review working copy (uncommitted changes)
fp review 

# review a specific issue (requires commits assigned)
fp review MYPROJ-a
```

## Plugin Features

### Skills

- **fp-plan**: Create plans and break them down into trackable issues. Supports importing from GitHub, Linear, and Notion URLs.
- **fp-implement**: Find, claim, and complete work on issues. Track progress with comments.
- **fp-review**: Ensure commits are assigned to issues, leave review comments, and use the web UI for interactive review.

## Data Storage

```
# Per-project (in repo root)
.fp/
└── config.toml   # Project identifier and issue prefix 

# Global
~/.fiberplane/
├── projects/      # Per-project files for issues, comments, etc
└── projects.toml  # Project registry
```

The CLI auto-discovers `.fp/` directories from parent/child paths.
