# OpenCode - Полный обзор

## Что такое OpenCode

OpenCode - это мощный AI-агент для программирования с открытым исходным кодом. Доступен как:
- Терминальный интерфейс (TUI)
- Десктопное приложение
- Расширение для IDE

**Ключевая особенность**: Поддержка 75+ AI провайдеров (альтернатива Kiro)

## Официальные ресурсы

- **Официальный сайт**: https://opencode.ai
- **Документация**: https://opencode.ai/docs/
- **GitHub**: https://github.com/opencode-ai/opencode
- **CLI документация**: https://opencode.ai/docs/cli/

## Основные возможности

### 1. Поддержка множества AI провайдеров
- OpenAI (GPT-4, GPT-5.1 Codex)
- Anthropic (Claude 3.7 Sonnet, Claude Haiku)
- GitHub Copilot
- Google Gemini
- AWS Bedrock
- Groq
- Azure OpenAI
- Google Cloud VertexAI
- OpenRouter
- Локальные модели (self-hosted)

### 2. Архитектура клиент-сервер
- Модульная архитектура
- Поддержка удаленного подключения
- API доступ через HTTP
- Headless режим

### 3. Интеграция с инструментами разработки
- **LSP (Language Server Protocol)** - интеллектуальные возможности для кода
- **MCP (Model Context Protocol)** - расширение через внешние инструменты
- **Git интеграция** - автоматизация через GitHub Actions
- **Форматтеры кода** - поддержка различных форматтеров

### 4. Система агентов
- **Primary agents** (Build, Plan) - основные агенты для взаимодействия
- **Subagents** (General, Explore) - специализированные агенты для задач
- Возможность создания кастомных агентов

### 5. Инструменты (Tools)
- Файловые операции (read, write, edit, patch)
- Поиск (grep, glob, list)
- Выполнение команд (bash)
- Веб-доступ (webfetch)
- LSP операции (определения, ссылки, hover)
- Управление задачами (todowrite, todoread)
- Загрузка навыков (skill)

## Установка

### Через install script (рекомендуется)
```bash
curl -fsSL https://opencode.ai/install.sh | sh
```

### Через Homebrew (macOS/Linux)
```bash
brew install opencode-ai/tap/opencode
```

### Через AUR (Arch Linux)
```bash
yay -S opencode
```

### Через Go
```bash
go install github.com/opencode-ai/opencode@latest
```

### Windows
Скачать бинарник с [Releases](https://github.com/opencode-ai/opencode/releases)

## Быстрый старт

### 1. Настройка провайдера
```bash
opencode
# Запустить команду /connect
# Выбрать провайдера (например, opencode для OpenCode Zen)
# Перейти на opencode.ai/auth
# Скопировать API ключ
```

### 2. Инициализация проекта
```bash
cd your-project
opencode
# Запустить команду /init
```

Это создаст файл `AGENTS.md` в корне проекта для понимания структуры.

### 3. Использование
```bash
opencode  # Запуск TUI
```

## Основные команды CLI

### Интерактивный режим
```bash
opencode                    # Запуск TUI
opencode tui                # Явный запуск TUI
opencode tui -c             # Продолжить последнюю сессию
opencode tui -s <session>   # Продолжить конкретную сессию
```

### Неинтерактивный режим
```bash
opencode run -p "Explain this code"
opencode run -p "Add logging" -f file.js
opencode run --attach http://localhost:4096 -p "Fix bug"
```

### Управление агентами
```bash
opencode agent list         # Список агентов
opencode agent create       # Создать нового агента
```

### Аутентификация
```bash
opencode auth login         # Настроить API ключи
opencode auth list          # Список провайдеров
opencode auth logout        # Выход из провайдера
```

### MCP серверы
```bash
opencode mcp add            # Добавить MCP сервер
opencode mcp list           # Список MCP серверов
opencode mcp auth           # Аутентификация OAuth
opencode mcp logout         # Удалить OAuth credentials
opencode mcp debug          # Отладка OAuth
```

### Управление сессиями
```bash
opencode session list       # Список сессий
opencode session stats      # Статистика использования
opencode session export     # Экспорт сессии
opencode session import     # Импорт сессии
```

### Модели
```bash
opencode models             # Список доступных моделей
opencode models --refresh   # Обновить кэш моделей
opencode models --verbose   # Подробная информация
```

### Серверные режимы
```bash
opencode serve              # Headless HTTP сервер
opencode web                # Сервер с веб-интерфейсом
opencode attach             # Подключиться к серверу
```

### GitHub интеграция
```bash
opencode github install     # Установить GitHub агента
opencode github run         # Запустить GitHub агента
```

### Утилиты
```bash
opencode upgrade            # Обновить OpenCode
opencode uninstall          # Удалить OpenCode
opencode --version          # Версия
```

## Горячие клавиши

### Глобальные
- `Ctrl+C` - Выход
- `Ctrl+?` или `?` - Помощь
- `Ctrl+L` - Просмотр логов
- `Ctrl+A` - Переключение сессии
- `Ctrl+K` - Диалог команд
- `Ctrl+O` - Выбор модели
- `Esc` - Закрыть диалог

### Чат
- `Ctrl+N` - Новая сессия
- `Ctrl+X` - Отменить операцию
- `i` - Фокус на редактор
- `Tab` - Переключение между агентами

### Редактор
- `Ctrl+S` или `Enter` - Отправить сообщение
- `Ctrl+E` - Открыть внешний редактор
- `Esc` - Снять фокус

## Конфигурация

### Расположение файлов
- **Глобальная конфигурация**: `~/.config/opencode/opencode.json`
- **Проектная конфигурация**: `.opencode/opencode.json`
- **Аутентификация**: `~/.local/share/opencode/auth.json`
- **Данные**: `~/.local/share/opencode/`

### Структура конфигурации
```json
{
  "$schema": "https://opencode.ai/config.json",
  "data": {
    "directory": ".opencode"
  },
  "providers": {
    "openai": {
      "apiKey": "your-api-key",
      "disabled": false
    },
    "anthropic": {
      "apiKey": "your-api-key",
      "disabled": false
    }
  },
  "agents": {
    "build": {
      "model": "anthropic/claude-sonnet-4-20250514",
      "maxTokens": 5000
    }
  },
  "shell": {
    "path": "/bin/bash",
    "args": ["-l"]
  },
  "mcpServers": {},
  "lsp": {},
  "autoCompact": true
}
```

## Переменные окружения

### Основные
- `OPENCODE_CONFIG` - Путь к конфигу
- `OPENCODE_CONFIG_DIR` - Директория конфига
- `OPENCODE_CONFIG_CONTENT` - Inline JSON конфиг
- `OPENCODE_AUTO_SHARE` - Автоматический шаринг сессий
- `OPENCODE_DISABLE_AUTOUPDATE` - Отключить автообновление
- `OPENCODE_SERVER_PASSWORD` - Пароль для serve/web
- `OPENCODE_CLIENT` - Идентификатор клиента

### API ключи провайдеров
- `ANTHROPIC_API_KEY` - Claude модели
- `OPENAI_API_KEY` - OpenAI модели
- `GEMINI_API_KEY` - Google Gemini
- `GITHUB_TOKEN` - GitHub Copilot
- `GROQ_API_KEY` - Groq модели
- `AWS_ACCESS_KEY_ID` - AWS Bedrock
- `AZURE_OPENAI_ENDPOINT` - Azure OpenAI
- `LOCAL_ENDPOINT` - Self-hosted модели

### Экспериментальные
- `OPENCODE_EXPERIMENTAL` - Включить все экспериментальные фичи
- `OPENCODE_EXPERIMENTAL_FILEWATCHER` - File watcher
- `OPENCODE_EXPERIMENTAL_LSP_TOOL` - Экспериментальный LSP tool
- `OPENCODE_EXPERIMENTAL_OUTPUT_TOKEN_MAX` - Макс токенов вывода

## Режимы работы

### Build Mode (по умолчанию)
- Полный доступ ко всем инструментам
- Может изменять файлы
- Выполнять команды
- Основной режим разработки

### Plan Mode
- Ограниченный доступ к инструментам
- Не может изменять файлы
- Только анализ и планирование
- Переключение через `Tab`

## Примеры использования

### Задать вопрос
```
Explain how authentication works in this codebase
```

### Добавить функцию
```
Add a new API endpoint for user registration with email validation
```

### Создать план
1. Переключиться в Plan mode (`Tab`)
2. Описать задачу
3. Получить план
4. Переключиться в Build mode
5. Попросить реализовать

### Отменить изменения
```
/undo  # Отменить последние изменения
/redo  # Вернуть изменения
```

### Поделиться сессией
```
/share  # Создать ссылку на сессию
```

## Кастомные команды

### Создание команды
Создать файл в `~/.config/opencode/commands/` или `.opencode/commands/`:

**Файл**: `prime-context.md`
```markdown
Analyze the current codebase and provide context about:
- Architecture patterns
- Key dependencies
- Code organization
```

### Использование
1. `Ctrl+K` - Открыть диалог команд
2. Выбрать `user:prime-context`
3. `Enter`

### Команды с аргументами
```markdown
Create a new $COMPONENT_TYPE called $NAME with the following features:
- $FEATURE_1
- $FEATURE_2
```

## Агенты

### Встроенные Primary агенты

#### Build
- Режим: primary
- Все инструменты включены
- Для полноценной разработки

#### Plan
- Режим: primary
- Ограниченные права
- Только планирование и анализ

### Встроенные Subagents

#### General
- Режим: subagent
- Исследование сложных вопросов
- Поиск кода
- Многошаговые задачи

#### Explore
- Режим: subagent
- Быстрое исследование кодовой базы
- Поиск файлов по паттернам

### Создание кастомного агента
```bash
opencode agent create
```

Или через конфигурацию:
```json
{
  "agents": {
    "code-reviewer": {
      "description": "Reviews code for best practices",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "prompt": "You are a code reviewer...",
      "tools": {
        "write": false,
        "edit": false
      }
    }
  }
}
```

### Использование агентов
- `Tab` - Переключение между primary агентами
- `@agent-name` - Вызов subagent в сообщении
- `/agent agent-name` - Переключиться на агента

## Инструменты (Tools)

### Файловые операции
- `read` - Чтение файлов
- `write` - Создание/перезапись файлов
- `edit` - Точное редактирование через замену строк
- `patch` - Применение патчей

### Поиск
- `grep` - Поиск по содержимому (regex)
- `glob` - Поиск файлов по паттерну
- `list` - Список файлов в директории

### Выполнение
- `bash` - Выполнение shell команд

### Веб
- `webfetch` - Загрузка веб-контента

### LSP (экспериментально)
- `goToDefinition` - Перейти к определению
- `findReferences` - Найти ссылки
- `hover` - Информация при наведении
- `documentSymbol` - Символы документа
- `workspaceSymbol` - Символы workspace

### Управление задачами
- `todowrite` - Создание/обновление todo списков
- `todoread` - Чтение todo списков

### Навыки
- `skill` - Загрузка SKILL.md файлов

### Интерактивность
- `question` - Задать вопрос пользователю

## MCP (Model Context Protocol)

### Что такое MCP
Стандартизированный способ интеграции внешних инструментов и сервисов.

### Типы MCP серверов

#### Локальные
```json
{
  "mcp": {
    "my-local-server": {
      "type": "local",
      "command": ["npx", "-y", "my-mcp-command"],
      "enabled": true,
      "environment": {
        "MY_VAR": "value"
      }
    }
  }
}
```

#### Удаленные
```json
{
  "mcp": {
    "my-remote-server": {
      "type": "remote",
      "url": "https://api.example.com/mcp",
      "enabled": true,
      "headers": {
        "Authorization": "Bearer token"
      }
    }
  }
}
```

### OAuth аутентификация
```bash
opencode mcp auth <server-name>  # Аутентификация
opencode mcp list                # Статус аутентификации
opencode mcp logout <server>     # Удалить credentials
opencode mcp debug <server>      # Отладка
```

### Примеры MCP серверов

#### Sentry
```json
{
  "mcp": {
    "sentry": {
      "type": "remote",
      "url": "https://mcp.sentry.io",
      "oauth": {
        "scope": "project:read issue:read"
      }
    }
  }
}
```

#### Context7
```json
{
  "mcp": {
    "context7": {
      "type": "remote",
      "url": "https://mcp.context7.com",
      "headers": {
        "Authorization": "Bearer ${CONTEXT7_API_KEY}"
      }
    }
  }
}
```

#### Grep by Vercel
```json
{
  "mcp": {
    "gh_grep": {
      "type": "remote",
      "url": "https://grep.vercel.app/mcp"
    }
  }
}
```

### Управление MCP инструментами

#### Глобальное отключение
```json
{
  "tools": {
    "mcp_sentry*": false
  }
}
```

#### Per-agent включение
```json
{
  "tools": {
    "mcp_sentry*": false
  },
  "agents": {
    "debugger": {
      "tools": {
        "mcp_sentry*": true
      }
    }
  }
}
```

## LSP (Language Server Protocol)

### Возможности
- Диагностика кода
- Определения и ссылки
- Hover информация
- Символы документа/workspace
- Call hierarchy

### Конфигурация
```json
{
  "lsp": {
    "go": {
      "disabled": false,
      "command": "gopls"
    },
    "typescript": {
      "disabled": false,
      "command": "typescript-language-server",
      "args": ["--stdio"]
    }
  }
}
```

### Использование AI
AI может использовать LSP через инструмент `diagnostics`:
- Получать ошибки компиляции
- Находить проблемы типизации
- Анализировать код

## Auto Compact

### Что это
Автоматическое сжатие контекста при приближении к лимиту модели.

### Как работает
1. Мониторинг использования контекста
2. При достижении порога - суммаризация
3. Создание новой сессии с резюме
4. Сохранение важной информации

### Настройка
```json
{
  "autoCompact": true  // включено по умолчанию
}
```

Отключить:
```bash
export OPENCODE_DISABLE_AUTOCOMPACT=true
```

## Permissions (Разрешения)

### Уровни разрешений
- `allow` - Разрешить без запроса
- `ask` - Спросить перед выполнением (по умолчанию)
- `deny` - Запретить

### Глобальные разрешения
```json
{
  "permissions": {
    "edit": "allow",
    "bash": "ask",
    "webfetch": "deny"
  }
}
```

### Per-agent разрешения
```json
{
  "agents": {
    "plan": {
      "permissions": {
        "write": "deny",
        "edit": "deny",
        "bash": "deny"
      }
    }
  }
}
```

### Разрешения для команд
```json
{
  "permissions": {
    "bash": {
      "*": "ask",
      "npm install": "allow",
      "rm -rf": "deny",
      "git push": "ask"
    }
  }
}
```

## GitHub интеграция

### Установка GitHub агента
```bash
opencode github install
```

Это создаст:
- GitHub Actions workflow
- Конфигурацию для автоматизации

### Использование
```bash
opencode github run --event pull_request --token $GITHUB_TOKEN
```

### Возможности
- Автоматический review PR
- Анализ изменений
- Комментарии к коду
- Автоматические исправления

## Серверные режимы

### Serve (Headless)
```bash
opencode serve --port 4096 --hostname localhost
```

HTTP API для программного доступа.

### Web (с интерфейсом)
```bash
opencode web --port 4096
```

Открывает браузер с веб-интерфейсом.

### Attach (подключение)
```bash
opencode attach --session <session-id>
```

Подключение к запущенному серверу.

### Безопасность
```bash
export OPENCODE_SERVER_PASSWORD="your-password"
export OPENCODE_SERVER_USERNAME="custom-user"  # по умолчанию "opencode"
```

## Статистика и аналитика

### Просмотр статистики
```bash
opencode session stats                    # Вся статистика
opencode session stats --days 7           # За последние 7 дней
opencode session stats --models 5         # Топ 5 моделей
opencode session stats --project myapp    # По проекту
```

### Экспорт/импорт сессий
```bash
opencode session export <session-id> > session.json
opencode session import session.json
opencode session import https://opencode.ai/share/abc123
```

## Навыки (Skills)

### Что такое Skills
Файлы `SKILL.md` с инструкциями и контекстом для AI.

### Расположение
- Глобальные: `~/.config/opencode/skills/`
- Проектные: `.opencode/skills/`

### Загрузка навыка
AI может загрузить навык через инструмент `skill`:
```
Load the skill for code review best practices
```

### Создание навыка
**Файл**: `.opencode/skills/testing.md`
```markdown
# Testing Guidelines

## Unit Tests
- Use Jest for JavaScript
- Aim for 80% coverage
- Mock external dependencies

## Integration Tests
- Use Supertest for API tests
- Test happy and error paths
```

## Кастомные инструменты

### Создание
```json
{
  "tools": {
    "custom": {
      "my-tool": {
        "description": "My custom tool",
        "parameters": {
          "param1": {
            "type": "string",
            "description": "First parameter"
          }
        },
        "command": "node scripts/my-tool.js {{param1}}"
      }
    }
  }
}
```

## Форматирование кода

### Настройка форматтеров
```json
{
  "formatters": {
    "javascript": {
      "command": "prettier",
      "args": ["--write"]
    },
    "python": {
      "command": "black",
      "args": ["-"]
    }
  }
}
```

## Темы и кастомизация

### Выбор темы
Настраивается через конфигурацию TUI.

### Кастомные keybinds
```json
{
  "keybinds": {
    "send_message": "ctrl+enter",
    "new_session": "ctrl+t",
    "switch_agent": "alt+tab"
  }
}
```

## Troubleshooting

### Проблемы с аутентификацией
```bash
opencode auth list          # Проверить провайдеров
opencode auth logout <provider>
opencode auth login
```

### Проблемы с MCP
```bash
opencode mcp debug <server>  # Диагностика
opencode mcp list            # Статус серверов
```

### Логи
```bash
opencode --print-logs       # Вывод логов в stderr
opencode --log-level DEBUG  # Уровень логирования
```

В TUI: `Ctrl+L` для просмотра логов

### Очистка данных
```bash
opencode uninstall --dry-run  # Посмотреть что будет удалено
opencode uninstall -c -d      # Удалить все кроме конфига и данных
```

## Лучшие практики

### 1. Используйте Plan mode для сложных задач
- Сначала получите план
- Проверьте подход
- Затем реализуйте

### 2. Создавайте специализированных агентов
- Code reviewer
- Security auditor
- Documentation writer

### 3. Настройте разрешения
- Ограничьте опасные команды
- Требуйте подтверждения для критичных операций

### 4. Используйте AGENTS.md
- Документируйте структуру проекта
- Описывайте паттерны кода
- Добавляйте контекст для AI

### 5. Организуйте кастомные команды
- Создавайте команды для частых задач
- Используйте аргументы для гибкости
- Группируйте в поддиректории

### 6. Настройте MCP серверы
- Добавляйте только нужные
- Следите за использованием контекста
- Отключайте неиспользуемые

### 7. Используйте сессии
- Экспортируйте важные сессии
- Делитесь с командой
- Анализируйте статистику

## Ограничения и предостережения

### 1. Ранняя стадия разработки
- Возможны breaking changes
- Некоторые фичи экспериментальные
- Не для production без тестирования

### 2. Контекст
- MCP серверы добавляют токены
- Следите за лимитами моделей
- Используйте auto compact

### 3. Безопасность
- Проверяйте команды перед выполнением
- Настройте разрешения
- Не храните секреты в конфиге

### 4. Стоимость
- Разные модели - разная цена
- Следите за статистикой
- Используйте max_steps для контроля

## Миграция и совместимость

### Из Claude Code
OpenCode - форк Claude Code, поэтому:
- Читает `.claude/` директорию
- Поддерживает CLAUDE.md
- Загружает .claude/skills

Отключить:
```bash
export OPENCODE_DISABLE_CLAUDE_CODE=true
```

### Конфигурация
Файлы конфигурации мержатся:
1. Глобальная конфигурация
2. Проектная конфигурация
3. Переменные окружения

Последние переопределяют предыдущие.

## Сообщество и поддержка

### Вклад в проект
1. Fork репозитория
2. Создать feature branch
3. Commit изменений
4. Push в branch
5. Открыть Pull Request

### Лицензия
MIT License

### Благодарности
- Оригинальный автор и команда Charm
- Open source сообщество
- Контрибьюторы

## Дополнительные ресурсы

- [Официальная документация](https://opencode.ai/docs/)
- [GitHub репозиторий](https://github.com/opencode-ai/opencode)
- [Примеры конфигураций](https://opencode.ai/docs/config/)
- [MCP серверы](https://opencode.ai/docs/mcp-servers)
- [Создание агентов](https://opencode.ai/docs/agents)
- [Инструменты](https://opencode.ai/docs/tools/)

---

*Документация актуальна на январь 2026*
*Источник: https://opencode.ai*
