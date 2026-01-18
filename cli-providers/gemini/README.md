# Gemini CLI Configuration

Конфигурация Gemini CLI для роли **Technical Reviewer** в пайплайне Draft Spec → Review → Final Spec.

## Установка

### 1. Копируй конфигурацию

```bash
# Из WSL/Linux
cp -r cli-providers/gemini/global/* ~/.gemini/

# Из Windows
xcopy /E /I cli-providers\gemini\global %USERPROFILE%\.gemini
```

### 2. Включи хуки и MCP

Отредактируй `~/.gemini/settings.json`:

```json
{
  "tools": { "enableHooks": true },
  "hooks": { "enabled": true },
  "general": {
    "previewFeatures": true
  }
}
```

### 3. Проверь MCP серверы

```bash
gemini
# В футере должно быть: "7 MCP servers"
```

## Структура

```
~/.gemini/
├── GEMINI.md              # Главный промпт (агент-ревьюер)
├── mcp.json               # MCP серверы (code-index, Context7, pg-aiguide и т.д.)
├── settings.json          # Настройки CLI
└── prompts/
    └── reviewer-prompt.md # One-shot промпт для ревью
```

## Использование

### Вариант 1: Интерактивный режим

```bash
cd <project>
gemini

# В чате:
> Проверь спеку из .ai/10_qwen_spec.md
```

Gemini создаст:
- `.ai/questions.md` — вопросы тебе
- `.ai/review.md` — результаты ревью
- `.ai/final-spec.md` — финальная спека

### Вариант 2: One-shot (без чата)

```bash
cd <project>
gemini -p "$(cat ~/.gemini/prompts/reviewer-prompt.md)" \
       -i .ai/10_qwen_spec.md \
       -o .ai/20_gemini_review.md
```

## Роль в пайплайне

```
Qwen (Draft Spec)
    ↓
    .ai/10_qwen_spec.md
    ↓
Gemini (Review + Questions)
    ↓
    .ai/questions.md ← ты отвечаешь
    .ai/review.md
    ↓
Gemini (Final Spec)
    ↓
    .ai/final-spec.md
    ↓
Kiro (Implementation)
    ↓
    Готовый код
```

## MCP серверы

- **code-index**: Поиск по проекту, анализ символов
- **memory**: Граф знаний для контекста
- **sequential-thinking**: Пошаговое мышление для сложных решений
- **Context7**: Документация библиотек (React, Next.js, FastAPI)
- **Ref**: GitHub/web документация
- **pg-aiguide**: PostgreSQL best practices
- **mcp-compass**: Поиск других MCP серверов

## Настройки UI

Рекомендуемые (в Settings):

- ✅ **Agent Skills**: true
- ✅ **Enable Codebase Investigator**: true
- ✅ **Preview Features**: true
- ✅ **Enable Prompt Completion**: true
- ✅ **Show Status in Title**: true
- ✅ **Show Memory Usage**: true
- ❌ **Hide Context Summary**: false (показывать контекст)
- ❌ **Hide Model Info**: false (показывать токены)

## Стиль работы

### Для пользователя
- Простым языком
- Вопросы в отдельном файле
- Подтверждение понимания: "Я правильно понял, что..."

### Внутри (для ИИ)
- Минимум токенов
- Технический язык
- Без воды

## Примеры

### Пример questions.md

```markdown
# Уточняющие вопросы

## Я правильно понял?
- [ ] Real-time уведомления для всех пользователей?
- [ ] Хранить 30 дней?

## Что непонятно
1. **Частота обновлений**: Каждую секунду или каждые 5 сек?
   - Рекомендую: каждые 5 сек

## Если не ответишь
Я выберу рекомендованные варианты.
```

### Пример review.md

```markdown
# Результаты ревью

## 🔴 Критичные проблемы
- Polling каждые 100ms убьёт сервер

## 🟡 Улучшения
- Нет rate limiting

## ✅ Что хорошо
- Правильная структура

## Альтернативы
[3 варианта]

## Рекомендация
[Гибридное решение]
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

### Хуки не работают

Проверь `settings.json`:
```json
{
  "tools": { "enableHooks": true },
  "hooks": { "enabled": true }
}
```

### Gemini не видит GEMINI.md

```bash
# Проверь наличие
ls ~/.gemini/GEMINI.md

# В футере Gemini должно быть: "1 context file"
```

## Дополнительно

- [Официальная документация](https://geminicli.com/docs/)
- [Hooks guide](https://geminicli.com/docs/hooks/)
- [MCP servers](https://geminicli.com/docs/get-started/configuration/)
