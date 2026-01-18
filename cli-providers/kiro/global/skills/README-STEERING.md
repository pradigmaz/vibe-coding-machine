# Steering Files в Skills

## Что такое Steering Files?

Steering файлы - это дополнительные workflow guides и детальная документация, которая загружается по требованию (on-demand). Они используются когда:

1. Основной SKILL.md становится слишком большим (>500 строк)
2. Есть независимые workflows, которые не нужны всегда
3. Нужна прогрессивная загрузка информации

## Структура

```
skills/
  component-refactoring/
    SKILL.md                           # Основной файл (всегда загружается)
    steering/                          # Дополнительные материалы
      complexity-patterns.md           # Детальный workflow
      component-splitting.md
      hook-extraction.md
```

## Skills со Steering папками

### 1. component-refactoring (3 файла)
- `steering/complexity-patterns.md` - Паттерны определения сложности
- `steering/component-splitting.md` - Разделение компонентов
- `steering/hook-extraction.md` - Извлечение custom hooks

### 2. designing-apis (1 файл)
- `steering/OPENAPI-TEMPLATE.md` - Готовый шаблон OpenAPI 3.0

### 3. react-best-practices (47 файлов!)
Детальные паттерны производительности, разделенные по категориям:
- `async-*.md` - Eliminating waterfalls (5 файлов)
- `bundle-*.md` - Bundle size optimization (5 файлов)
- `server-*.md` - Server-side performance (4 файла)
- `rerender-*.md` - Re-render optimization (6 файлов)
- `rendering-*.md` - Rendering performance (7 файлов)
- `js-*.md` - JavaScript performance (12 файлов)
- `client-*.md` - Client-side data fetching (2 файла)
- `advanced-*.md` - Advanced patterns (2 файла)
- `_sections.md` - Полный список всех паттернов
- `_template.md` - Шаблон для новых паттернов

### 4. power-builder (2 файла)
- `steering/interactive.md` - Interactive power creation workflow
- `steering/testing.md` - Testing and updating powers

### 5. prowler-ui (1 файл)
- `steering/ui-docs.md` - Prowler UI documentation

## Как использовать в агентах

### Автоматическая загрузка

Steering файлы загружаются автоматически когда агент читает skill:

```json
{
  "resources": [
    "skill://~/.kiro/skills/component-refactoring/SKILL.md"
  ]
}
```

Kiro автоматически делает доступными все файлы из `steering/` папки.

### Ссылки в SKILL.md

В основном SKILL.md файле должны быть ссылки на steering:

```markdown
# Component Refactoring Skill

## Дополнительные материалы (steering)

Для детальных workflow guides смотри:
- `steering/complexity-patterns.md` - Паттерны определения сложности
- `steering/component-splitting.md` - Разделение компонентов
- `steering/hook-extraction.md` - Извлечение custom hooks
```

### Когда агент должен читать steering

Агент должен обращаться к steering файлам когда:
1. Нужен детальный workflow для конкретной задачи
2. Основной SKILL.md упоминает steering файл
3. Задача требует глубокого понимания паттерна

## Best Practices

### Для создания steering файлов

1. **Используй steering когда:**
   - SKILL.md превышает 500 строк
   - Есть независимые workflows
   - Нужны детальные примеры

2. **Не используй steering когда:**
   - Информация критична для всех случаев
   - Файл простой и короткий
   - Контент тесно связан

3. **Структура steering файла:**
   ```markdown
   # [Название паттерна]
   
   ## Когда использовать
   
   ## Процесс
   
   ### Шаг 1: ...
   
   ### Шаг 2: ...
   
   ## Примеры
   
   ## Тестирование
   ```

### Для использования в агентах

1. **Всегда упоминай steering в SKILL.md**
2. **Группируй связанные steering файлы**
3. **Используй понятные имена файлов**

## Примеры использования

### Frontend агент с component-refactoring

```json
{
  "name": "frontend",
  "resources": [
    "skill://~/.kiro/skills/component-refactoring/SKILL.md"
  ]
}
```

Агент видит в SKILL.md:
```markdown
## Дополнительные материалы (steering)

Для детальных workflow guides смотри:
- `steering/hook-extraction.md` - Извлечение custom hooks
```

Агент может прочитать `steering/hook-extraction.md` для детального процесса.

### Backend агент с designing-apis

```json
{
  "name": "backend",
  "resources": [
    "skill://~/.kiro/skills/designing-apis/SKILL.md"
  ]
}
```

Агент видит:
```markdown
## Дополнительные материалы (steering)

Для шаблонов смотри:
- `steering/OPENAPI-TEMPLATE.md` - Готовый шаблон OpenAPI 3.0
```

Агент может использовать шаблон из steering.

## Заключение

Steering файлы - это мощный инструмент для организации детальной документации без перегрузки основных SKILL.md файлов. Используй их разумно!
