# fp

Local-first project management for AI agents using the fp CLI.

## Overview

fp-agent provides structured issue tracking and context management that's:
- **Git-friendly**: All data stored as markdown files in `.fp/`
- **VCS-integrated**: Automatic change tracking via git/jj commit ranges
- **Agent-native**: Auto-registers agent identity, preserves context across sessions
- **Dependency-aware**: Track task dependencies and blocked work
- **Multi-project aware**: Works from any subdirectory via project registry

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

# then, use minimal unique prefix to reference the issue:
fp issue create --title "Implement data layer" --parent MYPROJ-a
```

3. Track work:
```bash
fp issue update --status in-progress MYPROJ-a  # Starts tracking (captures base commit)
fp comment MYPROJ-a "Started implementation..."
fp issue diff MYPROJ-a                         # See changes since started
fp issue update --status done MYPROJ-a         # Complete (captures tip commit)
```

4. Review Claude's work:
```bash
# open a local review UI for working copy
# comments get printed to stdout
fp review 

# open the review UI for a specific issue's revisions
fp review MYPROJ-a
```

## Plugin Features

### Skills

- **fp-plan**: Create plans and break them down into trackable issues. Supports importing from GitHub, Linear, and Notion URLs.
- **fp-execute**: Find, claim, and complete work on issues. Track progress with comments.
- **fp-review**: Ensure commits are assigned to issues, leave review comments, and use the web UI for interactive review.

## Data Storage

```
# Per-project
.fp/
├── config.toml   # Project identifier and issue prefix 

# Global
~/.fiberplane/
├── projects/      # Per-project files for issues, comments, etc
└── projects.toml  # Project registry
```

The CLI auto-discovers `.fp/` directories from parent/child paths.
