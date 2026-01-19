# Dispatching Parallel Agents

Use this pattern when you need to execute multiple independent tasks simultaneously. This dramatically reduces total execution time.

## When to use
- You have 2+ tasks that do NOT depend on each other's output.
- Example: "Create backend API" AND "Create frontend UI".
- Example: "Search documentation for X" AND "Search documentation for Y".
- Example: "Fix bug A in file1" AND "Fix bug B in file2".

## How to use
In a **SINGLE** response message, emit multiple tool calls to the `Task` tool (or any other tool).

## Example Pattern

**User Request:** "Create a login page and a registration API."

**Orchestrator Response:**

```json
[
  {
    "tool": "task",
    "args": {
      "subagent_type": "frontend",
      "prompt": "Create a login page component using React and Tailwind..."
    }
  },
  {
    "tool": "task",
    "args": {
      "subagent_type": "backend",
      "prompt": "Create a registration API endpoint with JWT support..."
    }
  }
]
```

## Rules for Parallelism
1. **Independence:** Ensure Task A doesn't need Task B's file to exist *before* it starts.
2. **Context:** Provide full context to EACH task (they don't share memory during execution).
3. **Merge:** After all parallel tasks return, you (the Orchestrator) are responsible for verifying they fit together.
