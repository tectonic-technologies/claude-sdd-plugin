# Setup Command

Interactive setup wizard to customize the SDD plugin for your project.

## Arguments
- `$ARGUMENTS` - Optional: "quick" for minimal setup, "full" for complete customization

## Purpose

Guide users through configuring the SDD plugin for their specific project, generating:
- Customized `constitution.md`
- Customized `CLAUDE.md`
- Required directory structure
- Optional Beads installation

## Process

### 1. Welcome & Check Existing Setup

```
Welcome to SDD Plugin Setup!

This wizard will configure spec-driven development for your project.

Checking existing setup...
```

Check for existing files:
- `.claude/constitution.md` - exists? backup or overwrite?
- `.claude/CLAUDE.md` - exists? merge or overwrite?
- `specs/` directory
- `docs/research/` directory
- `docs/plans/` directory

If files exist, ask:
```
Found existing configuration files. How would you like to proceed?
1. Backup existing and create new
2. Merge with existing (keep your customizations)
3. Cancel setup
```

### 2. Gather Project Information

Ask these questions using AskUserQuestion:

**Project Basics:**
```
What is your project name?
> [user input]

Brief description (one line):
> [user input]
```

**Tech Stack:**
```
What is your primary language/framework?
1. TypeScript + Next.js
2. TypeScript + Node.js
3. TypeScript + React (Vite)
4. Python + FastAPI
5. Python + Django
6. Go
7. Other (specify)
> [user choice]
```

```
What database are you using?
1. PostgreSQL (Prisma)
2. PostgreSQL (Drizzle)
3. PostgreSQL (raw/pg)
4. MySQL
5. MongoDB
6. SQLite
7. Supabase
8. None / Other
> [user choice]
```

```
What validation library?
1. Zod
2. Yup
3. Joi
4. class-validator
5. None / Other
> [user choice]
```

```
Is this a monorepo?
1. Yes (Turborepo)
2. Yes (Nx)
3. Yes (pnpm workspaces)
4. Yes (other)
5. No (single package)
> [user choice]
```

**Verification Commands:**
```
What command runs type checking?
Default: pnpm check-types (or npm run check-types)
> [user input or enter for default]

What command runs linting?
Default: pnpm lint
> [user input or enter for default]

What command runs build?
Default: pnpm build
> [user input or enter for default]

What command runs tests?
Default: pnpm test
> [user input or enter for default]
```

**Optional Integrations:**
```
Which of these does your project use? (comma-separated numbers)
1. Shopify APIs
2. Stripe
3. AWS
4. Google Cloud
5. Vercel
6. Supabase
7. Auth0 / Clerk / NextAuth
8. None of these
> [user choices]
```

### 3. Create Directory Structure

```bash
mkdir -p specs
mkdir -p docs/research
mkdir -p docs/plans
```

Report:
```
Created directories:
  ✅ specs/
  ✅ docs/research/
  ✅ docs/plans/
```

### 4. Generate constitution.md

Based on answers, generate customized constitution:

```markdown
# Constitution

Immutable architectural principles for {PROJECT_NAME}.
Specs and plans MUST adhere to these constraints.

---

## Tech Stack (Non-Negotiable)

| Layer | Choice | Notes |
|-------|--------|-------|
| Language | {LANGUAGE} | {LANGUAGE_NOTES} |
| Framework | {FRAMEWORK} | {FRAMEWORK_VERSION} |
| Database | {DATABASE} | Via {ORM} |
| Validation | {VALIDATION} | All runtime validation |
{ADDITIONAL_STACK}

---

## Architectural Patterns

### API Response Format
\`\`\`typescript
{API_RESPONSE_PATTERN}
\`\`\`

### Database Access
{DATABASE_ACCESS_PATTERN}

### Error Handling
- Validate at system boundaries
- Use {VALIDATION} for schema validation
- Log errors with structured context

---

## Security (Mandatory)

### Input Validation
- Validate ALL external input at API boundaries
- Never trust client-provided IDs without verification

### Secrets
- No secrets in code, ever
- Use environment variables
- Never log sensitive data

{INTEGRATION_SPECIFIC_SECURITY}

---

## Code Style

### Imports (Order)
1. {FRAMEWORK} imports
2. External packages
3. Internal packages
4. Relative imports
5. Types (with `type` keyword)

### File Naming
| Type | Pattern |
|------|---------|
| Components | `PascalCase.tsx` |
| Utilities | `camelCase.ts` |
| Tests | `*.test.ts` |
| Specs | `*.spec.ts` |

---

## What Does NOT Belong Here

- Feature-specific requirements (goes in spec)
- Implementation approach (goes in plan)
- Temporary decisions
```

Save to `.claude/constitution.md`

### 5. Generate CLAUDE.md

Based on answers, generate customized CLAUDE.md:

```markdown
# {PROJECT_NAME} - AI Development Guide

## Project Overview

{PROJECT_DESCRIPTION}

## Tech Stack

| Category | Technology |
|----------|------------|
{TECH_STACK_TABLE}

## Directory Structure

\`\`\`
{DIRECTORY_STRUCTURE}
\`\`\`

---

## GCRV Refinement Loop

**NEVER submit code without verification.**

\`\`\`
GENERATE → VERIFY → CRITIQUE → REFINE → (repeat until pass)
\`\`\`

**Verification command:**
\`\`\`bash
{VERIFY_COMMAND}
\`\`\`

**Iteration limit:** 5 attempts, then ask for help.

---

## Task Tracking with Beads

\`\`\`bash
bd ready --json          # Find unblocked work
bd create "Task title"   # Create issue
bd close <id> --reason   # Complete work
\`\`\`

---

## Available Commands

| # | Command | Purpose |
|---|---------|---------|
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

### Right-Sizing

| Task Size | Workflow |
|-----------|----------|
| Trivial | Just do it → `/commit` |
| Small | `/refine` → `/commit` |
| Medium | `/spec` → `/plan` → `/implement` |
| Large | Full workflow with `/research` |

---

## Code Quality Gates

- [ ] `{TYPECHECK_CMD}` passes
- [ ] `{LINT_CMD}` passes
- [ ] `{BUILD_CMD}` passes
- [ ] No console.log in production
- [ ] Error handling implemented

---

## Getting Help

When stuck after 5 iterations:
1. Summarize attempts
2. Show exact error
3. State hypothesis
4. Ask specific question
```

Save to `.claude/CLAUDE.md` (merge if exists)

### 6. Beads Setup (Recommended)

```
Would you like to set up Beads for task tracking?
1. Yes, install now
2. No, skip for now
3. Show me more info first
```

If yes:
- Check if Go is installed
- Run: `go install github.com/steveyegge/beads/cmd/bd@latest`
- Run: `bd init` in project root
- Offer editor integration: `bd setup claude` or `bd setup cursor`
- Run `bd doctor` to verify setup

If "Show me more info":
```
Beads is external memory for AI agents (by Steve Yegge).
- Persistent task tracking across sessions
- Dependency-aware graph structure
- Git-backed, branches with your code
- Run `bd ready` to find unblocked work

Best practices:
- File beads for anything > 2 minutes
- Run `bd doctor` daily
- Run `bd cleanup` when issues exceed ~200
```


### 7. Summary

```
Setup complete! 🎉

Created/Updated:
  ✅ .claude/constitution.md - Your architectural constraints
  ✅ .claude/CLAUDE.md - Project-specific AI guide
  ✅ specs/ - For specification files
  ✅ docs/research/ - For research documents
  ✅ docs/plans/ - For implementation plans
  {✅ Beads initialized - if selected}

Quick Start:
  1. Review and customize .claude/constitution.md
  2. Start with: /research {your first task}
  3. Or for small tasks: /refine {task description}

Run /setup again anytime to reconfigure.
```

## Quick Mode

If `$ARGUMENTS` contains "quick":

Skip detailed questions, use smart defaults based on:
- Detected package.json (Node/TypeScript)
- Detected pyproject.toml (Python)
- Detected go.mod (Go)
- Detected existing config files

Generate minimal constitution and CLAUDE.md with TODOs for customization.

## Examples

```
/setup
# Full interactive wizard

/setup quick
# Quick setup with auto-detection

/setup --reconfigure
# Re-run setup, keeping existing customizations where possible
```


### 6b. Linear Integration (Optional)

```
Do you use Linear for project management?
1. Yes, set up Linear MCP
2. No, skip
3. Show me more info
```

If "Show me more info":
```
Linear MCP allows Claude to interact with your Linear workspace:

CREATE:
- linear_create_issue - Create issues with title, description, priority
- linear_add_comment - Add comments to issues (markdown supported)

READ:
- linear_search_issues - Search with filters (team, status, assignee, labels)
- linear_get_user_issues - Get issues assigned to a user

UPDATE:
- linear_update_issue - Modify title, description, priority, status

This enables:
- Filing issues directly from code reviews
- Creating tickets from discovered bugs
- Updating issue status as you work
- Searching for related issues
```

If yes, add Linear to the MCP registry (on-demand, not auto-loaded):

```bash
/mcp-add linear
```

This saves the config to `.mcp-registry.json`. When you need Linear:

```bash
/mcp-load linear
```

After loading:
1. Claude will prompt for Linear OAuth on first use
2. Grant access to your Linear workspace

**Beads vs Linear:**

| Aspect | Beads | Linear |
|--------|-------|--------|
| Best for | Solo/AI agent memory | Team collaboration |
| Storage | Git-backed local | Cloud-hosted |
| Offline | Yes | No |
| Dependencies | Graph-based | Basic links |
| Cost | Free | Linear pricing |

**Recommendation:** Use both! Beads for AI agent working memory, Linear for team-visible issues.
