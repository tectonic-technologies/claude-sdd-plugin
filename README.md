# Claude Code Plugin Marketplace

Internal marketplace for organization-approved Claude Code plugins.

## Quick Start

### For Plugin Users

Add this marketplace to your Claude Code installation:

```bash
# Add the marketplace
/plugin marketplace add tectonic-technologies/tectonic-claude-plugins

# List available plugins
/plugin search

# Install a plugin
/plugin install sdd-workflow@tectonic-claude-plugins
```

Or add to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "tectonic-claude-plugins": {
      "source": {
        "source": "github",
        "repo": "tectonic-technologies/tectonic-claude-plugins"
      }
    }
  },
  "enabledPlugins": {
    "sdd-workflow@tectonic-claude-plugins": true
  }
}
```

### For Plugin Authors

See [CONTRIBUTING.md](./CONTRIBUTING.md) for submission guidelines.

## Available Plugins

### Development Workflow

#### sdd-workflow
**Spec-Driven Development Workflow with Ralph Loop Integration**

A comprehensive workflow plugin implementing the GCRV (Generate-Critique-Refine-Verify) refinement loop with autonomous implementation cycles.

- 20 slash commands for structured development
- **Ralph loop integration** - Autonomous implementation with stop hook verification
- Research automation (codebase + web)
- Spec-before-plan methodology
- Beads task tracking integration
- Constitution template for architectural constraints
- Stop hook auto-verification (types, lint, build, tests)

**New in v2.0.0**: Enable autonomous implementation cycles with `/ralph-enable` that automatically iterate until all verification checks pass.

[View Plugin →](https://github.com/tectonic-technologies/claude-sdd-plugin)

## Categories

- **Development Workflow**: SDD workflow, CI/CD automation
- **Code Quality**: Linters, formatters, code review tools
- **Testing**: Test generation, E2E testing frameworks
- **Documentation**: API docs, README generators
- **DevOps**: Deployment, infrastructure, monitoring

## Plugin Submission

To submit a plugin for inclusion:

1. Fork this repository
2. Add your plugin to `marketplace.json`
3. Submit a pull request
4. Wait for security review and approval

See [CONTRIBUTING.md](./CONTRIBUTING.md) for detailed requirements.

## Security

All plugins undergo security review before inclusion. Plugins must:

- Have clear, documented functionality
- Not access external networks without disclosure
- Follow organization security policies
- Include MIT or Apache 2.0 license

Report security concerns to: security@your-org.com

## Validation

Validate your marketplace additions locally:

```bash
# Install dependencies
npm install

# Validate marketplace.json schema
npm run validate

# Test plugin installation
/plugin marketplace add ./
/plugin install your-plugin@tectonic-claude-plugins
```

## Maintenance

- **Owners**: DevTools Team <engineering@tectonic.so>
- **Updates**: Reviewed weekly
- **Support**: #claude-code Slack channel

## License

This marketplace configuration is licensed under MIT. Individual plugins have their own licenses.
