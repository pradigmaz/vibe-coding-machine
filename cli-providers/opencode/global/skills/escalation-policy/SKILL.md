---
name: escalation-policy
description: Политика эскалации задач между агентами. Определяет, когда агент должен передать задачу другому агенту или...
---
# Escalation Policy Skill

## Назначение

Политика эскалации задач между агентами. Определяет, когда агент должен передать задачу другому агенту или субагенту.

## Принципы эскалации

### 1. Эскалация по сложности

**gemini-3-flash-preview → gemini-3-pro-preview** когда:
- Задача требует глубокого анализа (> 5 файлов)
- Нужна оптимизация производительности
- Сложный рефакторинг архитектуры
- Поиск неочевидных уязвимостей
- Code review критичного кода

```
Пример:
gemini-3-flash-preview: "Эта задача требует анализа 15 файлов и оптимизации алгоритма.
         Эскалирую в backend-architect для глубокого анализа."
```

### 2. Эскалация по специализации

**Generic Agent → Specialized Subagent** когда:
- Нужна экспертиза в конкретной области
- Задача требует специфических знаний
- Есть готовый субагент для этой задачи

```
Backend Agent → backend-architect:
  - Проектирование новой архитектуры
  - Выбор паттернов проектирования
  - Дизайн API

Frontend Agent → typescript-types-specialist:
  - Сложные TypeScript типы
  - Advanced React patterns
  - Performance optimization

Reviewer → code-reviewer:
  - Глубокий code review
  - Архитектурный анализ
  - Security audit
```

### 3. Эскалация по типу задачи

**Orchestrator** делегирует:
```
Orchestrator
  ├─→ Architect (проектирование)
  ├─→ Backend (API, services, database)
  ├─→ Frontend (UI, components)
  ├─→ QA (тестирование)
  ├─→ Reviewer (code review)
  └─→ Debugger (исправление багов)
```

## Матрица эскалации

| Задача | Агент | Субагент | Модель |
|--------|-------|----------|--------|
| Простой CRUD | Backend | - | gemini-3-flash-preview |
| Сложная архитектура | Backend | backend-architect | gemini-3-flash-preview |
| Оптимизация алгоритма | Backend | backend-architect | gemini-3-pro-preview |
| Простой компонент | Frontend | - | gemini-3-flash-preview |
| Advanced TypeScript | Frontend | typescript-types-specialist | gemini-3-flash-preview |
| Performance React | Frontend | backend-architect | gemini-3-pro-preview |
| Code review | Reviewer | code-reviewer | gemini-3-pro-preview |
| Security audit | Reviewer | security-auditor | gpt-5.2-codex |
| Рефакторинг | Any | code-structure-refactorer | gemini-3-flash-preview |
| Поиск багов | Debugger | debugger | gemini-3-flash-preview |

## Когда НЕ эскалировать

❌ **Не эскалируй если**:
- Задача простая и понятная
- У тебя есть все необходимые инструменты
- Задача в твоей зоне ответственности
- Эскалация займёт больше времени, чем решение

✅ **Эскалируй если**:
- Задача выходит за рамки твоей экспертизы
- Нужны специфические инструменты
- Требуется более мощная модель (gemini-3-pro-preview)
- Задача критична и нужен expert review

## Примеры эскалации

### Пример 1: Backend → Backend Architect

**Задача**: Спроектировать микросервисную архитектуру для e-commerce

**Решение**:
```
Backend Agent: "Эта задача требует архитектурного проектирования.
                Эскалирую в backend-architect для дизайна системы."

Backend Architect: 
  1. Анализирует требования
  2. Проектирует сервисы (User, Product, Order, Payment)
  3. Определяет коммуникацию (REST, gRPC, Events)
  4. Возвращает архитектурный план

Backend Agent: Реализует спроектированную архитектуру
```

### Пример 2: Frontend → Optimization Expert gemini-3-pro-preview

**Задача**: Оптимизировать React приложение с медленным рендерингом

**Решение**:
```
Frontend Agent: "Приложение тормозит, нужна глубокая оптимизация.
                 Эскалирую в backend-architect."

Optimization Expert gemini-3-pro-preview:
  1. Профилирует приложение
  2. Находит bottlenecks (N+1 renders, heavy computations)
  3. Применяет оптимизации (React.memo, useMemo, virtualization)
  4. Измеряет улучшения (было 5s → стало 200ms)

Frontend Agent: Применяет рекомендации
```

### Пример 3: Reviewer → Vulnerability Hunter gemini-3-pro-preview

**Задача**: Security audit перед релизом

**Решение**:
```
Reviewer: "Нужен глубокий security audit.
           Эскалирую в security-auditor."

Vulnerability Hunter gemini-3-pro-preview:
  1. Сканирует на OWASP Top 10
  2. Проверяет SQL injection, XSS, CSRF
  3. Анализирует authentication/authorization
  4. Проверяет зависимости (npm audit, Snyk)
  5. Возвращает отчёт с приоритетами

Reviewer: Создаёт issues для найденных проблем
```

## Workflow эскалации

```
1. Агент получает задачу
   ↓
2. Анализирует сложность и тип
   ↓
3. Решение:
   ├─→ Простая задача → Выполняет сам
   └─→ Сложная/специфичная → Эскалирует
       ↓
4. Выбирает правильного субагента/агента
   ↓
5. Передаёт контекст и требования
   ↓
6. Получает результат
   ↓
7. Интегрирует в общее решение
```

## Коммуникация при эскалации

### Хорошая эскалация
```
"Задача требует проектирования микросервисной архитектуры для 
e-commerce платформы с 5 сервисами (User, Product, Order, Payment, 
Notification). Нужно определить границы сервисов, API контракты и 
способы коммуникации. Эскалирую в backend-architect."
```

### Плохая эскалация
```
"Сделай архитектуру."
```

**Что включать**:
- Описание задачи
- Контекст (что уже сделано)
- Требования
- Ограничения
- Ожидаемый результат

## Метрики эскалации

Отслеживай:
- **Частота эскалации**: Не должна быть > 30% задач
- **Успешность**: Эскалация решила проблему?
- **Время**: Эскалация ускорила или замедлила?

## Anti-patterns

❌ **Избыточная эскалация**
```
Backend: "Нужно создать простой GET endpoint. Эскалирую в backend-architect."
```
Решение: Простые задачи делай сам.

❌ **Эскалация без контекста**
```
Frontend: "Сделай компонент."
```
Решение: Передавай полный контекст.

❌ **Циклическая эскалация**
```
Backend → Frontend → Backend → Frontend
```
Решение: Orchestrator должен координировать.

❌ **Эскалация вместо обучения**
```
Backend: "Не знаю как сделать JOIN. Эскалирую."
```
Решение: Используй MCP серверы (Context7, Ref) для обучения.

## Checklist перед эскалацией

```
Escalation Checklist:
- [ ] Задача действительно сложная/специфичная?
- [ ] У меня нет нужных инструментов/знаний?
- [ ] Я передаю полный контекст?
- [ ] Я выбрал правильного агента/субагента?
- [ ] Эскалация ускорит решение?
- [ ] Я не могу решить это с помощью MCP серверов?
```
