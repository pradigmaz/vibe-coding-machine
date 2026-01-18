# Kiro Skills

## Что такое Skills?

Skills - это база знаний для агентов Kiro. Каждый skill содержит best practices, паттерны и рекомендации по конкретной теме.

## Структура

```
skills/
  architecture/
    SKILL.md          - Основной файл с знаниями
  code-standards/
    SKILL.md
    python/
      SKILL.md        - Специфичные стандарты для Python
    typescript/
      SKILL.md        - Специфичные стандарты для TypeScript
```

## Готовые Skills

### ✅ Базовые (адаптированы для Kiro CLI)

1. **architecture** - Архитектурные паттерны (SOLID, Clean Architecture, Microservices)
2. **code-standards** - Стандарты кода для разных языков
3. **escalation-policy** - Политика эскалации между агентами
4. **file-sizes** - Ограничения размеров файлов и рефакторинг

### 🔄 Требуют адаптации (из Kiro Powers)

Эти skills скопированы из Kiro Powers и содержат POWER.md файлы. Нужно:
1. Прочитать POWER.md
2. Извлечь полезный контент
3. Создать SKILL.md в формате Kiro CLI
4. Удалить POWER.md

**Список**:
- analyzing-projects
- async-python-patterns
- component-refactoring
- concept-workflow
- create-pr
- designing-apis
- designing-architecture
- designing-tests
- docs-review
- frontend-design
- javascript-testing-patterns
- managing-git
- nextjs-app-router-patterns
- optimizing-performance
- postgresql-table-design
- power-builder
- prowler-ui
- python-performance-optimization
- python-testing-patterns
- react-19
- react-best-practices
- react-state-management
- tailwind-4
- tailwind-design-system
- testing-python
- typescript
- typescript-advanced-types
- typescript-review
- typescript-write
- uv-package-manager

## Формат SKILL.md

### Структура файла

```markdown
# [Название] Skill

## Назначение

Краткое описание: что делает skill, кто использует.

## Основной контент

### Раздел 1

Теория, примеры кода, best practices.

### Раздел 2

Больше примеров и паттернов.

## Checklist

Чеклист для проверки/применения skill.

## Инструменты

Команды, утилиты, ссылки.
```

### Пример хорошего SKILL.md

```markdown
# React 19 Skill

## Назначение

React 19 паттерны с React Compiler. Используется frontend агентами при работе с React 19 компонентами.

## No Manual Memoization

React Compiler автоматически оптимизирует код.

\`\`\`typescript
// ✅ GOOD: Compiler handles optimization
function Component({ items }) {
  const filtered = items.filter(x => x.active);
  return <List items={filtered} />;
}

// ❌ BAD: Manual memoization
const filtered = useMemo(() => items.filter(x => x.active), [items]);
\`\`\`

## use() Hook

\`\`\`typescript
import { use } from "react";

function Comments({ promise }) {
  const comments = use(promise);
  return comments.map(c => <div key={c.id}>{c.text}</div>);
}
\`\`\`

## Checklist

\`\`\`
React 19 Review:
- [ ] No useMemo/useCallback (Compiler handles it)
- [ ] Named imports from "react"
- [ ] Server Components by default
- [ ] "use client" only when needed
- [ ] ref as prop (no forwardRef)
\`\`\`
```

## Как адаптировать POWER.md → SKILL.md

### Шаг 1: Прочитай POWER.md

```bash
# Пример
cat cli-providers/kiro/global/skills/react-19/POWER.md
```

### Шаг 2: Извлеки контент

Убери frontmatter (---), оставь только полезный контент:
- Примеры кода
- Best practices
- Паттерны
- Чеклисты

### Шаг 3: Создай SKILL.md

```bash
# Создай новый файл
touch cli-providers/kiro/global/skills/react-19/SKILL.md
```

Добавь:
1. Заголовок "# [Название] Skill"
2. Раздел "## Назначение"
3. Основной контент из POWER.md
4. Чеклист (если есть)

### Шаг 4: Удали POWER.md

```bash
rm cli-providers/kiro/global/skills/react-19/POWER.md
```

## Приоритет адаптации

### Высокий приоритет (используются часто)

1. **react-19** - Frontend агент
2. **nextjs-app-router-patterns** - Frontend агент
3. **typescript** - Frontend/Backend агенты
4. **python-testing-patterns** - Backend агент
5. **managing-git** - Все агенты
6. **create-pr** - Все агенты

### Средний приоритет

7. **designing-apis** - Backend агент
8. **postgresql-table-design** - Backend агент
9. **react-best-practices** - Frontend агент
10. **tailwind-4** - Frontend агент
11. **component-refactoring** - Frontend агент

### Низкий приоритет

12. Остальные skills - специфичные use cases

## Использование в агентах

### В конфигурации агента

```json
{
  "name": "frontend",
  "resources": [
    "skill://.kiro/skills/react-19/SKILL.md",
    "skill://.kiro/skills/typescript/SKILL.md",
    "skill://.kiro/skills/code-standards/SKILL.md"
  ]
}
```

### Wildcard для всех skills

```json
{
  "resources": [
    "skill://.kiro/skills/**/SKILL.md"
  ]
}
```

## Автоматизация адаптации

### Скрипт для массовой адаптации

```bash
#!/bin/bash
# adapt-skills.sh

for dir in cli-providers/kiro/global/skills/*/; do
  if [ -f "$dir/POWER.md" ]; then
    skill_name=$(basename "$dir")
    echo "Adapting $skill_name..."
    
    # Создай SKILL.md из POWER.md
    # (здесь нужна ручная работа для качественной адаптации)
    
    echo "✅ $skill_name adapted"
  fi
done
```

## Best Practices

### ✅ DO

- Используй конкретные примеры кода
- Показывай ❌ BAD и ✅ GOOD варианты
- Добавляй чеклисты
- Пиши на русском (для Kiro CLI)
- Группируй связанные концепции

### ❌ DON'T

- Не копируй весь POWER.md без адаптации
- Не оставляй frontmatter (---)
- Не дублируй информацию между skills
- Не пиши слишком общие вещи
- Не забывай про примеры

## Следующие шаги

1. Адаптируй высокоприоритетные skills
2. Протестируй с агентами
3. Собери feedback
4. Адаптируй остальные по необходимости

## Вопросы?

Если не понятно как адаптировать конкретный skill - спроси!
