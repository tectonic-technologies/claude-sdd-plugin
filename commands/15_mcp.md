# MCP Servers Reference

Quick reference for available MCP (Model Context Protocol) servers and their tools.

## Arguments
- `$ARGUMENTS` - Optional: specific MCP server name to show details

## Common MCP Servers

This is a template. Add your project MCP servers below.

| Server | Purpose | Auth |
|--------|---------|------|
| `context7` | Library documentation | None |
| (add your servers) | ... | ... |

---

## Context7 MCP (`context7`)

**Tools:**
- `resolve-library-id` - Find library ID for documentation
- `get-library-docs` - Fetch library documentation

**When to use:** Looking up library docs, API references, code examples

**Example:**
```
1. resolve-library-id: "next.js"
2. get-library-docs: "/vercel/next.js", topic: "app router"
```

---

## Adding Your MCP Servers

Document each MCP server your project uses with this template:

- Server name and ID
- Available tools with descriptions
- Auth method (None, OAuth, or Env vars)
- Required environment variables if applicable
- Use case descriptions

---

## Filter: $ARGUMENTS
