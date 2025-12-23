# Resume Work

Resume previously saved work by restoring full context and continuing implementation.

## Arguments
- `$ARGUMENTS` - Path to session file (e.g., `docs/sessions/2025-01-06_feature.md`)

## When to Use

- Returning to a previously paused feature
- Starting a new session on existing work
- Switching back to a saved task
- Recovering from an interrupted session

## Process

### Step 1: Load Session Context

If session file provided:
```
/resume docs/sessions/2025-01-06_user_management.md
```

Or discover recent sessions:
```bash
ls -la docs/sessions/
```

### Step 2: Restore Full Context

Read in order:
1. **Session summary** - Where we left off
2. **Implementation plan** - Overall progress
3. **Recent commits** - Completed work

```bash
git status
git log --oneline -10
git stash list
```

### Step 3: Rebuild Mental Model

```markdown
## Resuming: {Feature Name}

### Where We Left Off
- Working on: {Specific task}
- Phase: {X of Y}
- Last action: {What was being done}
- GCRV iteration: {N}/5

### Current State
- [ ] `pnpm check-types`: {status}
- [ ] `pnpm lint`: {status}
- [ ] `pnpm build`: {status}
- [ ] Uncommitted changes: {list}

### Immediate Next Steps
1. {First action to take}
2. {Second action}
3. {Continue with plan phase X}
```

### Step 4: Restore Working State

1. Apply any stashed changes:
   ```bash
   git stash pop stash@{n}
   ```

2. Verify environment:
   ```bash
   pnpm check-types && pnpm lint && pnpm build
   ```

3. Load todos and restore from session

### Step 5: Continue with GCRV

Based on plan checkboxes, identify where to resume:

```markdown
Looking at the plan, I need to continue with:
- [ ] Phase 2: API endpoints
  - [x] GET endpoints
  - [ ] POST endpoints <- Resume here
  - [ ] DELETE endpoints

Starting GCRV loop for POST endpoints...
```

### Step 6: Communicate Status

```markdown
Context restored!

Resuming: {Feature Name}
Current Phase: {X of Y}
Next Task: {Specific task}
GCRV Status: Iteration {N}/5

Previous session:
- Completed: {Y tasks}
- Remaining: {Z tasks}

Continuing with {specific next action}...
```

## Resume Patterns

### Pattern 1: Quick Resume (Same Day)
```
/resume
> Continue the user management feature from this morning
```
1. Find most recent session
2. Read plan to see progress
3. Continue from last checkbox with GCRV

### Pattern 2: Full Context Restore (Days Later)
```
/resume docs/sessions/2025-01-03_auth_refactor.md
```
1. Read full session summary
2. Check git history since then
3. Verify environment still builds
4. Rebuild complete context
5. Continue with GCRV loop

### Pattern 3: Investigate and Resume
```
/resume
> What was I working on last week?
```
1. List recent sessions
2. Show git branches with recent activity
3. Present options
4. Resume chosen work

## Handling Changes Since Last Session

If codebase changed:
1. Check for conflicts with current branch
2. Review changes to related files
3. Update plan if needed
4. Run full GCRV verification before continuing

```markdown
## Changes Since Last Session
- New commits: {list}
- Modified files: {that affect our work}
- Plan updates: {if any}
- GCRV status: Running full verification...
```

## Recovery Mode

If session wasn't properly saved:
1. Use git reflog to find work
2. Check editor backup files
3. Review shell history
4. Reconstruct from available evidence

## Integration

Works with:
- `/save` - Creates sessions to resume from
- `/implement` - Continues implementation with GCRV
- `/research` - Refresh understanding if needed
- `/validate` - Check what's been completed

## Success Criteria

A successful resume should:
- [ ] Load all relevant context
- [ ] Identify exact continuation point
- [ ] Restore working environment
- [ ] Verify GCRV status (run checks)
- [ ] Continue seamlessly from pause point
- [ ] Maintain plan consistency
- [ ] Preserve all previous decisions
