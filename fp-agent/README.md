# fp-agent

Local-first project management for AI agents using the fp CLI.

## Overview

fp-agent provides structured issue tracking and context management that's:
- **Git-friendly**: All data stored as markdown files in `.fp/`
- **Agent-native**: Auto-registers agent identity, preserves context across sessions
- **Dependency-aware**: Track task dependencies and blocked work

## Prerequisites

Install the `fp` CLI (from the nocturne monorepo):
```bash
# Install globally
bun link
# Or run directly
bunx fp
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
fp issue update MYPROJ-2 --status InProgress
fp comment MYPROJ-2 "Started implementation..."
```

## Plugin Features

### Hooks

- **SessionStart**: Registers agent identity, loads current work context
- **Stop**: Reminds to log progress before ending
- **PreCompact**: Preserves context before window fills

### Skills

- **fp-workflow**: Work session patterns (find work, claim tasks, log progress)
- **fp-planning**: Plan breakdown patterns (create hierarchies, model dependencies)

### Commands

- `/fp-agent`: Quick reference for fp CLI commands

## Data Storage

```
.fp/
├── config.toml      # Project settings
├── agents.toml      # Agent registry (gitignored)
├── activity.jsonl   # Activity log
└── issues/          # Issue markdown files
    ├── PROJ-1.md
    └── PROJ-2.md
```

## Links

- [FP CLI Source](https://github.com/fiberplane/nocturne/tree/main/apps/fp)
- [SPEC.md](https://github.com/fiberplane/nocturne/blob/main/apps/fp/SPEC.md)
