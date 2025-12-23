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

**Use `bd` (Beads) for all task/issue tracking.**

### Core Commands

```bash
bd ready --json          # Find unblocked work
bd create "Task title"   # Create issue
bd update <id> --status in_progress
bd close <id> --reason "description"
bd list                  # All issues
```

Reference: https://github.com/steveyegge/beads

---

## Available Commands

| # | Command | Purpose |
|---|---------|---------|
| 01 | `/research` | Codebase + web research |
| 02 | `/clarify` | Ask structured questions |
| 03 | `/spec` | Define contract (WHAT) |
| 04 | `/plan` | Define approach (HOW) |
| 05 | `/implement` | Execute with GCRV loop |
| 06 | `/refine` | Ad-hoc refinement |
| 07 | `/validate` | Verify implementation |
| 08 | `/checklist` | Quality check |
| 09 | `/commit` | Commit workflow |
| 10 | `/test-fix` | Fix errors |
| 11 | `/e2e-test` | Create E2E tests |
| 12 | `/review` | Code review |
| 13 | `/save` | Save progress |
| 14 | `/resume` | Resume work |
| 15 | `/mcp` | MCP servers reference |

**Typical workflow:**
```
/research → /clarify → /spec → /plan → /implement → /validate → /commit
                         ↓        ↓         ↓
                      (WHAT)   (HOW)   (updates plan)
```

### Right-Sizing the Process

| Task Size | Examples | Workflow |
|-----------|----------|----------|
| **Trivial** | Typo fix, add log | Just do it → `/commit` |
| **Small** | Bug fix, simple refactor | `/refine` → `/commit` |
| **Medium** | New endpoint, component | `/spec` → `/plan` → `/implement` |
| **Large** | New feature, architecture | Full workflow |

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
