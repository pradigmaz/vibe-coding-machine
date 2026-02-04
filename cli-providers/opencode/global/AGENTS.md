# Kiro Agent System

Мультиагентная система: оркестратор координирует, агенты исполняют.

## Документация

| Задача | Документ |
|--------|----------|
| Выбор агента | [docs/subagents.md](docs/subagents.md) |
| Мелкая задача (1-2 файла) | [docs/workflow-small.md](docs/workflow-small.md) |
| Крупная задача (3+ файлов) | [docs/workflow-large.md](docs/workflow-large.md) |
| Правила кода | [docs/coding-rules.md](docs/coding-rules.md) |

---

## Главный принцип

**Оркестратор — координатор, НЕ исполнитель.**
- ТОЛЬКО делегирует задачи через `use_subagent`
- СТРОГО ЗАПРЕЩЕНО: самостоятельный сбор информации, написание кода, редактирование файлов

---

## Права доступа

| Агент | write | edit | bash | subagent | Роль |
|-------|-------|------|------|----------|------|
| Orchestrator | ❌ | ❌ | ❌ | ✅ | Координатор |
| Backend/Frontend/Coder | ✅ | ✅ | ✅ | ❌ | Генерация кода |
| Reviewer/Architect | ❌ | ❌ | ❌ | ❌ | Анализ (READ-ONLY) |

---

## Quality Gates (ОБЯЗАТЕЛЬНО)

Перед "Готово" агент ОБЯЗАН проверить:

**JS/TS:** `tsc --noEmit` → `npm run lint` → `npm run build` → `npm run dev`
**Python:** `mypy/flake8` → `pytest` → runtime check
**Go:** `go vet` → `go build` → `go test`

**ЕСЛИ ПАДАЕТ → ЗАДАЧА НЕ ВЫПОЛНЕНА.**

---

## Workflow Summary

```
User Request
     ↓
ORCHESTRATOR → Классификация → Делегирование сбора
     ↓
COLLECTOR AGENTS (analyzer/archaeologist)
     ↓
ORCHESTRATOR → Показ плана → Подтверждение
     ↓
PRIMARY AGENTS (backend/frontend/coder)
     ↓
QA PIPELINE (test → review → debugger)
```
