# OpenCode - Архитектура и внутреннее устройство

## Общая архитектура

OpenCode построен на модульной клиент-серверной архитектуре, которая позволяет AI моделям от 75+ провайдеров взаимодействовать с кодовыми базами через комплексный фреймворк инструментов.

### Основные компоненты

```
┌─────────────────────────────────────────────────────────┐
│                    OpenCode Client                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │     TUI      │  │  Desktop App │  │ IDE Extension│  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                   OpenCode Server                        │
│  ┌──────────────────────────────────────────────────┐  │
│  │              Agent Orchestrator                   │  │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐ │  │
│  │  │   Build    │  │    Plan    │  │   Custom   │ │  │
│  │  │   Agent    │  │   Agent    │  │   Agents   │ │  │
│  │  └────────────┘  └────────────┘  └────────────┘ │  │
│  └──────────────────────────────────────────────────┘  │
│                          │                               │
│  ┌──────────────────────────────────────────────────┐  │
│  │              Tool Framework                       │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐       │  │
│  │  │ Built-in │  │   MCP    │  │  Custom  │       │  │
│  │  │  Tools   │  │  Servers │  │  Tools   │       │  │
│  │  └──────────┘  └──────────┘  └──────────┘       │  │
│  └──────────────────────────────────────────────────┘  │
│                          │                               │
│  ┌──────────────────────────────────────────────────┐  │
│  │           Provider Abstraction Layer              │  │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐   │  │
│  │  │OpenAI  │ │Anthropic│ │ Gemini │ │  ...   │   │  │
│  │  └────────┘ └────────┘ └────────┘ └────────┘   │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                External Integrations                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐             │
│  │   LSP    │  │   MCP    │  │  GitHub  │             │
│  │ Servers  │  │ Servers  │  │ Actions  │             │
│  └──────────┘  └──────────┘  └──────────┘             │
└─────────────────────────────────────────────────────────┘
```

## Клиент-серверная модель

### Сервер (Backend)

**Язык**: Go

**Ответственность**:
- Управление сессиями
- Оркестрация агентов
- Выполнение инструментов
- Управление контекстом
- Интеграция с провайдерами
- Обработка разрешений
- Хранение данных

**Режимы работы**:
1. **Embedded** - Встроенный в TUI/Desktop
2. **Standalone** - Headless HTTP сервер
3. **Web** - Сервер с веб-интерфейсом

### Клиент (Frontend)

**Варианты**:
1. **TUI** - Терминальный интерфейс
2. **Desktop** - Десктопное приложение
3. **IDE Extension** - Расширение для IDE
4. **HTTP API** - Программный доступ

**Ответственность**:
- Пользовательский интерфейс
- Ввод/вывод
- Отображение результатов
- Управление сессиями
- Взаимодействие с сервером

## Система агентов

### Типы агентов

#### Primary Agents
Основные агенты для прямого взаимодействия с пользователем.

**Характеристики**:
- Полный доступ к инструментам
- Управление основной сессией
- Переключение через Tab
- Настраиваемые разрешения

**Встроенные**:
- **Build** - Полный доступ, для разработки
- **Plan** - Ограниченный доступ, для планирования

#### Subagents
Специализированные агенты для конкретных задач.

**Характеристики**:
- Вызываются через @ mention
- Создают дочерние сессии
- Фокус на конкретной задаче
- Возврат результата в основную сессию

**Встроенные**:
- **General** - Исследование, поиск, многошаговые задачи
- **Explore** - Быстрое исследование кодовой базы

### Жизненный цикл агента

```
┌──────────────┐
│ Инициализация│
│  - Загрузка  │
│  - Конфиг    │
│  - Промпт    │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Получение   │
│   запроса    │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Обработка   │
│  контекста   │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Вызов LLM  │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Выполнение  │
│ инструментов │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Итерация   │
│ (если нужно) │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│    Ответ     │
│ пользователю │
└──────────────┘
```

### Конфигурация агента

```json
{
  "agents": {
    "my-agent": {
      "description": "Описание агента",
      "mode": "primary|subagent|all",
      "model": "provider/model-id",
      "temperature": 0.7,
      "maxTokens": 5000,
      "maxSteps": 10,
      "prompt": "{file:./prompts/agent.md}",
      "tools": {
        "write": true,
        "edit": true,
        "bash": false
      },
      "permissions": {
        "edit": "ask",
        "bash": "deny"
      },
      "hidden": false
    }
  }
}
```

## Фреймворк инструментов

### Архитектура инструментов

```
┌─────────────────────────────────────────┐
│         Tool Registry                    │
│  ┌────────────────────────────────────┐ │
│  │  Built-in Tools                    │ │
│  │  - File operations                 │ │
│  │  - Search                          │ │
│  │  - Execution                       │ │
│  └────────────────────────────────────┘ │
│  ┌────────────────────────────────────┐ │
│  │  MCP Tools                         │ │
│  │  - Local servers                   │ │
│  │  - Remote servers                  │ │
│  │  - OAuth integration               │ │
│  └────────────────────────────────────┘ │
│  ┌────────────────────────────────────┐ │
│  │  Custom Tools                      │ │
│  │  - User-defined                    │ │
│  │  - Project-specific                │ │
│  └────────────────────────────────────┘ │
└─────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│      Permission System                   │
│  - allow / ask / deny                   │
│  - Per-tool configuration               │
│  - Glob patterns                        │
└─────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│       Tool Execution                     │
│  - Validation                           │
│  - Sandboxing                           │
│  - Result handling                      │
└─────────────────────────────────────────┘
```

### Встроенные инструменты

#### Файловые операции
- **read** - Чтение файлов с поддержкой диапазонов
- **write** - Создание/перезапись файлов
- **edit** - Точное редактирование через замену
- **patch** - Применение diff патчей

#### Поиск
- **grep** - Regex поиск (использует ripgrep)
- **glob** - Поиск файлов по паттерну
- **list** - Список директорий

#### Выполнение
- **bash** - Выполнение shell команд
- **webfetch** - Загрузка веб-контента

#### LSP интеграция
- **lsp** - Операции Language Server Protocol

#### Управление
- **skill** - Загрузка навыков
- **todowrite/todoread** - Управление задачами
- **question** - Интерактивные вопросы

### MCP (Model Context Protocol)

#### Архитектура MCP

```
┌─────────────────────────────────────────┐
│         MCP Client (OpenCode)            │
│  ┌────────────────────────────────────┐ │
│  │  Connection Manager                │ │
│  │  - Local connections (stdio)       │ │
│  │  - Remote connections (HTTP)       │ │
│  │  - OAuth handler                   │ │
│  └────────────────────────────────────┘ │
│  ┌────────────────────────────────────┐ │
│  │  Tool Discovery                    │ │
│  │  - Fetch tool schemas              │ │
│  │  - Register in tool registry       │ │
│  └────────────────────────────────────┘ │
└─────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│         MCP Servers                      │
│  ┌────────────┐  ┌────────────┐        │
│  │   Local    │  │   Remote   │        │
│  │  (stdio)   │  │   (HTTP)   │        │
│  └────────────┘  └────────────┘        │
└─────────────────────────────────────────┘
```

#### Типы MCP серверов

**Local (stdio)**:
- Запуск через command
- Коммуникация через stdin/stdout
- Переменные окружения
- Примеры: filesystem, database

**Remote (HTTP)**:
- HTTP/HTTPS подключение
- OAuth аутентификация
- Headers для авторизации
- Примеры: Sentry, Context7, GitHub

#### OAuth Flow

```
1. OpenCode обнаруживает 401 ответ
   │
   ▼
2. Попытка Dynamic Client Registration (RFC 7591)
   │
   ▼
3. Открытие браузера для авторизации
   │
   ▼
4. Получение authorization code
   │
   ▼
5. Обмен на access/refresh tokens
   │
   ▼
6. Сохранение в ~/.local/share/opencode/mcp-auth.json
   │
   ▼
7. Автоматическое использование в запросах
```

## LSP (Language Server Protocol)

### Архитектура LSP

```
┌─────────────────────────────────────────┐
│         LSP Client (OpenCode)            │
│  ┌────────────────────────────────────┐ │
│  │  LSP Manager                       │ │
│  │  - Server lifecycle                │ │
│  │  - Connection management           │ │
│  │  - Request/response handling       │ │
│  └────────────────────────────────────┘ │
└─────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│      Language Servers                    │
│  ┌──────────┐  ┌──────────┐            │
│  │  gopls   │  │typescript│            │
│  │          │  │-language-│            │
│  │          │  │  server  │            │
│  └──────────┘  └──────────┘            │
└─────────────────────────────────────────┘
```

### Поддерживаемые операции

- **textDocument/diagnostic** - Диагностика кода
- **textDocument/definition** - Перейти к определению
- **textDocument/references** - Найти ссылки
- **textDocument/hover** - Hover информация
- **textDocument/documentSymbol** - Символы документа
- **workspace/symbol** - Символы workspace
- **textDocument/implementation** - Перейти к реализации
- **textDocument/prepareCallHierarchy** - Call hierarchy
- **callHierarchy/incomingCalls** - Входящие вызовы
- **callHierarchy/outgoingCalls** - Исходящие вызовы

### Интеграция с AI

AI получает доступ к LSP через инструмент `diagnostics`:

```typescript
// AI может запросить диагностику
{
  "tool": "diagnostics",
  "parameters": {
    "file_path": "src/app.ts"
  }
}

// Получает ответ с ошибками
{
  "diagnostics": [
    {
      "severity": "error",
      "message": "Type 'string' is not assignable to type 'number'",
      "range": {
        "start": {"line": 10, "character": 5},
        "end": {"line": 10, "character": 15}
      }
    }
  ]
}
```

## Управление контекстом

### Auto Compact

Автоматическое сжатие контекста при приближении к лимиту модели.

```
┌─────────────────────────────────────────┐
│      Context Monitor                     │
│  - Отслеживание использования токенов   │
│  - Определение порога (80-90%)          │
└─────────────────┬───────────────────────┘
                  │
                  ▼ (Порог достигнут)
┌─────────────────────────────────────────┐
│      Compaction Process                  │
│  1. Суммаризация истории                │
│  2. Сохранение важного контекста        │
│  3. Создание новой сессии               │
│  4. Перенос резюме                      │
└─────────────────────────────────────────┘
```

### Управление сессиями

```
Session {
  id: string
  title: string
  created: timestamp
  updated: timestamp
  messages: Message[]
  context: Context
  agent: AgentConfig
  model: ModelConfig
  parent?: SessionId
  children?: SessionId[]
}

Message {
  role: "user" | "assistant" | "system"
  content: string | Content[]
  tool_calls?: ToolCall[]
  tool_results?: ToolResult[]
  timestamp: timestamp
}

Context {
  files: FileContext[]
  skills: Skill[]
  memory: Memory[]
  tokens_used: number
  tokens_limit: number
}
```

## Система разрешений

### Уровни разрешений

```
┌─────────────────────────────────────────┐
│      Permission Levels                   │
│  ┌────────────────────────────────────┐ │
│  │  allow                             │ │
│  │  - Автоматическое выполнение       │ │
│  │  - Без запроса пользователю        │ │
│  └────────────────────────────────────┘ │
│  ┌────────────────────────────────────┐ │
│  │  ask (default)                     │ │
│  │  - Запрос подтверждения            │ │
│  │  - Показ деталей операции          │ │
│  └────────────────────────────────────┘ │
│  ┌────────────────────────────────────┐ │
│  │  deny                              │ │
│  │  - Блокировка выполнения           │ │
│  │  - Инструмент недоступен           │ │
│  └────────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

### Иерархия разрешений

```
1. Глобальные разрешения (config.json)
   │
   ▼
2. Per-agent разрешения (agent config)
   │
   ▼
3. Per-tool разрешения (tool config)
   │
   ▼
4. Runtime разрешения (user decision)
```

### Примеры конфигурации

```json
{
  "permissions": {
    "edit": "allow",
    "bash": {
      "*": "ask",
      "npm install": "allow",
      "git push": "ask",
      "rm -rf": "deny"
    },
    "mcp_*": "ask"
  },
  "agents": {
    "plan": {
      "permissions": {
        "write": "deny",
        "edit": "deny"
      }
    }
  }
}
```

## Провайдеры AI

### Абстракция провайдера

```
┌─────────────────────────────────────────┐
│      Provider Interface                  │
│  ┌────────────────────────────────────┐ │
│  │  Common API                        │ │
│  │  - chat()                          │ │
│  │  - stream()                        │ │
│  │  - listModels()                    │ │
│  └────────────────────────────────────┘ │
└─────────────────────────────────────────┘
                 │
    ┌────────────┼────────────┐
    ▼            ▼            ▼
┌────────┐  ┌────────┐  ┌────────┐
│ OpenAI │  │Anthropic│ │ Gemini │
│Provider│  │Provider │ │Provider│
└────────┘  └────────┘  └────────┘
```

### Поддерживаемые провайдеры

1. **OpenAI** - GPT-4, GPT-5.1 Codex
2. **Anthropic** - Claude 3.7 Sonnet, Haiku
3. **GitHub Copilot** - Через GitHub token
4. **Google Gemini** - Gemini Pro, Flash
5. **AWS Bedrock** - Claude через AWS
6. **Groq** - Быстрые модели
7. **Azure OpenAI** - Enterprise OpenAI
8. **Google Cloud VertexAI** - Gemini через GCP
9. **OpenRouter** - Агрегатор моделей
10. **Local** - Self-hosted модели

### Конфигурация провайдера

```json
{
  "providers": {
    "openai": {
      "apiKey": "${OPENAI_API_KEY}",
      "disabled": false,
      "baseURL": "https://api.openai.com/v1"
    },
    "anthropic": {
      "apiKey": "${ANTHROPIC_API_KEY}",
      "disabled": false
    },
    "local": {
      "endpoint": "http://localhost:8080",
      "disabled": false
    }
  }
}
```

## Хранение данных

### Структура директорий

```
~/.local/share/opencode/
├── auth.json              # Credentials провайдеров
├── mcp-auth.json          # OAuth tokens для MCP
├── sessions/              # Данные сессий
│   ├── abc123/
│   │   ├── metadata.json
│   │   ├── messages.json
│   │   └── context.json
│   └── def456/
├── snapshots/             # Снапшоты состояния
├── cache/                 # Кэш моделей и данных
└── logs/                  # Логи

~/.config/opencode/
├── opencode.json          # Глобальная конфигурация
├── commands/              # Кастомные команды
│   ├── user:command1.md
│   └── user:command2.md
└── skills/                # Глобальные навыки
    └── skill1.md

.opencode/                 # Проектная конфигурация
├── opencode.json
├── commands/
│   └── project:command.md
└── skills/
    └── project-skill.md
```

### Формат данных

**Session Metadata**:
```json
{
  "id": "abc123",
  "title": "Add authentication",
  "created": "2026-01-18T10:00:00Z",
  "updated": "2026-01-18T11:30:00Z",
  "agent": "build",
  "model": "anthropic/claude-sonnet-4",
  "tokens_used": 15000,
  "cost": 0.45,
  "parent": null,
  "children": ["def456"]
}
```

**Messages**:
```json
{
  "messages": [
    {
      "role": "user",
      "content": "Add JWT authentication",
      "timestamp": "2026-01-18T10:00:00Z"
    },
    {
      "role": "assistant",
      "content": "I'll help you add JWT authentication...",
      "tool_calls": [
        {
          "tool": "write",
          "parameters": {
            "file_path": "src/auth.ts",
            "content": "..."
          }
        }
      ],
      "timestamp": "2026-01-18T10:01:00Z"
    }
  ]
}
```

## HTTP API

### Endpoints

```
POST   /api/sessions              # Создать сессию
GET    /api/sessions              # Список сессий
GET    /api/sessions/:id          # Получить сессию
DELETE /api/sessions/:id          # Удалить сессию

POST   /api/sessions/:id/messages # Отправить сообщение
GET    /api/sessions/:id/messages # История сообщений

POST   /api/tools/:name           # Выполнить инструмент
GET    /api/tools                 # Список инструментов

GET    /api/agents                # Список агентов
GET    /api/models                # Список моделей

GET    /api/health                # Health check
GET    /api/version               # Версия
```

### Аутентификация

HTTP Basic Auth:
```bash
curl -u opencode:password http://localhost:4096/api/sessions
```

Настройка:
```bash
export OPENCODE_SERVER_PASSWORD="password"
export OPENCODE_SERVER_USERNAME="opencode"
```

## Производительность

### Оптимизации

1. **Кэширование**
   - Кэш моделей (models.dev)
   - Кэш LSP результатов
   - Кэш MCP tool schemas

2. **Параллелизация**
   - Параллельные tool calls
   - Асинхронные MCP запросы
   - Concurrent LSP операции

3. **Streaming**
   - Streaming ответов от LLM
   - Incremental UI updates
   - Progressive tool execution

4. **Компрессия**
   - Auto compact для контекста
   - Сжатие старых сессий
   - Pruning неиспользуемых данных

### Мониторинг

```bash
# Статистика использования
opencode session stats

# Логи производительности
opencode --log-level DEBUG --print-logs

# Профилирование
OPENCODE_EXPERIMENTAL=true opencode tui
```

## Безопасность

### Меры безопасности

1. **Sandboxing**
   - Изоляция выполнения команд
   - Ограничение доступа к файлам
   - Контроль сетевых запросов

2. **Разрешения**
   - Явное подтверждение операций
   - Whitelist/blacklist команд
   - Per-tool конфигурация

3. **Аутентификация**
   - Безопасное хранение credentials
   - OAuth для MCP серверов
   - HTTP Basic Auth для API

4. **Валидация**
   - Проверка входных данных
   - Санитизация путей файлов
   - Валидация tool parameters

### Хранение секретов

```
~/.local/share/opencode/auth.json
- Права доступа: 600
- Шифрование: OS keychain (опционально)
- Переменные окружения: приоритет

~/.local/share/opencode/mcp-auth.json
- OAuth tokens
- Refresh tokens
- Автоматическое обновление
```

## Расширяемость

### Точки расширения

1. **Кастомные агенты**
   - Markdown конфигурация
   - JSON конфигурация
   - Программная регистрация

2. **Кастомные инструменты**
   - JSON определение
   - Command execution
   - Script integration

3. **MCP серверы**
   - Local stdio servers
   - Remote HTTP servers
   - OAuth integration

4. **LSP серверы**
   - Любой LSP-совместимый сервер
   - Кастомная конфигурация
   - Multiple languages

5. **Провайдеры**
   - OpenAI-compatible API
   - Custom endpoints
   - Local models

## Миграция и совместимость

### Claude Code совместимость

OpenCode - форк Claude Code, поддерживает:

```
.claude/
├── CLAUDE.md              # Читается как AGENTS.md
├── skills/                # Загружаются как OpenCode skills
└── config.json            # Мержится с OpenCode config
```

Отключение:
```bash
export OPENCODE_DISABLE_CLAUDE_CODE=true
export OPENCODE_DISABLE_CLAUDE_CODE_PROMPT=true
export OPENCODE_DISABLE_CLAUDE_CODE_SKILLS=true
```

### Конфигурация merge

Приоритет (последний переопределяет):
1. Глобальная конфигурация
2. Проектная конфигурация
3. Переменные окружения
4. CLI флаги

---

*Документация актуальна на январь 2026*
*Источники: https://opencode.ai, GitHub, DeepWiki*
