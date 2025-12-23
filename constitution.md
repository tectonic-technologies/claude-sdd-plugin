# Constitution

Immutable architectural principles for your project.
Specs and plans MUST adhere to these constraints.

Customize this file for your project-specific tech stack and patterns.

---

## Tech Stack (Non-Negotiable)

| Layer | Choice | Notes |
|-------|--------|-------|
| Language | TypeScript strict | No `any`, no `as` escape hatches |
| Validation | Zod | All runtime validation |
| (customize) | ... | ... |

---

## Architectural Patterns

### API Response Format

Define your standard response format:

```typescript
// Example: Discriminated union
type ApiResponse<T> = { data: T } | { error: string };

// Example: Result type
type Result<T, E> = { ok: true; value: T } | { ok: false; error: E };
```

### Database Access

Define your database access patterns:

```typescript
// Example patterns - customize for your ORM/DB
import { db } from "./database";

// Always use query builder, never raw SQL
const users = await db.select().from(users);
```

### Error Handling

- Validate at system boundaries (API routes, webhooks)
- Use schema validation with error recovery
- Log errors with structured context

---

## Security (Mandatory)

### Input Validation
- Validate ALL external input at API boundaries
- Never trust client-provided IDs without verification
- Sanitize before database queries

### Secrets
- No secrets in code, ever
- Use environment variables
- Never log sensitive data

### Authentication
- Validate session/tokens on every request
- Verify webhook signatures

---

## Code Style

### Imports (Order)
1. Framework imports (React, Next.js, etc.)
2. External packages
3. Internal packages
4. Relative imports
5. Types (with `type` keyword)

### File Naming

| Type | Pattern |
|------|---------|
| Components | `PascalCase.tsx` |
| Utilities | `camelCase.ts` |
| Tests | `*.test.ts` |
| E2E Tests | `*.e2e.test.ts` |
| Specs | `*.spec.ts` |

### Logging

Use structured logging instead of console.log in production.

---

## What Does NOT Belong Here

- Feature-specific requirements (goes in spec)
- Implementation approach (goes in plan)
- Temporary decisions or experiments
- Anything that might change per-feature
