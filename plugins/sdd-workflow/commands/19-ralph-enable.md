# Ralph Enable Command

Enable Ralph loop for autonomous implementation cycles with the SDD workflow.

## Purpose

Activates the stop hook that prevents Claude from exiting until implementation is complete. This creates a continuous feedback loop where Claude iteratively refines the implementation based on verification failures.

## Arguments

- `$ARGUMENTS` - **Required**: The implementation prompt or path to plan file
- `--max-iterations <n>` - Maximum iterations before auto-stop (default: 50)
- `--completion-promise <text>` - Text to search for indicating completion (default: "IMPLEMENTATION_COMPLETE")

## How It Works

1. **Enable Ralph loop** - Activates the stop hook
2. **Store prompt** - Saves the implementation prompt for re-feeding
3. **Begin implementation** - Claude starts working on the task
4. **Verification cycle** - On each exit attempt:
   - Run type checking
   - Run linting
   - Run build
   - Run tests
   - Check for completion promise
5. **Continue or exit**:
   - If checks fail → Re-feed prompt, continue loop
   - If completion promise found → Exit successfully
   - If max iterations reached → Exit with summary

## Usage Examples

### With Plan File

```bash
/ralph-enable docs/plans/user-authentication.md --max-iterations 30
```

### With Inline Prompt

```bash
/ralph-enable "Implement the user authentication feature from specs/auth.spec.ts. Fix all type errors, linting issues, and ensure all tests pass. When complete, output IMPLEMENTATION_COMPLETE"
```

### Custom Completion Promise

```bash
/ralph-enable docs/plans/api-integration.md --completion-promise "ALL_TESTS_PASSING" --max-iterations 40
```

## Process

### Phase 1: Enable Ralph Loop

```bash
# Create state file
echo '{
  "enabled": true,
  "iteration": 0,
  "prompt": "<prompt>",
  "max_iterations": <n>
}' > hooks/.ralph-state.json
```

### Phase 2: Display Configuration

```
╔════════════════════════════════════════════════════════════════╗
║  Ralph Loop Enabled - Autonomous Implementation Mode           ║
╚════════════════════════════════════════════════════════════════╝

Configuration:
  📝 Prompt: <prompt or plan file>
  🔄 Max Iterations: <n>
  ✅ Completion Promise: "<text>"

Verification Checks (run on each iteration):
  - Type checking (pnpm check-types)
  - Linting (pnpm lint)
  - Build (pnpm build)
  - Tests (pnpm test)

The loop will continue until:
  1. Completion promise is found in output
  2. Max iterations reached
  3. /ralph-cancel is called

Starting implementation...
```

### Phase 3: Execute Prompt

Begin the implementation with the provided prompt or plan file.

## Verification Checks

On each iteration, the stop hook runs:

| Check | Command | Exit on Fail |
|-------|---------|--------------|
| Type Check | `pnpm check-types` | No - Continue loop |
| Lint | `pnpm lint` | No - Continue loop |
| Build | `pnpm build` | No - Continue loop |
| Tests | `pnpm test` | No - Continue loop |
| Completion Promise | `grep <promise>` | Yes - Exit successfully |
| Max Iterations | Counter check | Yes - Exit with summary |

## Completion Promise

The completion promise is a **literal string match**. When Claude outputs this exact text, the loop exits successfully.

**Best Practices:**

```markdown
# In your prompt:
"When all requirements are met and all tests pass, output the following on a new line:

IMPLEMENTATION_COMPLETE
"

# The hook will search for exact match: "IMPLEMENTATION_COMPLETE"
```

**Where to Output:**

- Directly in Claude's response
- In a status file: `IMPLEMENTATION_STATUS.md`
- In `.claude/status.txt`

## Safety Mechanisms

### 1. Max Iterations (Required)

Always set `--max-iterations` to prevent infinite loops and API cost overruns:

```bash
--max-iterations 30  # Recommended for medium tasks
--max-iterations 50  # For complex features
--max-iterations 100 # For large projects
```

### 2. Cancel Command

At any time, run:

```bash
/ralph-cancel
```

This immediately disables the loop and allows normal exit.

### 3. Iteration Counter Display

Each iteration shows:

```
Ralph Loop - SDD Implementation Cycle #5

Running verification checks...
  📋 Type check: ✓
  🔍 Lint check: ✗
  🔨 Build check: ✓
  🧪 Tests: ✗

❌ Verification failed:
   - Linting failed
   - Tests failed

Continuing loop to fix issues...

Iteration 5 of 30 - Re-feeding prompt...
```

## Best Practices

### 1. Clear Success Criteria

```bash
/ralph-enable "
Implement user registration feature from specs/registration.spec.ts

Success criteria:
- All TypeScript types correct (no errors)
- All linting rules pass
- Registration endpoint works (POST /api/register)
- Input validation with Zod schema
- Unit tests pass (coverage > 80%)
- Integration tests pass

Output IMPLEMENTATION_COMPLETE when all criteria met.
" --max-iterations 40
```

### 2. Incremental Prompts

```bash
/ralph-enable "
Phase 1: Setup database schema and migrations
Phase 2: Implement CRUD operations
Phase 3: Add validation and error handling
Phase 4: Write unit tests
Phase 5: Integration tests

Complete each phase before moving to next.
Output IMPLEMENTATION_COMPLETE when all phases done.
" --max-iterations 50
```

### 3. Self-Correction Pattern

```bash
/ralph-enable "
Implement the payment processing feature.

On each iteration:
1. Run all checks (type, lint, build, test)
2. If any fail, analyze the error
3. Fix the issue
4. Re-run checks
5. If all pass, output IMPLEMENTATION_COMPLETE

Do not output IMPLEMENTATION_COMPLETE until ALL checks pass.
" --max-iterations 30
```

## Use Cases

**✅ Good for:**
- Implementing features with clear specs
- Fixing failing tests/builds
- Refactoring with verification
- TDD workflows
- Getting builds to pass in CI

**❌ Not good for:**
- Exploratory coding
- Design decisions requiring human input
- One-time scripts
- Production debugging

## Integration with SDD Workflow

Ralph loop enhances the `/implement` command:

```
/research → /clarify → /spec → /plan → /ralph-enable → (autonomous loop) → /commit
                                          ↓
                                    GCRV + Verification
                                          ↓
                                    Auto-refinement
```

## Examples

### Example 1: Plan File

```bash
/ralph-enable docs/plans/shopping-cart.md --max-iterations 30 --completion-promise "CART_COMPLETE"
```

### Example 2: Test-Driven Development

```bash
/ralph-enable "
Write tests for the authentication module first (TDD).
Then implement the feature until all tests pass.
Requirements in specs/auth.spec.ts.
Output IMPLEMENTATION_COMPLETE when coverage > 90% and all tests green.
" --max-iterations 40
```

### Example 3: Bug Fix

```bash
/ralph-enable "
Fix the authentication token refresh bug (issue #123).

Steps:
1. Reproduce the issue with a test
2. Fix the bug
3. Ensure test passes
4. Ensure no regressions (all other tests pass)

Output IMPLEMENTATION_COMPLETE when bug is fixed and all tests pass.
" --max-iterations 20
```

## Output

```
╔════════════════════════════════════════════════════════════════╗
║  Ralph Loop Complete - Implementation Successful                ║
╚════════════════════════════════════════════════════════════════╝

Summary:
  🔄 Total Iterations: 12
  ✅ Completion: Found promise "IMPLEMENTATION_COMPLETE"

  Final Status:
    📋 Type check: ✓
    🔍 Lint check: ✓
    🔨 Build check: ✓
    🧪 Tests: ✓

Files Modified:
  - src/components/Cart.tsx
  - src/hooks/useCart.ts
  - src/api/cart.ts
  - tests/cart.test.ts

Next Steps:
  - Review changes: git diff
  - Commit: /commit
  - Create PR
```

## Troubleshooting

### Loop Not Stopping

Check that completion promise is **exact match**:
```bash
# Prompt says:
"Output IMPLEMENTATION_COMPLETE"

# Claude outputs:
"Implementation complete!" ❌ (case different)
"IMPLEMENTATION_COMPLETE" ✅ (exact match)
```

### Infinite Loop

Always use `--max-iterations`:
```bash
/ralph-enable "<prompt>" --max-iterations 30
```

Or cancel immediately:
```bash
/ralph-cancel
```

### Checks Failing Repeatedly

The loop will continue attempting fixes. If stuck after many iterations, cancel and debug manually:

```bash
/ralph-cancel

# Then debug:
pnpm check-types  # See what's failing
pnpm lint         # Fix linting issues
pnpm test         # Check test failures
```

## Integration

Works with:
- `/implement` - Autonomous implementation mode
- `/test-fix` - Auto-fix failing tests
- `/validate` - Verify against spec with retries

## Focus: $ARGUMENTS
