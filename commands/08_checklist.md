# Checklist Command

Run comprehensive pre-commit quality validation checklist (verification only).

## When to Use This vs /commit

| Scenario | Command | Why |
|----------|---------|-----|
| **Want to commit** | `/commit` | Does verification + commit (optional push) |
| **Just want to verify** | `/checklist` | Verification only, no commit |
| **Mid-implementation check** | `/checklist` | Quick quality check |
| **Before pausing work** | `/checklist` | Ensure code is clean |
| **PR review prep** | `/checklist` | Final verification |

**Use `/commit` for the complete workflow** (most common case).
**Use `/checklist` when you only want to verify** without committing.

> Note: `/commit` will ask if you want to push to remote. You can commit locally without pushing.

## Arguments
- `$ARGUMENTS` - Optional scope filter (package name or "all")

## Purpose

Validate that your changes meet all quality gates. This command runs automated checks and provides a manual verification checklist but does NOT create commits.

## When to Use

**Use for verification only:**
- Mid-implementation quality checks
- Before pausing work (ensure code is clean)
- PR review preparation
- After major refactoring
- Periodic code health checks

**Use /commit instead when:**
- You're ready to commit and push
- Completing a task or feature
- Ending a work session and want to save progress

## Execution Process

### Phase 1: Automated Verification

Run all automated checks in sequence:

```bash
# Type checking
pnpm check-types

# Linting
pnpm lint

# Build verification
pnpm build

# Database schema check (if modified)
pnpm db:generate:central
pnpm db:generate:regional
```

Report results:
```
## Automated Checks

✅ TypeScript compilation: PASS
✅ Lint: PASS
✅ Build: PASS
✅ Database schemas: PASS
```

If any fail, stop and report:
```
❌ Pre-commit validation FAILED

Failed check: {check name}
Error: {error details}

Fix this before committing.
```

### Phase 2: General Quality Checklist

Present manual checklist for user verification:

```markdown
## General Quality Checklist

Before committing, verify:

### Code Quality
- [ ] No `console.log` statements in production code
- [ ] No commented-out code blocks
- [ ] No hardcoded secrets or credentials
- [ ] No `.only` or `.skip` in tests
- [ ] Error handling implemented for all async operations
- [ ] All TypeScript types properly defined (no `any` without justification)

### Documentation
- [ ] Public APIs have JSDoc comments
- [ ] Complex logic has explanatory comments
- [ ] README updated if user-facing changes
- [ ] Spec file updated if requirements changed

### Testing
- [ ] New features have tests
- [ ] Edge cases covered
- [ ] Error cases tested
- [ ] Integration tests pass (if applicable)

### Dependencies
- [ ] New dependencies justified and documented
- [ ] Package versions pinned appropriately
- [ ] No unused dependencies
- [ ] No dependency version conflicts

### Performance
- [ ] No obvious performance regressions
- [ ] Database queries optimized (indexes, batching)
- [ ] No N+1 queries introduced
- [ ] API rate limiting considered
```

### Phase 3: Domain-Specific Checks

Based on files modified, present relevant domain checklists:

#### Example: E-commerce Platform Changes

```markdown
## Example: E-commerce Checklist

If you modified e-commerce integration code:

- [ ] Webhook signatures validated
- [ ] Session tokens verified
- [ ] Store domain validated
- [ ] API scopes declared
- [ ] Privacy webhooks handled
- [ ] Rate limiting implemented
- [ ] GraphQL queries validated
- [ ] UI components used correctly
```

#### Database Changes

```markdown
## Database-Specific Checklist

If you modified database schemas or queries:

- [ ] Indexes added on frequently queried columns
- [ ] Foreign keys have proper `onDelete` behavior
- [ ] Type inference exported (`$inferSelect`, `$inferInsert`)
- [ ] Regional DB accessed via `getDbForBrand()` only (not direct client)
- [ ] Connection pooling configured correctly
- [ ] Migrations generated and tested
- [ ] No raw SQL without proper escaping
- [ ] Timestamps added (createdAt, updatedAt)
```

#### API Changes

```markdown
## API-Specific Checklist

If you modified API routes or endpoints:

- [ ] Input validation implemented
- [ ] Consistent response format (`{ data: T } | { error: string }`)
- [ ] Proper HTTP status codes used
- [ ] Authentication/authorization checked
- [ ] CORS configured if needed
- [ ] Error messages don't leak sensitive info
- [ ] Request/response types exported
```

#### Auth Changes

```markdown
## Auth-Specific Checklist

If you modified authentication code:

- [ ] Server-side auth uses `getAuthUserId()` or `getSessionUser()`
- [ ] Client-side auth wrapped in `AuthProvider`
- [ ] Unauthenticated users redirected appropriately
- [ ] Session tokens validated
- [ ] No auth tokens logged or exposed
- [ ] Database client initialized correctly
```

#### Storage Changes

```markdown
## Storage-Specific Checklist

If you modified file storage code (Cloudflare R2):

- [ ] File keys use proper naming convention
- [ ] Content types set correctly
- [ ] Cache headers configured
- [ ] Presigned URLs used for sensitive files
- [ ] File cleanup implemented (no orphaned files)
- [ ] Error handling for upload/download failures
```

### Phase 4: Security Checklist

```markdown
## Security Checklist

Critical security checks:

- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities (sanitize user input)
- [ ] No CSRF vulnerabilities (use tokens)
- [ ] No command injection (validate shell inputs)
- [ ] No insecure file uploads (validate types, scan for malware)
- [ ] Secrets in environment variables, not code
- [ ] No sensitive data in logs
- [ ] Authentication required for protected routes
- [ ] Authorization checks for user-specific data
- [ ] Rate limiting on public endpoints
```

### Phase 5: Git Status Check

Show current git status:

```bash
git status
git diff --stat
```

Present summary:
```markdown
## Files Changed

Modified files:
- `path/to/file1.ts` (+45, -12)
- `path/to/file2.tsx` (+23, -8)

New files:
- `path/to/new-file.ts`

Ensure all changes are intentional and related to your task.
```

### Phase 6: Final Report

Generate final report:

```markdown
# Pre-Commit Validation Report

## Automated Checks
✅ All passed

## Manual Verification
Please confirm you've reviewed all applicable checklists above.

## Summary
- Files modified: {count}
- Lines added: {count}
- Lines removed: {count}
- Checks passed: {count}/{total}

## Next Steps
If all checks pass and manual verification complete:
1. Review the changes one more time
2. Create commit: `git commit -m "your message"`
3. Push to remote: `git push`

If checks failed:
1. Fix the issues reported above
2. Run /checklist again
3. Repeat until all pass
```

## Scope Filtering

If `$ARGUMENTS` contains a package name:

```bash
# Check only specific package
turbo run check-types lint build --filter={package}
```

Only show checklists relevant to that package.

## Integration

Works with:
- `/implement` - Run before marking phase complete
- `/refine` - Run after refinement loop succeeds
- `/validate` - Run as part of validation
- Git workflow - Always run before `git commit`

## Example Usage

```
/checklist
# Full validation of all changes

/checklist packages/database
# Validate only database package changes

/checklist shopify-apps
# Validate only specific app changes
```

## Auto-Fix Suggestions

If automated checks fail with fixable issues:

```markdown
## Auto-Fix Available

The following issues can be auto-fixed:

❌ Lint errors: 12 issues
   Run: pnpm lint:fix

❌ Format issues: 45 files
   Run: pnpm format

Would you like me to run these fixes? (Y/n)
```

## Configuration

Customize checks in `.claude/checklist-config.json` (optional):

```json
{
  "skipChecks": [],
  "customChecks": [
    {
      "name": "Custom Check",
      "command": "pnpm custom:check",
      "required": true
    }
  ],
  "autoFix": true
}
```

## Guidelines

1. **Run early, run often** - Don't wait until the end
2. **Fix issues immediately** - Don't accumulate technical debt
3. **Review manually** - Automated checks don't catch everything
4. **Be honest** - If you're unsure about a checklist item, investigate
5. **Document exceptions** - If you skip a check, note why

## Anti-Patterns

**Don't:**
- Skip the checklist because "it's a small change"
- Ignore failed checks with the intent to "fix later"
- Commit without running the checklist
- Auto-fix without understanding what's being fixed
- Rush through manual verification

## Scope: $ARGUMENTS
