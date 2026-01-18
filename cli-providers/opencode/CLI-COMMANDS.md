# OpenCode CLI - Справочник команд

Полный справочник всех команд командной строки OpenCode CLI.

## Основные команды

### `opencode` (без аргументов)
Запускает TUI (Terminal User Interface) по умолчанию.

```bash
opencode
```

---

## tui - Терминальный интерфейс

Запуск терминального пользовательского интерфейса OpenCode.

```bash
opencode tui [flags]
```

### Флаги

| Флаг | Короткий | Описание |
|------|----------|----------|
| `--continue` | `-c` | Продолжить последнюю сессию |
| `--session` | `-s` | ID сессии для продолжения |
| `--prompt` | | Промпт для использования |
| `--model` | `-m` | Модель в формате provider/model |
| `--agent` | | Агент для использования |
| `--port` | | Порт для прослушивания |
| `--hostname` | | Hostname для прослушивания |

### Примеры

```bash
# Запуск TUI
opencode tui

# Продолжить последнюю сессию
opencode tui -c

# Продолжить конкретную сессию
opencode tui -s abc123

# Запуск с конкретной моделью
opencode tui -m anthropic/claude-sonnet-4

# Запуск с конкретным агентом
opencode tui --agent code-reviewer
```

---

## agent - Управление агентами

Управление агентами для OpenCode.

```bash
opencode agent <command>
```

### Подкоманды

#### `create` - Создать агента
Создать нового агента с кастомной конфигурацией.

```bash
opencode agent create
```

Интерактивный процесс:
1. Выбор расположения (global/project)
2. Описание агента
3. Генерация system prompt
4. Выбор доступных инструментов
5. Создание markdown файла

#### `list` - Список агентов
Показать всех доступных агентов.

```bash
opencode agent list
```

---

## attach - Подключение к серверу

Подключить терминал к уже запущенному OpenCode backend серверу.

```bash
opencode attach [flags]
```

### Флаги

| Флаг | Короткий | Описание |
|------|----------|----------|
| `--dir` | | Рабочая директория для TUI |
| `--session` | `-s` | ID сессии для продолжения |

### Примеры

```bash
# Подключиться к локальному серверу
opencode attach

# Подключиться с конкретной директорией
opencode attach --dir /path/to/project

# Продолжить сессию
opencode attach -s abc123
```

---

## auth - Управление аутентификацией

Управление credentials и login для провайдеров.

```bash
opencode auth <command>
```

### Подкоманды

#### `login` - Вход
Настроить API ключи для провайдеров.

```bash
opencode auth login
```

Credentials сохраняются в `~/.local/share/opencode/auth.json`.

OpenCode загружает провайдеров из:
- Файла credentials
- Переменных окружения
- `.env` файла в проекте

#### `list` - Список провайдеров
Показать всех аутентифицированных провайдеров.

```bash
opencode auth list
# или короткая версия
opencode auth ls
```

#### `logout` - Выход
Выйти из провайдера, удалив его из credentials файла.

```bash
opencode auth logout <provider>
```

### Примеры

```bash
# Настроить провайдера
opencode auth login

# Посмотреть список
opencode auth list

# Выйти из OpenAI
opencode auth logout openai
```

---

## github - GitHub интеграция

Управление GitHub агентом для автоматизации репозитория.

```bash
opencode github <command>
```

### Подкоманды

#### `install` - Установка
Установить GitHub агента в репозиторий.

```bash
opencode github install
```

Настраивает:
- GitHub Actions workflow
- Конфигурацию агента

#### `run` - Запуск
Запустить GitHub агента (обычно в GitHub Actions).

```bash
opencode github run [flags]
```

### Флаги

| Флаг | Описание |
|------|----------|
| `--event` | GitHub mock event для запуска |
| `--token` | GitHub personal access token |

### Примеры

```bash
# Установить агента
opencode github install

# Запустить с mock event
opencode github run --event pull_request --token $GITHUB_TOKEN
```

---

## mcp - Model Context Protocol

Управление MCP серверами.

```bash
opencode mcp <command>
```

### Подкоманды

#### `add` - Добавить сервер
Добавить MCP сервер в конфигурацию.

```bash
opencode mcp add
```

Интерактивный процесс выбора локального или удаленного сервера.

#### `list` - Список серверов
Показать все настроенные MCP серверы и их статус подключения.

```bash
opencode mcp list
# или короткая версия
opencode mcp ls
```

#### `auth` - OAuth аутентификация
Аутентифицироваться с OAuth-enabled MCP сервером.

```bash
opencode mcp auth [server-name]
```

Без имени сервера - выбор из доступных OAuth-capable серверов.

Показать OAuth-capable серверы и статус:
```bash
opencode mcp auth --list
# или короткая версия
opencode mcp auth -l
```

#### `logout` - Удалить credentials
Удалить OAuth credentials для MCP сервера.

```bash
opencode mcp logout <server-name>
```

#### `debug` - Отладка
Отладка OAuth проблем подключения.

```bash
opencode mcp debug <server-name>
```

Показывает:
- Текущий статус аутентификации
- Тест HTTP подключения
- Попытка OAuth discovery flow

### Примеры

```bash
# Добавить MCP сервер
opencode mcp add

# Список серверов
opencode mcp list

# Аутентификация с Sentry
opencode mcp auth sentry

# Список OAuth серверов
opencode mcp auth --list

# Выйти из сервера
opencode mcp logout sentry

# Отладка подключения
opencode mcp debug sentry
```

---

## models - Список моделей

Показать все доступные модели от настроенных провайдеров.

```bash
opencode models [provider] [flags]
```

### Флаги

| Флаг | Описание |
|------|----------|
| `--refresh` | Обновить кэш моделей с models.dev |
| `--verbose` | Подробный вывод (включая метаданные и стоимость) |

### Примеры

```bash
# Все модели
opencode models

# Модели конкретного провайдера
opencode models anthropic

# Обновить кэш
opencode models --refresh

# Подробная информация
opencode models --verbose

# Модели OpenAI с обновлением
opencode models openai --refresh
```

Формат вывода: `provider/model`

Полезно для определения точного имени модели для конфигурации.

---

## run - Неинтерактивный режим

Запустить OpenCode в неинтерактивном режиме с прямым промптом.

```bash
opencode run [flags]
```

### Флаги

| Флаг | Короткий | Описание |
|------|----------|----------|
| `--command` | | Команда для выполнения (message для args) |
| `--continue` | `-c` | Продолжить последнюю сессию |
| `--session` | `-s` | ID сессии для продолжения |
| `--share` | | Поделиться сессией |
| `--model` | `-m` | Модель в формате provider/model |
| `--agent` | | Агент для использования |
| `--file` | `-f` | Файл(ы) для прикрепления к сообщению |
| `--format` | | Формат: default (форматированный) или json (raw JSON events) |
| `--title` | | Заголовок сессии |
| `--attach` | | Подключиться к запущенному серверу |
| `--port` | | Порт для локального сервера |

### Примеры

```bash
# Простой промпт
opencode run -p "Explain this code"

# С файлом
opencode run -p "Review this file" -f src/app.js

# Подключение к серверу (избежать cold boot MCP)
opencode run --attach http://localhost:4096 -p "Fix bug"

# С конкретной моделью
opencode run -m anthropic/claude-sonnet-4 -p "Add tests"

# JSON формат вывода
opencode run -p "Analyze code" --format json

# С заголовком сессии
opencode run -p "Refactor auth" --title "Auth Refactoring"

# Продолжить сессию
opencode run -c -p "Continue previous task"
```

Все разрешения автоматически одобряются в этом режиме.

---

## serve - Headless сервер

Запустить headless OpenCode сервер для API доступа.

```bash
opencode serve [flags]
```

### Флаги

| Флаг | Описание |
|------|----------|
| `--port` | Порт для прослушивания |
| `--hostname` | Hostname для прослушивания |
| `--mdns` | Включить mDNS discovery |
| `--cors` | Дополнительные browser origin(s) для CORS |

### Безопасность

Установить `OPENCODE_SERVER_PASSWORD` для включения HTTP basic auth:
```bash
export OPENCODE_SERVER_PASSWORD="your-password"
export OPENCODE_SERVER_USERNAME="custom-user"  # по умолчанию "opencode"
```

### Примеры

```bash
# Запуск на порту 4096
opencode serve --port 4096

# С hostname
opencode serve --port 4096 --hostname 0.0.0.0

# С mDNS
opencode serve --mdns

# С CORS
opencode serve --cors "https://example.com"

# С аутентификацией
OPENCODE_SERVER_PASSWORD="secret" opencode serve --port 4096
```

Полный HTTP интерфейс доступен в [server docs](https://opencode.ai/docs/server).

---

## session - Управление сессиями

Управление OpenCode сессиями.

```bash
opencode session <command>
```

### Подкоманды

#### `list` - Список сессий
Показать все OpenCode сессии.

```bash
opencode session list [flags]
```

**Флаги:**

| Флаг | Короткий | Описание |
|------|----------|----------|
| `--max-count` | `-n` | Ограничить N последними сессиями |
| `--format` | | Формат вывода: table или json (по умолчанию table) |

**Примеры:**
```bash
# Все сессии
opencode session list

# Последние 10
opencode session list -n 10

# JSON формат
opencode session list --format json
```

#### `stats` - Статистика
Показать статистику использования токенов и стоимости.

```bash
opencode session stats [flags]
```

**Флаги:**

| Флаг | Описание |
|------|----------|
| `--days` | Показать статистику за последние N дней (по умолчанию все время) |
| `--tools` | Количество инструментов для показа (по умолчанию все) |
| `--models` | Показать разбивку по моделям (скрыто по умолчанию). Число для топ N |
| `--project` | Фильтр по проекту (все проекты, пустая строка: текущий проект) |

**Примеры:**
```bash
# Вся статистика
opencode session stats

# За последние 7 дней
opencode session stats --days 7

# Топ 5 инструментов
opencode session stats --tools 5

# С разбивкой по моделям (топ 3)
opencode session stats --models 3

# Для конкретного проекта
opencode session stats --project myapp

# Текущий проект за неделю
opencode session stats --days 7 --project ""
```

#### `export` - Экспорт сессии
Экспортировать данные сессии как JSON.

```bash
opencode session export [session-id]
```

Без ID - интерактивный выбор из доступных сессий.

**Примеры:**
```bash
# Экспорт конкретной сессии
opencode session export abc123 > session.json

# Интерактивный выбор
opencode session export
```

#### `import` - Импорт сессии
Импортировать данные сессии из JSON файла или OpenCode share URL.

```bash
opencode session import <file-or-url>
```

**Примеры:**
```bash
# Из локального файла
opencode session import session.json

# Из share URL
opencode session import https://opencode.ai/share/abc123
```

---

## web - Веб-интерфейс

Запустить headless OpenCode сервер с веб-интерфейсом.

```bash
opencode web [flags]
```

### Флаги

| Флаг | Описание |
|------|----------|
| `--port` | Порт для прослушивания |
| `--hostname` | Hostname для прослушивания |
| `--mdns` | Включить mDNS discovery |
| `--cors` | Дополнительные browser origin(s) для CORS |

### Безопасность

Установить `OPENCODE_SERVER_PASSWORD` для включения HTTP basic auth:
```bash
export OPENCODE_SERVER_PASSWORD="your-password"
export OPENCODE_SERVER_USERNAME="custom-user"  # по умолчанию "opencode"
```

### Примеры

```bash
# Запуск веб-интерфейса
opencode web

# На конкретном порту
opencode web --port 8080

# С аутентификацией
OPENCODE_SERVER_PASSWORD="secret" opencode web --port 8080
```

Автоматически открывает браузер с веб-интерфейсом.

---

## acp - Agent Client Protocol

Запустить ACP (Agent Client Protocol) сервер.

```bash
opencode acp [flags]
```

### Флаги

| Флаг | Описание |
|------|----------|
| `--cwd` | Рабочая директория |
| `--port` | Порт для прослушивания |
| `--hostname` | Hostname для прослушивания |

### Примеры

```bash
# Запуск ACP сервера
opencode acp

# С конкретной директорией
opencode acp --cwd /path/to/project

# На конкретном порту
opencode acp --port 5000
```

Коммуникация через stdin/stdout используя nd-JSON.

---

## uninstall - Удаление

Удалить OpenCode и все связанные файлы.

```bash
opencode uninstall [flags]
```

### Флаги

| Флаг | Короткий | Описание |
|------|----------|----------|
| `--keep-config` | `-c` | Сохранить конфигурационные файлы |
| `--keep-data` | `-d` | Сохранить данные сессий и снапшоты |
| `--dry-run` | | Показать что будет удалено без удаления |
| `--force` | `-f` | Пропустить подтверждения |

### Примеры

```bash
# Посмотреть что будет удалено
opencode uninstall --dry-run

# Удалить все
opencode uninstall

# Сохранить конфиг и данные
opencode uninstall -c -d

# Без подтверждений
opencode uninstall -f
```

---

## upgrade - Обновление

Обновить OpenCode до последней или конкретной версии.

```bash
opencode upgrade [version] [flags]
```

### Флаги

| Флаг | Короткий | Описание |
|------|----------|----------|
| `--method` | `-m` | Метод установки: curl, npm, pnpm, bun, brew |

### Примеры

```bash
# До последней версии
opencode upgrade

# До конкретной версии
opencode upgrade v1.2.3

# С указанием метода
opencode upgrade --method brew

# Конкретная версия через npm
opencode upgrade v1.2.3 --method npm
```

---

## Глобальные флаги

Эти флаги работают со всеми командами OpenCode CLI.

| Флаг | Короткий | Описание |
|------|----------|----------|
| `--help` | `-h` | Показать помощь |
| `--version` | `-v` | Показать версию |
| `--print-logs` | | Выводить логи в stderr |
| `--log-level` | | Уровень логирования (DEBUG, INFO, WARN, ERROR) |

### Примеры

```bash
# Помощь по команде
opencode tui --help

# Версия
opencode --version

# С логами
opencode tui --print-logs

# С уровнем логирования
opencode tui --log-level DEBUG
```

---

## Переменные окружения

OpenCode можно настроить через переменные окружения.

### Основные

| Переменная | Тип | Описание |
|------------|-----|----------|
| `OPENCODE_AUTO_SHARE` | boolean | Автоматически делиться сессиями |
| `OPENCODE_GIT_BASH_PATH` | string | Путь к Git Bash на Windows |
| `OPENCODE_CONFIG` | string | Путь к конфиг файлу |
| `OPENCODE_CONFIG_DIR` | string | Путь к директории конфига |
| `OPENCODE_CONFIG_CONTENT` | string | Inline json конфиг |
| `OPENCODE_DISABLE_AUTOUPDATE` | boolean | Отключить автообновление |
| `OPENCODE_DISABLE_PRUNE` | boolean | Отключить очистку старых данных |
| `OPENCODE_DISABLE_TERMINAL_TITLE` | boolean | Отключить обновление заголовка терминала |
| `OPENCODE_PERMISSION` | string | Inline json конфиг разрешений |
| `OPENCODE_DISABLE_DEFAULT_PLUGINS` | boolean | Отключить плагины по умолчанию |
| `OPENCODE_DISABLE_LSP_DOWNLOAD` | boolean | Отключить автозагрузку LSP серверов |
| `OPENCODE_ENABLE_EXPERIMENTAL_MODELS` | boolean | Включить экспериментальные модели |
| `OPENCODE_DISABLE_AUTOCOMPACT` | boolean | Отключить автосжатие контекста |
| `OPENCODE_DISABLE_CLAUDE_CODE` | boolean | Отключить чтение из .claude |
| `OPENCODE_DISABLE_CLAUDE_CODE_PROMPT` | boolean | Отключить чтение ~/.claude/CLAUDE.md |
| `OPENCODE_DISABLE_CLAUDE_CODE_SKILLS` | boolean | Отключить загрузку .claude/skills |
| `OPENCODE_CLIENT` | string | Идентификатор клиента (по умолчанию cli) |
| `OPENCODE_ENABLE_EXA` | boolean | Включить Exa web search tools |
| `OPENCODE_SERVER_PASSWORD` | string | Включить basic auth для serve/web |
| `OPENCODE_SERVER_USERNAME` | string | Переопределить username для basic auth |

### Экспериментальные

| Переменная | Тип | Описание |
|------------|-----|----------|
| `OPENCODE_EXPERIMENTAL` | boolean | Включить все экспериментальные фичи |
| `OPENCODE_EXPERIMENTAL_ICON_DISCOVERY` | boolean | Включить icon discovery |
| `OPENCODE_EXPERIMENTAL_DISABLE_COPY_ON_SELECT` | boolean | Отключить copy on select в TUI |
| `OPENCODE_EXPERIMENTAL_BASH_MAX_OUTPUT_LENGTH` | number | Макс длина вывода bash команд |
| `OPENCODE_EXPERIMENTAL_BASH_DEFAULT_TIMEOUT_MS` | number | Таймаут по умолчанию для bash в мс |
| `OPENCODE_EXPERIMENTAL_OUTPUT_TOKEN_MAX` | number | Макс токенов вывода для LLM |
| `OPENCODE_EXPERIMENTAL_FILEWATCHER` | boolean | Включить file watcher для всей директории |
| `OPENCODE_EXPERIMENTAL_OXFMT` | boolean | Включить oxfmt форматтер |
| `OPENCODE_EXPERIMENTAL_LSP_TOOL` | boolean | Включить экспериментальный LSP tool |

### Примеры использования

```bash
# Отключить автообновление
export OPENCODE_DISABLE_AUTOUPDATE=true

# Кастомный конфиг
export OPENCODE_CONFIG="/path/to/config.json"

# Inline конфиг
export OPENCODE_CONFIG_CONTENT='{"autoCompact": false}'

# Включить экспериментальные фичи
export OPENCODE_EXPERIMENTAL=true

# Настроить сервер с паролем
export OPENCODE_SERVER_PASSWORD="secret"
export OPENCODE_SERVER_USERNAME="admin"

# Уровень логирования
opencode tui --log-level DEBUG

# Отключить Claude Code интеграцию
export OPENCODE_DISABLE_CLAUDE_CODE=true
```

---

## Быстрые команды

### Частые сценарии

```bash
# Быстрый старт
opencode

# Продолжить работу
opencode tui -c

# Быстрый вопрос
opencode run -p "How does auth work?"

# Код ревью
opencode run -p "Review this PR" -f changes.diff

# Статистика
opencode session stats --days 7

# Список моделей
opencode models --verbose

# Настройка провайдера
opencode auth login

# Создать агента
opencode agent create

# Добавить MCP
opencode mcp add

# Запустить сервер
opencode serve --port 4096

# Веб-интерфейс
opencode web

# Обновление
opencode upgrade
```

---

*Документация актуальна на январь 2026*
*Источник: https://opencode.ai/docs/cli/*
