# MCP Load Command

Load an MCP server from the registry on-demand.

## Arguments
- `$ARGUMENTS` - Required: the service name to load (e.g., "github", "slack")

## Process

### 1. Validate Input

If no service specified:
```
Usage: /mcp-load <service>

Available MCPs in registry:
```

Then list all MCPs from `.mcp-registry.json`.

### 2. Read Registry

Read `.mcp-registry.json` and find the requested service.

If not found:
```
MCP "{service}" not found in registry.

Run /mcp-add {service} to search and add it first.
```

### 3. Load the MCP

Use `claude mcp add` to activate the server:

**For command-based:**
```bash
claude mcp add {service} -- {command} {args...}

# With env vars:
claude mcp add {service} --env VAR1 --env VAR2 -- {command} {args...}
```

**For URL-based (SSE):**
```bash
claude mcp add {service} --url {url}
```

### 4. Verify

```bash
claude mcp list
```

### 5. Report

```
Loaded MCP: {service}

Tools now available:
  - {tool_1}
  - {tool_2}

{If env vars required: Make sure these are set in your environment:
  - {VAR1}
  - {VAR2}}

{If OAuth: Complete OAuth flow on first tool use.}
```

## Examples

```
/mcp-load github
# Loads GitHub MCP from registry

/mcp-load postgres
# Loads PostgreSQL MCP from registry
```
