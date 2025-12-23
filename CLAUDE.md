# Project Name - AI Development Guide

## Project Overview

(Describe your project here)

## Tech Stack

| Category | Technology | Version |
|----------|------------|---------|
| Language | TypeScript | 5.x |
| Framework | (your framework) | - |
| Database | (your database) | - |
| (add more) | ... | - |

## Directory Structure

```
your-project/
├── src/
├── packages/         # If monorepo
├── specs/            # Specification files
├── docs/
│   ├── research/     # Research documents
│   └── plans/        # Implementation plans
└── .claude/
    ├── commands/     # Slash commands (from plugin)
    └── constitution.md
```

---

## GCRV Refinement Loop

**NEVER submit code without verification.**

```
GENERATE → VERIFY → CRITIQUE → REFINE → (repeat until pass)
```

**Verification command:**
```bash
pnpm check-types && pnpm lint && pnpm build
# or: npm run check-types && npm run lint && npm run build
```

**Iteration limit:** 5 attempts, then ask for help.

---

## Task Tracking with Beads

Beads is external memory for AI agents with dependency tracking and query capabilities.
It replaces messy markdown plans with a dependency-aware graph.

Reference: https://github.com/steveyegge/beads

### Why Beads?

- **Persistent memory** - Context survives across sessions
- **Dependency-aware** - Knows what blocks what
- **Agent-optimized** - JSON output, auto-ready detection
- **Git-backed** - Branches and merges with your code

### Session Workflow

**Start of session:**
```bash
bd ready --json              # Find unblocked work - START HERE
bd doctor                    # Run daily to fix issues
```

**During work:**
```bash
bd create "Task title" -p 1  # Create issue (priority 1-5)
bd update <id> --status in_progress
bd dep add <child> <parent>  # Link dependencies
```

**End of session ("Landing the Plane"):**
```bash
bd close <id> --reason "description"  # Complete work
bd list                                # Review open issues
bd sync                                # Ensure synced to git
```

### Best Practices (from Steve Yegge)

1. **File beads for anything > 2 minutes**
   - If a task takes longer than 2 minutes, create a bead for it
   - Ask the agent to file beads during code reviews

2. **Run `bd doctor` daily**
   - Diagnoses and auto-fixes issues
   - Handles migrations and config updates

3. **Regular cleanup**
   - Run `bd cleanup` every few days
   - Clean up when you exceed ~200 issues
   - Rarely let it go beyond 500

4. **Use hierarchical structure**
   - `bd-a3f8` - Epic level
   - `bd-a3f8.1` - Task level  
   - `bd-a3f8.1.1` - Sub-task level

5. **Dependency types**
   - `blocks` - Task X prevents Task Y
   - `parent-child` - Hierarchical containment
   - `discovered-from` - Found during other work
   - `related` - Associated but independent

### Essential Commands

| Command | Purpose |
|---------|---------|
| `bd init` | Initialize in project |
| `bd ready --json` | Find unblocked work |
| `bd create "Title" -p 1` | Create priority-1 issue |
| `bd show <id>` | View issue details |
| `bd dep add <child> <parent>` | Create dependency |
| `bd dep tree <id>` | Visualize hierarchy |
| `bd blocked` | Show what is blocked |
| `bd close <id> --reason "..." ` | Complete issue |
| `bd cleanup` | Remove old closed issues |
| `bd doctor` | Diagnose and fix problems |
| `bd stats` | Project statistics |

### Editor Integration

```bash
bd setup claude    # Claude Code integration
bd setup cursor    # Cursor integration
bd setup aider     # Aider integration
```

This injects ~1-2k tokens of workflow context on session start.

---

## Available Commands

| # | Command | Purpose |
|---|---------|---------|
| 00 | `/setup` | Interactive setup wizard |
| 01 | `/research` | Codebase + web research |
| 02 | `/clarify` | Clarifying questions |
| 03 | `/spec` | Define contract (WHAT) |
| 04 | `/plan` | Define approach (HOW) |
| 05 | `/implement` | Execute with GCRV |
| 06 | `/refine` | Ad-hoc refinement |
| 07 | `/validate` | Verify implementation |
| 08 | `/checklist` | Quality check |
| 09 | `/commit` | Commit workflow |
| 10 | `/test-fix` | Fix errors |
| 11 | `/e2e-test` | Create E2E tests |
| 12 | `/review` | Code review |
| 13 | `/save` | Save progress |
| 14 | `/resume` | Resume work |
| 15 | `/mcp` | MCP reference |

**Typical workflow:**
```
/research → /clarify → /spec → /plan → /implement → /validate → /commit
                         ↓        ↓         ↓
                      (WHAT)   (HOW)   (updates plan)
```

### Right-Sizing the Process

| Task Size | Workflow |
|-----------|----------|
| Trivial | Just do it → `/commit` |
| Small | `/refine` → `/commit` |
| Medium | `/spec` → `/plan` → `/implement` |
| Large | Full workflow with `/research` |

---

## Document Ownership

| Document | Location | Owns |
|----------|----------|------|
| **Research** | `docs/research/` | Context, patterns |
| **Spec** | `specs/` | Contract (schemas, examples) |
| **Plan** | `docs/plans/` | Approach (phases, files) |

---

## Code Quality Gates

Before completing ANY task:
- [ ] Type check passes
- [ ] Lint passes
- [ ] Build passes
- [ ] No console.log in production
- [ ] Error handling implemented

---

## Getting Help

When stuck after 5 iterations:
1. Summarize attempts
2. Show exact error
3. State hypothesis
4. Ask specific question
