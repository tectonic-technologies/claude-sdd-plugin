# PR Fix Command

Address PR review comments while preserving original design intent from spec and plan. Update spec and plan files to reflect any changes made.

## Pipeline Position

```
/research → /spec → /plan → /implement → /commit → PR Review → [/pr-fix]
                                                                    ↓
                                                        Address feedback
                                                                    ↓
                                                        Update spec/plan
                                                                    ↓
                                                        Ready to merge
```

## Arguments

- `$ARGUMENTS` - **Required**: PR link (GitHub URL) OR pasted review comments
- `--research=path` - Optional: Path to research doc (auto-detects from `docs/research/`)
- `--spec=path` - Optional: Path to spec file (auto-detects from `specs/`)
- `--plan=path` - Optional: Path to plan file (auto-detects from `docs/plans/`)

## Input

- **PR Feedback**: GitHub PR URL or pasted comment text
- **Context Files** (auto-detected if not specified):
  - `docs/research/{feature}.md` - Original research context
  - `specs/{feature}.spec.ts` - Contract/schema definitions
  - `docs/plans/{feature}.md` - Implementation approach

## Output

- Fixed code addressing PR comments
- **Updated spec file** (if contract changes)
- **Updated plan file** (with PR feedback deviations)
- Summary of changes made
- List of comments needing discussion

## Process

### Phase 1: Gather Context

1. Read research, spec, and plan files to understand original intent
2. If paths not provided, auto-detect from:
   - Current git branch name
   - Most recently modified files in each directory

### Phase 2: Fetch PR Comments

**If GitHub URL provided:**
```bash
gh pr view {pr-number} --comments --json comments,reviews
gh api repos/{owner}/{repo}/pulls/{pr-number}/comments
```

**If comments pasted directly:**
Parse the pasted text for review feedback.

### Phase 3: Categorize Comments

| Type | Priority | Action |
|------|----------|--------|
| 🔴 Required Change | High | Must fix before merge |
| 🟠 Suggestion | Medium | Apply if aligns with spec |
| 🟡 Nit/Style | Low | Quick fixes |
| 💬 Question | - | Respond or clarify |
| ✅ Approval | - | No action needed |

### Phase 4: Address Each Comment

For each comment (highest priority first):

```
┌─────────────────────────────────────────────────────┐
│ Comment: {reviewer}: {comment text}                  │
├─────────────────────────────────────────────────────┤
│ File: {file:line}                                    │
│ Type: {required/suggestion/nit/question}             │
│ Spec Check: {aligns with spec? yes/no/n/a}           │
│ Action: {fix applied / needs discussion / skip}      │
└─────────────────────────────────────────────────────┘
```

**Important**: Before applying a suggestion, check if it conflicts with:
- The spec contract (schemas, invariants)
- The plan's architectural decisions
- Other parts of the implementation

If conflict exists, flag for discussion instead of blindly applying.

### Phase 5: GCRV Fix Loop

For each fix:

```
GENERATE → VERIFY → CRITIQUE → REFINE → (repeat until pass)
            ↓
    pnpm typecheck && pnpm lint && pnpm build
```

### Phase 6: Update Spec and Plan Files

**CRITICAL: Keep documentation in sync with changes.**

#### Update Spec File When:
- Schema changes (new fields, modified types)
- New edge cases discovered from PR feedback
- Invariants added or modified
- Examples need updating to match new behavior

#### Update Plan File When:
- Implementation approach changed based on feedback
- Different files modified than originally planned
- New considerations or constraints identified

Add a "PR Feedback" section to the plan's Implementation Notes:

```markdown
## Implementation Notes

### PR Feedback Changes

#### Change: {short description}
- **PR Comment**: "{reviewer comment}"
- **Original Approach**: {what the plan/spec said}
- **New Approach**: {what was changed}
- **Reason**: {why the reviewer feedback was valid}
```

### Phase 7: Verification

After all fixes:
```bash
pnpm typecheck && pnpm lint && pnpm build
```

### Phase 8: Summary

```markdown
# PR Fix Summary

## Comments Addressed

| # | Reviewer | Comment | Action |
|---|----------|---------|--------|
| 1 | @alice | Missing null check | ✅ Fixed |
| 2 | @bob | Consider using memo | ✅ Applied |
| 3 | @alice | Why not use X? | 💬 Responded |

## Needs Discussion

### Comment by @bob: "Should we use a different pattern here?"
- **File**: src/components/Widget.tsx:45
- **Spec says**: Uses observer pattern (invariant #3)
- **Recommendation**: Keep current approach per spec, explain in PR comment

## Documentation Updated

### Spec Changes
- Added edge case: empty array handling
- Updated inputSchema: new optional field `timeout`

### Plan Changes
- Added PR Feedback section with 2 changes recorded
- Updated files list to include new utility

## Files Modified
- src/components/Widget.tsx
- src/hooks/useWidget.ts
- specs/widget.spec.ts (spec updated)
- docs/plans/widget.md (plan updated)

## Verification
- pnpm typecheck: ✅
- pnpm lint: ✅
- pnpm build: ✅
```

## Example Usage

```bash
# With GitHub PR link
/pr-fix https://github.com/org/repo/pull/123 --spec=specs/feature.spec.ts

# With pasted comments
/pr-fix "
@reviewer1: Missing error handling on line 45
@reviewer2: Consider using useMemo here for performance
" --plan=docs/plans/feature.md

# Auto-detect all context files
/pr-fix https://github.com/org/repo/pull/123
```

## When to Skip a Suggestion

Skip (and flag for discussion) when:
- Suggestion conflicts with spec invariants
- Suggestion would require plan deviation without justification
- Suggestion is opinion-based with no clear improvement
- Suggestion would break other parts of the system

## Document Update Checklist

Before completing, verify:
- [ ] Spec updated if contract/schema changed
- [ ] Spec examples updated if behavior changed
- [ ] Plan updated with PR Feedback section
- [ ] All changes documented for future reference

## Integration

Works with:
- `/commit` - Commit the fixes (include spec/plan changes)
- `/validate` - Re-verify implementation after fixes

## Focus: $ARGUMENTS
