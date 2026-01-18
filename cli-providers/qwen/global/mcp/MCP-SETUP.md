# MCP Setup для Qwen Code CLI

## Рекомендуемые MCP серверы для Draft Spec Workflow

### 1. **code-index** (Обязательно)
**Назначение:** Анализ кодовой базы, поиск символов, структура проекта

**Установка:**
```bash
pip install uv
uvx code-index-mcp
```

**Использование:**
- Поиск существующих сервисов/компонентов
- Анализ структуры проекта
- Поиск паттернов в коде

**Команды в Qwen:**
```
Найди все сервисы в backend/services/
Покажи структуру компонентов в frontend/
```

---

### 2. **memory** (Рекомендуется)
**Назначение:** Knowledge graph для отслеживания контекста проекта

**Установка:**
```bash
npx -y @modelcontextprotocol/server-memory
```

**Использование:**
- Сохранение архитектурных решений
- Отслеживание зависимостей между модулями
- История изменений требований

**Команды в Qwen:**
```
Сохрани решение: используем Redis для кэша
Покажи все решения по архитектуре
```

---

### 3. **sequential-thinking** (Рекомендуется)
**Назначение:** Пошаговое рассуждение для сложных решений

**Установка:**
```bash
npx -y @modelcontextprotocol/server-sequential-thinking
```

**Использование:**
- Анализ сложных архитектурных решений
- Выбор между альтернативами
- Оценка рисков

**Команды в Qwen:**
```
Проанализируй: WebSocket vs Polling для уведомлений
Оцени риски использования микросервисов
```

---

### 4. **Context7** (Опционально)
**Назначение:** Поиск документации по библиотекам

**Установка:**
```bash
# Получить API key: https://context7.com
npx -y @upstash/context7-mcp --api-key YOUR_KEY
```

**Использование:**
- Поиск best practices для библиотек
- Примеры использования API
- Актуальная документация

**Команды в Qwen:**
```
Найди документацию по FastAPI authentication
Покажи примеры использования React Query
```

---

### 5. **Ref** (Опционально)
**Назначение:** Поиск документации на GitHub и в интернете

**Установка:**
```bash
# Получить API key: https://ref.tools
# Добавить в .qwen/.env: REF_API_KEY=your-key
```

**Использование:**
- Поиск примеров на GitHub
- Документация из README
- Best practices из статей

**Команды в Qwen:**
```
Найди примеры JWT authentication в FastAPI
Покажи best practices для Next.js App Router
```

---

### 6. **pg-aiguide** (Для PostgreSQL проектов)
**Назначение:** PostgreSQL и TimescaleDB документация

**Установка:**
```bash
# Не требует установки (HTTP endpoint)
```

**Использование:**
- Дизайн таблиц PostgreSQL
- Оптимизация запросов
- TimescaleDB hypertables

**Команды в Qwen:**
```
Как правильно создать индексы для таблицы users?
Покажи best practices для партиционирования
```

---

### 7. **refactor-mcp** (Опционально)
**Назначение:** Поиск и рефакторинг кода

**Установка:**
```bash
npx -y @myuon/refactor-mcp
```

**Использование:**
- Поиск дублирующегося кода
- Массовый рефакторинг
- Поиск паттернов

**Команды в Qwen:**
```
Найди все использования старого API
Замени все console.log на logger
```

---

### 8. **mcp-compass** (Утилита)
**Назначение:** Поиск и обнаружение MCP серверов

**Установка:**
```bash
npx -y mcp-compass
```

**Использование:**
- Поиск новых MCP серверов
- Информация о доступных серверах

**Команды в Qwen:**
```
Найди MCP серверы для работы с Docker
Покажи информацию о server-memory
```

---

## Конфигурация в settings.json

**Минимальная (только для Draft Spec):**
```json
{
  "mcpServers": {
    "code-index": {
      "command": "uvx",
      "args": ["code-index-mcp"],
      "trust": false
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "trust": false
    }
  }
}
```

**Полная (все серверы):**
```json
{
  "mcpServers": {
    "code-index": {
      "command": "uvx",
      "args": ["code-index-mcp"],
      "trust": false,
      "includeTools": [
        "set_project_path",
        "search_code_advanced",
        "find_files",
        "get_file_summary"
      ]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "trust": false
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"],
      "trust": false
    },
    "Context7": {
      "command": "npx",
      "args": [
        "-y",
        "@upstash/context7-mcp",
        "--api-key",
        "${CONTEXT7_API_KEY}"
      ],
      "trust": false
    },
    "Ref": {
      "url": "https://api.ref.tools/mcp",
      "headers": {
        "x-ref-api-key": "${REF_API_KEY}"
      },
      "trust": false
    },
    "pg-aiguide": {
      "url": "https://mcp.tigerdata.com/docs",
      "trust": false
    },
    "refactor-mcp": {
      "command": "npx",
      "args": ["-y", "@myuon/refactor-mcp"],
      "trust": false
    },
    "mcp-compass": {
      "command": "npx",
      "args": ["-y", "mcp-compass"],
      "trust": false
    }
  }
}
```

---

## Environment Variables

**Файл:** `.qwen/.env`

```bash
# Context7 API Key (опционально)
CONTEXT7_API_KEY=ctx7sk-your-key

# Ref API Key (опционально)
REF_API_KEY=ref-your-key
```

---

## Приоритеты для Draft Spec

### Обязательно:
1. ✅ **code-index** - анализ репозитория
2. ✅ **memory** - сохранение контекста

### Рекомендуется:
3. ✅ **sequential-thinking** - сложные решения
4. ✅ **pg-aiguide** - если используется PostgreSQL

### Опционально:
5. ⚠️ **Context7** - если нужна документация библиотек
6. ⚠️ **Ref** - если нужны примеры с GitHub
7. ⚠️ **refactor-mcp** - если нужен рефакторинг

---

## Тестирование MCP

### Проверка code-index:
```bash
qwen
```
```
Найди все файлы с названием *service*.py
```

### Проверка memory:
```
Сохрани решение: используем FastAPI для backend
Покажи все сохранённые решения
```

### Проверка sequential-thinking:
```
Проанализируй: какую БД выбрать - PostgreSQL или MongoDB?
```

---

## Troubleshooting

### MCP сервер не запускается

**Ошибка:** `Initializing MCP tools from mcp servers: ['code-index']` зависает

**Решение:**
1. Проверить установку: `uvx --version`
2. Тестировать вручную: `uvx code-index-mcp`
3. Проверить логи в терминале

### Environment variables не загружаются

**Ошибка:** `CONTEXT7_API_KEY not found`

**Решение:**
1. Создать `.qwen/.env`
2. Добавить переменные
3. Перезапустить Qwen

### Permission denied

**Ошибка:** `Permission denied` при доступе к файлам

**Решение:**
1. Установить `trust: false` в конфиге
2. Одобрять каждый tool call вручную
3. Или `trust: true` для доверенных серверов

---

## Следующие шаги

1. Установить минимальный набор (code-index + memory)
2. Протестировать каждый MCP сервер
3. Добавить опциональные по необходимости
4. Настроить environment variables
5. Интегрировать в workflow
