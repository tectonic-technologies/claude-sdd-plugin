# Contributing to the Plugin Marketplace

Thank you for contributing to our organization's Claude Code plugin marketplace!

## Submission Process

### 1. Prepare Your Plugin

Ensure your plugin meets all requirements:

#### Required Files

```
your-plugin/
├── .claude-plugin/
│   └── plugin.json          # Required metadata
├── commands/                 # If using commands
│   └── *.md
├── README.md                 # Clear documentation
├── LICENSE                   # MIT or Apache 2.0
└── CHANGELOG.md              # Version history
```

#### plugin.json Requirements

```json
{
  "name": "your-plugin-name",        // Required: kebab-case
  "version": "1.0.0",                // Required: semantic versioning
  "description": "Clear description", // Required: < 200 chars
  "author": {                         // Required
    "name": "Your Name",
    "email": "you@company.com"        // Optional but recommended
  },
  "repository": "https://github.com/...", // Recommended
  "license": "MIT",                   // Required: MIT or Apache-2.0
  "keywords": ["tag1", "tag2"]        // Recommended: 3-7 keywords
}
```

#### Documentation Requirements

Your `README.md` must include:

- Clear description of what the plugin does
- Installation instructions
- Usage examples
- List of all commands/features
- Configuration options (if any)
- Dependencies and prerequisites
- Troubleshooting section

### 2. Fork and Add Entry

1. Fork this repository
2. Edit `.claude-plugin/marketplace.json`
3. Add your plugin entry:

```json
{
  "name": "your-plugin-name",
  "source": {
    "source": "github",
    "repo": "your-org/your-plugin-repo"
  },
  "description": "Brief description matching plugin.json",
  "version": "1.0.0",
  "author": {
    "name": "Your Name",
    "email": "you@company.com"
  },
  "homepage": "https://github.com/your-org/your-plugin-repo",
  "repository": "https://github.com/your-org/your-plugin-repo",
  "license": "MIT",
  "keywords": ["keyword1", "keyword2"],
  "category": "productivity"  // See categories below
}
```

#### Available Categories

- `productivity` - Workflow, automation, efficiency tools
- `code-quality` - Linters, formatters, analyzers
- `testing` - Test generation, testing frameworks
- `documentation` - Doc generators, API docs
- `devops` - Deployment, infrastructure, CI/CD
- `security` - Security scanning, vulnerability checks
- `data` - Data processing, transformation tools

### 3. Validate Your Changes

```bash
# Clone your fork
git clone https://github.com/your-username/claude-plugins.git
cd claude-plugins

# Install validation dependencies
npm install

# Validate marketplace.json schema
npm run validate

# Test plugin installation locally
/plugin marketplace add ./
/plugin install your-plugin@tectonic-claude-plugins
```

### 4. Submit Pull Request

Create a pull request with:

**Title Format:**
```
Add plugin: your-plugin-name v1.0.0
```

**PR Description Template:**
```markdown
## Plugin Information

- **Name**: your-plugin-name
- **Version**: 1.0.0
- **Category**: productivity
- **Repository**: https://github.com/your-org/your-plugin-repo

## Description

[Brief description of what the plugin does]

## Checklist

- [ ] plugin.json includes all required fields
- [ ] README.md includes installation and usage
- [ ] LICENSE file included (MIT or Apache-2.0)
- [ ] marketplace.json validated with `npm run validate`
- [ ] Plugin tested locally
- [ ] No external network access (or disclosed in description)
- [ ] Follows organization security policies

## Security Review

- [ ] Plugin code reviewed for security issues
- [ ] No credentials or secrets in code
- [ ] External dependencies documented
- [ ] Network access documented (if any)

## Testing

Describe how you tested the plugin:

[Your testing steps]
```

### 5. Review Process

Your submission will go through:

1. **Automated validation** - JSON schema, format checks
2. **Security review** - Code inspection, dependency audit
3. **Functionality review** - Testing in real scenarios
4. **Documentation review** - Clarity, completeness

**Timeline**: Reviews typically complete within 3-5 business days.

## Updating Existing Plugins

### Version Updates

To update your plugin version:

1. Update `version` in your plugin's `plugin.json`
2. Add entry to your `CHANGELOG.md`
3. Create PR updating version in marketplace.json

### Breaking Changes

If your update includes breaking changes:

1. Increment major version (e.g., 1.x.x → 2.0.0)
2. Document migration path in CHANGELOG.md
3. Notify users via #claude-code channel

## Security Requirements

### Code Review

All plugins must pass security review:

- No obfuscated code
- Dependencies audited
- No shell command injection risks
- Proper input validation
- Secure file operations

### Network Access

If your plugin accesses external networks:

- Clearly document in README.md
- List all endpoints accessed
- Explain why network access is needed
- Use HTTPS for all requests

### Credentials

- Never hardcode credentials
- Document required environment variables
- Use secure credential storage
- Provide clear setup instructions

## Best Practices

### Plugin Design

- **Single responsibility** - Do one thing well
- **Clear naming** - Use descriptive, searchable names
- **Composable** - Work well with other plugins
- **Documented** - Every command/feature explained

### Command Naming

```bash
# Good
/api-docs          # Clear, specific
/test-e2e          # Descriptive
/deploy-staging    # Action + target

# Avoid
/do-stuff          # Vague
/x                 # Not searchable
/theprocess        # Unclear
```

### Error Handling

- Provide clear error messages
- Include troubleshooting steps
- Log errors appropriately
- Fail gracefully

### Performance

- Minimize file reads
- Cache expensive operations
- Avoid blocking operations in commands
- Document resource requirements

## Plugin Categories Explained

### Productivity
Tools that improve developer workflow and efficiency:
- Task automation
- Workflow optimization
- Project scaffolding
- Code generation

### Code Quality
Tools that improve code maintainability:
- Linters and formatters
- Code analyzers
- Refactoring tools
- Style guides

### Testing
Tools for test creation and execution:
- Test generators
- E2E frameworks
- Coverage tools
- Mock generators

### Documentation
Tools for creating and maintaining docs:
- API documentation
- README generators
- Changelog automation
- Diagram generation

### DevOps
Tools for deployment and infrastructure:
- CI/CD integration
- Container management
- Cloud deployment
- Monitoring setup

### Security
Tools for security and compliance:
- Vulnerability scanning
- Dependency auditing
- Secret detection
- Security policies

## Support

- **Questions**: #claude-code Slack channel
- **Issues**: GitHub Issues on this repo
- **Security**: security@tectonic.so
- **Ownership**: engineering@tectonic.so

## License

By contributing, you agree that your plugin submission will be listed under this marketplace's MIT license. Your plugin code retains its own license.
