# Manus Context Engineering Principles

Детальное описание принципов context engineering от Manus - компании приобретенной Meta за $2 млрд.

## 6 Принципов Manus

### Принцип 1: Проектируй вокруг KV-Cache

> "KV-cache hit rate - это ЕДИНСТВЕННАЯ самая важная метрика для production AI агентов."

**Статистика**:
- ~100:1 соотношение входных/выходных токенов
- Кешированные токены: $0.30/MTok vs Некешированные: $3/MTok
- Разница в 10 раз!

**Реализация**:
- Держи prompt prefixes СТАБИЛЬНЫМИ (изменение одного токена инвалидирует cache)
- НЕТ timestamps в system prompts
- Делай контекст APPEND-ONLY с детерминистической сериализацией

**Пример**:
```
❌ BAD: Динамический prefix
System: [Current time: 2026-01-18 10:30:45] You are an AI assistant...
# Каждую секунду новый timestamp = cache miss

✅ GOOD: Стабильный prefix
System: You are an AI assistant...
# Prefix не меняется = cache hit
```

### Принцип 2: Маскируй, не удаляй

Не удаляй инструменты динамически (ломает KV-cache). Используй logit masking вместо этого.

**Best Practice**: Используй консистентные action prefixes (например, `browser_`, `shell_`, `file_`) для легкого маскирования.

**Пример**:
```
❌ BAD: Динамическое удаление инструментов
tools = [read_file, write_file, execute_code]
if not allow_execution:
    tools.remove(execute_code)  # Меняет prompt = cache miss

✅ GOOD: Logit masking
tools = [read_file, write_file, execute_code]  # Всегда одинаковый список
if not allow_execution:
    mask_logits(execute_code)  # Prompt не меняется = cache hit
```

### Принцип 3: Файловая система как внешняя память

> "Markdown - это моя 'рабочая память' на диске."

**Формула**:
```
Context Window = RAM (volatile, limited)
Filesystem = Disk (persistent, unlimited)
```

**Сжатие должно быть восстанавливаемым**:
- Храни URLs даже если веб-контент удален
- Храни file paths при удалении document contents
- Никогда не теряй указатель на полные данные

**Пример**:
```markdown
❌ BAD: Потеря указателя
## Research
Found useful information about React hooks.

✅ GOOD: Сохранение указателя
## Research
Found useful information about React hooks.
Source: https://react.dev/reference/react/hooks
File: docs/react-hooks-guide.pdf (page 15)
```

### Принцип 4: Манипулируй вниманием через повторение

> "Создает и обновляет todo.md на протяжении задач чтобы протолкнуть глобальный план в недавний attention span модели."

**Проблема**: После ~50 tool calls модели забывают исходные цели ("lost in the middle" эффект).

**Решение**: Перечитывай `task_plan.md` перед каждым решением. Цели появляются в окне внимания.

**Визуализация**:
```
┌─────────────────────────────────────────────────────────┐
│ Start of context: [Original goal - far away, forgotten] │
│                                                          │
│ ...many tool calls...                                    │
│ ...more tool calls...                                    │
│ ...even more tool calls...                               │
│                                                          │
│ End of context: [Recently read task_plan.md]            │
│                 ↑ THIS GETS ATTENTION!                   │
└─────────────────────────────────────────────────────────┘
```

**Пример workflow**:
```
Loop 1: Create task_plan.md with goal
Loop 2-10: Work on implementation
Loop 11: Read task_plan.md  ← Goal back in attention!
Loop 12: Make decision (with goal fresh in mind)
Loop 13-20: More work
Loop 21: Read task_plan.md  ← Goal refreshed again!
```

### Принцип 5: Оставляй неправильные шаги в контексте

> "Оставь неправильные повороты в контексте."

**Почему**:
- Неудачные действия со стек-трейсами позволяют модели неявно обновлять убеждения
- Уменьшает повторение ошибок
- Восстановление после ошибок - "один из самых четких сигналов ИСТИННОГО агентского поведения"

**Пример**:
```
❌ BAD: Скрытие ошибок
Action: Read config.json
Error: File not found
[Скрыто из контекста]
Action: Read config.json  # Повторяет ту же ошибку

✅ GOOD: Сохранение ошибок
Action: Read config.json
Error: File not found
  at readFile (fs.js:123)
  Stack trace: ...
Observation: File doesn't exist, need to create default
Action: Write config.json (with defaults)
Action: Read config.json
Success!
```

### Принцип 6: Не попадай в few-shot ловушку

> "Однообразие порождает хрупкость."

**Проблема**: Повторяющиеся action-observation пары вызывают drift и hallucination.

**Решение**: Вноси контролируемую вариативность:
- Варьируй формулировки слегка
- Не копируй-пасти паттерны слепо
- Рекалибруй на повторяющихся задачах

**Пример**:
```
❌ BAD: Повторяющиеся паттерны
Action: Read file.txt
Observation: Content of file.txt
Action: Read file2.txt
Observation: Content of file2.txt
Action: Read file3.txt
Observation: Content of file3.txt
# Модель начинает галлюцинировать паттерн

✅ GOOD: Вариативность
Action: Read file.txt
Observation: Content of file.txt
Action: Check file2.txt contents
Observation: File contains: ...
Action: Examine file3.txt
Observation: Found in file3.txt: ...
# Разные формулировки предотвращают drift
```

## 3 Стратегии Context Engineering

### Стратегия 1: Context Reduction (Сжатие контекста)

**Compaction (Уплотнение)**:
```
Tool calls имеют ДВА представления:
├── FULL: Raw tool content (хранится в файловой системе)
└── COMPACT: Reference/file path только

ПРАВИЛА:
- Применяй compaction к STALE (старым) tool results
- Держи RECENT results FULL (для guidance следующего решения)
```

**Пример**:
```
FULL (недавний):
Action: Read src/auth/login.ts
Observation: [полный код файла, 200 строк]

COMPACT (старый):
Action: Read src/auth/login.ts
Observation: File content stored at .context/login-ts-content.md
```

**Summarization (Суммаризация)**:
- Применяется когда compaction достигает diminishing returns
- Генерируется используя полные tool results
- Создает стандартизированные summary objects

**Пример**:
```
BEFORE (10 file reads):
Read file1.ts: [200 lines]
Read file2.ts: [150 lines]
...
Read file10.ts: [180 lines]

AFTER (summarization):
Summary: Analyzed 10 TypeScript files in src/auth/
Key findings:
- All use JWT for authentication
- Common pattern: validateToken() function
- Error handling via try-catch
Full content: .context/auth-analysis-summary.md
```

### Стратегия 2: Context Isolation (Изоляция контекста)

**Multi-Agent Architecture**:
```
┌─────────────────────────────────┐
│         PLANNER AGENT           │
│  └─ Assigns tasks to sub-agents │
├─────────────────────────────────┤
│       KNOWLEDGE MANAGER         │
│  └─ Reviews conversations       │
│  └─ Determines filesystem store │
├─────────────────────────────────┤
│      EXECUTOR SUB-AGENTS        │
│  └─ Perform assigned tasks      │
│  └─ Have own context windows    │
└─────────────────────────────────┘
```

**Ключевое открытие**: Manus изначально использовал `todo.md` для task planning, но обнаружил что ~33% действий тратились на его обновление. Перешли на dedicated planner agent вызывающего executor sub-agents.

**Пример**:
```
❌ BAD: Один агент делает всё
Agent context: [system prompt] + [task plan] + [file1] + [file2] + ... + [file50]
# Контекст переполнен, цели забыты

✅ GOOD: Multi-agent isolation
Planner context: [system prompt] + [high-level plan]
Executor1 context: [system prompt] + [subtask1] + [relevant files]
Executor2 context: [system prompt] + [subtask2] + [relevant files]
# Каждый агент фокусируется на своей задаче
```

### Стратегия 3: Context Offloading (Выгрузка контекста)

**Tool Design**:
- Используй <20 атомарных функций всего
- Храни полные результаты в файловой системе, не в контексте
- Используй `glob` и `grep` для поиска
- Progressive disclosure: загружай информацию только по мере необходимости

**Пример**:
```
❌ BAD: Всё в контексте
Action: List all files
Observation: [1000 files listed]
Action: Read file1
Observation: [full content]
Action: Read file2
Observation: [full content]
# Контекст забит ненужной информацией

✅ GOOD: Progressive disclosure
Action: Find files matching "*.test.ts"
Observation: Found 5 test files (stored in .context/test-files.txt)
Action: Read most relevant test file
Observation: [content of 1 file]
# Загружаем только то что нужно сейчас
```

## Agent Loop

Manus работает в непрерывном 7-шаговом цикле:

```
┌─────────────────────────────────────────┐
│  1. ANALYZE CONTEXT                      │
│     - Understand user intent             │
│     - Assess current state               │
│     - Review recent observations         │
├─────────────────────────────────────────┤
│  2. THINK                                │
│     - Should I update the plan?          │
│     - What's the next logical action?    │
│     - Are there blockers?                │
├─────────────────────────────────────────┤
│  3. SELECT TOOL                          │
│     - Choose ONE tool                    │
│     - Ensure parameters available        │
├─────────────────────────────────────────┤
│  4. EXECUTE ACTION                       │
│     - Tool runs in sandbox               │
├─────────────────────────────────────────┤
│  5. RECEIVE OBSERVATION                  │
│     - Result appended to context         │
├─────────────────────────────────────────┤
│  6. ITERATE                              │
│     - Return to step 1                   │
│     - Continue until complete            │
├─────────────────────────────────────────┤
│  7. DELIVER OUTCOME                      │
│     - Send results to user               │
│     - Attach all relevant files          │
└─────────────────────────────────────────┘
```

## Типы файлов которые создает Manus

| Файл | Назначение | Когда создается | Когда обновляется |
|------|-----------|-----------------|-------------------|
| `task_plan.md` | Phase tracking, progress | Task start | После завершения фаз |
| `findings.md` | Discoveries, decisions | После ЛЮБОГО открытия | После просмотра images/PDFs |
| `progress.md` | Session log, what's done | На breakpoints | На протяжении сессии |
| Code files | Implementation | Перед execution | После ошибок |

## Критические ограничения

- **Single-Action Execution**: ОДИН tool call за turn. Нет параллельного выполнения.
- **Plan is Required**: Агент должен ВСЕГДА знать: goal, current phase, remaining phases
- **Files are Memory**: Context = volatile. Filesystem = persistent.
- **Never Repeat Failures**: Если action failed, next action ДОЛЖЕН быть другим
- **Communication is a Tool**: Message types: `info` (progress), `ask` (blocking), `result` (terminal)

## Статистика Manus

| Метрика | Значение |
|---------|----------|
| Средние tool calls на задачу | ~50 |
| Соотношение входных/выходных токенов | 100:1 |
| Цена приобретения | $2 млрд |
| Время до $100M выручки | 8 месяцев |
| Рефакторингов фреймворка с запуска | 5 раз |
| KV-cache hit rate | Самая важная метрика |
| Кешированные токены | $0.30/MTok |
| Некешированные токены | $3/MTok |
| Экономия при cache hit | 10x |

## Ключевые цитаты

> "Context window = RAM (volatile, limited). Filesystem = Disk (persistent, unlimited). Anything important gets written to disk."

> "if action_failed: next_action != same_action. Track what you tried. Mutate the approach."

> "Error recovery is one of the clearest signals of TRUE agentic behavior."

> "KV-cache hit rate is the single most important metric for a production-stage AI agent."

> "Leave the wrong turns in the context."

> "Markdown is my 'working memory' on disk. Since I process information iteratively and my active context has limits, Markdown files serve as scratch pads for notes, checkpoints for progress, building blocks for final deliverables."

## Применение в Kiro

### Как Kiro реализует принципы Manus

1. **Файловая система как память**: `task_plan.md`, `findings.md`, `progress.md`
2. **Манипуляция вниманием**: Перечитывание плана перед решениями
3. **Сохранение ошибок**: Логирование в task_plan.md
4. **Goal tracking**: Чекбоксы показывают прогресс
5. **Completion verification**: Проверка всех фаз перед завершением

### Отличия от оригинального Manus

| Аспект | Manus | Kiro |
|--------|-------|------|
| Multi-agent | Planner + Executors | Single agent с sub-agents |
| Compaction | Автоматическое | Ручное (через файлы) |
| KV-cache | Оптимизирован | Не контролируется напрямую |
| Tool count | <20 атомарных | Больше инструментов |
| Context isolation | Dedicated agents | Shared context |

### Что можно улучшить

1. **Автоматическое compaction**: Старые tool results → file references
2. **KV-cache optimization**: Стабильные prefixes, append-only context
3. **Multi-agent architecture**: Planner → Executor pattern
4. **Progressive disclosure**: Загрузка информации по требованию
5. **Logit masking**: Вместо динамического удаления инструментов

## Источник

Основано на официальной документации Manus по context engineering:
https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus

## Дополнительные ресурсы

- [Lance Martin's Manus Analysis](https://twitter.com/RLanceMartin/status/1234567890)
- [Meta Acquisition Announcement](https://techcrunch.com/2025/12/29/meta-just-bought-manus)
- [Context Engineering Best Practices](https://manus.im/blog)
