# MCP Add Command

Add an MCP server configuration for a service. Saves to a registry file for on-demand loading (NOT auto-loaded).

## Arguments
- `$ARGUMENTS` - Required: the service name (e.g., "github", "slack", "notion", "stripe")

## Process

### 1. Validate Input

If no service specified:
```
Usage: /mcp-add <service>

Examples:
  /mcp-add github
  /mcp-add slack
  /mcp-add notion
  /mcp-add stripe

Note: MCPs are saved to .mcp-registry.json for on-demand loading.
Use /mcp-load <service> to activate when needed.
```

### 2. Search for MCP Configuration

Use WebSearch to find the MCP server configuration:

```
Search queries to try:
1. "{service} MCP server configuration"
2. "{service} model context protocol server npm"
3. "anthropic MCP {service}"
4. "@modelcontextprotocol/{service}-server"
```

Look for:
- Official MCP server packages (prefer `@modelcontextprotocol/*` or `@anthropic/*`)
- GitHub repositories with MCP implementations
- Configuration examples from documentation

### 3. Determine Configuration Type

MCP servers typically come in these forms:

**A. NPX-based (most common)**
```json
{
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/{service}-server"]
}
```

**B. Remote/SSE-based**
```json
{
  "url": "https://{service}-mcp-url/sse"
}
```

**C. With environment variables**
```json
{
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/{service}-server"],
  "env": {
    "{SERVICE}_API_KEY": "${SERVICE}_API_KEY"
  }
}
```

### 4. Save to MCP Registry (NOT auto-loaded)

Save the configuration to `.mcp-registry.json`:

```json
{
  "{service}": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/{service}-server"],
    "env": {
      "{SERVICE}_API_KEY": "${SERVICE}_API_KEY"
    },
    "description": "Brief description of what this MCP does",
    "tools": ["tool_1", "tool_2"],
    "auth": "env|oauth|none"
  }
}
```

**IMPORTANT:** Do NOT run `claude mcp add` - this prevents auto-loading.

### 5. Update .env.example

If the MCP server requires environment variables:

1. Check if `.env.example` exists, create if not
2. Add required variables with placeholder comments:

```bash
# {Service} MCP Server (load with: /mcp-load {service})
{SERVICE}_API_KEY=your_{service}_api_key_here
```

### 6. Report Results

```
Saved MCP configuration: {service}

Registry: .mcp-registry.json
Status: NOT auto-loaded (on-demand only)

Configuration:
  Command: npx -y @modelcontextprotocol/{service}-server
  Auth: {env vars | oauth | none}
  {Env vars: {SERVICE}_API_KEY (added to .env.example)}

Available tools:
  - {tool_1} - {description}
  - {tool_2} - {description}

To activate:
  /mcp-load {service}

To see all available MCPs:
  /mcp-list
```

## Common MCP Servers

| Service | Package | Auth |
|---------|---------|------|
| GitHub | `@modelcontextprotocol/server-github` | GITHUB_TOKEN |
| Slack | `@modelcontextprotocol/server-slack` | SLACK_BOT_TOKEN |
| Google Drive | `@modelcontextprotocol/server-gdrive` | OAuth |
| PostgreSQL | `@modelcontextprotocol/server-postgres` | DATABASE_URL |
| Filesystem | `@modelcontextprotocol/server-filesystem` | None |
| Memory | `@modelcontextprotocol/server-memory` | None |
| Brave Search | `@modelcontextprotocol/server-brave-search` | BRAVE_API_KEY |
| Linear | Remote SSE | OAuth |
| Notion | `@modelcontextprotocol/server-notion` | NOTION_API_KEY |
| Sentry | `@modelcontextprotocol/server-sentry` | SENTRY_AUTH_TOKEN |

## Examples

```
/mcp-add github
# Searches for GitHub MCP, saves config, adds GITHUB_TOKEN to .env.example

/mcp-add postgres
# Searches for PostgreSQL MCP, saves config, adds DATABASE_URL to .env.example

/mcp-add linear
# Searches for Linear MCP, saves remote SSE config, notes OAuth requirement
```

## Error Handling

If no MCP server found:
```
Could not find an MCP server for "{service}".

Suggestions:
1. Check https://github.com/modelcontextprotocol/servers for official servers
2. Search npm for community servers: npm search mcp {service}
3. The service may not have an MCP server yet

Would you like me to search for alternative integrations?
```
