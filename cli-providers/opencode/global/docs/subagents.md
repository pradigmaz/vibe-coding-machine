# Subagents Reference

## Когда какой агент использовать

### Анализ и сбор информации

| Агент | Когда использовать |
|-------|-------------------|
| `project-analyzer` | Новый проект, быстрый анализ структуры |
| `code-archaeologist` | Legacy код, сложные зависимости, "где это лежит?" |
| `context-manager` | Управление контекстом между агентами |

### Разработка

| Агент | Когда использовать |
|-------|-------------------|
| `backend-developer` | API, база данных, серверная логика (НОВЫЙ код) |
| `frontend-developer` | UI компоненты, React/Vue (НОВЫЙ код) |
| `general-coder` | Cross-stack задачи (UI + API + DB) |
| `debugger` | **Баги после code-reviewer**, ошибки, исправления |
| `code-structure-refactorer` | **Рефакторинг, разбиение файлов, модуляризация** |
| `legacy-modernizer` | Модернизация legacy кода |
| `mobile-developer` | React Native, Flutter |

### Архитектура

| Агент | Когда использовать |
|-------|-------------------|
| `backend-architect` | Системный дизайн, выбор стека |
| `api-architect` | API контракты, REST/GraphQL схемы |
| `graphql-architect` | GraphQL схемы, resolvers |
| `database-optimizer` | Оптимизация запросов, индексы |
| `database-architect` | Схема БД, миграции |
| `database-admin` | Backup, replication, мониторинг |

### Frontend специалисты

| Агент | Когда использовать |
|-------|-------------------|
| `react-expert` | React специфика |
| `nextjs-specialist` | Next.js специфика |
| `vue-expert` | Vue специфика |
| `vue-nuxt-expert` | Nuxt специфика |
| `ui-ux-designer` | UI/UX дизайн |
| `tailwind-css-expert` | Tailwind стили |

### Backend специалисты

| Агент | Когда использовать |
|-------|-------------------|
| `django-expert` | Django |
| `laravel-expert` | Laravel |
| `api-builder` | tRPC, API интеграция |

### Language experts

| Агент | Когда использовать |
|-------|-------------------|
| `typescript-expert` | TypeScript общий |
| `typescript-types-specialist` | Сложные типы TS |
| `golang-pro` | Go |
| `rust-pro` | Rust |
| `python-pro` | Python |

### QA

| Агент | Когда использовать |
|-------|-------------------|
| `test-automator` | Написание тестов |
| `code-reviewer` | Проверка качества кода |
| `security-auditor` | Проверка безопасности |
| `accessibility-specialist` | WCAG, accessibility |

### Документация и обучение

| Агент | Когда использовать |
|-------|-------------------|
| `documentarist` | Обновление памяти (автоматически!) |
| `documentation-specialist` | README, API docs |
| `learning-extractor` | Извлечение паттернов в skills |

### DevOps & Infra

| Агент | Когда использовать |
|-------|-------------------|
| `devops-engineer` | CI/CD, Docker, инфраструктура |

### Специализированные

| Агент | Когда использовать |
|-------|-------------------|
| `langgraph-specialist` | LangGraph StateGraph workflows |
| `llm-service-specialist` | LLM сервисы, OpenAI SDK |
| `judge-specialist` | LLM Judge системы |
| `stage-pipeline-specialist` | Stage pipelines |
| `utility-builder` | JSON repair, validation, утилиты |
| `game-developer` | Unity, Unreal |
| `lead-research-assistant` | Исследования |

---

## Правила выбора

```
Рефакторинг/разбиение файлов → code-structure-refactorer ✅
Frontend задача (НОВЫЙ код) → frontend-developer
Backend задача (НОВЫЙ код) → backend-developer
Cross-stack → general-coder
Тесты → test-automator
Баги → debugger
Крупная задача → specs-workflow.md
```

### Рефакторинг — ТОЛЬКО code-structure-refactorer!
```
"Разбей файл на модули" → @code-structure-refactorer
"Файл слишком большой" → @code-structure-refactorer
"Рефакторинг" → @code-structure-refactorer
"Модуляризация" → @code-structure-refactorer
```

**НЕ отдавай рефакторинг frontend-developer или backend-developer!**
Они пишут НОВЫЙ код. Refactorer специализируется на улучшении структуры СУЩЕСТВУЮЩЕГО кода.

### Баги — ТОЛЬКО debugger!
```
Баг после code-reviewer → @debugger (НИКОГДА кодеру!)
Баг от пользователя → @debugger
Runtime ошибка → @debugger
Тесты падают → @debugger
```

**Почему не кодер?** Кодер пишет НОВЫЙ код. Debugger специализируется на поиске и исправлении проблем в существующем коде.

---

## Правило контекста

**Оркестратор передаёт задачу → ПОЛНЫЙ контекст обязателен**

**Агенты могут запросить доп. информацию:**
```
"Мне нужен контекст. Запроси у @code-archaeologist:
- Как используется функция X в других файлах?
- Какие типы принимает метод Y?"
```

Оркестратор ОБЯЗАН выполнить запрос и передать результат агенту.
