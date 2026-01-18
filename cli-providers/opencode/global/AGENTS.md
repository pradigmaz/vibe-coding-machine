---
inclusion: always
---

# OpenCode Draft Workflow

**Цель:** Генерация чернового кода с полным контролем пользователя.

## Workflow

### 1. Orchestrator создаёт план
```
Пользователь: Добавь JWT аутентификацию

Orchestrator:
- Уточняет детали
- Создаёт TODO план в .ai/
- Делегирует project-analyzer через Task tool (если нужен анализ)
- Делегирует implementation-planner через Task tool
```

### 2. Orchestrator делегирует primary agents
```
/agent architect
# Проектирует архитектуру, создаёт спеку

/agent backend
# Генерирует код в .ai/draft-code/

/agent orchestrator
# Возвращается для координации
```

### 3. Orchestrator делегирует subagents для проверки
```
Task tool → self-reviewer: Проверь код в .ai/draft-code/
Task tool → security-auditor: Проверь на уязвимости
```

### 4. Исправления (если нужно)
```
/agent backend
# Исправляет ошибки из отчётов
```

### 5. Готово
Код в `.ai/draft-code/` готов для review в Gemini CLI (пользователь переключится сам).

## Правила для агентов

### ОБЯЗАТЕЛЬНО
- `sequential-thinking` для сложных задач (особенно GLM-4.7)
- Код в `.ai/draft-code/`, НЕ в основной проект
- Отчёты в `.ai/` для контроля
- Следуй плану из `.ai/implementation-plan.md`

### Orchestrator
- Уточняет детали ВСЕГДА
- Создаёт TODO план
- Делегирует primary agents через `/agent`
- Делегирует subagents через Task tool

### Primary agents (architect, backend, frontend, coder, debugger, reviewer)
- Orchestrator делегирует через `/agent название`
- Генерируют код в `.ai/draft-code/`
- Создают спеки/отчёты в `.ai/`

### Subagents (project-analyzer, implementation-planner, self-reviewer, и т.д.)
- Orchestrator делегирует через Task tool
- Создают child sessions, результат возвращается автоматически
- Анализируют/проверяют, не пишут код напрямую в проект

### Структура кода
- Backend: `services/`, `crud/`, `models/`, `schemas/`
- Frontend: компоненты по доменам
- Файлы до 300 строк (backend), 250 (frontend)

### Нельзя
- Писать напрямую в проект (только в `.ai/draft-code/`)
- Пропускать этап анализа для новых проектов
- Генерировать код без плана
- Применять код без self-review

## Агенты

### Primary agents (orchestrator делегирует через `/agent`)
- `orchestrator` - координатор, создаёт планы, делегирует задачи
- `architect` - проектирование архитектуры
- `backend` - backend разработка
- `frontend` - frontend разработка
- `coder` - универсальный разработчик
- `debugger` - отладка
- `reviewer` - code review (READ-ONLY)

### Subagents (orchestrator делегирует через Task tool)
- `project-analyzer` - анализ структуры проекта
- `implementation-planner` - создание плана
- `self-reviewer` - проверка сгенерированного кода
- `db-architect` - проектирование БД, индексы, SQL
- `security-auditor` - аудит безопасности, OWASP
- `test-engineer` - написание тестов, coverage
- `refactoring-specialist` - рефакторинг, паттерны
- `performance-profiler` - анализ производительности

**Важно:** Subagents создают child sessions, результат возвращается автоматически

## MCP Tools

- `sequential-thinking` - для GLM-4.7 (нет reasoning)
- `code-index` - поиск по проекту
- `Context7` - документация библиотек
- `pg-aiguide` - PostgreSQL best practices
- `shadcn` - UI компоненты

## Skills (Навыки)

Используй `skill(name="skill-name")` для загрузки best practices:

### Frontend агент
- `react-19` - React 19 patterns
- `react-best-practices` - Performance optimization
- `nextjs-app-router-patterns` - Next.js App Router
- `tailwind-4` - Tailwind CSS 4
- `typescript` - TypeScript strict patterns
- `frontend-design` - UI/UX patterns

### Backend агент
- `async-python-patterns` - Async Python
- `dotnet-backend-patterns` - .NET patterns
- `postgresql-table-design` - Database design
- `auth-implementation-patterns` - Authentication
- `error-handling-patterns` - Error handling
- `microservices-patterns` - Microservices

### Architect агент
- `architecture-patterns` - Architecture patterns
- `designing-architecture` - System design
- `designing-apis` - API design
- `microservices-patterns` - Microservices

### Reviewer агент
- `code-review-excellence` - Code review
- `security-compliance` - Security audit
- `code-standards` - Code standards

### Debugger агент
- `debugging-strategies` - Debugging
- `error-resolver` - Error resolution

### Все агенты
- `analyzing-projects` - Project analysis
- `managing-git` - Git workflows
- `file-sizes` - File size limits
