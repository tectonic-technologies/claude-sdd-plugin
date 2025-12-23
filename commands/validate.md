# Validate Implementation

Validate that an implementation matches its plan and spec, updating documentation if deviations are found.

## Pipeline Position

```
/research → /clarify → /spec → /plan → /implement → [/validate] → /commit
                                                         ↓
                                              Validation Report
                                                         ↓
                                            Plan updated if needed
```

**This is an optional step after /implement, before /commit.**

## Arguments
- `$ARGUMENTS` - Path to plan file (e.g., `docs/plans/feature.md`)

## Input
- **File**: `docs/plans/{feature}.md` (the plan being validated)
- **Referenced**: `specs/{feature}.spec.ts` (the contract)

## Output
- Validation report
- **Plan file updated with any unrecorded deviations**

## Process

### Step 1: Read Plan and Spec

1. **Read the implementation plan** completely:
   - Phases and expected changes
   - Files to modify
   - Implementation Notes (deviations already recorded)
   - Spec file reference

2. **Read the spec file**:
   - Input/output schemas
   - Examples (test cases)
   - Invariants

### Step 2: Context Discovery

1. **Identify what should have changed**:
   - List all files that should be modified (from plan)
   - Note all success criteria
   - Identify key functionality to verify

2. **Spawn parallel research tasks** to discover actual implementation:
   - Find what files were actually modified
   - Check if tests exist and pass
   - Verify code structure matches plan

### Step 3: Systematic Validation

For each phase in the plan:

1. **Check completion status**:
   - Look for checkmarks in the plan (`- [x]`)
   - Verify actual code matches claimed completion

2. **Run automated verification (GCRV)**:
   ```bash
   pnpm check-types && pnpm lint && pnpm build
   ```
   - Document pass/fail status
   - If failures, investigate root cause

3. **Run spec tests**:
   ```bash
   pnpm test --filter {package}
   ```
   - Verify all spec examples pass
   - Check invariants hold

4. **Compare plan vs reality**:
   - Files planned vs files modified
   - Approach planned vs approach taken
   - Check if deviations were recorded

### Step 4: Documentation Consistency Check

**NEW: Verify documentation matches implementation**

1. **Check Plan's Implementation Notes**:
   - Were all deviations recorded during /implement?
   - Are there unrecorded deviations?

2. **Check Spec Examples**:
   - Do examples still match the implementation?
   - Are there new edge cases discovered?

3. **Flag Documentation Gaps**:
   - List any unrecorded deviations
   - Note any spec examples that may need updating

### Step 5: Generate Validation Report

```markdown
## Validation Report: {Plan Name}

### References
- **Plan**: `docs/plans/{feature}.md`
- **Spec**: `specs/{feature}.spec.ts`
- **Research**: `docs/research/{topic}.md`

### Implementation Status

| Phase | Status | Notes |
|-------|--------|-------|
| Phase 1: {Name} | {Complete/Partial/Not started} | {notes} |
| Phase 2: {Name} | {Status} | {notes} |

### GCRV Verification Results

```bash
pnpm check-types  # {PASS/FAIL}
pnpm lint         # {PASS/FAIL}
pnpm build        # {PASS/FAIL}
pnpm test         # {PASS/FAIL} ({pass}/{total})
```

### Spec Compliance

| Spec Item | Status |
|-----------|--------|
| Example: normal-case | {PASS/FAIL} |
| Example: edge-case | {PASS/FAIL} |
| Example: error-case | {PASS/FAIL} |
| Invariants | {All hold / {N} violations} |

### Code Review Findings

#### Matches Plan
- {What was correctly implemented}
- {Another correct implementation}

#### Recorded Deviations (from Implementation Notes)
- {Deviation already recorded in plan}

#### Unrecorded Deviations Found
- {Deviation NOT recorded in plan}
- {Another unrecorded deviation}

### Documentation Status

| Document | Status | Action Needed |
|----------|--------|---------------|
| Plan | {Current/Stale} | {None/Update Implementation Notes} |
| Spec | {Current/Stale} | {None/Update examples} |

### Manual Testing Required

1. UI functionality:
   - [ ] Verify feature appears correctly
   - [ ] Test error states

2. Integration:
   - [ ] Confirm works with existing components
   - [ ] Check performance

### Recommendations
- {Action items before merge}
- {Improvements to consider}
```

### Step 6: Update Documentation (if needed)

**If unrecorded deviations are found:**

```
Found {N} unrecorded deviation(s):

1. {Deviation description}
2. {Another deviation}

Would you like me to update the plan's Implementation Notes section? [Y/n]
```

If yes, add to the plan:

```markdown
## Implementation Notes

### Deviations

### Deviation: {discovered during validation}
- **Phase**: {phase}
- **Planned**: {what plan said}
- **Actual**: {what was found}
- **Reason**: {inferred or ask user}
- **Discovered**: During validation (not recorded during implementation)
```

### Step 7: Present Summary

```
Validation complete!

Status: {PASS / PASS with notes / NEEDS ATTENTION}

Spec compliance: {all examples pass / {N} failures}
GCRV checks: {all pass / {N} failures}
Documentation: {current / updated / needs review}

{If issues found}
Issues requiring attention:
1. {Issue 1}
2. {Issue 2}

{If documentation updated}
Documentation updated:
- Plan: Added {N} deviation(s) to Implementation Notes

**Next step**: `/commit`
```

## Validation Checklist

Always verify:
- [ ] All phases marked complete are actually done
- [ ] `pnpm check-types` passes
- [ ] `pnpm lint` passes
- [ ] `pnpm build` passes
- [ ] All spec examples pass
- [ ] All invariants hold
- [ ] Code follows existing patterns
- [ ] No regressions introduced
- [ ] Error handling is robust
- [ ] **Plan's Implementation Notes reflect actual deviations**
- [ ] **Spec examples still valid**

## Important Guidelines

1. **Be thorough but practical** - Focus on what matters
2. **Run all automated checks** - Don't skip GCRV verification
3. **Document everything** - Both successes and issues
4. **Update stale docs** - Don't leave documentation out of sync
5. **Think critically** - Question if implementation solves the problem
6. **Consider maintenance** - Will this be maintainable?

## Integration

Works with:
- `/plan` - Creates the plan being validated
- `/spec` - Defines the contract being verified
- `/implement` - Executes the plan
- `/commit` - Commits with doc consistency check
- `/save` - Saves progress if issues found

## What Changed from Previous Version

The validate command now:
- ✅ Checks spec examples pass
- ✅ Detects unrecorded deviations
- ✅ Offers to update plan's Implementation Notes
- ✅ Reports documentation status
- ✅ References the new pipeline order
