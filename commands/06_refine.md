# Refine Command

Execute the Generate-Critique-Refine-Verify (GCRV) loop for any development task.

## Arguments

- `$ARGUMENTS` - The task description and any options

## Options (parsed from arguments)

- `--max=N` - Maximum iterations (default: 5)
- `--spec=path` - Path to spec file for requirements
- `--filter=pkg` - Limit verification to specific package

## Execution Protocol

### Phase 1: Understand

1. Parse the task from `$ARGUMENTS`
2. If `--spec` provided, read the spec file for requirements
3. Identify affected files and packages
4. Check for existing tests or specs in `specs/` directory

### Phase 2: Generate-Verify Loop

For each iteration (1 to max):

```
┌─────────────────────────────────────────────────────┐
│ Iteration {N}/{MAX}                                 │
├─────────────────────────────────────────────────────┤
│ 1. GENERATE: Write/modify code                      │
│ 2. VERIFY: Run checks                               │
│    - pnpm check-types {--filter if specified}       │
│    - pnpm lint                                      │
│    - pnpm build {--filter if specified}             │
│ 3. CRITIQUE: If failed, analyze root cause          │
│ 4. REFINE: Apply minimal fix for root cause         │
└─────────────────────────────────────────────────────┘
```

### Phase 3: Report

**On Success:**
```
✅ REFINEMENT COMPLETE

Task: {description}
Iterations: {N}/{MAX}
Files Modified:
- {file:line} - {change description}

Verification:
- TypeScript: ✅ Pass
- Lint: ✅ Pass
- Build: ✅ Pass

Ready for commit.
```

**On Failure (max iterations reached):**
```
❌ REFINEMENT INCOMPLETE - Requesting Help

Task: {description}
Iterations: {MAX}/{MAX}

Attempts:
1. {approach} → {result}
2. {approach} → {result}
...

Current Error:
{exact error}

Hypothesis: {what I think is wrong}

Question: {specific help needed}
```

## Self-Audit Rules

1. **Stop early if solved** - Don't iterate past success
2. **One fix per iteration** - Fix root cause, not symptoms
3. **Track what changed** - Report file:line for each modification
4. **Recognize patterns** - Same error twice = step back and rethink
5. **Know limits** - After 5 iterations, ask for help

## Verification Commands

```bash
# Default (all packages)
pnpm check-types && pnpm lint && pnpm build

# Filtered (when --filter specified)
turbo run check-types lint build --filter={filter}
```

## Example Usage

```
/refine Add HMAC verification to the orders webhook handler

/refine --max=3 Fix the type error in UserProfile component

/refine --spec=specs/sync-products.spec.ts Implement product sync function

/refine --filter=packages/database Add index to runs table for status queries
```

## Task: $ARGUMENTS
