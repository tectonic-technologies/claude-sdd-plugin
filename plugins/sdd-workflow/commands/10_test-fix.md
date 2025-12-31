# Test Fix Command

Diagnose and fix failing tests, type errors, or lint issues.

## Arguments

- `$ARGUMENTS` - Optional: specific file, package, or error to focus on

## Execution Protocol

### Phase 1: Diagnose

Run verification and categorize failures:

```bash
# Collect all errors
pnpm check-types 2>&1 | tee /tmp/type-errors.txt
pnpm lint 2>&1 | tee /tmp/lint-errors.txt
pnpm build 2>&1 | tee /tmp/build-errors.txt
```

### Phase 2: Categorize

Group errors by type and priority:

| Priority | Type | Description |
|----------|------|-------------|
| 1 | Type Errors | TypeScript compilation failures |
| 2 | Import Errors | Missing modules, circular deps |
| 3 | Lint Errors | Code style, unused vars |
| 4 | Build Errors | Next.js, bundler issues |
| 5 | Test Failures | Failed assertions |

### Phase 3: Fix Loop

For each error category (highest priority first):

```
┌─────────────────────────────────────────────────────┐
│ Fixing: {error category}                            │
├─────────────────────────────────────────────────────┤
│ Error: {specific error message}                     │
│ File: {file:line}                                   │
│ Root Cause: {analysis}                              │
│ Fix: {what was changed}                             │
│ Verify: {re-run check}                              │
└─────────────────────────────────────────────────────┘
```

### Phase 4: Regression Check

After fixing all errors:
```bash
pnpm check-types && pnpm lint && pnpm build
```

Ensure no new errors introduced.

## Common Fix Patterns

### Type Errors

```typescript
// TS2322: Type 'X' is not assignable to type 'Y'
// → Check type definitions, add type assertion or fix source

// TS2339: Property 'x' does not exist on type 'Y'
// → Add property to interface or use optional chaining

// TS7006: Parameter 'x' implicitly has 'any' type
// → Add explicit type annotation

// TS2345: Argument of type 'X' is not assignable
// → Check function signature, fix argument type
```

### Import Errors

```typescript
// Cannot find module 'your-package/x'
// → Check package.json exports, tsconfig paths

// Circular dependency
// → Extract shared types to separate file
```

### Lint Errors

```typescript
// 'x' is defined but never used
// → Remove or prefix with underscore: _x

// Unexpected console statement
// → Remove or use proper logging

// Missing return type
// → Add explicit return type annotation
```

### Build Errors

```typescript
// Module not found
// → Check transpilePackages in next.config.ts

// Dynamic import failed
// → Ensure proper 'use client' directive
```

## Output Format

```
📋 DIAGNOSIS COMPLETE

Type Errors: {N}
Lint Errors: {N}
Build Errors: {N}

🔧 FIXING...

[1/N] TS2322 in src/components/Button.tsx:15
  Error: Type 'string' is not assignable to type 'number'
  Fix: Changed prop type from number to string
  ✅ Fixed

[2/N] ...

🔍 REGRESSION CHECK

pnpm check-types: ✅
pnpm lint: ✅
pnpm build: ✅

✅ ALL ERRORS FIXED
```

## Focus: $ARGUMENTS
