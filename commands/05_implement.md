# Implement from Plan

Implement a feature from its plan using the GCRV refinement loop, tracking any deviations.

## Pipeline Position

```
/research → /clarify → /spec → /plan → [/implement]
                                            ↓
                                  Implementation + Tests
                                            ↓
                              Plan updated with deviations
```

**This is the FIFTH and FINAL step in the development pipeline.**

## Arguments
- `$ARGUMENTS` - **Required**: Path to plan file (e.g., `docs/plans/feature-name.md`)

## Input
- **File**: `docs/plans/{feature}.md` (from /plan command)
- **Referenced**: `specs/{feature}.spec.ts` (via plan frontmatter)

## Output
- Implementation code matching the spec contract
- Generated tests from spec examples
- **Plan file updated with any deviations**

## Process

### 1. Validate Input

If no file path provided:
```
Usage: /implement docs/plans/{feature}.md

Please provide the path to a plan file. Run the full pipeline first:
/research → /clarify → /spec → /plan → /implement
```

If file doesn't exist:
```
Plan file not found: {path}

Pipeline: /research {topic} → /clarify → /spec → /plan → /implement
```

### 2. Read Plan and Spec

1. Read the plan file completely and extract:
   - Phases and implementation steps
   - Files to modify
   - Spec file reference

2. Read the referenced spec file for:
   - Input/output schemas (the contract)
   - Examples (become test cases)
   - Invariants (must always hold)
   - Edge cases and constraints

### 3. Create Feature Branch

**ALWAYS create a new branch before implementing:**

```
Based on the plan, I'll create a feature branch:

  git checkout -b feat/{feature-name}

Proceed? [Y/n]
```

### 4. Generate Tests First (TDD)

Create test file from spec examples:

**File**: `specs/{feature-name}.test.ts` or appropriate test location

```typescript
import { describe, it, expect } from 'vitest';
import { spec, execute, validateInput, validateOutput } from './{feature-name}.spec';

describe(spec.name, () => {
  // Test each example from spec
  spec.examples.forEach((example) => {
    it(example.description, async () => {
      const input = validateInput(example.input);

      if (example.shouldThrow) {
        await expect(execute(input)).rejects.toThrow();
      } else {
        const output = await execute(input);
        expect(validateOutput(output)).toEqual(example.expectedOutput);
      }
    });
  });

  // Test each edge case
  spec.edgeCases.forEach((edgeCase) => {
    it(edgeCase.description, async () => {
      // Edge case test
    });
  });

  // Test invariants
  describe('invariants', () => {
    spec.invariants.forEach((invariant) => {
      it(invariant, async () => {
        // Property-based test for invariant
      });
    });
  });
});
```

### 5. GCRV Implementation Loop

**Apply for EVERY phase from the plan:**

```
┌─────────────────────────────────────────────────────────────────┐
│                     REFINEMENT LOOP                             │
├─────────────────────────────────────────────────────────────────┤
│   ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐ │
│   │ GENERATE │───▶│  VERIFY  │───▶│ CRITIQUE │───▶│  REFINE  │ │
│   └──────────┘    └────┬─────┘    └──────────┘    └────┬─────┘ │
│        ▲               │                               │       │
│        │          PASS ▼                               │       │
│        │         ┌──────────┐                          │       │
│        │         │   DONE   │                          │       │
│        │         └──────────┘                          │       │
│        └─────────────────────────────FAIL──────────────┘       │
│                                                                 │
│   Feedback = TypeCheck + Lint + Build + Tests                   │
└─────────────────────────────────────────────────────────────────┘
```

### Verification Commands

After EVERY change:
```bash
pnpm check-types && pnpm lint && pnpm build && pnpm test --filter {package}
```

### Iteration Reporting

```
Iteration N/5: {what changed}
- Changed: {file:line}
- Reason: {why}
- Tests: {pass/fail count}
- Result: {pass/fail}
```

### Termination Conditions

| Condition | Action |
|-----------|--------|
| All checks + tests pass | DONE |
| After 5 iterations | STOP - ask for help |
| Spec unclear | STOP - clarify |

## Deviation Tracking

**CRITICAL: When implementation differs from plan, update the plan file.**

### When to Record a Deviation

Record a deviation when:
- You take a different approach than planned
- You modify different files than listed
- The code structure differs significantly
- You discover the plan was incorrect or incomplete

### How to Record Deviations

Update the plan's "Implementation Notes" section:

```markdown
## Implementation Notes

_Updated during implementation_

### Deviations

### Deviation: {short description}
- **Phase**: Phase {N}
- **Planned**: {what the plan said to do}
- **Actual**: {what was actually done}
- **Reason**: {why the change was needed}

### Deviation: {another deviation}
...
```

### Example Deviation Entry

```markdown
### Deviation: Used React Query instead of SWR
- **Phase**: Phase 2 - Data Fetching
- **Planned**: Use SWR for data fetching with custom hooks
- **Actual**: Used React Query (TanStack Query) with suspense
- **Reason**: React Query has better TypeScript support and suspense integration needed for the streaming UI
```

## Implementation Steps

### Phase-by-Phase from Plan

For each phase in the plan:

1. **Read phase details** from plan file
2. **Implement changes** following plan's approach
3. **Track deviations** - if approach differs, update plan
4. **Run verification**: `pnpm check-types && pnpm lint && pnpm build`
5. **Run tests**: `pnpm test --filter {package}`
6. **If fail**: Critique → Refine → Verify again
7. **If pass**: Mark phase complete, move to next

### Update Spec File

After implementation, update the spec's execute function:

```typescript
export async function execute(input: Input): Promise<Output> {
  // Actual implementation
  const validated = validateInput(input);
  // ... implementation logic ...
  return result;
}
```

## When Stuck

After 5 failed iterations:

```markdown
## Stuck After 5 Iterations

### Plan
{plan file path}

### Spec
{spec file path}

### What I'm Trying
{Current phase/task}

### Attempts
1. Iteration 1: {approach} → {result}
2. Iteration 2: {approach} → {result}
...

### Current Error
```
{exact error}
```

### Failing Test
{which spec example is failing}

### Question
{specific question}
```

## Success Criteria

Implementation is complete when:
- [ ] All spec examples pass
- [ ] All edge cases handled
- [ ] All invariants hold
- [ ] `pnpm check-types` passes
- [ ] `pnpm lint` passes
- [ ] `pnpm build` passes
- [ ] Tests pass
- [ ] **Plan updated with any deviations**

## Final Output

```
Implementation complete!

Branch: feat/{feature-name}

Files created/modified:
- {file1}
- {file2}

Tests: {pass count}/{total count} passing

All spec examples validated ✓
All invariants hold ✓

Deviations from plan: {count}
- {deviation 1 summary}
- {deviation 2 summary}

Plan updated: docs/plans/{feature-name}.md

**Next steps**:
1. `/validate` - Verify implementation (optional)
2. `/commit` - Commit changes
3. Create PR when ready
```

## Integration

This command completes the pipeline:
- **Input**: Plan file (implementation approach)
- **References**: Spec file (contract/test cases)
- **Output**: Working implementation + tests + updated plan

Works with:
- `/validate` - Verify implementation matches plan
- `/commit` - Commit the changes (checks doc consistency)
- `/save` - Save progress if interrupted

## Document Updates During Implementation

| Document | What Gets Updated |
|----------|-------------------|
| Plan | "Implementation Notes" section with deviations |
| Spec | `execute()` function with actual implementation |
| Tests | Generated from spec examples |

The plan serves as both the implementation guide AND the record of what actually happened.
