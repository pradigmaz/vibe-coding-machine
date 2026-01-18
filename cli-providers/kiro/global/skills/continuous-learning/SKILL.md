# Continuous Learning Skill

## Назначение

Система непрерывного обучения: извлекает знания из сессий и сохраняет как новые skills. Активируется когда:
- Решена нетривиальная проблема (>10 мин исследования)
- Найден workaround для неочевидного бага
- Обнаружен проектный паттерн, которого нет в документации
- Пользователь говорит `/retrospective`

## Когда извлекать skill

### ✅ Извлекай

1. **Нетривиальные решения**: Debugging техники, workarounds, решения требующие исследования
2. **Проектные паттерны**: Конвенции, конфигурации, архитектурные решения специфичные для кодбейза
3. **Интеграция инструментов**: Как правильно использовать библиотеку/API когда документация не помогает
4. **Решение ошибок**: Конкретные error messages и их реальные причины/фиксы
5. **Оптимизация workflow**: Многошаговые процессы которые можно упростить

### ❌ Не извлекай

- Простые lookup в документации
- Одноразовые решения
- Очевидные вещи
- Непроверенные теории

## Критерии качества

Перед извлечением проверь:
- **Переиспользуемо**: Поможет в будущих задачах?
- **Нетривиально**: Требует discovery, не просто чтение доков?
- **Специфично**: Можно описать точные trigger conditions?
- **Проверено**: Решение реально работает?

## Процесс извлечения

### Шаг 1: Идентифицируй знание

- Какая была проблема?
- Что было неочевидно в решении?
- Что нужно знать чтобы решить это быстрее в следующий раз?
- Какие точные trigger conditions (error messages, симптомы)?

### Шаг 2: Исследуй best practices (когда нужно)

**Всегда ищи**:
- Best practices для технологии/фреймворка
- Текущую документацию или изменения API
- Известные gotchas или pitfalls
- Альтернативные подходы

**Когда искать**:
- Тема связана с конкретными технологиями/фреймворками
- Не уверен в current best practices
- Решение могло измениться после Jan 2025
- Есть официальная документация

**Когда пропустить**:
- Проектные паттерны уникальные для этого кодбейза
- Контекстно-специфичные решения
- Стабильные концепции программирования

**Стратегия поиска**:
```
1. "[технология] [фича] official docs 2026"
2. "[технология] [проблема] best practices 2026"
3. "[технология] [error message] solution 2026"
4. Добавь References секцию в skill
```

### Шаг 3: Структура skill

```markdown
# [Название] Skill

## Назначение
[Краткое описание проблемы которую решает skill]

## Проблема
[Детальное описание проблемы]

## Trigger Conditions
[Когда использовать? Точные error messages, симптомы, сценарии]

## Решение

### Шаг 1
[Инструкции с примерами кода]

### Шаг 2
[Продолжение]

## Проверка
[Как проверить что решение работает]

## Пример

**До**:
```
[Код с ошибкой]
```

**После**:
```
[Исправленный код]
```

## Заметки
- [Caveats]
- [Edge cases]
- [Когда НЕ использовать]

## References
- [Ссылки на документацию]
```

### Шаг 4: Сохрани skill

**Проектные skills**: `.kiro/skills/[skill-name]/SKILL.md`
**Глобальные skills**: `cli-providers/kiro/global/skills/[skill-name]/SKILL.md`

## Retrospective Mode

Когда пользователь говорит `/retrospective`:

1. **Review сессии**: Анализируй историю для извлекаемых знаний
2. **Идентифицируй кандидатов**: Список потенциальных skills
3. **Приоритизируй**: Фокус на самых ценных
4. **Извлеки**: Создай 1-3 skills
5. **Суммаризируй**: Отчет что создано и почему

## Self-Reflection Prompts

Во время работы спрашивай себя:
- "Что я узнал что не было очевидно?"
- "Если я столкнусь с этим снова, что бы я хотел знать?"
- "Какой error message привел сюда и какова реальная причина?"
- "Это специфично для проекта или поможет в похожих проектах?"

## Quality Gates

Перед финализацией skill:
- [ ] Описание содержит конкретные trigger conditions
- [ ] Решение проверено
- [ ] Контент достаточно специфичен чтобы быть actionable
- [ ] Контент достаточно общий чтобы быть reusable
- [ ] Нет sensitive информации (credentials, internal URLs)
- [ ] Не дублирует существующую документацию
- [ ] Web research проведен когда нужно
- [ ] References секция добавлена если использовались источники

## Anti-Patterns

❌ **Избегай**:
- **Over-extraction**: Не каждая задача заслуживает skill
- **Vague descriptions**: "Помогает с React проблемами" — плохо
- **Unverified solutions**: Только то что реально работает
- **Documentation duplication**: Не переписывай официальные доки
- **Stale knowledge**: Помечай версии и даты

## Пример: Полный процесс

**Сценарий**: При debugging Next.js обнаружил что ошибки `getServerSideProps` не показываются в browser console потому что они server-side, реальная ошибка в терминале.

**Шаг 1 - Идентификация**:
- Проблема: Server-side ошибки не в browser console
- Неочевидно: Ожидаемое поведение для server-side кода в Next.js
- Trigger: Generic error page с пустым browser console

**Шаг 2 - Research**:
Поиск: "Next.js getServerSideProps error handling best practices 2026"
- Нашел официальные доки по error handling
- Обнаружил рекомендуемые паттерны для try-catch
- Узнал про error boundaries для server components

**Шаг 3-4 - Создание**:

```markdown
# Next.js Server-Side Error Debugging Skill

## Назначение
Debug getServerSideProps и getStaticProps ошибок в Next.js когда browser console пустой.

## Проблема
Server-side ошибки в Next.js не появляются в browser console, что затрудняет debugging.

## Trigger Conditions
- Страница показывает "Internal Server Error"
- Browser console пустой
- Используется getServerSideProps, getStaticProps, или API routes
- Ошибка только при navigation/refresh

## Решение

### Шаг 1: Проверь терминал
Смотри терминал где запущен `npm run dev` — ошибки там

### Шаг 2: Production logs
Для production: Vercel dashboard, CloudWatch, etc.

### Шаг 3: Добавь try-catch
```typescript
export async function getServerSideProps() {
  try {
    const data = await fetchData();
    return { props: { data } };
  } catch (error) {
    console.error('Server error:', error);
    return { notFound: true };
  }
}
```

## Проверка
В терминале должен быть stack trace с файлом и номером строки.

## Пример

**До**:
```
// Browser: пустой console
// Страница: "Internal Server Error"
```

**После**:
```
// Terminal:
// Error: Cannot read property 'id' of undefined
//   at getServerSideProps (pages/user.tsx:12:20)
```

## Заметки
- Применимо ко всему server-side коду в Next.js
- В dev Next.js иногда показывает modal с частичной ошибкой
- `reactStrictMode` может вызывать double-execution

## References
- [Next.js Data Fetching](https://nextjs.org/docs/pages/building-your-application/data-fetching/get-server-side-props)
- [Next.js Error Handling](https://nextjs.org/docs/pages/building-your-application/routing/error-handling)
```

## Интеграция с Workflow

### Автоматические триггеры

Активируй skill сразу после задачи если:
1. **Нетривиальный debugging**: >10 мин исследования, не найдено в доках
2. **Решение ошибки**: Error message был misleading
3. **Workaround discovery**: Нашел workaround через эксперименты
4. **Configuration insight**: Обнаружил проектную настройку отличную от стандарта
5. **Trial-and-error success**: Попробовал несколько подходов

### Явный вызов

Также активируй когда:
- Пользователь говорит `/retrospective`
- Пользователь говорит "сохрани это как skill"
- Пользователь спрашивает "что мы узнали?"

### Self-Check после задачи

После каждой значимой задачи спроси себя:
- "Я потратил время на исследование чего-то?"
- "Будущему мне это пригодится?"
- "Решение было неочевидно из документации?"

Если да — активируй skill немедленно.

## Цель

Непрерывное автономное улучшение. Каждое ценное открытие должно помочь будущим сессиям.
