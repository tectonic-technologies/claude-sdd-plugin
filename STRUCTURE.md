# Marketplace Structure

This document shows the complete structure of your Claude Code plugin marketplace.

## Directory Layout

```
marketplace-template/
├── .claude-plugin/
│   └── marketplace.json              # Central registry of all plugins
│
├── .github/
│   └── workflows/
│       └── validate.yml              # Auto-validates PRs
│
├── plugins/                          # Plugin storage
│   └── sdd-workflow/                 # Spec-Driven Development plugin
│       ├── .claude-plugin/
│       │   └── plugin.json           # Plugin metadata
│       ├── commands/                 # 18 slash commands
│       │   ├── 00_setup.md
│       │   ├── 01_research.md
│       │   ├── 02_clarify.md
│       │   ├── 03_spec.md
│       │   ├── 04_plan.md
│       │   ├── 05_implement.md
│       │   ├── 06_refine.md
│       │   ├── 07_validate.md
│       │   ├── 08_checklist.md
│       │   ├── 09_commit.md
│       │   ├── 10_test-fix.md
│       │   ├── 11_e2e-test.md
│       │   ├── 12_review.md
│       │   ├── 13_save.md
│       │   ├── 14_resume.md
│       │   ├── 15_mcp.md
│       │   ├── 16_mcp-add.md
│       │   └── 17_mcp-load.md
│       ├── scripts/
│       │   └── setup-beads.sh        # Beads installation
│       ├── CHANGELOG.md              # Version history
│       ├── CLAUDE.md                 # Project guide template
│       ├── constitution.md           # Constraints template
│       ├── LICENSE                   # MIT license
│       └── README.md                 # Plugin documentation
│
├── scripts/
│   └── validate-marketplace.js       # Validation logic
│
├── .gitignore                        # Git ignore rules
├── CONTRIBUTING.md                   # Submission guidelines
├── package.json                      # npm scripts
├── README.md                         # User documentation
├── SETUP.md                          # Setup guide
└── STRUCTURE.md                      # This file
```

## Key Files Explained

### Configuration Files

| File | Purpose |
|------|---------|
| `.claude-plugin/marketplace.json` | Lists all available plugins and their metadata |
| `package.json` | Defines npm scripts for validation |
| `.gitignore` | Excludes node_modules and temp files |

### Documentation

| File | Audience | Content |
|------|----------|---------|
| `README.md` | Plugin users | How to install and use plugins |
| `CONTRIBUTING.md` | Plugin authors | How to submit new plugins |
| `SETUP.md` | Marketplace admins | How to deploy the marketplace |
| `STRUCTURE.md` | Developers | This structure reference |

### Automation

| File | Purpose |
|------|---------|
| `.github/workflows/validate.yml` | Runs validation on every PR |
| `scripts/validate-marketplace.js` | Validates marketplace.json schema |

### Plugin Directory

The `plugins/` directory contains plugin code:
- Each plugin in its own subdirectory
- Plugin name matches directory name
- Must have `.claude-plugin/plugin.json`
- Referenced in marketplace.json as `./plugins/plugin-name`

## Validation

Run validation before committing:

```bash
npm install
npm run validate
```

Expected output:
```
✓ marketplace.json is valid JSON
✓ Marketplace name: tectonic-claude-plugins
✓ Owner: Tectonic Technologies
✓ 1 plugin(s) validated
```

## Adding New Plugins

### Local Plugin (Recommended)

1. Copy plugin to `plugins/new-plugin/`
2. Add entry to `marketplace.json`:
   ```json
   {
     "name": "new-plugin",
     "source": "./plugins/new-plugin",
     ...
   }
   ```

### External Plugin

1. Add entry to `marketplace.json`:
   ```json
   {
     "name": "external-plugin",
     "source": {
       "source": "github",
       "repo": "org/plugin-repo"
     },
     ...
   }
   ```

## Size Information

Current marketplace:
- **Total files**: ~30+
- **Plugin commands**: 18
- **Lines of code**: ~2000+ (plugin) + ~500 (marketplace)
- **Documentation**: ~3000 lines

Disk usage (approximate):
- Marketplace infrastructure: ~100 KB
- SDD workflow plugin: ~150 KB
- **Total**: ~250 KB

## Workflow

### For Users

```bash
# Add marketplace
/plugin marketplace add tectonic-technologies/tectonic-claude-plugins

# Install plugin
/plugin install sdd-workflow@tectonic-claude-plugins
```

### For Contributors

```bash
# Fork repo, add plugin
git checkout -b add-my-plugin

# Validate
npm run validate

# Submit PR
gh pr create
```

### For Maintainers

```bash
# Review PRs
# - Security check
# - Functionality test
# - Documentation review

# Merge approved PRs
gh pr merge 123
```

## Next Steps

1. Read [SETUP.md](SETUP.md) for deployment
2. Read [CONTRIBUTING.md](CONTRIBUTING.md) for plugin submission
3. Read [README.md](README.md) for end-user instructions

