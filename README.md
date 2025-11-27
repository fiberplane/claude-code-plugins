# Fiberplane Claude Code Plugins

A collection of plugins for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## Installation

Add this marketplace to your Claude Code settings:

```bash
claude plugins:add-marketplace github:fiberplane/claude-code-plugins
```

Then enable the plugin you want:

```bash
claude plugins:enable linear-agent
```

Or add it directly to your `~/.claude/settings.json`:

```json
{
  "enabledPlugins": ["linear-agent@fiberplane-claude-code-plugins"]
}
```

## Available Plugins

### linear-agent

Long-running agent workflow using Linear as the project management backend. Implements Anthropic's "effective harnesses for long-running agents" pattern.

**Features:**
- Break down project briefs into Linear issues
- Scaffold all features upfront to prevent architectural conflicts
- Implement one feature per session with progress tracked in Linear

**Usage:** `/linear-agent`

[Full documentation](./linear-agent/README.md)

## Development

To test a plugin locally:

```bash
claude --plugin ./linear-agent
```
