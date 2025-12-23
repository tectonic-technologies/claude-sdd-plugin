# Spec-Driven Development (SDD) Plugin for Claude Code

A comprehensive workflow plugin implementing the GCRV (Generate-Critique-Refine-Verify) refinement loop for AI-assisted software development.

Based on research from [ARC Prize 2025](https://arcprize.org/blog/arc-prize-2025-results-analysis) and industry best practices from [GitHub Spec-Kit](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/) and [AWS Kiro](https://kiro.dev/).

## Features

- **15 slash commands** for structured development workflow
- **Spec-driven development** - Define WHAT before HOW
- **GCRV refinement loop** - Generate, Critique, Refine, Verify
- **Research automation** - Codebase + web research with auto-detection
- **Constitution template** - Immutable architectural constraints
- **Beads integration** - Graph-based task tracking

## Installation

### Via Claude Code Plugin System

```bash
/plugin install skypawalker/claude-sdd-plugin
```

### Manual Installation

1. Clone this repo into your project:
```bash
git clone https://github.com/skypawalker/claude-sdd-plugin.git .claude-plugins/sdd
```

2. Copy commands to your project:
```bash
cp -r .claude-plugins/sdd/commands/* .claude/commands/
cp .claude-plugins/sdd/constitution.md .claude/
```

3. Merge CLAUDE.md with your existing one (or copy if none exists)

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


## File Structure

```
claude-sdd-plugin/
├── .claude-plugin/
│   └── plugin.json          # Plugin metadata
├── commands/                 # 15 slash commands
│   ├── 01_research.md
│   ├── 02_clarify.md
│   ├── 03_spec.md
│   ├── 04_plan.md
│   └── ...
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
