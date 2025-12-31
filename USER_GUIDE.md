# User Guide: Installing and Using Marketplace Plugins

Quick guide for developers using plugins from the Tectonic Claude Code marketplace.

## Installation

### Step 1: Add the Marketplace

In any Claude Code session, run:

```bash
/plugin marketplace add tectonic-technologies/tectonic-claude-marketplace
```

You should see:
```
✅ Marketplace 'tectonic-claude-marketplace' added successfully
```

### Step 2: Browse Available Plugins

See what plugins are available:

```bash
/plugin search
```

Or search for specific plugins:

```bash
/plugin search sdd
```

### Step 3: Install a Plugin

Install the SDD workflow plugin:

```bash
/plugin install sdd-workflow@tectonic-claude-marketplace
```

You should see:
```
✅ Plugin 'sdd-workflow' installed successfully
   20 commands available
```

### Step 4: Verify Installation

List installed plugins:

```bash
/plugin list
```

You should see:
```
Installed Plugins:
  ✓ sdd-workflow@tectonic-claude-marketplace (v2.0.0)
    - 20 commands
    - Spec-Driven Development Workflow
```

## Using Plugin Commands

### Available Commands

Once installed, you can use any of the 20 SDD workflow commands:

```bash
/setup              # Interactive setup wizard
/research           # Conduct research
/clarify            # Ask clarifying questions
/spec               # Create specification
/plan               # Create implementation plan
/implement          # Execute plan with GCRV
/refine             # Ad-hoc refinement
/validate           # Verify implementation
/checklist          # Quality check
/commit             # Commit workflow
/test-fix           # Fix failing tests
/e2e-test           # Create E2E tests
/review             # Code review
/save               # Save progress
/resume             # Resume from checkpoint
/mcp                # MCP reference
/mcp-add            # Add MCP config
/mcp-load           # Load MCP on-demand
/pr-fix             # Address PR feedback
/ralph-enable       # Enable autonomous loop
/ralph-cancel       # Cancel Ralph loop
```

### Getting Help

For any command, use the help flag:

```bash
/setup --help
/research --help
/ralph-enable --help
```

## Common Workflows

### 1. Start a New Feature

```bash
# Step 1: Research the problem
/research "How do we currently handle user authentication?"

# Step 2: Ask clarifying questions (if needed)
/clarify docs/research/authentication.md

# Step 3: Define WHAT to build
/spec docs/research/authentication.md

# Step 4: Define HOW to build it
/plan specs/authentication.spec.ts

# Step 5: Implement with GCRV loop
/implement docs/plans/authentication.md

# Step 6: Validate against spec
/validate specs/authentication.spec.ts

# Step 7: Run checklist
/checklist

# Step 8: Commit changes
/commit
```

### 2. Quick Small Task

```bash
# For small tasks, skip research/spec/plan:
/refine "Add error handling to the login function"

# Commit when done
/commit
```

### 3. Autonomous Implementation with Ralph Loop

```bash
# Research and create spec/plan first
/research "User registration feature"
/clarify docs/research/registration.md
/spec docs/research/registration.md
/plan specs/registration.spec.ts

# Enable autonomous loop - Claude will iterate until all checks pass
/ralph-enable "Implement user registration from docs/plans/registration.md. Output COMPLETE when all tests pass." --max-iterations 30

# Claude will now:
# - Implement the feature
# - Try to exit
# - Stop hook intercepts and runs verification (types, lint, build, tests)
# - If checks fail → auto-fix and retry
# - If checks pass + "COMPLETE" found → exit successfully
# - If max iterations (30) reached → exit with summary

# Cancel anytime if needed:
/ralph-cancel
```

### 4. Fix Failing Tests

```bash
# Let Claude fix test failures in a loop
/ralph-enable "Fix all failing tests in tests/auth.test.ts. Output TESTS_PASSING when coverage > 80% and all tests green." --max-iterations 20 --completion-promise "TESTS_PASSING"
```

### 5. Address PR Review Comments

```bash
# After receiving PR feedback
/pr-fix https://github.com/org/repo/pull/123

# Or paste comments directly:
/pr-fix "
@reviewer1: Missing error handling on line 45
@reviewer2: Consider using useMemo here for performance
"

# The command will:
# - Read original spec and plan
# - Categorize comments by priority
# - Apply fixes with GCRV loop
# - Update spec/plan if needed
# - Show summary of changes
```

## Project Setup

### Option 1: Auto-enable in Project

Add to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "tectonic-claude-marketplace": {
      "source": {
        "source": "github",
        "repo": "tectonic-technologies/tectonic-claude-marketplace"
      }
    }
  },
  "enabledPlugins": {
    "sdd-workflow@tectonic-claude-marketplace": true
  }
}
```

Now the plugin is automatically enabled for anyone working on the project!

### Option 2: Run Setup Wizard

The SDD plugin includes an interactive setup wizard:

```bash
/setup
```

This will:
- Create project structure (`specs/`, `docs/research/`, `docs/plans/`)
- Generate `.claude/constitution.md` (architectural constraints)
- Generate `.claude/CLAUDE.md` (project guide)
- Set up Beads task tracking (optional)
- Configure verification commands

Follow the prompts to customize for your project.

## Ralph Loop Best Practices

### 1. Always Set Max Iterations

Prevent infinite loops and API cost overruns:

```bash
# Good - has safety limit
/ralph-enable "task" --max-iterations 30

# Bad - could run forever
/ralph-enable "task"  # Uses default 50, but be explicit
```

### 2. Use Clear Completion Promises

The completion promise must be an **exact string match**:

```bash
# Good - clear and unique
/ralph-enable "Implement feature. Output IMPLEMENTATION_COMPLETE when done." --completion-promise "IMPLEMENTATION_COMPLETE"

# Bad - Claude might output variations
/ralph-enable "Implement feature. Say done when finished." --completion-promise "done"
```

### 3. Include Success Criteria in Prompt

```bash
/ralph-enable "
Implement user authentication feature.

Success criteria:
- All TypeScript types correct
- Linting passes
- Build succeeds
- All tests pass (coverage > 80%)
- No console.logs in production code

Output AUTH_COMPLETE when all criteria met.
" --max-iterations 40 --completion-promise "AUTH_COMPLETE"
```

### 4. Best Use Cases for Ralph Loop

**✅ Good for:**
- Features with clear specs and test requirements
- TDD workflows (write tests, then implement)
- Fixing failing builds/tests
- Refactoring with existing test coverage

**❌ Not good for:**
- Exploratory coding
- Tasks requiring design decisions
- One-off scripts
- Production debugging

### 5. Monitor Progress

Each iteration shows verification status:

```
Ralph Loop - SDD Implementation Cycle #7

Running verification checks...
  📋 Type check: ✓
  🔍 Lint check: ✗
  🔨 Build check: ✓
  🧪 Tests: ✗

❌ Verification failed:
   - Linting failed
   - Tests failed

Continuing loop to fix issues...
Iteration 7 of 30 - Re-feeding prompt...
```

### 6. Cancel When Stuck

If the same error repeats for 5+ iterations:

```bash
/ralph-cancel

# Then debug manually:
pnpm lint          # See what's failing
pnpm test          # Check test failures

# Fix manually or adjust prompt and retry:
/ralph-enable "<better prompt>" --max-iterations 20
```

## Managing Plugins

### Update a Plugin

```bash
# Update specific plugin
/plugin update sdd-workflow@tectonic-claude-marketplace

# Update all plugins
/plugin update --all
```

### Uninstall a Plugin

```bash
/plugin uninstall sdd-workflow@tectonic-claude-marketplace
```

### Check Plugin Info

```bash
/plugin info sdd-workflow@tectonic-claude-marketplace
```

You'll see:
```
Plugin: sdd-workflow
Version: 2.0.0
Author: skypawalker
Description: Spec-Driven Development Workflow with Ralph Loop integration
Commands: 20
License: MIT
```

### List Marketplaces

```bash
/plugin marketplace list
```

### Remove Marketplace

```bash
/plugin marketplace remove tectonic-claude-marketplace
```

## Troubleshooting

### Plugin Commands Not Working

1. **Verify plugin is installed:**
   ```bash
   /plugin list
   ```

2. **Reinstall if needed:**
   ```bash
   /plugin uninstall sdd-workflow@tectonic-claude-marketplace
   /plugin install sdd-workflow@tectonic-claude-marketplace
   ```

3. **Check for updates:**
   ```bash
   /plugin update sdd-workflow@tectonic-claude-marketplace
   ```

### Marketplace Not Found

1. **Verify marketplace was added:**
   ```bash
   /plugin marketplace list
   ```

2. **Re-add if needed:**
   ```bash
   /plugin marketplace add tectonic-technologies/tectonic-claude-marketplace
   ```

3. **Check repository access:**
   - Ensure you have access to the GitHub repository
   - For private marketplaces, ensure your Git credentials are configured

### Ralph Loop Not Stopping

1. **Cancel immediately:**
   ```bash
   /ralph-cancel
   ```

2. **Check completion promise:**
   - Must be exact string match
   - Claude must output exactly: `IMPLEMENTATION_COMPLETE` (or your custom promise)
   - Not: "implementation complete" or "Implementation Complete"

3. **Check max iterations:**
   - Default is 50, but should be set explicitly
   - Use lower values for testing: `--max-iterations 5`

### Verification Checks Failing Repeatedly

If the loop keeps failing on the same check:

1. **Cancel the loop:**
   ```bash
   /ralph-cancel
   ```

2. **Debug manually:**
   ```bash
   pnpm check-types  # See type errors
   pnpm lint         # See linting issues
   pnpm build        # See build errors
   pnpm test         # See test failures
   ```

3. **Fix the blockers manually, then:**
   - Continue with `/implement` or `/refine`, or
   - Re-enable Ralph with adjusted prompt

## Getting Help

### Command Help

Most commands support `--help`:

```bash
/setup --help
/research --help
/ralph-enable --help
```

### Documentation

- **Plugin README**: See [sdd-workflow README](https://github.com/tectonic-technologies/claude-sdd-plugin/blob/main/README.md)
- **Command Docs**: Each command has detailed documentation in the plugin repo
- **Examples**: Check the `examples/` directory in the plugin repo

### Support Channels

- **Slack**: #claude-code channel
- **Email**: engineering@tectonic.so
- **Issues**: [GitHub Issues](https://github.com/tectonic-technologies/claude-sdd-plugin/issues)

## Tips and Tricks

### 1. Use Tab Completion

Claude Code supports tab completion for commands:

```bash
/se<TAB>     # Completes to /setup
/ra<TAB>     # Shows /ralph-enable and /ralph-cancel
```

### 2. Chain Commands

For common workflows, chain commands:

```bash
# After research is done, immediately create spec
/research "topic" && /spec docs/research/topic.md

# After implementation, validate and commit
/implement plan.md && /validate spec.ts && /commit
```

### 3. Save Checkpoints

Before major changes, save progress:

```bash
/save "Before refactoring auth system"

# Make changes...

# Resume if needed
/resume
```

### 4. Use MCP Servers

Load MCP servers on-demand for additional capabilities:

```bash
/mcp-load linear-server      # For Linear integration
/mcp-load context7           # For library docs
```

### 5. Customize Verification Commands

If your project uses different commands, update `.claude/CLAUDE.md`:

```markdown
## Code Quality Gates

- [ ] `npm run typecheck` passes   ← Customize this
- [ ] `npm run lint` passes
- [ ] `npm run build` passes
- [ ] `npm test` passes
```

The stop hook will adapt to your project's commands.

## Quick Reference

### Installation
```bash
/plugin marketplace add tectonic-technologies/tectonic-claude-marketplace
/plugin install sdd-workflow@tectonic-claude-marketplace
```

### Basic Workflow
```bash
/research → /clarify → /spec → /plan → /implement → /validate → /commit
```

### Autonomous Workflow
```bash
/research → /spec → /plan → /ralph-enable
```

### Common Commands
```bash
/setup                  # One-time project setup
/refine "task"          # Quick small tasks
/ralph-enable "prompt"  # Autonomous implementation
/ralph-cancel           # Cancel loop
/commit                 # Commit changes
```

### Help
```bash
/plugin list            # See installed plugins
/<command> --help       # Command help
/plugin info <name>     # Plugin details
```

---

**Ready to get started?** Run `/setup` in your project to configure the SDD workflow!
