# Planning with Files Skill для Kiro CLI

Реализация Manus-style file-based planning для сложных задач в Kiro CLI.

## Что это?

Planning with Files - это skill основанный на методологии компании Manus (приобретена Meta за $2 млрд), которая использует файловую систему как "внешнюю память" для AI-агентов.

## Структура

```
planning-with-files/
├── SKILL.md                      # Основной skill файл
├── README.md                     # Этот файл
├── steering/                     # Дополнительные материалы
│   ├── examples.md              # Детальные примеры использования
│   ├── manus-principles.md      # Полное описание принципов Manus
│   └── templates.md             # Готовые шаблоны для копирования
└── hooks/                        # Автоматизация (опционально)
    ├── README.md                # Документация по хукам
    └── planning-hooks-example.json  # Пример конфигурации хуков
```

## Быстрый старт

### 1. Создай три файла вручную

В корне проекта создай:
- `task_plan.md` - фазы и прогресс
- `findings.md` - исследования и решения
- `progress.md` - лог сессии

### 2. Используй шаблоны

Скопируй шаблоны из `steering/templates.md` или используй минимальные версии:

**task_plan.md:**
```markdown
# Task Plan: [Описание]

## Цель
[Одно предложение]

## Фазы
- [ ] Phase 1: Discovery
- [ ] Phase 2: Planning
- [ ] Phase 3: Implementation
- [ ] Phase 4: Testing
- [ ] Phase 5: Delivery

## Принятые решения
| Решение | Обоснование |
|---------|-------------|

## Встреченные ошибки
| Ошибка | Решение |
|--------|---------|
```

**findings.md:**
```markdown
# Findings

## Требования
-

## Результаты исследований
-

## Технические решения
| Решение | Обоснование |
|---------|-------------|

## Ресурсы
-
```

**progress.md:**
```markdown
# Progress Log

## Session: [ДАТА]

### Current Status
- **Phase:** 1
- **Started:** [ВРЕМЯ]

### Actions Taken
-

### Errors
| Ошибка | Решение |
|--------|---------|
```

### 3. Начни работу

Следуй workflow:
1. Перечитывай `task_plan.md` перед важными решениями
2. Обновляй `findings.md` после открытий
3. Логируй прогресс в `progress.md`
4. Меняй статусы фаз: `pending` → `in_progress` → `complete`

### 4. Хуки работают автоматически!

Planning-with-files включает **глобальные хуки** которые:
- Автоматически показывают план перед промптом
- Проверяют завершение фаз после ответа
- Напоминают обновить статусы

**Ничего настраивать не нужно** - хуки уже установлены в `cli-providers/kiro/global/hooks/`.

Подробности в `hooks/README.md`.

## Ключевые правила

1. **Создавай план первым** - никогда не начинай без `task_plan.md`
2. **Правило 2-х действий** - сохраняй находки после каждых 2 view/browser операций
3. **Читай перед решением** - перечитывай план перед важными решениями
4. **Обновляй после действия** - меняй статусы фаз после завершения
5. **Логируй ВСЕ ошибки** - каждая ошибка в таблицу
6. **Никогда не повторяй неудачи** - меняй подход после ошибки

## Когда использовать

### ✅ Используй для

- Многошаговых задач (3+ шага)
- Исследовательских задач
- Создания/построения проектов
- Задач требующих >5 tool calls
- Всего что требует организации

### ❌ Пропускай для

- Простых вопросов
- Редактирования одного файла
- Быстрых поисков
- Задач <3 шагов

## Дополнительные материалы

### steering/examples.md

Детальные примеры использования:
- Feature Development (Dark Mode Toggle)
- Bug Investigation (Memory Leak)
- API Integration (Stripe Payment)
- Общие паттерны

### steering/manus-principles.md

Полное описание принципов Manus:
- 6 принципов Manus
- 3 стратегии context engineering
- Agent loop
- Статистика и метрики

### steering/templates.md

Готовые шаблоны для копирования:
- Полные и минимальные шаблоны
- Шаблоны для разных типов задач (Bug Fix, Feature, Research, Refactoring)
- Команды для быстрого создания файлов
- Советы по адаптации

## Интеграция с агентами Kiro

### В конфигурации агента

```json
{
  "name": "architect",
  "resources": [
    "skill://cli-providers/kiro/global/skills/planning-with-files/SKILL.md"
  ]
}
```

### Для всех агентов

Добавь в глобальные resources:
```json
{
  "resources": [
    "skill://cli-providers/kiro/global/skills/**/SKILL.md"
  ]
}
```

## Примеры использования

### Пример 1: Простая задача

```bash
# Создай файлы вручную или скопируй шаблоны
# task_plan.md, findings.md, progress.md

# Заполни task_plan.md
# Цель: Добавить dark mode toggle
# Фазы: Discovery, Planning, Implementation, Testing, Delivery

# Работа
# ... агент работает, обновляет файлы ...

# Проверка вручную
# Открой task_plan.md и проверь что все фазы complete
```

### Пример 2: Сложная задача

```bash
# Создай файлы с детальными шаблонами
# task_plan.md с 7 фазами
# findings.md с исследованиями API
# progress.md с детальным логом

# Работа с перечитыванием плана
# Перед каждым важным решением читай task_plan.md

# Логирование ошибок
# Каждая ошибка → task_plan.md таблица

# Проверка вручную
# Все фазы complete?
```

## Тест 5-ти вопросов

Если можешь ответить на эти вопросы, управление контекстом в порядке:

| Вопрос | Источник ответа |
|--------|-----------------|
| Где я? | Текущая фаза в task_plan.md |
| Куда я иду? | Оставшиеся фазы |
| Какая цель? | Формулировка цели в плане |
| Что я узнал? | findings.md |
| Что я сделал? | progress.md |

## Статистика Manus

- Цена приобретения: **$2 млрд**
- Время до $100M выручки: **8 месяцев**
- Средние tool calls на задачу: **~50**
- Соотношение входных/выходных токенов: **100:1**
- Экономия при KV-cache hit: **10x**

## Ресурсы

- [Manus Context Engineering](https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus)
- [Original planning-with-files plugin](https://github.com/OthmanAdi/planning-with-files)
- [Meta Acquisition Announcement](https://techcrunch.com/2025/12/29/meta-just-bought-manus)

## Лицензия

MIT License - адаптировано для Kiro CLI из [OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files)

## Автор оригинального skill

[Ahmad Othman Ammar Adi](https://github.com/OthmanAdi)

## Адаптация для Kiro CLI

Адаптировано для Kiro CLI с сохранением всех ключевых принципов Manus.
