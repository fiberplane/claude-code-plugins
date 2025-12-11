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
curl -fsSL https://setup.fiberplane.com/install.sh | sh -s
```

## Usage

1. Initialize a project:
```bash
fp init --prefix MYPROJ
```

2. Create issues and plans:
```bash
fp issue create --title "Add feature X"
fp issue create --title "Implement data layer" --parent MYPROJ-1
```

3. Track work:
```bash
fp issue update --status open MYPROJ-2   # Starts tracking (captures base commit)
fp comment MYPROJ-2 "Started implementation..."
fp issue diff MYPROJ-2                   # See changes since started
fp issue update --status done MYPROJ-2   # Complete (captures tip commit)
```

## Plugin Features

### Hooks

- **SessionStart**: Registers agent identity, loads current work context
- **SessionEnd**: Ends agent session gracefully
- **PreCompact**: Preserves context before window fills

### Skills

- **fp-workflow**: Work session patterns (find work, claim tasks, log progress)
- **fp-planning**: Plan breakdown patterns (create hierarchies, model dependencies)

### Commands

- `/fp`: Interactive task picker and context loader

## Data Storage

```
# Per-project
.fp/
├── workspace.toml   # Current issue (local state)
├── activity.jsonl   # Activity log
└── issues/          # Issue markdown files
    ├── PROJ-1.md
    └── PROJ-2.md

# Global
~/.fiberplane/
├── agents.toml      # Agent identities (cross-project)
└── projects.toml    # Project registry
```

The CLI auto-discovers `.fp/` directories from parent/child paths.
