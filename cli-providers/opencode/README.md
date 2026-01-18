# OpenCode CLI Configuration

Конфигурация OpenCode CLI для генерации **чернового кода** в пайплайне:

```
Qwen (Draft Spec) → OpenCode (Draft Code) → Gemini (Review) → Kiro (Production)
```

---

## Установка

### 1. Установи OpenCode

```bash
# npm
npm i -g opencode-ai

# curl
curl -fsSL https://opencode.ai/install | bash
```

### 2. Копируй конфигурацию

```bash
# Linux/macOS
cp -r cli-providers/opencode/global/* ~/.config/opencode/

# Windows
xcopy /E /I cli-providers\opencode\global %USERPROFILE%\.config\opencode
```

### 3. Проверь конфигурацию

```bash
opencode
# Должны быть доступны бесплатные модели:
# - GLM-4.7
# - MiniMax M2.1
# - Grok Code Fast 1
```

---

## Структура

```
~/.config/opencode/
├── opencode.json          # Главный конфиг
├── AGENTS.md              # Правила для всех агентов
└── agents/
    ├── orchestrator.md    # Координатор (MiniMax M2.1)
    ├── architect.md       # Архитектор (MiniMax M2.1)
    ├── backend.md         # Backend (GLM-4.7)
    ├── frontend.md        # Frontend (GLM-4.7)
    ├── coder.md           # Универсальный (GLM-4.7)
    ├── reviewer.md        # Reviewer (MiniMax M2.1)
    └── debugger.md        # Debugger (GLM-4.7)
```

---

## Бесплатные модели

### GLM-4.7 (основная работа)
- Backend разработка
- Frontend разработка
- Универсальный код
- Отладка

### MiniMax M2.1 (планирование/ревью)
- Orchestrator (координация)
- Architect (проектирование)
- Reviewer (code review)

### Grok Code Fast 1 (быстрые задачи)
- Генерация заголовков
- Простые операции

---

## Использование

### Вариант 1: Через Orchestrator

```bash
cd <project>
opencode

# В чате:
> /agent orchestrator
> Реализуй систему уведомлений из .ai/final-spec.md
```

Orchestrator:
1. Создаст TODO план
2. Делегирует backend агенту
3. Делегирует frontend агенту
4. Делегирует reviewer агенту

### Вариант 2: Напрямую к агенту

```bash
opencode

# Backend код
> /agent backend
> Реализуй API для уведомлений из спеки

# Frontend код
> /agent frontend
> Создай UI для уведомлений

# Review
> /agent reviewer
> Проверь код в .ai/draft-code/
```

### Вариант 3: Команды

```bash
# Draft спека
opencode /spec "система уведомлений"

# Реализация
opencode /implement

# Review
opencode /review backend/

# Debug
opencode /debug "TypeError в NotificationList"
```

---

## Workflow

### Полный пайплайн

```
1. Qwen Code (Draft Spec)
   qwen
   > Создай draft спеку для системы уведомлений
   → .ai/10_qwen_spec.md

2. Gemini (Review Spec)
   gemini
   > Проверь спеку из .ai/10_qwen_spec.md
   → .ai/review.md
   → .ai/final-spec.md

3. OpenCode (Draft Code)
   opencode
   > /agent orchestrator
   > Реализуй из .ai/final-spec.md
   
   Orchestrator делегирует:
   → /agent backend → .ai/draft-code/backend/
   → /agent frontend → .ai/draft-code/frontend/
   → /agent reviewer → .ai/review-report.md

4. Gemini (Review Code)
   gemini
   > Проверь код из .ai/draft-code/
   → .ai/code-review.md

5. Kiro (Production Code)
   kiro agent orchestrator
   > Финализируй код из .ai/draft-code/ с учётом .ai/code-review.md
   → Готовый production код
```

---

## Агенты

### orchestrator (MiniMax M2.1)
**Роль:** Координатор задач

**Использование:**
```
/agent orchestrator
Реализуй систему уведомлений
```

**Что делает:**
1. Задаёт уточняющие вопросы
2. Создаёт TODO план
3. Делегирует другим агентам
4. Отчитывается о результатах

### architect (MiniMax M2.1)
**Роль:** Проектирование архитектуры

**Использование:**
```
/agent architect
Спроектируй систему уведомлений
```

**Что делает:**
1. Анализирует требования (sequential-thinking)
2. Предлагает альтернативы
3. Создаёт спецификацию в `.ai/10_opencode_spec.md`

### backend (GLM-4.7)
**Роль:** Backend разработка

**Использование:**
```
/agent backend
Реализуй API для уведомлений
```

**Что делает:**
1. Генерирует черновой backend код
2. Создаёт файлы в `.ai/draft-code/backend/`
3. Использует sequential-thinking для сложных задач

### frontend (GLM-4.7)
**Роль:** Frontend разработка

**Использование:**
```
/agent frontend
Создай UI для уведомлений
```

**Что делает:**
1. Генерирует черновой UI код
2. Использует shadcn/ui компоненты
3. Создаёт файлы в `.ai/draft-code/frontend/`

### coder (GLM-4.7)
**Роль:** Универсальный разработчик

**Использование:**
```
/agent coder
Реализуй функцию для отправки email
```

**Что делает:**
1. Пишет код на любом языке/стеке
2. Определяет стек автоматически
3. Генерирует черновой код

### reviewer (MiniMax M2.1)
**Роль:** Code review (READ-ONLY)

**Использование:**
```
/agent reviewer
Проверь код в .ai/draft-code/
```

**Что делает:**
1. Анализирует черновой код
2. Находит критичные ошибки
3. Создаёт отчёт в `.ai/review-report.md`

### debugger (GLM-4.7)
**Роль:** Отладка

**Использование:**
```
/agent debugger
Исправь TypeError в NotificationList
```

**Что делает:**
1. Анализирует ошибки (sequential-thinking)
2. Находит root cause
3. Предлагает фиксы

---

## MCP Серверы

### ОБЯЗАТЕЛЬНО используй
- `sequential-thinking` — для GLM-4.7 (нет reasoning)
- `code-index` — поиск по проекту
- `Context7` — документация библиотек
- `pg-aiguide` — PostgreSQL best practices

### Дополнительно
- `memory` — граф знаний
- `refactor-mcp` — массовые изменения
- `shadcn` — UI компоненты
- `Ref` — GitHub/web документация

---

## Команды

### /spec <описание>
Создаёт draft спецификацию

```bash
opencode /spec "система уведомлений"
```

Создаёт:
- `.ai/questions.md` — вопросы пользователю
- `.ai/10_opencode_spec.md` — draft спека

### /implement
Реализует спецификацию

```bash
opencode /implement
```

Читает `.ai/final-spec.md` и генерирует код в `.ai/draft-code/`

### /review <путь>
Проверяет код

```bash
opencode /review .ai/draft-code/
```

Создаёт `.ai/review-report.md`

### /debug <описание>
Отлаживает ошибку

```bash
opencode /debug "TypeError в NotificationList"
```

Создаёт `.ai/debug-fix.md`

---

## Примеры

### Пример 1: Простая задача

```bash
opencode

> /agent coder
> Добавь endpoint GET /api/health для health check

# GLM-4.7 генерирует код
# Создаёт .ai/draft-code/backend/routes/health.py
```

### Пример 2: Сложная фича

```bash
opencode

> /agent orchestrator
> Реализуй систему уведомлений из .ai/final-spec.md

# Orchestrator создаёт план:
# TODO:
# - [ ] 1. Backend API
# - [ ] 2. Frontend UI
# - [ ] 3. Code review

# Делегирует:
# /agent backend → генерирует API
# /agent frontend → генерирует UI
# /agent reviewer → проверяет код
```

### Пример 3: Отладка

```bash
opencode

> /agent debugger
> TypeError: Cannot read property 'id' of undefined
> File: components/NotificationList.tsx:15

# Debugger:
# 1. Использует sequential-thinking
# 2. Находит root cause
# 3. Предлагает фикс в .ai/debug-fix.md
```

---

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

Проверь `opencode.json`:
```json
{
  "mcp": {
    "sequential-thinking": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-sequential-thinking"],
      "enabled": true
    }
  }
}
```

### Агенты не переключаются

Используй команду `/agent название`:
```
/agent backend
/agent frontend
/agent orchestrator
```

---

## Дополнительно

- [Официальная документация](https://opencode.ai/docs/)
- [MCP Configuration](https://dev.opencode.ai/docs/mcp-servers/)
- [Agent Configuration](https://opencode.ai/docs/config/)
