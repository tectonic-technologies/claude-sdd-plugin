# Ralph Cancel Command

Immediately cancel the active Ralph loop and allow normal session exit.

## Purpose

Disables the stop hook that keeps Claude in an autonomous implementation loop. Use this to regain control when:
- The loop is stuck
- You want to intervene manually
- Max iterations is too high and you want to stop early
- You need to change the approach

## Arguments

None. This command takes no arguments.

## Usage

```bash
/ralph-cancel
```

## Process

### Step 1: Disable Loop

Update the Ralph state file to disable the loop:

```bash
# Set enabled = false in hooks/.ralph-state.json
{
  "enabled": false,
  "iteration": <current>,
  "prompt": "<original prompt>",
  "max_iterations": <max>
}
```

### Step 2: Display Summary

```
╔════════════════════════════════════════════════════════════════╗
║  Ralph Loop Cancelled                                          ║
╚════════════════════════════════════════════════════════════════╝

Loop Status:
  🔄 Completed Iterations: 7 of 30
  ⏸️  Status: Manually stopped

Last Verification Results:
  📋 Type check: ✗
  🔍 Lint check: ✓
  🔨 Build check: ✓
  🧪 Tests: ✗

The stop hook is now disabled. Claude will exit normally on next exit attempt.

Next Steps:
  - Fix remaining issues manually
  - Re-enable with /ralph-enable if needed
  - Review changes: git diff
```

### Step 3: Allow Normal Exit

The next time Claude attempts to exit, the stop hook will see `enabled: false` and allow the session to end normally.

## When to Cancel

### 1. Loop Is Stuck

If the same errors repeat for 5+ iterations:

```bash
# Iteration 15: "Type error in Widget.tsx line 45"
# Iteration 16: "Type error in Widget.tsx line 45"
# Iteration 17: "Type error in Widget.tsx line 45"
# ...

/ralph-cancel

# Then debug manually:
cat src/components/Widget.tsx
# Fix the issue yourself
```

### 2. Need to Change Approach

If you realize the prompt needs adjustment:

```bash
/ralph-cancel

# Then re-enable with better prompt:
/ralph-enable "New approach: Use composition instead of inheritance. Implement auth with middleware pattern..." --max-iterations 20
```

### 3. Want to Intervene

If you want to manually adjust something mid-loop:

```bash
/ralph-cancel

# Make manual edits
# Then either:
# - Continue manually, or
# - Re-enable Ralph with updated prompt
```

### 4. Cost Control

If API costs are running high and you want to stop:

```bash
/ralph-cancel

# Check what was accomplished
git diff
git log -3

# Decide whether to continue manually or re-enable with lower --max-iterations
```

## After Cancelling

You have several options:

### Option 1: Continue Manually

```bash
/ralph-cancel

# Then work normally:
# - Edit files
# - Run commands
# - Test changes
# - /commit when ready
```

### Option 2: Re-enable with Adjustments

```bash
/ralph-cancel

# Adjust the prompt or settings:
/ralph-enable "Updated prompt with clearer success criteria..." --max-iterations 15 --completion-promise "NEW_PROMISE"
```

### Option 3: Switch to Different Command

```bash
/ralph-cancel

# Use different workflow:
/refine "Just fix the type errors in Widget.tsx"
# or
/test-fix "Focus on fixing the failing auth tests"
```

## State Persistence

Cancelling preserves the state file with:
- Total iterations completed
- Original prompt (in case you want to re-enable)
- Last max iterations setting

This allows you to review what happened and potentially resume:

```bash
# View current state:
cat plugins/sdd-workflow/hooks/.ralph-state.json

{
  "enabled": false,
  "iteration": 12,
  "prompt": "Implement user authentication...",
  "max_iterations": 30
}
```

## Safety Notes

- **Immediate effect**: The loop stops on the very next exit attempt
- **No data loss**: All work done in iterations is committed to files
- **Reversible**: You can re-enable with `/ralph-enable` anytime
- **Clean state**: The state file is updated, not deleted

## Examples

### Example 1: Stop When Stuck

```bash
# Loop running, iteration 8
# Same error keeps appearing
/ralph-cancel

Output:
  Ralph Loop Cancelled
  Completed 8 of 30 iterations
  Last error: Type error in auth.ts:23

  Fix manually and re-enable if needed.
```

### Example 2: Stop to Change Strategy

```bash
/ralph-cancel

# After reviewing, realize the approach is wrong
# Change plan file: docs/plans/feature.md
# Re-enable with different prompt

/ralph-enable "Use the updated plan in docs/plans/feature.md. Previous approach didn't work, now using microservices pattern instead." --max-iterations 20
```

### Example 3: Emergency Stop

```bash
# API costs running high, need to stop NOW
/ralph-cancel

Output:
  Ralph Loop Cancelled
  Iterations: 25 of 100

  Session will exit on next attempt.
```

## Integration

Works with:
- `/ralph-enable` - Cancel an active loop
- `/implement` - Cancel during autonomous implementation
- Any command running in Ralph loop mode

## Technical Details

The cancel operation:

1. Reads `.ralph-state.json`
2. Sets `enabled: false`
3. Preserves iteration count and prompt
4. Displays summary
5. Allows next exit attempt to succeed

## Exit Codes

- Success (0): Loop successfully cancelled
- Error (1): No active loop to cancel

## Focus: $ARGUMENTS
