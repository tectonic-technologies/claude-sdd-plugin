# Create Implementation Plan

Create detailed implementation plans from specifications to define HOW to build.

## Pipeline Position

```
/research → /clarify → /spec → [/plan] → /implement
                                  ↓
                          docs/plans/{feature}.md
```

**This is the FOURTH step in the development pipeline.**

The spec defines WHAT to build (contract). The plan defines HOW to build it (approach).

## Arguments
- `$ARGUMENTS` - **Required**: Path to spec file (e.g., `specs/feature-name.spec.ts`)

## Input
- **File**: `specs/{feature}.spec.ts` (from /spec command)
- **Referenced**: `docs/research/{topic}.md` (via spec.research field)

## Output
- **File**: `docs/plans/{feature-name}.md`

## Process

### 1. Validate Input

If no file path provided:
```
Usage: /plan specs/{feature}.spec.ts

Please provide the path to a spec file. Run /research → /clarify → /spec first.
```

If file doesn't exist:
```
Spec file not found: {path}

Pipeline: /research {topic} → /clarify → /spec → /plan
```

### 2. Read Spec and Research

1. Read the spec file completely and extract:
   - Name and description
   - Input/output schemas
   - Examples, invariants, edge cases
   - Constraints and dependencies
   - Research file reference

2. Read the referenced research file for:
   - Context and findings
   - Clarifications and decisions
   - Code references and patterns
   - Recommendations

### 3. Additional Research (if needed)

If more context needed, spawn Explore agents:
- Find implementation patterns for the approach
- Identify all files that need modification
- Check for similar existing features

### 4. Present Plan Structure

```
Based on the spec, here's my proposed implementation plan:

## {Feature Name}

### Contract (from spec):
- Input: {schema summary}
- Output: {schema summary}
- Examples: {count}

### Phases:
1. {Phase 1} - {what it accomplishes}
2. {Phase 2} - {what it accomplishes}
3. {Phase 3} - {what it accomplishes}

### Key Files:
- `{file1}` - {changes}
- `{file2}` - {changes}

Does this phasing make sense? Any adjustments needed?
```

### 5. Write Detailed Plan

Save to `docs/plans/{feature-name}.md`:

```markdown
---
date: {ISO timestamp}
spec: "specs/{feature-name}.spec.ts"
research: "docs/research/{topic}.md"
status: draft
---

# {Feature Name} Implementation Plan

## Overview
{Brief description of what we're implementing and why}

## References
- **Spec**: `specs/{feature-name}.spec.ts` (source of truth for contract)
- **Research**: `docs/research/{topic}.md` (context and patterns)

## Contract Summary
_From spec - see spec file for full details_

| Aspect | Summary |
|--------|---------|
| Input | {key fields from inputSchema} |
| Output | {key fields from outputSchema} |
| Examples | {count} cases defined |
| Invariants | {count} rules to maintain |

## Out of Scope
{Explicitly list what we're NOT doing}

---

## Phase 1: {Descriptive Name}

### Overview
{What this phase accomplishes}

### Files to Modify

| File | Changes |
|------|---------|
| `path/to/file.ts` | {Summary of changes} |

### Implementation Details

#### 1. {Component/Task}
**File**: `path/to/file.ts`

```typescript
// Specific code to add/modify
```

**Why**: {Reasoning for this approach}

### Verification

```bash
pnpm check-types && pnpm lint && pnpm build
```

- [ ] {Specific verification step}
- [ ] {Another verification step}

---

## Phase 2: {Descriptive Name}
{Similar structure...}

---

## Testing Strategy

### From Spec Examples
The spec defines {N} examples that become test cases:
1. `normal-case` - {description}
2. `edge-case` - {description}
3. `error-case` - {description}

### Additional Tests
- {Any tests beyond spec examples}

### E2E Tests
- {End-to-end scenarios if applicable}

---

## Implementation Notes

_This section is updated during /implement when deviations from plan occur._

### Deviations
_None yet - populated during implementation_

<!--
Format for deviations:
### Deviation: {short description}
- **Phase**: {which phase}
- **Planned**: {what the plan said}
- **Actual**: {what was actually done}
- **Reason**: {why the change was needed}
-->

---

**Next Step**: Run `/implement docs/plans/{feature-name}.md`
```

### 6. Update Spec File

Add plan reference to the spec:

```typescript
// Add to spec object
plan: 'docs/plans/{feature-name}.md',
```

### 7. Present Summary & Next Step

```
Plan complete! Saved to: docs/plans/{feature-name}.md

References:
- Spec: specs/{feature-name}.spec.ts (contract)
- Research: docs/research/{topic}.md (context)

Phases:
1. {Phase 1} - {summary}
2. {Phase 2} - {summary}

Files affected: {count}
Complexity: {low/medium/high}

**Next step**: `/implement docs/plans/{feature-name}.md`
```

## Plan File Structure

| Section | Purpose | Source |
|---------|---------|--------|
| Overview | What and why | Summary from spec/research |
| References | Links to spec and research | File paths |
| Contract Summary | Quick reference | Extracted from spec (not duplicated) |
| Out of Scope | Boundaries | Decisions from clarify |
| Phases | Step-by-step HOW | New content |
| Testing Strategy | How to verify | References spec examples |
| Implementation Notes | Track deviations | Updated during /implement |

## Important Guidelines

1. **Plan defines HOW, not WHAT** - The spec owns the contract
2. **Reference, don't duplicate** - Link to spec for schemas/examples
3. **Contract Summary is a summary** - Point to spec for details
4. **Be specific on approach** - Include exact file paths and code snippets
5. **Measurable phases** - Each phase must be independently verifiable
6. **Implementation Notes section** - Required for tracking deviations
7. **Always include "Next Step"** pointing to /implement

## Relationship to Other Documents

```
┌─────────────────────────────────────────────────────────────┐
│                    SINGLE SOURCE OF TRUTH                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Spec owns:                    Plan owns:                   │
│  ├─ Input/Output schemas       ├─ Implementation phases     │
│  ├─ Examples (test cases)      ├─ Files to modify           │
│  ├─ Invariants                 ├─ Code approach             │
│  ├─ Edge cases                 ├─ Why decisions             │
│  └─ Constraints                └─ Implementation notes      │
│                                                              │
│  Plan REFERENCES spec (doesn't duplicate)                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## What Changed from Previous Version

The plan no longer contains:
- ❌ "Spec Requirements" section (moved to /spec)
- ❌ Input/Output schema definitions (in spec)
- ❌ Example cases (in spec)
- ❌ Invariants (in spec)

The plan now contains:
- ✅ "Contract Summary" - brief reference to spec
- ✅ "Implementation Notes" - tracks deviations during implementation
- ✅ Clear references to spec and research files
