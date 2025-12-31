# Spec-Driven Development (SDD) Plugin for Claude Code

A comprehensive workflow plugin implementing the GCRV (Generate-Critique-Refine-Verify) refinement loop for AI-assisted software development.

Based on research from [ARC Prize 2025](https://arcprize.org/blog/arc-prize-2025-results-analysis) and industry best practices from [GitHub Spec-Kit](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/) and [AWS Kiro](https://kiro.dev/).

## Features

- **20 slash commands** for structured development workflow
- **Ralph loop integration** - Autonomous implementation with stop hook
- **Stop hook verification** - Auto-checks types, lint, build, tests on each iteration
- **Spec-driven development** - Define WHAT before HOW
- **GCRV refinement loop** - Generate, Critique, Refine, Verify
- **Research automation** - Codebase + web research with auto-detection
- **Constitution template** - Immutable architectural constraints
- **Beads integration** - Graph-based task tracking

## Installation

Clone the repo and run Claude Code with the `--plugin-dir` flag:

```bash
git clone https://github.com/tectonic-technologies/claude-sdd-plugin.git
cd your-project
claude --plugin-dir ../claude-sdd-plugin
```

### Install Beads (Optional but Recommended)

```bash
./scripts/setup-beads.sh
# or manually:
go install github.com/steveyegge/beads/cmd/bd@latest
```

## Workflow

```
/research → /clarify → /spec → /plan → /implement → /validate → /commit
                         ↓        ↓         ↓
                      (WHAT)   (HOW)   (tracks deviations)
```

### Right-Sizing

| Task Size | Workflow |
|-----------|----------|
| Trivial | Just do it → `/commit` |
| Small | `/refine` → `/commit` |
| Medium | `/spec` → `/plan` → `/implement` |
| Large | Full workflow starting with `/research` |

## Commands Reference

| Command | Purpose |
|---------|---------|
| `/setup` | Interactive setup wizard |
| `/research` | Codebase + web research (auto-detects type) |
| `/clarify` | Ask structured clarifying questions |
| `/spec` | Define the contract (WHAT to build) |
| `/plan` | Define the approach (HOW to build) |
| `/implement` | Execute plan with GCRV loop |
| `/refine` | Ad-hoc refinement for small tasks |
| `/validate` | Verify implementation matches spec/plan |
| `/checklist` | Pre-commit quality checklist |
| `/commit` | Full commit workflow |
| `/test-fix` | Diagnose and fix errors |
| `/e2e-test` | Create E2E tests |
| `/review` | Multi-dimensional code review |
| `/save` | Save progress checkpoint |
| `/resume` | Resume from checkpoint |
| `/mcp` | MCP servers reference |
| `/mcp-add` | Add MCP config to registry (not auto-loaded) |
| `/mcp-load` | Load MCP from registry on-demand |
| `/pr-fix` | Address PR review feedback and update spec/plan |
| `/ralph-enable` | Enable autonomous implementation loop with verification |
| `/ralph-cancel` | Cancel active Ralph loop immediately |


## File Structure

```
claude-sdd-plugin/
├── .claude-plugin/
│   └── plugin.json          # Plugin metadata
├── commands/                 # 20 slash commands
│   ├── 00-setup.md
│   ├── 01-research.md
│   ├── 02-clarify.md
│   ├── 03-spec.md
│   ├── 04-plan.md
│   ├── ...
│   ├── 18-pr-fix.md
│   ├── 19-ralph-enable.md
│   └── 20-ralph-cancel.md
├── hooks/
│   ├── stop-hook.sh         # Ralph loop stop hook
│   └── .ralph-state.json    # Loop state (generated)
├── constitution.md           # Architectural constraints template
├── CLAUDE.md                 # Project guide template
├── scripts/
│   └── setup-beads.sh       # Beads installation script
└── README.md
```

## Customization

### Constitution

Edit `constitution.md` to define your project constraints:
- Tech stack (languages, frameworks, libraries)
- Architectural patterns (API format, database access)
- Security requirements
- Code style rules

### CLAUDE.md

Merge with or adapt the provided `CLAUDE.md` template for your project-specific:
- Directory structure
- Package names
- Verification commands
- Development scripts

## Key Concepts

### Spec vs Plan

| Spec (WHAT) | Plan (HOW) |
|-------------|------------|
| Input/output schemas | Implementation phases |
| Examples (test cases) | Files to modify |
| Invariants | Code approach |
| Constraints | Dependencies |

**Spec comes before Plan** - You must know what you are building before planning how to build it.

### GCRV Refinement Loop

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ GENERATE │───▶│  VERIFY  │───▶│ CRITIQUE │───▶│  REFINE  │
└──────────┘    └────┬─────┘    └──────────┘    └────┬─────┘
                     │ PASS                          │
                     ▼                               │
               ┌──────────┐                          │
               │   DONE   │◀─────────────────────────┘
               └──────────┘         (repeat until pass)
```

### Ralph Loop - Autonomous Implementation

The plugin includes a **stop hook** that enables autonomous implementation cycles inspired by Anthropic's Ralph Wiggum pattern:

```bash
# Enable autonomous loop
/ralph-enable "Implement feature from specs/auth.spec.ts. Output COMPLETE when all tests pass." --max-iterations 30

# The stop hook intercepts exits and runs verification:
# - Type checking
# - Linting
# - Build
# - Tests

# Loop continues until:
# - Completion promise found ("COMPLETE")
# - All checks pass
# - Max iterations reached

# Cancel anytime
/ralph-cancel
```

**How it works:**
1. Claude implements the feature
2. Tries to exit
3. Stop hook intercepts and runs verification
4. If checks fail → re-feed prompt, continue loop
5. If checks pass + completion promise → exit successfully

**Best for:** Features with clear specs, TDD workflows, fixing failing tests

### Beads Task Tracking

```bash
bd init                    # Initialize in project
bd ready --json            # Find unblocked work
bd create "Task title"     # Create issue
bd close <id> --reason     # Complete work
```

## License

MIT

## References

- [ARC Prize 2025: Year of the Refinement Loop](https://arcprize.org/blog/arc-prize-2025-results-analysis)
- [GitHub Spec-Kit](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/)
- [Martin Fowler: Understanding SDD](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html)
- [Beads Task Tracking](https://github.com/steveyegge/beads)
- [Ralph Wiggum - Anthropic Official Plugin](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/ralph-wiggum)
- [Ralph Loop Guide](https://awesomeclaude.ai/ralph-wiggum)
