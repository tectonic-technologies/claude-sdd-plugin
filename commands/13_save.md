# Save Progress

Create a comprehensive progress checkpoint when pausing work on a feature.

## Beads Integration ("Landing the Plane")

Before saving, ensure Beads state is current:

```bash
# Update any in-progress beads
bd list --status in_progress

# Close completed work
bd close <id> --reason "Completed X, Y, Z"

# File remaining work as new beads
bd create "TODO: remaining work" -p 2

# Sync to git
bd sync
```

This ensures work survives context switches and can be resumed.

---

## When to Use

- User needs to stop mid-implementation
- Switching to another task/feature
- End of work session
- Before context switch

## Process

### Step 1: Assess Current State

1. Review conversation history for context
2. Check git status for uncommitted changes
3. Identify active plan if one exists
4. Review todo list for current tasks

### Step 2: Save Code Progress

```bash
git status
git diff
```

If meaningful work exists, create WIP commit:
```bash
git add {specific files}
git commit -m "WIP: {Feature} - {Current state}"
```

Note any uncommitted changes and why they weren't committed.

### Step 3: Update Plan Document

If working from a plan, add checkpoint:

```markdown
---

## Progress Checkpoint - {ISO Timestamp}

### Work Completed This Session
- [x] Specific task completed
- [x] Another completed item
- [ ] Partially complete task (50% done)

### Current State
- **Active File**: `path/to/file.ts:123`
- **Current Task**: {What you were doing}
- **Blockers**: {Any issues encountered}

### GCRV Status
- Last verification: {pass/fail}
- Iteration: {N}/5
- Pending issues: {list}

### Local Changes
- Modified: `file1.ts` - Added validation logic
- Modified: `file2.ts` - Partial refactor
- Untracked: `test.tmp` - Temporary test file

### Next Steps
1. {Immediate next action}
2. {Following task}
3. {Subsequent work}

### Context Notes
- {Important discovery or decision}
- {Gotcha to remember}
- {Dependency to check}

### Commands to Resume
```bash
cd /path/to/your/project
git status
/resume docs/sessions/{session-file}.md
```
```

### Step 4: Create Session Summary

Save to `docs/sessions/{date}_{feature}.md`:

```markdown
---
date: {ISO timestamp}
feature: {Feature name}
plan: docs/plans/{plan}.md
status: in_progress
last_commit: {git hash}
---

# Session Summary: {Feature Name}

## Session Duration
- Started: {timestamp}
- Ended: {timestamp}

## Objectives
- {What we set out to do}

## Accomplishments
- {What was completed}
- {Problems solved}
- {Code written}

## GCRV Loop Status
- Total iterations: {N}
- Phases completed: {X}/{Y}
- Current verification: {pass/fail}

## Discoveries
- {Important findings}
- {Patterns identified}
- {Issues uncovered}

## Decisions Made
- {Architecture choices}
- {Implementation decisions}
- {Trade-offs accepted}

## Open Questions
- {Unresolved issues}
- {Needs investigation}
- {Requires team input}

## File Changes
```bash
git diff --stat HEAD~N..HEAD
```

## Test Status
- [ ] `pnpm check-types` passing
- [ ] `pnpm lint` passing
- [ ] `pnpm build` passing

## Ready to Resume
To continue this work:
1. Read this session summary
2. Check plan: `{plan path}`
3. Run `/resume docs/sessions/{this-file}.md`

## Additional Context
{Any other important information}
```

### Step 5: Clean Up

1. Commit all meaningful changes:
   ```bash
   git status
   git diff
   git add .
   git commit -m "WIP: {Feature} - Save progress checkpoint"
   ```

2. Update todo list to reflect saved state

3. Present summary:
   ```
   Progress saved!

   Session summary: docs/sessions/{file}
   Plan updated: docs/plans/{file}
   Commits created: {list}

   To resume: /resume docs/sessions/{file}
   ```

## Important Guidelines

- **Always commit meaningful work** - Don't leave important changes uncommitted
- **Be specific in notes** - Future you needs clear context
- **Include commands** - Make resuming copy-paste easy
- **Document blockers** - Explain why work stopped
- **Reference everything** - Link to plans, research, commits
- **Note GCRV status** - Where in the loop did we stop?

## Integration

Works with:
- `/implement` - Updates plan progress
- `/resume` - Paired resume command
- `/validate` - Can validate partial progress
