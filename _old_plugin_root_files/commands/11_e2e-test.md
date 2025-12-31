# E2E Test Command

Create and manage End-to-End tests following project conventions.

## Usage

```
/e2e-test <feature-name>
```

## E2E Test Conventions

### Location

**ALL E2E tests MUST be in `packages/tasks/src/__tests__/`**

```
packages/tasks/src/__tests__/
├── competitor-analysis.e2e.test.ts
├── website-health.e2e.test.ts
└── <your-feature>.e2e.test.ts
```

### Why This Location?

1. **Centralized E2E test location**
   - All E2E tests in one place for easy discovery
   - Consistent test infrastructure and patterns
   - Shared Vitest configuration with extended timeout

2. **Dependencies available**
   - Tasks package has ALL workspace dependencies:
     - `your-packages/tools` - External service integrations
     - `your-packages/core` - Business logic
     - `your-packages/ai` - AI agents and tools
     - `your-packages/database` - Database access
   - Can test cross-package workflows

3. **Why NOT in /scripts**
   - `/scripts` has no package.json
   - tsx can't resolve `your-packages/*` packages from outside workspace
   - Module resolution errors with workspace packages

4. **Why NOT in individual packages (tools, core, ai)**
   - Those packages have **unit tests** for their own functionality
   - E2E tests cross package boundaries (orchestration layer)
   - Tasks package is the orchestration layer

### Naming Convention

- **Format**: `<feature-name>.e2e.test.ts`
- **Examples**:
  - `competitor-analysis.e2e.test.ts`
  - `website-health.e2e.test.ts`
  - `product-sync.e2e.test.ts`

### File Template

```typescript
/**
 * E2E <Feature Name> Test
 *
 * WHY THIS TEST IS HERE (packages/tasks):
 *
 * E2E tests are co-located in the tasks package because:
 *
 * 1. Centralized E2E test location:
 *    - All E2E tests in one place (competitor-analysis, website-health, etc.)
 *    - Consistent test infrastructure and patterns
 *
 * 2. Dependencies:
 *    - Tasks package has your-packages/tools, your-packages/core, your-packages/ai as dependencies
 *    - Can test cross-package workflows
 *
 * 3. Why NOT in /scripts:
 *    - /scripts has no package.json, causing module resolution issues
 *    - tsx can't properly resolve your-packages/* packages
 *
 * 4. Why NOT in individual packages:
 *    - Individual packages test their own functionality with unit tests
 *    - E2E tests belong in orchestration layer (tasks)
 *
 * LESSON: E2E tests that cross package boundaries belong in the tasks package.
 *
 * Tests <feature> workflow:
 * - <Step 1>
 * - <Step 2>
 * - <Step 3>
 */

import { describe, it, expect } from 'vitest';
import { /* imports from your-packages/tools */ } from 'your-packages/tools';
import { /* imports from your-packages/core */ } from 'your-packages/core';
import { /* imports from your-packages/ai */ } from 'your-packages/ai';

describe('<Feature Name> E2E', () => {
  it(
    'should execute complete <feature> workflow',
    async () => {
      // Arrange
      const input = { /* test data */ };

      // Act
      const result = await executeWorkflow(input);

      // Assert
      expect(result).toBeDefined();
      expect(result.status).toBe('success');
    },
    180000 // 3 minutes timeout for E2E tests
  );
});
```

## When to Create E2E Tests

Create E2E tests when:
- ✅ Testing cross-package workflows
- ✅ Testing complete feature flows (source → processing → output)
- ✅ Testing integrations between tools, AI, and business logic
- ✅ Testing external API integrations end-to-end
- ✅ Validating multi-step processes

Do NOT create E2E tests for:
- ❌ Testing individual package functionality (use unit tests)
- ❌ Testing pure functions (use unit tests in the package)
- ❌ Testing database operations only (use integration tests in database package)

## Execution Process

### Step 1: Create Test File

```bash
# Create new E2E test
touch packages/tasks/src/__tests__/<feature>.e2e.test.ts
```

### Step 2: Write Test

Use the template above and:
1. Add comprehensive documentation header
2. Import from appropriate `your-packages/*` packages
3. Structure test with clear Arrange-Act-Assert pattern
4. Set appropriate timeout (default: 180000ms = 3 minutes)
5. Add descriptive test names

### Step 3: Run Test

```bash
# Run single E2E test
pnpm --filter your-packages/tasks test:e2e src/__tests__/<feature>.e2e.test.ts

# Run all E2E tests
pnpm --filter your-packages/tasks test:e2e

# Watch mode (not recommended for E2E)
pnpm --filter your-packages/tasks test:watch src/__tests__/<feature>.e2e.test.ts
```

### Step 4: Verify

Ensure test:
- ✅ Runs successfully
- ✅ Has clear output/logging for debugging
- ✅ Completes within timeout
- ✅ Tests real workflow (not mocked)
- ✅ Cleans up after itself (if needed)

## Package Exports for E2E Tests

If you need to import from subpackages, add exports to package.json:

```json
// packages/tools/package.json
{
  "exports": {
    "./sitemap": {
      "types": "./src/sitemap/index.ts",
      "default": "./dist/sitemap/index.js"
    },
    "./html-analyzer": {
      "types": "./src/html-analyzer/index.ts",
      "default": "./dist/html-analyzer/index.js"
    }
  }
}
```

Then import with:
```typescript
import { parseSitemap } from 'your-packages/tools/sitemap';
import { checkAltText } from 'your-packages/tools/html-analyzer';
```

## Best Practices

1. **Use Real Data**: Test with actual external services when possible
2. **Limit Test Scope**: Use small sample sizes for speed (e.g., first 10 URLs)
3. **Add Logging**: Console.log progress for debugging
4. **Handle Errors**: Gracefully handle API failures
5. **Environment Variables**: Use TEST_* env vars for test configuration
6. **Timeout Appropriately**: Set realistic timeouts (3 min default)
7. **Document Why**: Always explain why the test is in tasks package

## Example E2E Tests

### Competitor Analysis E2E

```typescript
describe('Competitor Analysis E2E', () => {
  it('should analyze site with hybrid mapping', async () => {
    const stats = await analyzeSite(TEST_URL, {
      validateExternal: false,
      maxPages: 3,
      mapProductTypes: mapProductTypesHybrid,
    });

    expect(stats.totalProducts).toBeGreaterThan(0);
    expect(stats.uniqueCategories).toBeGreaterThan(0);
  }, 180000);
});
```

### Website Health E2E

```typescript
describe('Website Health E2E', () => {
  it('should run complete health check workflow', async () => {
    const sitemap = await parseSitemap(TEST_SITEMAP_URL);
    const health = await checkUrlsHealth(sitemap.urls, { concurrency: 5 });
    const classification = classifyUrls(health.map(h => h.url));

    expect(sitemap.totalUrls).toBeGreaterThan(0);
    expect(health.length).toBeGreaterThan(0);
    expect(classification.classes.length).toBeGreaterThan(0);
  }, 180000);
});
```

## Anti-Patterns

❌ **Don't:**
- Create E2E tests in `/scripts` (module resolution fails)
- Create E2E tests in individual packages (wrong layer)
- Mix unit tests with E2E tests in same file
- Use short timeouts (< 30s)
- Mock external services in E2E tests (defeats purpose)

✅ **Do:**
- Centralize ALL E2E tests in `packages/tasks/src/__tests__/`
- Use descriptive test names
- Add comprehensive documentation headers
- Test real workflows
- Use appropriate timeouts
- Log progress for debugging

## Integration with Other Commands

- **After `/implement`**: Create E2E test to validate complete workflow
- **With `/test-fix`**: Fix E2E test failures
- **Before `/commit`**: Ensure E2E tests pass
- **With `/checklist`**: E2E tests are part of verification

## Summary

**Golden Rule**: All E2E tests that import from `your-packages/*` packages MUST be in `packages/tasks/src/__tests__/`.

This ensures proper module resolution, centralized test infrastructure, and clear separation between unit tests (in individual packages) and E2E tests (in tasks package).
