# Fiberplane Claude Code Plugins

A collection of plugins for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## Installation

In Claude Code, add this marketplace:

```
/plugin marketplace add fiberplane/claude-code-plugins
```

Then install the plugin:

```
/plugin install linear-agent@fiberplane-claude-code-plugins
```

Or configure via `~/.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "fiberplane-claude-code-plugins": {
      "source": {
        "source": "github",
        "repo": "fiberplane/claude-code-plugins"
      }
    }
  },
  "enabledPlugins": {
    "linear-agent@fiberplane-claude-code-plugins": true
  }
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
