# MCP Configuration for Qwen Code

## Recommended MCP Servers for Draft Spec Workflow

### 1. Filesystem (Essential)

**Purpose**: Read/write files, search codebase

**Installation**:
```bash
# Requires uv package manager
pip install uv
# or
brew install uv
```

**Configuration** (add to `~/.qwen/settings.json`):
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "uvx",
      "args": ["mcp-server-filesystem", "."],
      "trust": false,
      "includeTools": [
        "read_file",
        "read_multiple_files",
        "write_file",
        "list_directory",
        "search_files",
        "get_file_info"
      ],
      "description": "Access project files for analysis and spec generation"
    }
  }
}
```

---

### 2. Git (Recommended)

**Purpose**: Analyze git history, commits, branches

**Installation**:
```bash
uvx mcp-server-git --help
```

**Configuration**:
```json
{
  "mcpServers": {
    "git": {
      "command": "uvx",
      "args": ["mcp-server-git", "--repository", "."],
      "trust": false,
      "includeTools": [
        "git_status",
        "git_diff",
        "git_log",
        "git_show"
      ],
      "description": "Analyze git history and changes"
    }
  }
}
```

---

### 3. PostgreSQL (Optional)

**Purpose**: Analyze existing database schema

**Installation**:
```bash
uvx mcp-server-postgres --help
```

**Configuration**:
```json
{
  "mcpServers": {
    "postgres": {
      "command": "uvx",
      "args": ["mcp-server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:pass@localhost:5432/dbname"
      },
      "trust": false,
      "includeTools": [
        "query",
        "list_tables",
        "describe_table"
      ],
      "description": "Query database schema for analysis"
    }
  }
}
```

**Security Note**: Store connection string in `.qwen/.env`:
```bash
POSTGRES_CONNECTION_STRING=postgresql://user:pass@localhost:5432/dbname
```

---

### 4. Bright Data (Optional - for web research)

**Purpose**: Search web, scrape documentation

**Installation**:
```bash
npm install -g @brightdata/mcp
```

**Configuration**:
```json
{
  "mcpServers": {
    "brightdata": {
      "command": "npx",
      "args": ["-y", "@brightdata/mcp"],
      "env": {
        "API_TOKEN": "${BRIGHT_DATA_API_TOKEN}",
        "BROWSER_AUTH": "${BRIGHT_DATA_BROWSER_AUTH}"
      },
      "trust": false,
      "includeTools": [
        "search_engine",
        "scrape_as_markdown"
      ],
      "description": "Search web for technical documentation and examples"
    }
  }
}
```

---

## Complete Configuration Example

**File**: `~/.qwen/settings.json`

```json
{
  "general": {
    "vimMode": false,
    "preferredEditor": "code"
  },
  "ui": {
    "theme": "GitHub",
    "hideBanner": false,
    "showLineNumbers": true
  },
  "model": {
    "name": "qwen3-coder-plus",
    "maxSessionTurns": -1,
    "chatCompression": {
      "contextPercentageThreshold": 0.7
    }
  },
  "context": {
    "fileName": ["QWEN.md", "00_thoughts.md"],
    "fileFiltering": {
      "respectGitIgnore": true,
      "respectQwenIgnore": true
    }
  },
  "tools": {
    "approvalMode": "default",
    "autoAccept": false,
    "useRipgrep": true
  },
  "mcpServers": {
    "filesystem": {
      "command": "uvx",
      "args": ["mcp-server-filesystem", "."],
      "trust": false,
      "includeTools": [
        "read_file",
        "read_multiple_files",
        "write_file",
        "list_directory",
        "search_files"
      ]
    },
    "git": {
      "command": "uvx",
      "args": ["mcp-server-git", "--repository", "."],
      "trust": false,
      "includeTools": [
        "git_status",
        "git_diff",
        "git_log"
      ]
    }
  },
  "mcp": {
    "allowed": ["filesystem", "git"],
    "excluded": []
  },
  "privacy": {
    "usageStatisticsEnabled": false
  }
}
```

---

## Environment Variables

**File**: `.qwen/.env` (project-specific)

```bash
# PostgreSQL (if using postgres MCP)
POSTGRES_CONNECTION_STRING=postgresql://user:pass@localhost:5432/dbname

# Bright Data (if using web search)
BRIGHT_DATA_API_TOKEN=your-token
BRIGHT_DATA_BROWSER_AUTH=username:password

# Tavily (if using web_search tool)
TAVILY_API_KEY=tvly-your-key
```

---

## Testing MCP Servers

### Test Filesystem MCP

```bash
qwen
```

Then in chat:
```
List all Python files in the services/ directory
```

### Test Git MCP

```
Show me the last 5 commits
```

### Test PostgreSQL MCP

```
List all tables in the database
```

---

## Troubleshooting

### MCP Server Not Starting

**Error**: `Initializing MCP tools from mcp servers: ['filesystem']` hangs

**Solution**:
1. Check if `uvx` is installed: `uvx --version`
2. Test MCP server manually: `uvx mcp-server-filesystem .`
3. Check logs in terminal

### Permission Denied

**Error**: `Permission denied` when accessing files

**Solution**:
1. Set `trust: false` in config (requires approval)
2. Or set `trust: true` for trusted servers
3. Check file permissions: `ls -la`

### Environment Variables Not Loaded

**Error**: `API_TOKEN` not found

**Solution**:
1. Create `.qwen/.env` file
2. Add variables: `API_TOKEN=your-token`
3. Restart Qwen Code

---

## Best Practices

### Security

1. ✅ **Never commit** `.qwen/.env` to git
2. ✅ **Use** `trust: false` for untrusted servers
3. ✅ **Store** credentials in environment variables
4. ❌ **Don't** hardcode API keys in `settings.json`

### Performance

1. ✅ **Use** `includeTools` to limit available tools
2. ✅ **Use** `excludeTools` to block dangerous operations
3. ✅ **Set** `timeout` for slow servers
4. ❌ **Don't** enable all MCP servers at once

### Organization

1. ✅ **Global config**: `~/.qwen/settings.json` (user-wide)
2. ✅ **Project config**: `.qwen/settings.json` (project-specific)
3. ✅ **Secrets**: `.qwen/.env` (never commit)
4. ✅ **Ignore**: Add `.qwen/.env` to `.gitignore`

---

## Next Steps

1. Install required MCP servers
2. Configure `~/.qwen/settings.json`
3. Test each MCP server
4. Create `.qwen/.env` for secrets
5. Start using Qwen with MCP tools
