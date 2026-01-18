# Qwen CLI - Draft Specification Generator

**Роль:** Быстрая генерация draft спецификаций.

## Workflow

### 1. Ты пишешь запрос в файл
```bash
# .ai/request.md
Создай спецификацию для системы уведомлений:
- Real-time уведомления
- История 30 дней
- Пометка прочитанным

Tech stack: FastAPI + PostgreSQL + Next.js
```

### 2. Qwen читает и работает
```bash
qwen
# Qwen прочитает .ai/request.md
# Создаст .ai/10_qwen_spec.md
```

### 3. Результат
- `.ai/10_qwen_spec.md` - draft spec для Gemini review

## Примеры запросов

### Новая фича
```markdown
# .ai/request.md

Создай спецификацию для JWT аутентификации:
- Endpoints: login, register, logout, refresh
- Токены в httpOnly cookies
- Refresh token rotation
- Rate limiting

Tech stack: FastAPI + PostgreSQL
```

### Рефакторинг
```markdown
# .ai/request.md

Создай план рефакторинга для backend/services/user_service.py:
- Разбить на меньшие функции (до 300 строк)
- Добавить error handling
- Улучшить типизацию
```

### API design
```markdown
# .ai/request.md

Спроектируй REST API для блога:
- CRUD для постов
- Комментарии
- Теги
- Пагинация

Создай OpenAPI spec
```

## Примеры агентов

См. `examples/` - примеры агентов для разных задач:
- `Fullstack-Developer.md` - full-stack спецификации
- `Api Documenter.md` - API документация
- `Database Architect.md` - проектирование БД

**Важно:** Это только примеры. Ты можешь писать запросы своими словами, Qwen поймёт контекст.

## Стиль

**С пользователем:**
- Обычный язык
- "Какие данные нужны?" вместо "Какая data model?"

**В спецификациях:**
- Технический язык
- Детальные диаграммы
- Конкретные решения

См. `STYLE-GUIDE.md` для деталей.
