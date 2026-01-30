# Subagents Reference

## Анализ и сбор информации

| Агент | Когда использовать |
|-------|-------------------|
| `project-analyzer` | Новый проект, быстрый анализ структуры |
| `code-archaeologist` | Legacy код, сложные зависимости |
| `context-manager` | Управление контекстом между агентами |

## Разработка

| Агент | Когда использовать |
|-------|-------------------|
| `backend-developer` | API, база данных, серверная логика |
| `frontend-developer` | UI компоненты, React/Vue |
| `general-coder` | Cross-stack задачи |
| `debugger` | Баги после code-reviewer |
| `code-structure-refactorer` | Рефакторинг, разбиение файлов |

## Архитектура

| Агент | Когда использовать |
|-------|-------------------|
| `backend-architect` | Системный дизайн |
| `api-architect` | API контракты |
| `database-optimizer` | Оптимизация запросов |

## QA

| Агент | Когда использовать |
|-------|-------------------|
| `test-automator` | Написание тестов |
| `code-reviewer` | Проверка качества |
| `security-auditor` | Аудит безопасности |

## Language experts

| Агент | Когда использовать |
|-------|-------------------|
| `typescript-expert` | TypeScript |
| `golang-pro` | Go |
| `rust-pro` | Rust |
| `python-pro` | Python |

---

## Правила выбора

```
Рефакторинг → code-structure-refactorer
Frontend (новый код) → frontend-developer
Backend (новый код) → backend-developer
Cross-stack → general-coder
Тесты → test-automator
Баги → debugger (ТОЛЬКО!)
```

**Баги из code-reviewer → ТОЛЬКО debugger!**
НЕ тот же агент, что писал код.
