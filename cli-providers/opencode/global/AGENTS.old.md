# OpenCode Agent System

**Главный принцип:** Оркестратор координирует, агенты исполняют. Память обновляется автоматически.

---

## Агенты и права

| Тип | Агенты | Права | Роль |
|-----|--------|-------|------|
| **Координатор** | orchestrator | task, memory(read) | Делегирует задачи, читает память |
| **Кодеры** | backend, frontend, coder, debugger | write, edit, bash, memory(read) | Пишут код в проект |
| **Анализаторы** | project-analyzer, code-archaeologist | read, grep, glob, bash, memory(read) | Сбор информации |
| **Архитекторы** | backend-architect, api-architect, cloud-architect | read, memory(read) | Проектирование (фаза Design) |
| **Документалист** | documentarist | write, edit, memory(write) | **Автоматически** обновляет память |
| **QA** | test-automator, code-reviewer, security-auditor | write, edit, bash, memory(read) | Тесты, ревью, аудит |
| **Обучение** | learning-extractor | read, write, glob, grep, skill | Извлекает паттерны в skills |

---

## Документация

| Документ | Для кого | Содержание |
|----------|----------|------------|
| [CODING_RULES.md](CODING_RULES.md) | Кодеры | Размер файлов, логирование, проверка |
| [SUBAGENT_RULES.md](SUBAGENT_RULES.md) | Все субагенты | Запрет рекурсии, retry, формат ответа |
| [docs/orchestrator.md](docs/orchestrator.md) | Оркестратор | Workflow для мелких задач, QA pipeline |
| [docs/subagents.md](docs/subagents.md) | Справочник | Список агентов и когда использовать |
| [docs/specs-workflow.md](docs/specs-workflow.md) | Оркестратор | **Крупные задачи:** Requirements → Design → Tasks |

---

## Критические Anti-Patterns

```
❌ Оркестратор сам читает файлы / пишет код
❌ Субагент вызывает task с собственным именем
❌ Сдача задачи без проверки (Build/Lint/Dev)
❌ Оркестратор пропускает диалог с пользователем
❌ Документалист НЕ обновляет память после задачи
❌ Оркестратор пропускает QA pipeline после кодера
❌ Игнорирование альтернатив от агентов
❌ Продолжение при blocked статусе без решения
❌ Говорить "Готово" БЕЗ вызова @documentarist
❌ Сокращать контекст между агентами (передавай ПОЛНЫЙ JSON!)
❌ Баги после ревью → backend-developer (используй @debugger!)
❌ Крупная задача БЕЗ specs (Requirements → Design → Tasks)
❌ Выполнять все tasks скопом (по одной!)
```

---

## Быстрый справочник

### QA Pipeline (после каждого кодера)
```
@test-automator → @code-reviewer → @debugger (если баги) → @documentarist
```
Детали: [docs/orchestrator.md](docs/orchestrator.md#6-после-кодера--qa-pipeline-автоматически)

### Крупные задачи (3+ файлов, новая фича)
```
Requirements → Design → Tasks (с subtasks) → Execute по одной
```
Детали: [docs/specs-workflow.md](docs/specs-workflow.md)

### Передача контекста
- Оркестратор передаёт ПОЛНЫЙ JSON между агентами
- Агенты могут запросить контекст через `@code-archaeologist`

Детали: [docs/subagents.md](docs/subagents.md#правило-контекста)

---

## Memory (Автообновление)

**Documentarist ОБЯЗАН обновлять память после каждой задачи.**
Без напоминаний. Автоматически.
