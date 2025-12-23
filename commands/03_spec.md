# Spec Command

Create specifications from research findings to define the contract before implementation planning.

## Pipeline Position

```
/research → /clarify → [/spec] → /plan → /implement
                          ↓
                   specs/{feature}.spec.ts
```

**This is the THIRD step in the development pipeline.**

The spec defines WHAT to build (contract). The plan defines HOW to build it (approach).

## Constitution Reference

**IMPORTANT**: All specs must adhere to `.claude/constitution.md`.

Before generating a spec, read the constitution to ensure compliance with:
- Tech stack constraints defined in constitution
- Architectural patterns (API response format, multi-tenancy)
- Security requirements (input validation, HMAC verification)

Do NOT duplicate constitution content in specs — just follow it.

## Arguments
- `$ARGUMENTS` - **Required**: Path to research file (e.g., `docs/research/feature-name.md`)

## Input
- **File**: `docs/research/{topic}.md` (with clarifications resolved via /clarify)

## Output
- **File**: `specs/{feature}.spec.ts`

## Process

### 1. Validate Input

If no file path provided:
```
Usage: /spec docs/research/{topic}.md

Please provide the path to a research file. Run /research → /clarify first.
```

If file doesn't exist:
```
Research file not found: {path}

Pipeline: /research {topic} → /clarify → /spec
```

If no clarifications section (warning only):
```
Warning: Research file has unresolved questions.

Consider running /clarify {path} first, or confirm you want to proceed.
```

### 2. Read Research File

Read the research file completely and extract:
- Summary and key findings
- Clarifications and decisions made
- Recommendations for approach
- Open questions (if any remaining)

### 3. Gather Requirements

If research doesn't contain enough detail for the spec, use AskUserQuestion to clarify:

**Schema Questions:**
- What are the required inputs?
- What should the output look like?
- What types/formats are expected?

**Behavior Questions:**
- What are the success criteria?
- How should errors be handled?
- What edge cases matter?

**Constraint Questions:**
- Performance requirements?
- Size/rate limits?
- Dependencies?

### 4. Generate Spec File

Create `specs/{feature-name}.spec.ts`:

```typescript
/**
 * Spec: {Feature Name}
 *
 * Contract defining WHAT this feature does.
 * Generated from: docs/research/{topic}.md
 * Date: {ISO timestamp}
 *
 * This spec is the SOURCE OF TRUTH for:
 * - Input/output schemas
 * - Expected behaviors (examples)
 * - Invariants that must always hold
 * - Edge cases to handle
 */

import { z } from 'zod';

// =============================================================================
// SCHEMAS (Contract Definition)
// =============================================================================

export const inputSchema = z.object({
  // Define all required and optional inputs
  field1: z.string().describe('description'),
  field2: z.number().optional().describe('description'),
});

export const outputSchema = z.object({
  // Define the expected output structure
  result: z.string().describe('description'),
  success: z.boolean(),
});

export type Input = z.infer<typeof inputSchema>;
export type Output = z.infer<typeof outputSchema>;

// =============================================================================
// SPECIFICATION
// =============================================================================

export const spec = {
  name: '{feature-name}',
  description: '{What this feature does - from research summary}',

  // Source reference
  research: 'docs/research/{topic}.md',

  // Schemas
  inputSchema,
  outputSchema,

  // ==========================================================================
  // EXAMPLES - Concrete input/output pairs (minimum 3)
  // These become test cases and serve as ground truth
  // ==========================================================================
  examples: [
    {
      id: 'normal-case',
      description: 'Standard successful operation',
      input: {
        // Concrete input values
      },
      expectedOutput: {
        // Expected output values
      },
    },
    {
      id: 'edge-case',
      description: 'Boundary condition handling',
      input: {
        // Edge case input
      },
      expectedOutput: {
        // Expected output
      },
    },
    {
      id: 'error-case',
      description: 'Invalid input handling',
      input: {
        // Invalid input
      },
      expectedOutput: {
        // Error response
      },
      shouldThrow: true, // or expectedError: 'message'
    },
  ],

  // ==========================================================================
  // INVARIANTS - Properties that ALWAYS hold
  // ==========================================================================
  invariants: [
    'output.success === true implies output.result is non-empty',
    'input validation errors return success: false',
    // Add domain-specific invariants
  ],

  // ==========================================================================
  // EDGE CASES - Boundary conditions to test
  // ==========================================================================
  edgeCases: [
    {
      id: 'empty-input',
      description: 'Handle empty/minimal input',
      input: {},
      expectedBehavior: 'Returns validation error',
    },
    {
      id: 'max-size',
      description: 'Handle maximum size input',
      input: { /* max values */ },
      expectedBehavior: 'Processes within time limit',
    },
  ],

  // ==========================================================================
  // CONSTRAINTS - Non-functional requirements
  // ==========================================================================
  constraints: {
    maxExecutionMs: 5000,
    maxMemoryMb: 100,
    // Add other constraints
  },

  // ==========================================================================
  // DEPENDENCIES
  // ==========================================================================
  dependencies: [
    'your-package/database',
    'your-package/utils',
  ],
} as const;

// =============================================================================
// VALIDATION HELPERS
// =============================================================================

export function validateInput(input: unknown): Input {
  return inputSchema.parse(input);
}

export function validateOutput(output: unknown): Output {
  return outputSchema.parse(output);
}

// =============================================================================
// IMPLEMENTATION PLACEHOLDER
// =============================================================================

/**
 * Implementation will be added by /implement command
 *
 * @param input - Validated input
 * @returns Output matching outputSchema
 */
export async function execute(input: Input): Promise<Output> {
  throw new Error('Not implemented - run /plan then /implement');
}
```

### 5. Critique & Refine Spec

Before finalizing, self-critique the generated spec:

**Constitution Compliance:**
- [ ] Uses Zod for all schemas (not raw TypeScript types)?
- [ ] API responses follow `{ data: T } | { error: string }` pattern?
- [ ] Multi-tenant queries scoped by brandId (if applicable)?
- [ ] Security: input validation at boundaries?

**Completeness Check:**
- [ ] Are all inputs from research captured in schema?
- [ ] Does output schema cover success AND error cases?
- [ ] Are there at least 3 examples (normal, edge, error)?
- [ ] Do examples have concrete values, not placeholders?

**Correctness Check:**
- [ ] Do examples actually match the schemas?
- [ ] Are invariants testable (not vague)?
- [ ] Do edge cases cover boundary conditions?
- [ ] Are constraints realistic?

**Clarity Check:**
- [ ] Would another developer understand the contract?
- [ ] Are field descriptions meaningful?
- [ ] Is the spec self-contained (minimal research lookup needed)?

**If any check fails:** Refine the spec before proceeding. Fix the specific issue and re-validate.

**If checks pass:** Continue to step 6.

### 6. Update Research File

Add spec reference to the research file frontmatter:

```markdown
---
spec: "specs/{feature-name}.spec.ts"
---
```

### 7. Present Summary & Next Step

```
Spec created! Saved to: specs/{feature-name}.spec.ts

Contract defined:
- Input: {field count} fields
- Output: {field count} fields
- Examples: {count} (normal, edge, error)
- Invariants: {count}
- Edge cases: {count}

**Next step**: `/plan specs/{feature-name}.spec.ts`
```

## Spec File Purpose

| Section | Purpose | Source of Truth For |
|---------|---------|---------------------|
| Schemas | Zod schemas for type-safe validation | Data structure contract |
| Examples | Concrete input/output pairs | Expected behavior |
| Invariants | Properties that must always hold | Correctness criteria |
| Edge Cases | Boundary conditions | Robustness requirements |
| Constraints | Performance and resource limits | Non-functional requirements |

## Important Guidelines

1. **Spec defines WHAT, not HOW** - No implementation details, just the contract
2. **Use Zod schemas** - Type-safe validation for input/output
3. **Minimum 3 examples** - Normal, edge, and error cases with concrete values
4. **Examples are ground truth** - They become test cases
5. **Reference research, don't duplicate** - Link to research for context
6. **Spec is stable** - Changes rarely once defined (contract)
7. **Always include "Next Step"** pointing to /plan

## Relationship to Other Documents

```
┌─────────────────────────────────────────────────────────────┐
│                    DOCUMENT OWNERSHIP                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Research (docs/research/)     Spec (specs/)                │
│  ├─ Context                    ├─ Schemas (INPUT/OUTPUT)    │
│  ├─ Existing patterns          ├─ Examples (BEHAVIOR)       │
│  ├─ Code analysis              ├─ Invariants (RULES)        │
│  └─ Clarifications             └─ Constraints (LIMITS)      │
│           │                              │                   │
│           └──────────┬───────────────────┘                   │
│                      ▼                                       │
│               Plan (docs/plans/)                             │
│               ├─ Phases (HOW)                                │
│               ├─ Files to modify                             │
│               ├─ Implementation steps                        │
│               └─ Implementation notes                        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

The spec is the **contract** - it should be stable and change only when requirements change.
The plan is the **approach** - it may evolve during implementation.
