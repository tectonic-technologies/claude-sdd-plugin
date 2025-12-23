# Review Command

Perform code review with spec validation, pattern checking, and security analysis.

## Beads Integration

**File beads for issues found during review** (Steve Yegge tip):
```bash
bd create "Fix: {issue description}" -p 2
bd dep add <new-id> <parent-feature-id> --type discovered-from
```

This creates actionable, trackable issues from code review findings.

---

## Arguments

- `$ARGUMENTS` - Files, directories, or git diff to review

## Review Dimensions

### 1. Correctness

- Does the code do what it's supposed to?
- Are edge cases handled?
- If spec exists, does implementation match?

### 2. Type Safety

- Are types properly defined and exported?
- Any `any` types that should be specific?
- Proper use of generics?

### 3. Error Handling

- Are errors caught and handled appropriately?
- Proper error messages for debugging?
- No swallowed errors?

### 4. Security

- Input validation present?
- HMAC verification for webhooks?
- No sensitive data in logs?
- SQL injection prevention (parameterized queries)?

### 5. Performance

- Unnecessary re-renders in React?
- Missing indexes for DB queries?
- N+1 query problems?
- Proper use of caching?

### 6. Patterns

- Follows project conventions (see CLAUDE.md)?
- Proper import order?
- File naming correct?
- Component patterns (server vs client)?

### 7. Platform-Specific (if applicable)

- Rate limiting handled?
- Bulk operations for large datasets?
- Session tokens verified?
- GDPR webhooks implemented?

## Review Process

```
┌─────────────────────────────────────────────────────┐
│ CODE REVIEW: {target}                               │
├─────────────────────────────────────────────────────┤
│                                                     │
│ 1. Read all changed files                           │
│ 2. Check for spec in specs/ directory               │
│ 3. Analyze against each dimension                   │
│ 4. Generate findings with severity                  │
│ 5. Suggest specific fixes                           │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## Severity Levels

| Level | Description | Action |
|-------|-------------|--------|
| 🔴 Critical | Security issue, data loss risk | Must fix before merge |
| 🟠 High | Bug, type error, missing validation | Should fix |
| 🟡 Medium | Code smell, pattern violation | Consider fixing |
| 🟢 Low | Style, minor improvement | Optional |
| 💡 Suggestion | Enhancement idea | Future consideration |

## Output Format

```markdown
# Code Review: {target}

## Summary
- Files reviewed: {N}
- Issues found: {N} (🔴{n} 🟠{n} 🟡{n} 🟢{n})

## Findings

### 🔴 Critical: Missing HMAC verification
**File:** `apps/shopify-apps/src/app/[appId]/api/webhooks/route.ts:25`
**Issue:** Webhook handler processes requests without verifying HMAC signature
**Risk:** Attackers can send fake webhook events
**Fix:**
```typescript
import { verifyWebhookHmac } from 'your-packages/integrations';

const isValid = verifyWebhookHmac(body, hmacHeader, apiSecret);
if (!isValid) {
  return NextResponse.json({ error: 'Invalid signature' }, { status: 401 });
}
```

### 🟠 High: Unhandled promise rejection
**File:** `packages/database/src/resolver.ts:45`
**Issue:** `getDbForBrand` doesn't handle case where brand doesn't exist
**Fix:** Add null check and throw descriptive error

### 🟡 Medium: Missing type export
**File:** `packages/utils/src/format.ts`
**Issue:** Return types not exported for public functions
**Fix:** Export type definitions

## Checklist

- [ ] All critical issues addressed
- [ ] High priority issues addressed
- [ ] Types verified with `pnpm check-types`
- [ ] Lint passed with `pnpm lint`
- [ ] Build successful with `pnpm build`
```

## Example Usage

```
/review src/components/UserProfile.tsx
# Review single file

/review packages/shopify-shared
# Review entire package

/review git diff main
# Review changes from main branch

/review apps/admin/src/app/api
# Review all API routes
```

## Target: $ARGUMENTS
