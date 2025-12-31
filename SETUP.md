# Marketplace Setup Guide

This guide walks you through setting up your organization's Claude Code plugin marketplace.

## Overview

You'll create a Git repository that serves as a central registry for approved Claude Code plugins. Teams can then install plugins from your marketplace using simple commands.

## Prerequisites

- Git repository hosting (GitHub, GitLab, Bitbucket, or self-hosted)
- Organization/team with permissions to create repositories
- Basic familiarity with Git

## Setup Steps

### 1. Create Marketplace Repository

**On GitHub:**
```bash
# Create new repository via GitHub UI or CLI
gh repo create tectonic-technologies/tectonic-claude-plugins --public --description "Claude Code plugin marketplace"

# Clone the repository
git clone https://github.com/tectonic-technologies/tectonic-claude-plugins.git
cd claude-plugins
```

**On GitLab:**
```bash
# Create via GitLab UI or CLI
# Clone the repository
git clone https://gitlab.company.com/your-team/claude-plugins.git
cd claude-plugins
```

### 2. Copy Marketplace Template

Copy all files from the `marketplace-template` directory to your new repository:

```bash
# From the sdd-workflow plugin directory
cp -r marketplace-template/* /path/to/tectonic-technologies/tectonic-claude-plugins/
cp -r marketplace-template/.github /path/to/tectonic-technologies/tectonic-claude-plugins/
cp -r marketplace-template/.claude-plugin /path/to/tectonic-technologies/tectonic-claude-plugins/

cd /path/to/tectonic-technologies/tectonic-claude-plugins
```

### 3. Customize Marketplace Configuration

Edit `.claude-plugin/marketplace.json`:

```json
{
  "name": "tectonic-claude-plugins",          // ← Change to your org name (kebab-case)
  "owner": {
    "name": "DevTools Team",           // ← Your team name
    "email": "engineering@tectonic.so"   // ← Your contact email
  },
  "description": "Internal marketplace for Claude Code plugins",
  "homepage": "https://github.com/tectonic-technologies/tectonic-claude-plugins",      // ← Your repo URL
  "repository": "https://github.com/tectonic-technologies/tectonic-claude-plugins",    // ← Your repo URL
  "plugins": [
    // Plugins will be listed here
  ]
}
```

**Important naming rules:**
- Use kebab-case (lowercase with hyphens)
- Avoid reserved names: `claude-code-marketplace`, `anthropic-plugins`, etc.
- Make it memorable and organization-specific

### 4. Update Documentation

**README.md:**
- Replace `your-org` with your actual organization name
- Update repository URLs
- Update contact information (Slack channels, email addresses)
- Customize categories if needed

**CONTRIBUTING.md:**
- Update security contact email
- Update support channels
- Adjust validation requirements if needed
- Add organization-specific policies

### 5. Validate Configuration

```bash
# Install validation dependencies
npm install

# Run validation
npm run validate
```

You should see:
```
✓ marketplace.json is valid JSON
✓ Marketplace name: tectonic-claude-plugins
✓ Owner: DevTools Team
✓ Description present

✅ All checks passed!
```

### 6. Commit and Push

```bash
git add .
git commit -m "Initial marketplace setup"
git push origin main
```

### 7. Set Up Branch Protection (Recommended)

**GitHub:**
```
Settings → Branches → Add rule
- Branch name pattern: main
- ✓ Require a pull request before merging
- ✓ Require status checks to pass (select "Validate Marketplace")
- ✓ Require review from Code Owners
```

**GitLab:**
```
Settings → Repository → Protected Branches
- Branch: main
- Allowed to merge: Maintainers
- Allowed to push: No one
```

### 8. Create CODEOWNERS File (Optional)

Create `.github/CODEOWNERS` (GitHub) or `CODEOWNERS` (GitLab):

```
# DevTools team reviews all marketplace changes
.claude-plugin/marketplace.json  @your-org/devtools-team
```

## Adding Your First Plugin

### Option 1: Add SDD Workflow Plugin

The marketplace template includes the SDD workflow plugin as the first entry. If you want to keep it:

1. Verify the entry in `.claude-plugin/marketplace.json`
2. Test installation (see "Testing" section below)
3. Done!

### Option 2: Add Your Own Plugin

Edit `.claude-plugin/marketplace.json` and add your plugin to the `plugins` array:

```json
{
  "plugins": [
    {
      "name": "your-plugin",
      "source": {
        "source": "github",
        "repo": "your-org/your-plugin-repo"
      },
      "description": "Brief description of your plugin",
      "version": "1.0.0",
      "author": {
        "name": "Your Team"
      },
      "license": "MIT",
      "keywords": ["keyword1", "keyword2"],
      "category": "productivity"
    }
  ]
}
```

Validate and commit:
```bash
npm run validate
git add .claude-plugin/marketplace.json
git commit -m "Add your-plugin v1.0.0"
git push
```

## Testing

### Test Marketplace Installation

From any project directory:

```bash
# Add your marketplace
/plugin marketplace add tectonic-technologies/tectonic-claude-plugins

# Verify it was added
/plugin marketplace list
```

You should see your marketplace listed.

### Test Plugin Installation

```bash
# Install a plugin from your marketplace
/plugin install sdd-workflow@tectonic-claude-plugins

# Verify installation
/plugin list
```

Test that plugin commands work:
```bash
/setup
```

### Test with Local Marketplace (Before Pushing)

```bash
# From your marketplace directory
/plugin marketplace add ./

# Install plugin
/plugin install sdd-workflow@tectonic-claude-plugins
```

## Distribution to Team

### Method 1: Manual Instructions

Share with your team:

```markdown
## Installing Company Claude Plugins

Add our organization's plugin marketplace:

1. In any Claude Code session:
   /plugin marketplace add tectonic-technologies/tectonic-claude-plugins

2. Install the SDD workflow plugin:
   /plugin install sdd-workflow@tectonic-claude-plugins

3. Verify installation:
   /plugin list
```

### Method 2: Project Configuration

Add to your project's `.claude/settings.json`:

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

Commit this file to your project repositories. Plugins will be auto-enabled for all team members.

### Method 3: Global Configuration (Advanced)

For organization-wide enforcement, use managed settings:

```json
{
  "strictKnownMarketplaces": [
    {
      "source": "github",
      "repo": "tectonic-technologies/tectonic-claude-plugins"
    }
  ]
}
```

This restricts users to only install plugins from approved marketplaces.

## Maintenance

### Adding New Plugins

1. Plugin author submits PR with entry in `marketplace.json`
2. Review team validates:
   - Security review
   - Functionality testing
   - Documentation completeness
3. Merge PR
4. Notify team in Slack/Teams

### Updating Plugin Versions

When a plugin releases a new version:

1. Update `version` field in `marketplace.json`
2. Commit and push
3. Users can update:
   ```bash
   /plugin update sdd-workflow@tectonic-claude-plugins
   ```

### Removing Plugins

To deprecate a plugin:

1. Add deprecation notice to plugin entry:
   ```json
   {
     "name": "old-plugin",
     "deprecated": true,
     "deprecationMessage": "Use new-plugin instead"
   }
   ```

2. After grace period, remove entry entirely

## Troubleshooting

### Validation Fails

```bash
# Get detailed error messages
npm run validate

# Common issues:
# - Invalid JSON syntax → Use JSON validator
# - Reserved marketplace name → Choose different name
# - Invalid URLs → Check repository URLs
# - Duplicate plugin names → Ensure unique names
```

### Plugin Not Found

```bash
# Verify marketplace was added
/plugin marketplace list

# Verify plugin exists in marketplace
# Check .claude-plugin/marketplace.json in the repo
```

### GitHub Actions Failing

- Check `.github/workflows/validate.yml` exists
- Ensure repository has Actions enabled
- Check workflow logs for specific errors

## Security Considerations

### Plugin Review Process

Establish a security review checklist:

- [ ] Code review completed
- [ ] No hardcoded credentials
- [ ] Dependencies audited
- [ ] Network access documented
- [ ] Input validation present
- [ ] Test suite included

### Access Control

**Public marketplace (GitHub/GitLab public repo):**
- Anyone can see plugins
- Control via PR review process
- Suitable for open source plugins

**Private marketplace (private repo):**
- Only org members can access
- Requires authentication for git clone
- Suitable for proprietary plugins

### Network Isolation

If your organization restricts network access:

- Host on internal GitLab/GitHub Enterprise
- Update marketplace URLs accordingly
- Test accessibility from restricted networks

## Support

### Getting Help

- **Setup issues**: engineering@tectonic.so
- **Plugin submissions**: See CONTRIBUTING.md
- **Security concerns**: security@tectonic.so

### Useful Commands

```bash
# Validate marketplace
npm run validate

# List available plugins
/plugin search

# Show marketplace info
/plugin marketplace list

# Update all plugins
/plugin update --all
```

## Next Steps

1. ✅ Set up marketplace repository
2. ✅ Add first plugin
3. ✅ Test installation
4. Share with team
5. Establish review process
6. Monitor usage and feedback

---

**Need help?** Check the [official Claude Code plugin documentation](https://code.claude.com/docs/en/plugin-marketplaces.md) or reach out to your DevTools team.
