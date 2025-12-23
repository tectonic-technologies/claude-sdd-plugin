# Clarify Command

Resolve open questions from research before creating an implementation plan.

## Pipeline Position

```
/research → [/clarify] → /spec → /plan → /implement
     ↓           ↓
docs/research/  Updates research file with answers
```

**This is the SECOND step in the development pipeline.**

## Arguments
- `$ARGUMENTS` - **Required**: Path to research file (e.g., `docs/research/feature-name.md`)

## Input
- **File**: `docs/research/{topic}.md` (from /research command)

## Output
- **Updates**: Same research file with resolved questions
- **Adds**: "Clarifications" section with answers

## Process

### 1. Validate Input

If no file path provided:
```
Usage: /clarify docs/research/{topic}.md

Please provide the path to a research file. Run /research first if you haven't.
```

If file doesn't exist:
```
Research file not found: {path}

Run /research {topic} first to create the research document.
```

### 2. Read Research File

Read the research file completely and extract:
- Open Questions section
- Recommendations section
- Any ambiguities in findings

### 3. Present Questions

Use AskUserQuestion tool to resolve each open question:

```
Based on the research in {file}, I need to clarify {N} questions before planning:
```

Group questions by category:
- **Requirements**: What exactly should the feature do?
- **Constraints**: Performance, compatibility, scope limits?
- **Approach**: Which of the identified patterns to follow?
- **Priority**: What's in scope vs. out of scope?

### 4. Gather Answers

For each open question, use AskUserQuestion with:
- Clear, specific question
- 2-4 options when applicable
- Context from research findings

Example:
```typescript
AskUserQuestion({
  questions: [{
    question: "The research found two patterns for X. Which should we use?",
    header: "Pattern",
    options: [
      { label: "Pattern A", description: "Used in module Y, simpler but less flexible" },
      { label: "Pattern B", description: "Used in module Z, more complex but extensible" }
    ],
    multiSelect: false
  }]
})
```

### 5. Update Research File

Add a "Clarifications" section to the research file:

```markdown
## Clarifications

_Resolved on {date}_

### Q: {Original question}
**A**: {User's answer}
**Impact**: {How this affects implementation}

### Q: {Next question}
**A**: {Answer}
**Impact**: {Impact}

---

## Updated Recommendations

Based on clarifications:
1. {Updated recommendation}
2. {Updated recommendation}

---

**Next Step**: Run `/spec docs/research/{topic-slug}.md` to create the specification.
```

### 6. Present Summary & Next Step

```
Clarifications complete! Updated: docs/research/{topic}.md

Resolved {N} questions:
- {question 1}: {brief answer}
- {question 2}: {brief answer}

Key decisions:
- {decision 1}
- {decision 2}

**Next step**: `/spec docs/research/{topic}.md`
```

## When to Skip Clarify

If research has no open questions:
```
Research file has no open questions. Proceeding directly to spec creation.

**Next step**: `/spec docs/research/{topic}.md`
```

## Important Notes

- **Always read the research file first** - don't ask questions already answered
- **Use AskUserQuestion tool** - structured questions get better answers
- **Update the file in place** - keep all context together
- **Be specific** - vague questions lead to vague answers
- **Always include "Next Step"** pointing to /spec
