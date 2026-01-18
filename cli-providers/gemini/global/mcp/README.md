# MCP Servers для Gemini CLI

## Настроенные серверы

### 1. filesystem (включён)
**Описание**: Доступ к файловой системе проекта для чтения файлов

**Команда**: `npx -y @modelcontextprotocol/server-filesystem .`

**Использование**: Автоматически используется для чтения файлов проекта при ревью

### 2. postgres (выключен по умолчанию)
**Описание**: Инспекция схемы PostgreSQL базы данных

**Команда**: `uvx mcp-server-postgres`

**Настройка**:
```bash
# Установи connection string
export POSTGRES_CONNECTION_STRING="postgresql://user:pass@localhost:5432/dbname"

# Включи в settings.json
"postgres": {
  "disabled": false
}
```

**Использование**: Анализ существующей DB схемы, проверка indexes, constraints

### 3. github (выключен по умолчанию)
**Описание**: Доступ к GitHub репозиториям

**Команда**: `npx -y @modelcontextprotocol/server-github`

**Настройка**:
```bash
# Создай GitHub Personal Access Token
# https://github.com/settings/tokens

export GITHUB_TOKEN="ghp_..."

# Включи в settings.json
"github": {
  "disabled": false
}
```

**Использование**: Чтение issues, PRs, code review comments

## Как добавить новый MCP сервер

### Через CLI
```bash
gemini mcp add my-server \
  --command "npx" \
  --args "-y,@my/mcp-server" \
  --scope user
```

### Вручную в settings.json
```json
{
  "mcpServers": {
    "my-server": {
      "command": "npx",
      "args": ["-y", "@my/mcp-server"],
      "description": "My custom MCP server",
      "disabled": false
    }
  }
}
```

## Полезные MCP серверы

### Для разработки
- `@modelcontextprotocol/server-filesystem` — файловая система
- `@modelcontextprotocol/server-github` — GitHub
- `@modelcontextprotocol/server-gitlab` — GitLab
- `mcp-server-postgres` — PostgreSQL
- `mcp-server-sqlite` — SQLite

### Для документации
- `@modelcontextprotocol/server-fetch` — web scraping
- `@modelcontextprotocol/server-brave-search` — поиск в интернете

### Для AI/ML
- `@modelcontextprotocol/server-memory` — долгосрочная память
- `@modelcontextprotocol/server-everything` — универсальный поиск

## Troubleshooting

### MCP сервер не подключается
```bash
# Проверь что команда работает
npx -y @modelcontextprotocol/server-filesystem .

# Проверь логи
gemini --debug

# Проверь статус
gemini
/mcp
```

### Нет инструментов от MCP
```bash
# Убедись что сервер включён
"disabled": false

# Проверь что команда установлена
which npx
which uvx
```

### OAuth ошибки (для remote MCP)
```bash
# Переаутентифицируйся
gemini
/mcp auth my-server --reauth
```
