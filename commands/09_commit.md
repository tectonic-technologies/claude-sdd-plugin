# Commit Command

Complete pre-commit verification, documentation sync, commit creation, and push workflow.

## Usage

```
/commit
```

## Pipeline Position

```
/research → /clarify → /spec → /plan → /implement → /validate → [/commit]
                                                                     ↓
                                                              Git commit
```

**This is the final step that creates the git commit.**

## What This Command Does

This is the **primary commit workflow** that combines verification, documentation sync, and committing:

1. **Automated Checks**: Run types, lint, build
2. **Documentation Sync**: Verify docs match implementation (NEW)
3. **Manual Verification**: Present relevant checklists
4. **Git Status**: Show changed files and diff stats
5. **Stage Files**: Add relevant files to staging
6. **Generate Commit Message**: Create comprehensive commit with problem/solution structure
7. **Commit**: Create the commit
8. **Push** (optional): Optionally push to remote repository

## Workflow

### Phase 1: Automated Verification

Run all automated checks in parallel:

```bash
pnpm check-types && pnpm lint && pnpm build
```

If any fail, stop and report:
```
❌ Pre-commit verification FAILED

Failed check: {check name}
Error: {error details}

Fix this before committing.
```

### Phase 2: Documentation Sync (NEW)

**Check if documentation matches the implementation being committed.**

#### Step 1: Detect Related Documents

Look for related plan/spec files:
- Check `docs/plans/` for plans related to changed files
- Check `specs/` for specs related to changed files
- Look at git branch name for feature hints

```
Checking documentation consistency...

Related documents found:
- Plan: docs/plans/{feature}.md
- Spec: specs/{feature}.spec.ts
```

#### Step 2: Compare Implementation vs Documentation

If related documents exist:

1. **Check Plan's Implementation Notes**:
   - Does the plan have deviations recorded?
   - Do the changes match what was planned?

2. **Check Spec Examples**:
   - Are spec examples still valid?
   - Do tests pass?

#### Step 3: Report Documentation Status

```
## Documentation Status

| Document | Status | Notes |
|----------|--------|-------|
| Plan | ✅ Current | Implementation Notes up to date |
| Spec | ✅ Current | All examples pass |

OR

| Document | Status | Notes |
|----------|--------|-------|
| Plan | ⚠️ Stale | Missing deviation for {X} |
| Spec | ✅ Current | - |
```

#### Step 4: Handle Stale Documentation

If documentation is stale:

```
⚠️ Documentation may be out of sync:

Plan: docs/plans/{feature}.md
- Missing deviation: {description}

Options:
1. Update plan now (recommended)
2. Proceed anyway (adds Docs-Status: stale trailer)
3. Cancel commit to update docs first

Choice: [1/2/3]
```

**If Option 1 (Update):**
- Update the plan's Implementation Notes section
- Add the changes to staging

**If Option 2 (Proceed anyway):**
- Add git trailer to commit: `Docs-Status: stale`

**If Option 3 (Cancel):**
- Exit commit workflow

#### When No Related Documents Exist

If no plan/spec found:
```
Documentation check: No related plan/spec found.
Proceeding with commit...
```

### Phase 3: Manual Verification Checklist

Present relevant checklists based on files changed:

**General Quality Checklist**:
- [ ] No `console.log` in production code
- [ ] No commented-out code blocks
- [ ] No hardcoded secrets or credentials
- [ ] Error handling implemented for all async operations
- [ ] All TypeScript types properly defined (no `any`)

**Domain-Specific Checklists** (if applicable):

**Platform-Specific Changes**:
- [ ] HMAC validation for webhooks
- [ ] Session tokens verified
- [ ] Shop domain validated
- [ ] API scopes declared
- [ ] GDPR webhooks handled
- [ ] Rate limiting awareness

**Database Changes**:
- [ ] Indexes on frequently queried columns
- [ ] Foreign keys with proper `onDelete`
- [ ] Type inference exported
- [ ] Regional DB via resolver only
- [ ] Migrations generated

**API Changes**:
- [ ] Input validation implemented
- [ ] Consistent response format
- [ ] Proper HTTP status codes
- [ ] Authentication/authorization checked

### Phase 4: Git Status Review

Show current changes:

```bash
git status --short
git diff --stat
```

Present summary:
```
## Files Changed

Modified files:
- path/to/file1.ts (+45, -12)
- path/to/file2.tsx (+23, -8)

New files:
- path/to/new-file.ts

Deleted files:
- path/to/old-file.ts

Documentation files:
- docs/plans/{feature}.md (updated)
```

### Phase 5: Stage Files

Ask user which files to stage or stage all:

```bash
# Stage all changes
git add .

# Or stage specific files
git add <file1> <file2> <file3>
```

### Phase 6: Generate Commit Message

Create comprehensive commit following this template:

```
<type>: <short description>

BREAKING CHANGE: <description> (if applicable)

## Problem
- <What issue was being solved>
- <Context and background>

## Solution

### <Component/Feature Modified>
**Modified:** <files>
- <Change 1>
- <Change 2>

**Why:** <Rationale>

### <Another Component>
**Created:** <files>
- <What was added>

**Why:** <Rationale>

## Documentation
- Plan: docs/plans/{feature}.md (updated/current/n/a)
- Spec: specs/{feature}.spec.ts (updated/current/n/a)

## Migration Guide (if breaking changes)

### Before
```<language>
<old code>
```

### After
```<language>
<new code>
```

## Verification
- ✅ Type checking: PASS
- ✅ Lint: PASS
- ✅ Build: PASS
- ✅ Tests: <result>
- ✅ Docs: <current/updated/stale>

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>

Docs-Status: <current/updated/stale/n/a>
```

### Phase 7: Create Commit

```bash
git commit -m "$(cat <<'EOF'
<generated message>
EOF
)"
```

### Phase 8: Push to Remote (Optional)

Ask user: "Push to remote? (Y/n)"

If yes:
```bash
git push origin $(git branch --show-current)
```

Show PR creation link if new branch.

If no:
```
Commit created locally: <commit-hash>
You can push later with: git push
```

## Commit Types

Use conventional commit types:
- **feat**: New feature
- **fix**: Bug fix
- **refactor**: Code restructuring without behavior change
- **perf**: Performance improvement
- **docs**: Documentation changes
- **test**: Test additions or fixes
- **chore**: Build process, dependencies, tooling
- **style**: Code formatting (no functional changes)

## Documentation Trailers

The commit includes a `Docs-Status` trailer:

| Trailer Value | Meaning |
|---------------|---------|
| `current` | Documentation matches implementation |
| `updated` | Documentation was updated in this commit |
| `stale` | Documentation known to be out of sync (user chose to proceed) |
| `n/a` | No related documentation exists |

## Breaking Changes

If there are breaking changes:
1. Include `BREAKING CHANGE:` in commit body
2. Provide migration guide with before/after examples
3. Document affected APIs/components
4. List required user actions

## Example Execution

### With Documentation Sync

```
User: /commit

Agent: Running automated checks...
✅ Type checking: PASS
✅ Lint: PASS
✅ Build: PASS

Agent: Checking documentation consistency...
Related documents found:
- Plan: docs/plans/user-auth.md
- Spec: specs/user-auth.spec.ts

Documentation status:
| Document | Status |
|----------|--------|
| Plan | ⚠️ Missing deviation |
| Spec | ✅ Current |

Agent: Plan is missing a deviation record:
- You used JWT instead of session tokens (as planned)

Options:
1. Update plan now (recommended)
2. Proceed anyway (adds stale trailer)
3. Cancel commit

User: 1

Agent: Updating plan's Implementation Notes...
✅ Plan updated

Agent: Presenting manual checklist...
[User reviews and confirms]

Agent: Showing git status...
Modified: src/auth/login.ts (+45, -12)
Modified: docs/plans/user-auth.md (+8, -0)

Agent: Staging files...
git add .

Agent: Generating commit message...

Commit message:
feat: implement user authentication with JWT

## Problem
- Need secure user authentication
- Session management required

## Solution

### Authentication Module
**Modified:** src/auth/login.ts
- Implemented JWT-based authentication
- Added token refresh logic

**Why:** JWT provides stateless auth suitable for our API

## Documentation
- Plan: docs/plans/user-auth.md (updated)
- Spec: specs/user-auth.spec.ts (current)

## Verification
- ✅ Type checking: PASS
- ✅ Lint: PASS
- ✅ Build: PASS
- ✅ Tests: 12/12 PASS
- ✅ Docs: updated

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>

Docs-Status: updated

Agent: ✓ Committed: abc1234
Agent: Push to remote? (Y/n)
```

## Integration with Other Commands

- **After `/implement`**: Use `/commit` to save completed work
- **After `/validate`**: Use `/commit` after validation passes
- **After `/refine`**: Use `/commit` when refinement succeeds
- **Instead of `/checklist` + manual commit**: Use `/commit` for complete flow

## Best Practices

1. **Review before committing**: Always check git diff
2. **Keep docs in sync**: Don't skip documentation updates
3. **Atomic commits**: One logical change per commit
4. **Clear messages**: Explain WHY, not just WHAT
5. **Breaking changes**: Always include migration guide
6. **Test results**: Include actual verification output
7. **Clean staging**: Only commit relevant files

## Anti-Patterns

❌ **Don't:**
- Skip automated checks
- Ignore stale documentation warnings
- Commit without manual review
- Use vague commit messages
- Skip migration guide for breaking changes
- Commit unrelated changes together

✅ **Do:**
- Verify all checks pass first
- Update documentation when it's stale
- Review each changed file
- Write detailed problem/solution
- Document breaking changes
- Keep commits focused

## When to Use `/checklist` Instead

Use `/checklist` (not `/commit`) when:
- Mid-implementation quality check
- Want to verify without committing
- Pausing work temporarily
- Checking code health before major changes

**Use `/commit` when you're ready to save and push your work.**

## What Changed from Previous Version

The commit command now:
- ✅ Checks for related plan/spec files
- ✅ Verifies documentation matches implementation
- ✅ Offers to update stale documentation
- ✅ Includes `Docs-Status` trailer in commits
- ✅ Reports documentation status in commit message
