# Additional MCP Servers for Qwen (Optional)

## Дополнительные MCP серверы для специфических задач

### Documentation & Search

**1. consult7**
```json
{
  "consult7": {
    "command": "npx",
    "args": ["-y", "consult7"],
    "description": "Analyze large codebases and documents using high-context models"
  }
}
```
**Use case:** Анализ больших кодовых баз с использованием моделей с большим контекстом

**2. context-awesome**
```json
{
  "context-awesome": {
    "command": "npx",
    "args": ["-y", "context-awesome"],
    "description": "Query 8,500+ curated awesome lists (1M+ items)"
  }
}
```
**Use case:** Поиск лучших ресурсов и библиотек по темам

**3. Jina Reader**
```json
{
  "jina-reader": {
    "command": "npx",
    "args": ["-y", "@jina-ai/reader-mcp"],
    "description": "Fetch remote URL content as Markdown"
  }
}
```
**Use case:** Извлечение контента из веб-страниц в Markdown

---

### Architecture & Design

**4. llm-context**
```json
{
  "llm-context": {
    "command": "npx",
    "args": ["-y", "llm-context"],
    "description": "Share code context with LLMs via MCP or clipboard"
  }
}
```
**Use case:** Передача контекста кода между инструментами

**5. Sourcerer**
```json
{
  "sourcerer": {
    "command": "npx",
    "args": ["-y", "sourcerer-mcp"],
    "description": "Semantic code search & navigation that reduces token waste"
  }
}
```
**Use case:** Семантический поиск по коду с минимальным расходом токенов

**6. Scaffold**
```json
{
  "scaffold": {
    "command": "npx",
    "args": ["-y", "scaffold-mcp"],
    "description": "RAG system for structural understanding of large codebases"
  }
}
```
**Use case:** Структурное понимание больших кодовых баз через knowledge graph

---

### Database & Data

**7. SchemaCrawler**
```json
{
  "schemacrawler": {
    "command": "npx",
    "args": ["-y", "schemacrawler-mcp"],
    "description": "Connect to any relational database, get valid SQL"
  }
}
```
**Use case:** Анализ схем любых реляционных БД

**8. DynamoDB-Toolbox**
```json
{
  "dynamodb-toolbox": {
    "command": "npx",
    "args": ["-y", "dynamodb-toolbox-mcp"],
    "description": "Interact with DynamoDB using natural language"
  }
}
```
**Use case:** Работа с DynamoDB через естественный язык

---

### API & Integration

**9. OpenAPI Schema Explorer**
```json
{
  "openapi-explorer": {
    "command": "npx",
    "args": ["-y", "openapi-schema-explorer"],
    "description": "Token-efficient access to OpenAPI/Swagger specs"
  }
}
```
**Use case:** Эффективный доступ к OpenAPI спецификациям

**10. Hippycampus**
```json
{
  "hippycampus": {
    "command": "npx",
    "args": ["-y", "hippycampus"],
    "description": "Turn any Swagger/OpenAPI endpoint into MCP Server automatically"
  }
}
```
**Use case:** Автоматическое создание MCP серверов из OpenAPI спецификаций

---

### Project Management

**11. Linear**
```json
{
  "linear": {
    "command": "npx",
    "args": ["-y", "@linear/mcp"],
    "description": "Integrate with Linear project management"
  }
}
```
**Use case:** Интеграция с Linear для управления задачами

**12. Jira MCP Server**
```json
{
  "jira": {
    "command": "npx",
    "args": ["-y", "jira-mcp-server"],
    "description": "Interact with Jira Cloud for issue management"
  }
}
```
**Use case:** Работа с Jira задачами и проектами

---

### Version Control

**13. GitHub (via Docker)**
```json
{
  "github": {
    "command": "docker",
    "args": [
      "run",
      "-i",
      "--rm",
      "-e",
      "GITHUB_PERSONAL_ACCESS_TOKEN",
      "ghcr.io/github/github-mcp-server"
    ],
    "env": {
      "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
    },
    "description": "GitHub integration for repo search, code search, issues"
  }
}
```
**Use case:** Поиск репозиториев, кода, issues на GitHub

---

### Specialized Tools

**14. Mermaid**
```json
{
  "mermaid": {
    "command": "npx",
    "args": ["-y", "mermaid-mcp"],
    "description": "Generate mermaid diagrams dynamically"
  }
}
```
**Use case:** Генерация диаграмм Mermaid для документации

**15. Chart**
```json
{
  "chart": {
    "command": "npx",
    "args": ["-y", "chart-mcp"],
    "description": "Generate various chart types with Zod validation"
  }
}
```
**Use case:** Создание графиков и диаграмм

**16. Pandoc**
```json
{
  "pandoc": {
    "command": "npx",
    "args": ["-y", "pandoc-mcp"],
    "description": "Document format conversion (Markdown, HTML, PDF, etc.)"
  }
}
```
**Use case:** Конвертация документов между форматами

---

## Рекомендации по установке

### Для Draft Spec Workflow (минимум):
```json
{
  "mcpServers": {
    "code-index": { ... },
    "memory": { ... },
    "sequential-thinking": { ... },
    "pg-aiguide": { ... }
  }
}
```

### Для расширенного анализа (+):
```json
{
  "mcpServers": {
    // ... минимум ...
    "consult7": { ... },
    "sourcerer": { ... },
    "scaffold": { ... }
  }
}
```

### Для работы с API (+):
```json
{
  "mcpServers": {
    // ... минимум ...
    "openapi-explorer": { ... },
    "hippycampus": { ... }
  }
}
```

### Для интеграции с PM tools (+):
```json
{
  "mcpServers": {
    // ... минимум ...
    "linear": { ... },
    "jira": { ... }
  }
}
```

---

## Environment Variables

Для серверов, требующих API keys, создайте `.qwen/.env`:

```bash
# GitHub
GITHUB_TOKEN=ghp_your_token

# Context7 (если используете)
CONTEXT7_API_KEY=ctx7sk-your-key

# Ref (если используете)
REF_API_KEY=ref-your-key

# Linear (если используете)
LINEAR_API_KEY=lin_api_your_key

# Jira (если используете)
JIRA_API_TOKEN=your_jira_token
JIRA_EMAIL=your@email.com
JIRA_DOMAIN=your-domain.atlassian.net
```

---

## Тестирование новых MCP

```bash
qwen
```

Затем в чате:
```
Какие MCP серверы доступны?
Протестируй [server-name] - [test command]
```

---

## Полезные ссылки

- **Awesome MCP Servers**: https://github.com/wong2/awesome-mcp-servers
- **MCP Compass**: Используйте для поиска новых серверов
- **Official MCP Docs**: https://modelcontextprotocol.io
