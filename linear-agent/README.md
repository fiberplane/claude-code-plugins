# Linear Agent Plugin

Long-running agent workflow for Claude Code using Linear as the project management backend.

Implements [Anthropic's "effective harnesses for long-running agents"](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents) pattern with a three-phase approach:

1. **Planning** - Break down project brief into Linear issues (asks for tech preferences)
2. **Initialization** - Scaffold ALL features upfront to prevent architectural conflicts
3. **Coding Agent** - Implement ONE feature per session with progress tracked in Linear

## Prerequisites

- Linear MCP server configured (auto-provisioned by this plugin)
- Linear account with access to target project/issues

## Installation

```bash
claude --plugin /path/to/linear-agent
```

Or add to your Claude Code plugins directory.

## Usage

Start the workflow with the `/linear-agent` slash command.

### Starting a New Project

```
/linear-agent
```

If no `.claude-linear-agent.json` exists, you'll be prompted to provide a Linear project or issue URL.

**With a brief (no issues yet):**
1. Plugin asks about your tech preferences (language, framework, testing, architecture)
2. Analyzes the brief and proposes feature breakdown
3. Creates issues in Linear after your approval
4. Saves preferences for consistent implementation

**With existing issues:**
1. Asks about tech preferences (if not already set)
2. Presents an architecture plan for approval
3. Creates scaffolding (tests, types, structure) for ALL features
4. Commits the scaffold
5. Saves state to `.claude-linear-agent.json`

### Continuing Work

```
/linear-agent
```

When `.claude-linear-agent.json` exists, the plugin:
1. Fetches current issue status from Linear
2. Suggests next highest-priority issue
3. Implements the feature using your saved preferences
4. Commits with issue ID and updates Linear

## State File

The plugin creates a minimal `.claude-linear-agent.json` in your project root:

```json
{
  "type": "project",
  "linearId": "ABC-123",
  "phase": "coding"
}
```

Phases:
- `planning` - Breaking down brief into Linear issues
- `scaffolding` - Creating test stubs, types, directory structure
- `coding` - Implementing features one at a time

## Technical Preferences (Stored in Linear)

During planning/initialization, the plugin asks about:

- **Tech stack**: Language, framework, libraries
- **Architecture**: Patterns, module structure
- **Testing**: Frameworks, coverage approach
- **Code style**: Conventions, linting
- **Deployment**: Target environment
- **Constraints**: Performance, compatibility

These preferences are stored in Linear (project description or pinned "Technical Specifications" issue) - keeping Linear as the single source of truth.

## Plugin Components

| Component | Purpose |
|-----------|---------|
| Command | `/linear-agent` slash command to start/continue workflow |
| Skill | Workflow instructions for all three phases |
| MCP | Auto-provisions Linear MCP server connection |
| Hook | SessionStart injects context when state file exists |

## Key Principles

1. **Ask before assuming** - Gathers your preferences first
2. **Linear IS the feature list** - No duplicate tracking
3. **Scaffold ALL first** - Prevents architectural conflicts
4. **One feature per session** - Maintains focus
5. **Always mergeable** - No broken states between sessions
6. **Progress in Linear** - Comments provide continuity
