# Fiberplane Claude Code Plugins

Plugins for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## Installation

Add the marketplace and install the plugin:

```
/plugin marketplace add fiberplane/claude-code-plugins
/plugin install fp@fiberplane-claude-code-plugins
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
    "fp@fiberplane-claude-code-plugins": true
  }
}
```

## Available Plugins

### fp

Local-first issue tracking and code review for humans and AI agents.

- Git-friendly markdown files in `.fp/`
- VCS-integrated change tracking via git/jj commit ranges
- Auto-registers agent identity across sessions
- Task dependencies and blocked work tracking

**Usage:** `/fp`

**Prerequisites:**
```bash
curl -fsSL https://setup.fiberplane.com/install.sh | sh -s
```

[Full documentation](./fp/README.md)

## Development

```bash
claude plugin install ./fp
```
