а # KIRO.md

Guidance для Kiro при работе с этим skill.

## Обзор проекта

Это **Kiro skill** для continuous learning — позволяет Kiro автономно извлекать и сохранять изученные знания в reusable skills. Это не application codebase, а skill definition с документацией и примерами.

## Ключевые файлы

- `SKILL.md` — Основной skill definition (markdown без YAML frontmatter). Это то что Kiro загружает.
- `resources/skill-template.md` — Template для создания новых skills
- `examples/` — Sample extracted skills демонстрирующие правильный формат

## Формат Skill файла

Skills используют чистый markdown (без YAML frontmatter в отличие от Claude Code):

```markdown
# [Название] Skill

## Назначение
[Краткое описание: что решает, кто использует, когда активируется]

## Проблема
[Детальное описание проблемы]

## Trigger Conditions
[Точные условия активации: error messages, симптомы, сценарии]

## Решение
[Пошаговое решение с примерами кода]

## Проверка
[Как проверить что решение работает]

## Пример
[Конкретный пример применения]

## Заметки
[Caveats, edge cases, когда НЕ использовать]

## References
[Ссылки на документацию]
```

Секция "Trigger Conditions" критична — она определяет когда skill должен активироваться.

## Пути установки

- **Глобальные**: `cli-providers/kiro/global/skills/[skill-name]/`
- **Проектные**: `.kiro/skills/[skill-name]/`

## Quality критерии для Skills

При модификации или создании skills убедись:
- **Переиспользуемо**: Помогает в будущих задачах, не только в одном случае
- **Нетривиально**: Требует discovery, не просто documentation lookup
- **Специфично**: Четкие trigger conditions (точные error messages, симптомы)
- **Проверено**: Решение реально протестировано и работает

## Research основа

Подход основан на академической работе по skill libraries (Voyager, CASCADE, SEAgent, Reflexion). См. `resources/research-references.md` для деталей.

## Отличия от Claude Code версии

1. **Формат**: Без YAML frontmatter, только markdown
2. **Хуки**: JSON файлы вместо bash скриптов
3. **Язык**: Русский по умолчанию
4. **Путь**: `.kiro/` вместо `.claude/`

## Использование в Kiro

Skill активируется автоматически когда:
- Решена нетривиальная проблема (>10 мин исследования)
- Найден workaround для неочевидного бага
- Обнаружен проектный паттерн
- Пользователь говорит `/retrospective`

Или явно через:
```
Сохрани это как skill
```
