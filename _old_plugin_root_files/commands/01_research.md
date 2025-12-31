# Research

Conduct comprehensive research (codebase, web, or both) and synthesize findings.

## Pipeline Position

```
[/research] → /clarify → /spec → /plan → /implement
     ↓
docs/research/{topic}.md
```

**This is the FIRST step in the development pipeline.**

## Arguments
- `$ARGUMENTS` - Research question or topic

## Output
- **File**: `docs/research/{topic-slug}.md`
- **Format**: Structured research document with findings, references, and open questions

## Research Type Detection

Auto-detect research type based on the query:

| Query Pattern | Type | Tools Used |
|---------------|------|------------|
| "how do we handle X", "where is X implemented" | **Codebase** | Glob, Grep, Read, Task(Explore) |
| "best practices for X", "how to implement X in 2024" | **Web** | WebSearch, WebFetch, context7 |
| "how should we implement X" (needs both context) | **Hybrid** | Both codebase + web |

**Override with explicit flags:**
- `--codebase` or `--code` — Force codebase-only research
- `--web` — Force web-only research
- `--hybrid` — Force both

## Process

### 0. Determine Research Type

Analyze the query to determine type:

**Codebase indicators:**
- References to "our", "we", "existing", "current"
- Mentions specific files, components, or package names
- Asks "where" or "how do we" (present tense, internal)

**Web indicators:**
- References to years ("2024", "2025", "latest")
- Asks about "best practices", "industry standard"
- Mentions external libraries, APIs, or tools not in codebase
- Exploratory: "what are the options for X"

**Hybrid indicators:**
- "How should we implement X" (needs external best practices + internal context)
- "Compare our approach to industry standard"
- New feature that requires understanding both codebase patterns and external APIs

### 1. Read Mentioned Files First (Codebase/Hybrid)
- If user mentions specific files, read them FULLY first
- Use Read tool WITHOUT limit/offset parameters
- Read in main context before spawning sub-agents

### 2. Decompose Research Question
- Break down query into composable research areas
- Identify components, patterns, or concepts to investigate
- Create research plan using TodoWrite
- Consider relevant directories, files, architectural patterns

---

## Codebase Research (when type = codebase or hybrid)

### 3a. Spawn Parallel Sub-Agents
Use Task tool with subagent_type="Explore" for:
- Different aspects of the codebase concurrently
- Pattern discovery
- Cross-component connections

Example searches:
- "Find all files related to {concept}"
- "How does {component} connect to {other component}?"
- "What patterns are used for {functionality}?"

### 4a. Synthesize Codebase Findings
Wait for ALL sub-agents to complete, then:
- Compile all results
- Connect findings across components
- Include specific file paths and line numbers
- Highlight patterns and architectural decisions

---

## Web Research (when type = web or hybrid)

### 3b. Search the Web
Use WebSearch for broad exploration:
```
WebSearch: "{topic} best practices 2025"
WebSearch: "{topic} implementation guide"
WebSearch: "{library} documentation tutorial"
```

Run multiple searches in parallel for different angles.

### 4b. Fetch Detailed Sources
For promising results, use WebFetch to get full content:
```
WebFetch: {url} - "Extract key implementation details and code examples"
```

### 4c. Get Library Documentation
For libraries/APIs, use context7 MCP tools:
```
1. mcp__context7__resolve-library-id: "{library-name}"
2. mcp__context7__get-library-docs: {library-id}, topic: "{specific-topic}"
```

Also use any domain-specific MCP tools configured in your project.

### 4d. Synthesize Web Findings
Compile external research:
- Key insights with source links
- Code examples and patterns
- Industry best practices
- Relevant library/API documentation

---

## Combined Synthesis (all types)

### 5. Synthesize All Findings
Merge codebase and/or web findings:
- Compile all results
- Connect internal patterns with external best practices
- Include specific references (file paths for code, URLs for web)
- Identify gaps and conflicts

### 6. Generate Research Document

**IMPORTANT**: Always save to `docs/research/{topic-slug}.md`

```markdown
---
date: {ISO timestamp}
topic: "{Research Question}"
type: codebase | web | hybrid
status: complete
next_step: "/clarify docs/research/{topic-slug}.md"
---

# Research: {Topic}

## Research Question
{Original user query}

## Summary
{High-level findings - 3-5 bullet points}

## Codebase Findings (if applicable)

### {Component/Area 1}
- Finding with reference (`file.ts:line`)
- Connection to other components
- Implementation details

### {Component/Area 2}
...

### Code References
| File | Lines | Description |
|------|-------|-------------|
| `path/to/file.ts` | 123-145 | Description |
| `another/file.ts` | 45-67 | Description |

## External Research (if applicable)

### Key Insights
- {Insight 1} — [Source](url)
- {Insight 2} — [Source](url)

### Best Practices
- {Practice 1}
- {Practice 2}

### Relevant Documentation
- [{Library} docs: {topic}](url)

### Sources
| Source | Key Takeaway |
|--------|--------------|
| [Article Title](url) | Main insight |
| [Docs Page](url) | Relevant pattern |

## Architecture Insights
{Patterns, conventions, design decisions discovered}

## Open Questions
- [ ] {Question that needs clarification}
- [ ] {Another question}

## Recommendations
{Initial thoughts on implementation approach}

---

**Next Step**: Run `/clarify docs/research/{topic-slug}.md` to resolve open questions.
```

### 7. Present Summary & Next Step

After saving:
```
Research complete! Saved to: docs/research/{topic-slug}.md

Key findings:
- {bullet 1}
- {bullet 2}
- {bullet 3}

Open questions to resolve: {count}

**Next step**: `/clarify docs/research/{topic-slug}.md`
```

## Important Notes

- Always use parallel Task agents for efficiency
- Focus on concrete file paths and line numbers
- Documents should be self-contained
- Each sub-agent prompt should be specific
- **Always include the "Next Step" section pointing to /clarify**
