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

### Starting with a Brief (No Issues Yet)

Provide a Linear project URL that has a description but no issues:

```
Here's the Linear project: https://linear.app/team/project/abc-123
It just has a brief - help me break it down into features
```

The plugin will:
1. Ask about your tech preferences (language, framework, testing, architecture)
2. Analyze the brief and propose feature breakdown
3. Create issues in Linear after your approval
4. Save preferences for consistent implementation

### Starting with Existing Issues

If your project already has issues:

```
Here's the Linear project I want to work on: https://linear.app/team/project/abc-123
```

The plugin will:
1. Ask about tech preferences (if not already set)
2. Present an architecture plan for approval
3. Create scaffolding (tests, types, structure) for ALL features
4. Commit the scaffold
5. Save state to `.claude-linear-agent.json`

### Continuing Work

On subsequent sessions, the plugin auto-activates when `.claude-linear-agent.json` exists:

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
| Skill | Workflow instructions for all three phases |
| MCP | Auto-provisions Linear MCP server connection |
| Hook | SessionStart triggers workflow automatically |

## Key Principles

1. **Ask before assuming** - Gathers your preferences first
2. **Linear IS the feature list** - No duplicate tracking
3. **Scaffold ALL first** - Prevents architectural conflicts
4. **One feature per session** - Maintains focus
5. **Always mergeable** - No broken states between sessions
6. **Progress in Linear** - Comments provide continuity
