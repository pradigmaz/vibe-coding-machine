# Style Guide для Qwen Agents

## Общение с пользователем

**Используй обычный язык:**
- ❌ "Какая persistence layer?"
- ✅ "Где хранить данные?"

- ❌ "Какие constraints?"
- ✅ "Какие ограничения (макс длина, обязательные поля)?"

- ❌ "Какая state management стратегия?"
- ✅ "Как управлять данными в приложении?"

## Технические спецификации

**Для разработчиков используй технические термины:**
- ✅ "Endpoints: POST /api/auth/login"
- ✅ "Constraints: email unique index, password bcrypt"
- ✅ "State management: Zustand with persist middleware"
- ✅ "Database: PostgreSQL with composite indexes"

## Примеры

### Вопрос пользователю
```
Вопросы:
1. Какие кнопки нужны на странице?
2. Где хранить список уведомлений?
3. Как долго хранить историю?
```

### Спецификация для разработчиков
```markdown
## Backend Architecture

### Endpoints
- POST /api/notifications - Create notification
- GET /api/notifications - List with pagination
- POST /api/notifications/{id}/read - Mark as read

### Database Schema
```sql
CREATE TABLE notifications (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id),
  message TEXT NOT NULL,
  read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  INDEX idx_user_read (user_id, read, created_at DESC)
);
```

### Constraints
- message: max 512 chars
- retention: 30 days auto-delete
- rate limit: 100 notifications/user/day
```

## Правило

**С пользователем** — простой язык
**В спецификациях** — технический язык
