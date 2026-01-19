---
name: file-sizes
description: Ограничения на размеры файлов для поддержания читаемости и maintainability кода.
---
# File Sizes Skill

## Назначение

Ограничения на размеры файлов для поддержания читаемости и maintainability кода.

## Общие правила

### Максимальные размеры файлов

| Тип файла | Максимум строк | Рекомендуемый размер |
|-----------|----------------|----------------------|
| Component (React/Vue) | 300 | 150-200 |
| Service/Controller | 400 | 200-300 |
| Model/Entity | 200 | 100-150 |
| Utility/Helper | 150 | 50-100 |
| Test file | 500 | 200-300 |
| Config file | 100 | 50-80 |

### Когда файл слишком большой

**Признаки**:
- Больше 300 строк кода (без комментариев)
- Сложно найти нужную функцию
- Множество импортов (> 20)
- Несколько несвязанных концепций
- Сложно понять, что делает файл

**Действия**:
1. Анализируй структуру файла
2. Группируй связанные функции
3. Выноси в отдельные модули
4. Используй рефакторинг

## Стратегии разбиения

### 1. По ответственности (SRP)

```typescript
// ❌ BAD: Один большой файл (500 строк)
// UserService.ts
class UserService {
  // User CRUD
  createUser() { }
  updateUser() { }
  deleteUser() { }
  
  // Authentication
  login() { }
  logout() { }
  resetPassword() { }
  
  // Email
  sendWelcomeEmail() { }
  sendPasswordResetEmail() { }
  
  // Validation
  validateEmail() { }
  validatePassword() { }
}

// ✅ GOOD: Разделено по ответственности
// services/user/UserService.ts (150 строк)
class UserService {
  createUser() { }
  updateUser() { }
  deleteUser() { }
}

// services/auth/AuthService.ts (120 строк)
class AuthService {
  login() { }
  logout() { }
  resetPassword() { }
}

// services/email/EmailService.ts (100 строк)
class EmailService {
  sendWelcomeEmail() { }
  sendPasswordResetEmail() { }
}

// utils/validation.ts (80 строк)
export function validateEmail() { }
export function validatePassword() { }
```

### 2. По feature (Feature-based)

```
// ❌ BAD: Всё в одном компоненте
components/Dashboard.tsx (800 строк)

// ✅ GOOD: Разделено по features
features/
  dashboard/
    Dashboard.tsx (100 строк)
    components/
      UserStats.tsx (80 строк)
      RecentActivity.tsx (90 строк)
      QuickActions.tsx (70 строк)
    hooks/
      useDashboardData.ts (60 строк)
```

### 3. По слоям (Layered)

```
// ❌ BAD: Всё в одном файле
api/users.ts (600 строк)
  - Routes
  - Controllers
  - Services
  - Validation
  - DTOs

// ✅ GOOD: Разделено по слоям
api/users/
  routes.ts (50 строк)
  controller.ts (150 строк)
  service.ts (200 строк)
  validation.ts (80 строк)
  dto.ts (60 строк)
```

## React Component Refactoring

### Признаки большого компонента

```typescript
// ❌ BAD: Монолитный компонент (400+ строк)
function UserProfile() {
  // 10+ useState
  const [user, setUser] = useState();
  const [posts, setPosts] = useState();
  const [followers, setFollowers] = useState();
  // ... 7 more states
  
  // 5+ useEffect
  useEffect(() => { /* fetch user */ }, []);
  useEffect(() => { /* fetch posts */ }, []);
  // ... 3 more effects
  
  // 20+ event handlers
  const handleEditProfile = () => { };
  const handleUploadAvatar = () => { };
  // ... 18 more handlers
  
  // Сложный JSX (200+ строк)
  return (
    <div>
      {/* Header section */}
      {/* Profile info section */}
      {/* Posts section */}
      {/* Followers section */}
      {/* Settings section */}
    </div>
  );
}
```

### Рефакторинг

```typescript
// ✅ GOOD: Разделено на компоненты

// UserProfile.tsx (80 строк)
function UserProfile() {
  const { user, isLoading } = useUser();
  
  if (isLoading) return <LoadingSpinner />;
  
  return (
    <div>
      <ProfileHeader user={user} />
      <ProfileInfo user={user} />
      <UserPosts userId={user.id} />
      <UserFollowers userId={user.id} />
      <ProfileSettings user={user} />
    </div>
  );
}

// components/ProfileHeader.tsx (60 строк)
function ProfileHeader({ user }) {
  const { handleUploadAvatar } = useAvatarUpload();
  return (
    <header>
      <Avatar src={user.avatar} onUpload={handleUploadAvatar} />
      <h1>{user.name}</h1>
    </header>
  );
}

// hooks/useUser.ts (50 строк)
function useUser() {
  const [user, setUser] = useState();
  const [isLoading, setIsLoading] = useState(true);
  
  useEffect(() => {
    fetchUser().then(setUser).finally(() => setIsLoading(false));
  }, []);
  
  return { user, isLoading };
}
```

## Backend Service Refactoring

### Признаки большого сервиса

```python
# ❌ BAD: Монолитный сервис (600+ строк)
class UserService:
    # User CRUD (100 строк)
    def create_user(self): pass
    def update_user(self): pass
    def delete_user(self): pass
    
    # Authentication (150 строк)
    def login(self): pass
    def logout(self): pass
    def refresh_token(self): pass
    
    # Profile management (100 строк)
    def update_profile(self): pass
    def upload_avatar(self): pass
    
    # Social features (150 строк)
    def follow_user(self): pass
    def unfollow_user(self): pass
    def get_followers(self): pass
    
    # Notifications (100 строк)
    def send_notification(self): pass
    def get_notifications(self): pass
```

### Рефакторинг

```python
# ✅ GOOD: Разделено на сервисы

# services/user_service.py (150 строк)
class UserService:
    def create_user(self): pass
    def update_user(self): pass
    def delete_user(self): pass

# services/auth_service.py (180 строк)
class AuthService:
    def login(self): pass
    def logout(self): pass
    def refresh_token(self): pass

# services/profile_service.py (120 строк)
class ProfileService:
    def update_profile(self): pass
    def upload_avatar(self): pass

# services/social_service.py (170 строк)
class SocialService:
    def follow_user(self): pass
    def unfollow_user(self): pass
    def get_followers(self): pass

# services/notification_service.py (130 строк)
class NotificationService:
    def send_notification(self): pass
    def get_notifications(self): pass
```

## Утилиты и хелперы

### Группировка по функциональности

```typescript
// ❌ BAD: Один большой utils.ts (500 строк)
export function formatDate() { }
export function parseDate() { }
export function validateEmail() { }
export function validatePhone() { }
export function debounce() { }
export function throttle() { }
export function deepClone() { }
export function merge() { }

// ✅ GOOD: Разделено по категориям
utils/
  date.ts (80 строк)
    - formatDate
    - parseDate
    - addDays
    - diffDays
  
  validation.ts (100 строк)
    - validateEmail
    - validatePhone
    - validateURL
  
  function.ts (70 строк)
    - debounce
    - throttle
    - memoize
  
  object.ts (90 строк)
    - deepClone
    - merge
    - pick
    - omit
```

## Тестовые файлы

### Организация тестов

```typescript
// ❌ BAD: Один огромный тест файл (800 строк)
describe('UserService', () => {
  // 50+ тестов в одном файле
});

// ✅ GOOD: Разделено по функциональности
tests/
  UserService.create.test.ts (150 строк)
  UserService.update.test.ts (120 строк)
  UserService.delete.test.ts (100 строк)
  UserService.validation.test.ts (180 строк)
```

## Checklist для проверки размера файла

```
File Size Review:
- [ ] Файл меньше 300 строк?
- [ ] Файл имеет одну чёткую ответственность?
- [ ] Все функции в файле связаны между собой?
- [ ] Легко найти нужную функцию?
- [ ] Импортов меньше 20?
- [ ] Можно понять назначение файла за 30 секунд?
- [ ] Нет дублирования кода?
```

## Инструменты для анализа

### TypeScript/JavaScript
```bash
# Подсчёт строк
npx cloc src/

# Анализ сложности
npx eslint --plugin complexity src/

# Поиск больших файлов
find src -name "*.ts" -exec wc -l {} \; | sort -rn | head -10
```

### Python
```bash
# Подсчёт строк
cloc src/

# Анализ сложности
radon cc src/ -a

# Поиск больших файлов
find src -name "*.py" -exec wc -l {} \; | sort -rn | head -10
```

## Автоматизация

### Pre-commit hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

MAX_LINES=300

for file in $(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(ts|tsx|js|jsx|py)$'); do
  lines=$(wc -l < "$file")
  if [ "$lines" -gt "$MAX_LINES" ]; then
    echo "❌ $file has $lines lines (max: $MAX_LINES)"
    echo "   Consider splitting this file"
    exit 1
  fi
done
```

## Исключения

**Когда можно превысить лимит**:
- Generated code (Prisma schema, GraphQL types)
- Configuration files (webpack, tsconfig)
- Test fixtures с большими данными
- Migration files

**Но даже тогда**:
- Документируй почему файл большой
- Рассмотри возможность разбиения
- Добавь комментарии для навигации
