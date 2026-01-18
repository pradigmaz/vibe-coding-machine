# Planning with Files: Детальные примеры

## Пример 1: Feature Development - Dark Mode Toggle

### Запрос пользователя
"Добавь dark mode toggle на страницу настроек"

### Паттерн 3-х файлов в действии

#### task_plan.md
```markdown
# Task Plan: Dark Mode Toggle

## Цель
Добавить функциональный dark mode toggle в настройки.

## Текущая фаза
Phase 3

## Фазы

### Phase 1: Исследование существующей theme системы
- [x] Изучить текущую theme систему
- [x] Проверить есть ли уже dark theme
- [x] Задокументировать находки в findings.md
- **Status:** complete

### Phase 2: Дизайн подхода к реализации
- [x] Решить где хранить preference (localStorage)
- [x] Выбрать подход к theme switching (CSS custom properties)
- [x] Спланировать структуру компонентов
- **Status:** complete

### Phase 3: Реализация toggle компонента
- [ ] Создать ThemeToggle компонент (ТЕКУЩАЯ)
- [ ] Добавить в SettingsPage
- [ ] Стилизовать toggle
- **Status:** in_progress

### Phase 4: Добавление theme switching логики
- [ ] Создать useTheme hook
- [ ] Реализовать переключение themes
- [ ] Добавить persistence в localStorage
- **Status:** pending

### Phase 5: Тестирование и полировка
- [ ] Протестировать переключение
- [ ] Проверить persistence между сессиями
- [ ] Проверить accessibility
- **Status:** pending

## Ключевые вопросы
1. Где хранить theme preference? → localStorage ✓
2. Как реализовать switching? → CSS custom properties ✓
3. Нужен ли server-side rendering support? → Нет, client-only

## Принятые решения
| Решение | Обоснование |
|---------|-------------|
| CSS custom properties для theme | Нативная поддержка, легко переключать |
| localStorage для persistence | Простой API, работает без backend |
| Toggle в SettingsPage.tsx | Логичное место для настроек |
| useTheme custom hook | Переиспользуемая логика |

## Встреченные ошибки
| Ошибка | Попытка | Решение |
|--------|---------|---------|
| Flash of wrong theme on load | 1 | Добавил inline script в HTML head |

## Status
**Currently in Phase 3** - Строим toggle компонент
```

#### findings.md
```markdown
# Findings: Dark Mode Implementation

## Требования
- Toggle компонент на странице настроек
- Переключение между light и dark themes
- Сохранение preference между сессиями
- Плавный переход между themes

## Результаты исследований

### Существующая Theme система
- **Расположение**: src/styles/theme.ts
- **Использует**: CSS custom properties
- **Текущие themes**: только light
- **Структура**:
  ```typescript
  export const lightTheme = {
    '--bg-primary': '#ffffff',
    '--bg-secondary': '#f5f5f5',
    '--text-primary': '#000000',
    '--text-secondary': '#666666'
  };
  ```

### Файлы для модификации
1. `src/styles/theme.ts` - Добавить dark theme colors
2. `src/components/SettingsPage.tsx` - Добавить toggle
3. `src/hooks/useTheme.ts` - Создать новый hook
4. `src/App.tsx` - Обернуть в ThemeProvider (если нужно)

## Технические решения
| Решение | Обоснование |
|---------|-------------|
| CSS custom properties | Нативная поддержка, нет runtime overhead |
| localStorage | Простой API, не требует backend |
| useTheme hook | Инкапсулирует логику, переиспользуемо |
| Inline script для SSR | Предотвращает flash of wrong theme |

## Встреченные проблемы
| Проблема | Решение |
|----------|---------|
| Flash of wrong theme | Inline script в HTML head читает localStorage до render |
| TypeScript errors в theme.ts | Добавил proper typing для theme object |

## Ресурсы
- [CSS Custom Properties MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/--*)
- [localStorage API](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage)
- [React useEffect for theme](https://react.dev/reference/react/useEffect)

## Визуальные/Браузерные находки
- Существующий UI использует Material-UI компоненты
- Settings page имеет card layout
- Нужен Switch компонент для toggle (уже есть в проекте)

## Color Decisions для Dark Theme
- Dark background: `#1a1a2e`
- Dark surface: `#16213e`
- Dark text: `#eaeaea`
- Dark text secondary: `#a0a0a0`
- Accent color: остается тот же (`#3b82f6`)
```

#### progress.md
```markdown
# Progress Log

## Session: 2026-01-18

### Phase 1: Исследование существующей theme системы
- **Status:** complete
- **Started:** 2026-01-18 10:00
- **Completed:** 2026-01-18 10:15
- Actions taken:
  - Прочитал src/styles/theme.ts
  - Проверил package.json для theme библиотек
  - Изучил существующие компоненты
  - Задокументировал структуру в findings.md
- Files created/modified:
  - findings.md (created)
  - task_plan.md (updated)

### Phase 2: Дизайн подхода к реализации
- **Status:** complete
- **Started:** 2026-01-18 10:15
- **Completed:** 2026-01-18 10:30
- Actions taken:
  - Решил использовать CSS custom properties
  - Выбрал localStorage для persistence
  - Спланировал структуру useTheme hook
  - Обновил task_plan.md с решениями
- Files created/modified:
  - task_plan.md (updated - добавлены решения)
  - findings.md (updated - добавлены технические решения)

### Phase 3: Реализация toggle компонента
- **Status:** in_progress
- **Started:** 2026-01-18 10:30
- Actions taken:
  - Создал src/hooks/useTheme.ts
  - Добавил dark theme в src/styles/theme.ts
  - Начал работу над ThemeToggle компонентом
- Files created/modified:
  - src/hooks/useTheme.ts (created)
  - src/styles/theme.ts (modified - добавлен darkTheme)

### Phase 4: Добавление theme switching логики
- **Status:** pending

### Phase 5: Тестирование и полировка
- **Status:** pending

## Результаты тестов
| Тест | Вход | Ожидаемо | Фактически | Статус |
|------|------|----------|------------|--------|
| Theme switching | Click toggle | Theme changes | - | Pending |
| Persistence | Refresh page | Theme persists | - | Pending |
| Initial load | Open app | Correct theme | - | Pending |

## Лог ошибок
| Timestamp | Ошибка | Попытка | Решение |
|-----------|--------|---------|---------|
| 2026-01-18 10:45 | Flash of wrong theme on load | 1 | Добавил inline script в HTML head |
| 2026-01-18 10:50 | TypeScript error: Property '--bg-primary' does not exist | 2 | Добавил proper typing для theme object |

## Проверка 5-ти вопросов
| Вопрос | Ответ |
|--------|-------|
| Где я? | Phase 3 - Реализация toggle компонента |
| Куда я иду? | Phase 4 (theme switching), Phase 5 (testing) |
| Какая цель? | Добавить функциональный dark mode toggle в настройки |
| Что я узнал? | См. findings.md - структура theme системы, решения |
| Что я сделал? | Исследовал систему, спланировал подход, начал реализацию |
```

### Workflow Loop

```
Loop 1: Создание плана
→ Write task_plan.md
→ Write findings.md
→ Write progress.md

Loop 2-3: Исследование (Phase 1)
→ Read task_plan.md (освежить цели)
→ Read src/styles/theme.ts
→ Read package.json
→ Write findings.md (задокументировать находки)
→ Edit task_plan.md (отметить Phase 1 complete)
→ Edit progress.md (залогировать действия)

Loop 4-5: Планирование (Phase 2)
→ Read task_plan.md (освежить цели)
→ Read findings.md (получить контекст)
→ Edit task_plan.md (добавить решения, отметить Phase 2 complete)
→ Edit findings.md (добавить технические решения)
→ Edit progress.md (залогировать действия)

Loop 6-10: Реализация (Phase 3)
→ Read task_plan.md (освежить цели)
→ Write src/hooks/useTheme.ts
→ Edit src/styles/theme.ts
→ Write src/components/ThemeToggle.tsx
→ Edit progress.md (залогировать файлы)
→ [Ошибка: Flash of wrong theme]
→ Edit task_plan.md (залогировать ошибку)
→ [Исправление: inline script]
→ Edit task_plan.md (залогировать решение)
```

## Пример 2: Bug Investigation - Memory Leak

### Запрос пользователя
"Приложение использует всё больше памяти со временем, найди и исправь memory leak"

### task_plan.md
```markdown
# Task Plan: Memory Leak Investigation

## Цель
Идентифицировать и исправить memory leak вызывающий рост использования памяти.

## Текущая фаза
Phase 2

## Фазы

### Phase 1: Воспроизведение проблемы
- [x] Запустить приложение с memory profiler
- [x] Воспроизвести сценарий использования
- [x] Подтвердить рост памяти
- [x] Задокументировать паттерн в findings.md
- **Status:** complete

### Phase 2: Профилирование и анализ
- [ ] Сделать heap snapshot до и после (ТЕКУЩАЯ)
- [ ] Идентифицировать объекты не освобождающиеся
- [ ] Найти код создающий эти объекты
- **Status:** in_progress

### Phase 3: Идентификация корневой причины
- [ ] Проанализировать код
- [ ] Найти где отсутствует cleanup
- [ ] Задокументировать причину
- **Status:** pending

### Phase 4: Реализация fix
- [ ] Добавить proper cleanup
- [ ] Протестировать fix
- [ ] Проверить что leak исправлен
- **Status:** pending

### Phase 5: Verification
- [ ] Запустить длительный тест
- [ ] Подтвердить стабильное использование памяти
- [ ] Задокументировать решение
- **Status:** pending

## Ключевые вопросы
1. Какой сценарий вызывает leak? → Navigation между страницами ✓
2. Какие объекты не освобождаются? → Event listeners (в процессе)
3. Где отсутствует cleanup? → (pending)

## Принятые решения
| Решение | Обоснование |
|---------|-------------|
| Chrome DevTools Memory Profiler | Стандартный инструмент, детальная информация |
| Heap snapshots для анализа | Показывает retained objects |

## Встреченные ошибки
| Ошибка | Попытка | Решение |
|--------|---------|---------|
| Heap snapshot слишком большой | 1 | Использовал comparison view между snapshots |

## Status
**Currently in Phase 2** - Профилирование heap snapshots
```

### findings.md
```markdown
# Findings: Memory Leak Investigation

## Требования
- Идентифицировать причину роста памяти
- Исправить leak
- Проверить что память стабильна после fix

## Результаты исследований

### Воспроизведение
- **Сценарий**: Navigate между Dashboard → Settings → Dashboard (повторять)
- **Паттерн**: Память растет ~5MB на каждый цикл
- **Время**: Leak заметен после ~10 циклов (~50MB рост)

### Профилирование (Chrome DevTools)
- **Heap snapshot 1** (после 1 цикла): 45MB
- **Heap snapshot 2** (после 10 циклов): 95MB
- **Разница**: 50MB retained objects

### Retained Objects (из comparison view)
```
Top retained objects:
1. (array) - 15MB - 1000 items
2. EventListener - 12MB - 500 instances
3. Detached DOM nodes - 8MB - 200 nodes
4. Closure contexts - 7MB - 300 instances
```

### Подозрительный код
Найдены потенциальные источники:
1. `src/components/Dashboard.tsx` - addEventListener без removeEventListener
2. `src/hooks/useWebSocket.ts` - WebSocket connection не закрывается
3. `src/components/Chart.tsx` - Chart.js instance не destroy

## Технические решения
| Решение | Обоснование |
|---------|-------------|
| useEffect cleanup для event listeners | React best practice для cleanup |
| useEffect cleanup для WebSocket | Закрывать connection при unmount |
| Chart.destroy() в cleanup | Chart.js требует explicit destroy |

## Встреченные проблемы
| Проблема | Решение |
|----------|---------|
| Heap snapshot слишком большой для анализа | Использовал comparison view |
| Не понятно какой код создает listeners | Использовал "Retainers" view в DevTools |

## Ресурсы
- [Chrome DevTools Memory Profiler](https://developer.chrome.com/docs/devtools/memory-problems/)
- [React useEffect cleanup](https://react.dev/reference/react/useEffect#cleanup-function)
- [Chart.js destroy](https://www.chartjs.org/docs/latest/developers/api.html#destroy)

## Визуальные/Браузерные находки
- DevTools Memory tab показывает steady growth
- Heap snapshot comparison показывает EventListener accumulation
- Retainers view указывает на Dashboard component
```

### Ключевые моменты

1. **Правило 2-х действий в действии**:
   - После heap snapshot 1 → Записал в findings.md
   - После heap snapshot 2 → Обновил findings.md с comparison

2. **Логирование ошибок**:
   - Heap snapshot слишком большой → Залогировано в task_plan.md
   - Решение найдено → Обновлено в той же таблице

3. **Перечитывание плана**:
   - Перед каждым heap snapshot → Read task_plan.md
   - Перед анализом кода → Read task_plan.md + findings.md

## Пример 3: API Integration - Stripe Payment

### Краткий overview

```markdown
# Task Plan: Stripe Payment Integration

## Цель
Интегрировать Stripe для обработки платежей в checkout flow.

## Фазы
- [x] Phase 1: Stripe account setup и API keys ✓
- [x] Phase 2: Backend endpoint для payment intent ✓
- [ ] Phase 3: Frontend checkout form (ТЕКУЩАЯ)
- [ ] Phase 4: Webhook для payment confirmation
- [ ] Phase 5: Testing с test cards

## Принятые решения
| Решение | Обоснование |
|---------|-------------|
| Stripe Elements для форм | PCI compliance из коробки |
| Payment Intents API | Современный подход, поддержка 3D Secure |
| Webhook для confirmation | Надежное подтверждение платежа |

## Встреченные ошибки
| Ошибка | Попытка | Решение |
|--------|---------|---------|
| CORS error при создании payment intent | 1 | Добавил stripe.com в CORS whitelist |
| Webhook signature verification failed | 2 | Использовал raw body вместо parsed JSON |
```

### Ключевые паттерны

1. **Исследование API** → findings.md:
   ```markdown
   ## Результаты исследований
   - Stripe Elements требует publishable key (client-side)
   - Payment Intent создается на backend с secret key
   - Webhook endpoint должен быть publicly accessible
   ```

2. **Логирование решений** → task_plan.md:
   ```markdown
   ## Принятые решения
   | Решение | Обоснование |
   |---------|-------------|
   | Payment Intents API | Поддержка 3D Secure, современный подход |
   ```

3. **Tracking ошибок** → task_plan.md + progress.md:
   ```markdown
   ## Встреченные ошибки
   | Ошибка | Попытка | Решение |
   |--------|---------|---------|
   | CORS error | 1 | Добавил stripe.com в whitelist |
   ```

## Общие паттерны из примеров

### Паттерн 1: Освежение контекста
```bash
# Перед каждым важным решением
cat task_plan.md | head -30
```

### Паттерн 2: Сохранение визуальной информации
```markdown
# После просмотра DevTools, browser, screenshots
## Визуальные/Браузерные находки
- DevTools показывает X
- Browser console показывает Y
- Screenshot показывает Z
```

### Паттерн 3: Логирование ошибок немедленно
```markdown
# Как только ошибка происходит
## Встреченные ошибки
| Ошибка | Попытка | Решение |
|--------|---------|---------|
| [Error message] | 1 | [Что пробуем] |
```

### Паттерн 4: Обновление статусов
```markdown
# После завершения фазы
### Phase 2: Planning
- **Status:** complete  # Было: in_progress
```

### Паттерн 5: Тест 5-ти вопросов
```markdown
# Периодически проверяй
| Вопрос | Ответ |
|--------|-------|
| Где я? | Phase 3 |
| Куда я иду? | Phase 4, 5 |
| Какая цель? | [из task_plan.md] |
| Что я узнал? | [из findings.md] |
| Что я сделал? | [из progress.md] |
```

## Заключение

Эти примеры показывают как planning-with-files работает на практике:

1. **Создавай план первым** - всегда
2. **Перечитывай перед решениями** - держит цели в фокусе
3. **Логируй всё важное** - ошибки, решения, находки
4. **Обновляй статусы** - видимый прогресс
5. **Сохраняй визуальное как текст** - правило 2-х действий

Результат: Даже после 50+ tool calls ты знаешь где ты, куда идешь, и что узнал.
