# Continuous Learning Skill для Kiro

Адаптация [claude-code-continuous-learning-skill](https://github.com/blader/claude-code-continuous-learning-skill) для Kiro CLI.

## Что это

Система автоматического извлечения знаний из сессий. Когда решаешь нетривиальную проблему — skill сохраняет решение для будущего использования.

## Установка

### Шаг 1: Skill уже установлен

Файлы в `cli-providers/kiro/global/skills/continuous-learning/`

### Шаг 2: Создай хук (опционально)

Хук напоминает агенту проверять каждую сессию на extractable knowledge.

**Создай файл**: `cli-providers/kiro/global/hooks/continuous-learning.json`

```json
{
  "name": "Continuous Learning",
  "version": "1.0.0",
  "description": "Напоминает агенту извлекать знания после каждой задачи",
  "when": {
    "type": "agentStop"
  },
  "then": {
    "type": "askAgent",
    "prompt": "ОБЯЗАТЕЛЬНАЯ ОЦЕНКА: Оцени завершенную задачу на extractable knowledge используя continuous-learning skill. Спроси себя: (1) Требовалось ли нетривиальное исследование? (2) Поможет ли это решение в будущем? (3) Было ли что-то неочевидное? Если ДА хотя бы на один вопрос — извлеки skill СЕЙЧАС."
  }
}
```

## Использование

### Автоматический режим

Skill активируется когда:
- Решена проблема требующая >10 мин исследования
- Найден workaround для неочевидного бага
- Обнаружен проектный паттерн
- Error message был misleading

### Явный режим

Скажи агенту:
```
/retrospective
```

Или:
```
Сохрани это как skill
```

### Что извлекается

Только знания которые:
- Требовали реального discovery (не просто чтение доков)
- Помогут в будущих задачах
- Имеют четкие trigger conditions
- Проверены и работают

## Примеры

См. `examples/` в оригинальном репо:
- `nextjs-server-side-error-debugging/` - Next.js server-side ошибки
- `prisma-connection-pool-exhaustion/` - Prisma connection pool
- `typescript-circular-dependency/` - TypeScript circular deps

## Формат skill

```markdown
# [Название] Skill

## Назначение
[Краткое описание]

## Проблема
[Что решает]

## Trigger Conditions
- [Точный error message]
- [Симптомы]

## Решение
[Пошаговое решение]

## Проверка
[Как проверить]

## Пример
[Конкретный пример]

## Заметки
[Caveats, edge cases]

## References
[Ссылки на доки]
```

## Отличия от Claude Code версии

1. **Формат**: Без YAML frontmatter, только markdown
2. **Хуки**: JSON вместо bash скриптов
3. **Путь**: `.kiro/skills/` вместо `.claude/skills/`
4. **Язык**: Русский (по умолчанию для Kiro CLI)

## Quality Gates

Перед созданием skill:
- [ ] Trigger conditions конкретные
- [ ] Решение проверено
- [ ] Достаточно специфично
- [ ] Достаточно общее для reuse
- [ ] Нет sensitive данных
- [ ] Не дублирует доки
- [ ] Web research проведен
- [ ] References добавлены

## Lifecycle

1. **Creation**: Извлечение с проверкой
2. **Refinement**: Обновление при новых use cases
3. **Deprecation**: Пометка когда устарело
4. **Archival**: Удаление неактуальных

## Следующие шаги

1. Используй skill в работе
2. Собирай feedback
3. Улучшай template по необходимости
4. Делись полезными extracted skills

## Research

Основано на:
- [Voyager](https://arxiv.org/abs/2305.16291) - skill libraries для AI агентов
- [CASCADE](https://arxiv.org/abs/2512.23880) - meta-skills
- [SEAgent](https://arxiv.org/abs/2508.04700) - learning через trial-and-error
- [Reflexion](https://arxiv.org/abs/2303.11366) - self-reflection

Агенты которые сохраняют знания работают лучше чем те что начинают с нуля.
