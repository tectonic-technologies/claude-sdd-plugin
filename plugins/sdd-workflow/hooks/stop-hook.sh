#!/bin/bash
# SDD Plugin Stop Hook
# Integrates with Ralph loop to enable autonomous implementation cycles
# This hook intercepts Claude's exit attempts and re-feeds the prompt until completion

set -e

# Configuration
HOOKS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$HOOKS_DIR")"
STATE_FILE="$HOOKS_DIR/.ralph-state.json"
MAX_ITERATIONS=${SDD_MAX_ITERATIONS:-50}
COMPLETION_PROMISE=${SDD_COMPLETION_PROMISE:-"IMPLEMENTATION_COMPLETE"}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Initialize state if not exists
if [ ! -f "$STATE_FILE" ]; then
  echo '{"enabled":false,"iteration":0,"prompt":"","max_iterations":50}' > "$STATE_FILE"
fi

# Read state
ENABLED=$(jq -r '.enabled' "$STATE_FILE")
ITERATION=$(jq -r '.iteration' "$STATE_FILE")
PROMPT=$(jq -r '.prompt' "$STATE_FILE")
MAX_ITER=$(jq -r '.max_iterations' "$STATE_FILE")

# If Ralph loop not enabled, allow normal exit
if [ "$ENABLED" != "true" ]; then
  exit 0
fi

# Increment iteration counter
ITERATION=$((ITERATION + 1))
jq ".iteration = $ITERATION" "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}  Ralph Loop - SDD Implementation Cycle ${YELLOW}#$ITERATION${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if max iterations reached
if [ "$ITERATION" -ge "$MAX_ITER" ]; then
  echo -e "${RED}⚠️  Maximum iterations reached ($MAX_ITER)${NC}"
  echo -e "${YELLOW}Stopping Ralph loop and allowing exit.${NC}"
  jq '.enabled = false' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
  exit 0
fi

# Check for completion promise in recent output
# Look in the last Claude response or output files
FOUND_PROMISE=false

# Check if completion promise exists in recent messages
if grep -q "$COMPLETION_PROMISE" "$HOME/.claude/recent_output.txt" 2>/dev/null; then
  FOUND_PROMISE=true
fi

# Also check common output files
for file in "IMPLEMENTATION_STATUS.md" "STATUS.md" ".claude/status.txt"; do
  if [ -f "$file" ] && grep -q "$COMPLETION_PROMISE" "$file"; then
    FOUND_PROMISE=true
    break
  fi
done

if [ "$FOUND_PROMISE" = "true" ]; then
  echo -e "${GREEN}✅ Completion promise found: '$COMPLETION_PROMISE'${NC}"
  echo -e "${GREEN}Implementation cycle complete!${NC}"
  jq '.enabled = false' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
  exit 0
fi

# Run verification checks
echo -e "${BLUE}Running verification checks...${NC}"
echo ""

CHECKS_PASSED=true
FAILURES=()

# 1. Type checking
echo -n "  📋 Type check: "
if command -v pnpm &> /dev/null && [ -f "package.json" ]; then
  if pnpm check-types &> /dev/null || pnpm typecheck &> /dev/null || npm run check-types &> /dev/null; then
    echo -e "${GREEN}✓${NC}"
  else
    echo -e "${RED}✗${NC}"
    CHECKS_PASSED=false
    FAILURES+=("Type checking failed")
  fi
else
  echo -e "${YELLOW}skipped${NC}"
fi

# 2. Linting
echo -n "  🔍 Lint check: "
if command -v pnpm &> /dev/null && [ -f "package.json" ]; then
  if pnpm lint &> /dev/null || npm run lint &> /dev/null; then
    echo -e "${GREEN}✓${NC}"
  else
    echo -e "${RED}✗${NC}"
    CHECKS_PASSED=false
    FAILURES+=("Linting failed")
  fi
else
  echo -e "${YELLOW}skipped${NC}"
fi

# 3. Build
echo -n "  🔨 Build check: "
if command -v pnpm &> /dev/null && [ -f "package.json" ]; then
  if pnpm build &> /dev/null || npm run build &> /dev/null; then
    echo -e "${GREEN}✓${NC}"
  else
    echo -e "${RED}✗${NC}"
    CHECKS_PASSED=false
    FAILURES+=("Build failed")
  fi
else
  echo -e "${YELLOW}skipped${NC}"
fi

# 4. Tests
echo -n "  🧪 Tests: "
if command -v pnpm &> /dev/null && [ -f "package.json" ]; then
  if pnpm test &> /dev/null || npm test &> /dev/null; then
    echo -e "${GREEN}✓${NC}"
  else
    echo -e "${RED}✗${NC}"
    CHECKS_PASSED=false
    FAILURES+=("Tests failed")
  fi
else
  echo -e "${YELLOW}skipped${NC}"
fi

echo ""

# Check if spec file exists and validate against it
SPEC_FILE=$(find specs -name "*.spec.ts" -o -name "*.spec.md" 2>/dev/null | head -1)
if [ -n "$SPEC_FILE" ] && [ -f "$SPEC_FILE" ]; then
  echo -e "${BLUE}📄 Spec file found: $SPEC_FILE${NC}"
  # TODO: Add spec validation logic here
fi

# Check plan file
PLAN_FILE=$(find docs/plans -name "*.md" 2>/dev/null | head -1)
if [ -n "$PLAN_FILE" ] && [ -f "$PLAN_FILE" ]; then
  echo -e "${BLUE}📋 Plan file found: $PLAN_FILE${NC}"
fi

echo ""

# Decide whether to continue loop or exit
if [ "$CHECKS_PASSED" = "true" ]; then
  echo -e "${GREEN}✅ All verification checks passed!${NC}"
  echo -e "${YELLOW}⚠️  Note: Completion promise '$COMPLETION_PROMISE' not found.${NC}"
  echo -e "${YELLOW}   Continuing loop for further refinement...${NC}"
else
  echo -e "${RED}❌ Verification failed:${NC}"
  for failure in "${FAILURES[@]}"; do
    echo -e "${RED}   - $failure${NC}"
  done
  echo ""
  echo -e "${YELLOW}Continuing loop to fix issues...${NC}"
fi

echo ""
echo -e "${BLUE}Iteration $ITERATION of $MAX_ITER - Re-feeding prompt...${NC}"
echo -e "${BLUE}────────────────────────────────────────────────────────────────${NC}"
echo ""

# Re-feed the original prompt to continue the loop
# The prompt is stored in state and will be used by Claude Code
echo "$PROMPT"

# Exit with code 1 to signal Claude Code to continue the session
exit 1
