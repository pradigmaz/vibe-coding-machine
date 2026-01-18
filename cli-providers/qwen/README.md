# Qwen Code CLI Configuration

Конфигурация Qwen Code CLI для роли **Draft Spec Writer** в пайплайне Draft Spec → Review → Final Spec.

## Установка

### 1. Копируй конфигурацию

```bash
# Из WSL/Linux
cp cli-providers/qwen/global/QWEN.md ~/.qwen/

# Из Windows
copy cli-providers\qwen\global\QWEN.md %USERPROFILE%\.qwen\
```

### 2. Настрой MCP серверы

Отредактируй `~/.qwen/settings.json`:

```json
{
  "mcpServers": {
    "code-index": {
      "command": "uvx",
      "args": ["code-index-mcp"],
      "description": "Code analysis and symbol search"
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "description": "Knowledge graph for project context"
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"],
      "description": "ОБЯЗАТЕЛЬНО: Step-by-step reasoning (компенсирует отсутствие reasoning)"
    },
    "Context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp", "--api-key", "${CONTEXT7_API_KEY}"],
      "description": "Documentation search"
    },
    "Ref": {
      "url": "https://api.ref.tools/mcp",
      "headers": {
        "x-ref-api-key": "${REF_API_KEY}"
      },
      "description": "GitHub and web docs"
    },
    "pg-aiguide": {
      "url": "https://mcp.tigerdata.com/docs",
      "description": "PostgreSQL best practices"
    }
  },
  "mcp": {
    "allowed": ["code-index", "memory", "sequential-thinking", "Context7", "Ref", "pg-aiguide"],
    "excluded": []
  }
}
```

### 3. Проверь MCP серверы

```bash
qwen
# В футере должно быть: "6 MCP servers"
```

## Структура

```
~/.qwen/
├── QWEN.md                # Главный промпт (draft spec writer)
├── settings.json          # Настройки CLI + MCP серверы
└── mcp-config.json        # (опционально) дополнительная конфигурация MCP
```

## Использование

### Вариант 1: Интерактивный режим

```bash
cd <project>
qwen

# В чате:
> Создай draft спеку для системы уведомлений
```

Qwen создаст:
- `.ai/questions.md` — вопросы тебе
- `.ai/10_qwen_spec.md` — draft спецификация
- `.ai/handoff-to-gemini.md` — инструкция для передачи Gemini

### Вариант 2: One-shot (без чата)

```bash
cd <project>
qwen -p "Создай draft спеку для системы уведомлений" \
     -o .ai/10_qwen_spec.md
```

## Роль в пайплайне

```
Пользователь (требования)
    ↓
Qwen (Draft Spec + Sequential Thinking)
    ↓
    .ai/questions.md ← ты отвечаешь
    .ai/10_qwen_spec.md
    ↓
Gemini (Review + Alternatives)
    ↓
    .ai/review.md
    .ai/final-spec.md
    ↓
Kiro (Implementation)
    ↓
    Готовый код
```

## КРИТИЧНО: Sequential Thinking

**Qwen3-Coder НЕ имеет встроенного reasoning.**

Ты **ОБЯЗАН** использовать `sequential-thinking` MCP сервер перед любым анализом:

```bash
# В чате Qwen:
> Используй sequential-thinking для анализа требований к системе уведомлений
```

**Правило:** Без sequential-thinking не начинай писать спеку.

## MCP серверы

- **sequential-thinking**: **ОБЯЗАТЕЛЬНО** — компенсирует отсутствие reasoning
- **code-index**: Поиск по проекту, анализ символов
- **memory**: Граф знаний для контекста
- **Context7**: Документация библиотек (React, Next.js, FastAPI)
- **Ref**: GitHub/web документация
- **pg-aiguide**: PostgreSQL best practices

## Что НЕЛЬЗЯ

### Категорически запрещено
1. ❌ **Придумывать от себя** — только то, что в требованиях
2. ❌ **Угадывать API** — используй `Context7` для документации
3. ❌ **Пропускать sequential-thinking** — это компенсация отсутствия reasoning
4. ❌ **Писать без вопросов** — если непонятно, спроси
5. ❌ **Игнорировать существующий код** — используй `code-index`

## Стиль работы

### Для пользователя
- Простым языком
- Вопросы в отдельном файле
- Подтверждение понимания: "Я правильно понял, что..."

### Внутри (для ИИ)
- Минимум токенов
- Технический язык
- Без воды
- **ВСЕГДА sequential-thinking перед анализом**

## Примеры

### Пример questions.md

```markdown
# Уточняющие вопросы

## Я правильно понял?
- [ ] Нужна система уведомлений для всех пользователей?
- [ ] Real-time обновления?

## Что непонятно
1. **Частота обновлений**: Каждую секунду или каждые 5 сек?
   - Рекомендую: каждые 5 сек

## Подтверждение существующего кода
- [ ] Есть ли уже `NotificationService`? (я не нашёл)

## Если не ответишь
Я выберу рекомендованные варианты.
```

### Пример 10_qwen_spec.md

```markdown
# Draft Specification: Notification System

## Summary
Система уведомлений для пользователей с real-time обновлениями.

## Goals
- Показывать уведомления в реальном времени
- Хранить историю 30 дней

## Proposed Architecture
Polling каждые 5 сек (баланс UX/нагрузка).

### Альтернативы (не выбраны)
1. **WebSocket**: Сложнее поддерживать
2. **SSE**: Не поддерживается старыми браузерами

## Data Model
```sql
CREATE TABLE notifications (...)
```

## Backend
[API endpoints + структура файлов]

## Frontend
[Pages + Components]

## Open Questions
[Что осталось неясным]
```

## Troubleshooting

### MCP серверы не запускаются

```bash
# Проверь uvx
uvx --version

# Установи если нет
pip install uv
# или
brew install uv
```

### Sequential thinking не работает

Проверь `settings.json`:
```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```

### Qwen не видит QWEN.md

```bash
# Проверь наличие
ls ~/.qwen/QWEN.md

# В футере Qwen должно быть: "1 context file"
```

## Дополнительно

- [Официальная документация](https://qwenlm.github.io/qwen-code-docs/)
- [MCP Configuration](https://qwenlm.github.io/qwen-code-docs/en/users/features/mcp/)
- [Settings Reference](https://qwenlm.github.io/qwen-code-docs/en/users/configuration/settings/)
