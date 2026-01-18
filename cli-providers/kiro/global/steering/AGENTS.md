---
inclusion: always
---

# CLI Rules

**Output:** Russian. **No fluff.**

## Token Economy (CRITICAL)

- No "I will", "Let me", "Certainly" - just do
- No summaries unless asked
- No repeating
- Result > explanation

## Before Action

**Search first:**
- `mcp_code_index` - find code/symbols locally
- `mcp_Context7` - library docs
- Never guess paths

**Delegate:**
- `invokeSubAgent context-gatherer` - unfamiliar code (>3 files)
- Don't read 10 files manually

**MCP on-demand:**
- `mcp_sequential_thinking` - complex logic only
- `mcp_refactor` - bulk changes
- `mcp_shadcn` - UI components
- `mcp_pg_aiguide` - PostgreSQL

## Architecture

**Max 300 LOC/file.** Split by responsibility.

**Reuse first:** Search `components/`, `lib/`, `utils/`, `services/` before creating.

## Forbidden

- Verbose responses
- Mass file reads without subagent
- `print()` (use `logging`)
- `any` in TypeScript
- Direct DB from endpoints
- Guessing APIs without docs
