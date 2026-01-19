---
name: code-standards
description: Стандарты кода для разных языков программирования. Используется всеми агентами для поддержания качества к...
---
# Code Standards Skill

## Назначение

Стандарты кода для разных языков программирования. Используется всеми агентами для поддержания качества кода.

## Общие принципы

### Именование

```typescript
// ✅ GOOD: Понятные, описательные имена
const activeUserCount = users.filter(u => u.isActive).length;
function calculateTotalPrice(items: CartItem[]): number { }
class UserAuthenticationService { }

// ❌ BAD: Непонятные сокращения
const auc = users.filter(u => u.isActive).length;
function calc(items: any[]): number { }
class UAS { }
```

### Функции

**Правило одной ответственности**:
```typescript
// ✅ GOOD: Одна функция = одна задача
function validateEmail(email: string): boolean {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function sendWelcomeEmail(user: User): Promise<void> {
  return emailService.send({
    to: user.email,
    template: 'welcome',
    data: { name: user.name }
  });
}

// ❌ BAD: Функция делает слишком много
function processUser(email: string, name: string) {
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    throw new Error('Invalid email');
  }
  const user = db.users.create({ email, name });
  emailService.send({ to: email, template: 'welcome' });
  logger.info('User created');
  return user;
}
```

**Размер функции**: Максимум 20-30 строк. Если больше - разбивай.

### Комментарии

```typescript
// ✅ GOOD: Объясняет "почему", не "что"
// Using exponential backoff to avoid overwhelming the API
// after rate limit errors
await retryWithBackoff(() => api.call());

// ✅ GOOD: Документация для публичного API
/**
 * Calculates the total price including tax and discounts.
 * 
 * @param items - Cart items to calculate price for
 * @param taxRate - Tax rate as decimal (e.g., 0.2 for 20%)
 * @returns Total price in cents
 */
function calculateTotal(items: CartItem[], taxRate: number): number { }

// ❌ BAD: Очевидные комментарии
// Increment counter by 1
counter++;

// ❌ BAD: Закомментированный код
// const oldImplementation = () => { ... };
```

## TypeScript/JavaScript Standards

### Типизация

```typescript
// ✅ GOOD: Явные типы для публичного API
interface User {
  id: string;
  email: string;
  name: string;
  createdAt: Date;
}

function getUser(id: string): Promise<User | null> { }

// ✅ GOOD: Type guards
function isUser(value: unknown): value is User {
  return (
    typeof value === 'object' &&
    value !== null &&
    'id' in value &&
    'email' in value
  );
}

// ❌ BAD: any везде
function processData(data: any): any { }
```

### Async/Await

```typescript
// ✅ GOOD: Async/await для читаемости
async function fetchUserData(userId: string) {
  try {
    const user = await userService.getUser(userId);
    const posts = await postService.getUserPosts(userId);
    return { user, posts };
  } catch (error) {
    logger.error('Failed to fetch user data', { userId, error });
    throw error;
  }
}

// ❌ BAD: Promise chains
function fetchUserData(userId: string) {
  return userService.getUser(userId)
    .then(user => {
      return postService.getUserPosts(userId)
        .then(posts => ({ user, posts }));
    })
    .catch(error => {
      logger.error('Failed', error);
      throw error;
    });
}
```

### Деструктуризация

```typescript
// ✅ GOOD: Деструктуризация для читаемости
const { id, email, name } = user;
const [first, second, ...rest] = items;

// ✅ GOOD: Деструктуризация в параметрах
function createUser({ email, name, role = 'user' }: CreateUserInput) { }

// ❌ BAD: Повторяющиеся обращения
console.log(user.email);
console.log(user.name);
console.log(user.role);
```

## Python Standards

### PEP 8 Compliance

```python
# ✅ GOOD: PEP 8 naming
class UserService:
    def get_user_by_email(self, email: str) -> User | None:
        pass

MAX_RETRY_COUNT = 3
user_count = len(users)

# ❌ BAD: Non-PEP 8
class userService:
    def GetUserByEmail(self, Email: str) -> User | None:
        pass

maxRetryCount = 3
UserCount = len(users)
```

### Type Hints

```python
# ✅ GOOD: Type hints для всех публичных функций
from typing import List, Optional, Dict

def process_users(
    users: List[User],
    filters: Optional[Dict[str, str]] = None
) -> List[User]:
    """Process users with optional filters."""
    if filters is None:
        filters = {}
    return [u for u in users if matches_filters(u, filters)]

# ❌ BAD: Без type hints
def process_users(users, filters=None):
    if filters is None:
        filters = {}
    return [u for u in users if matches_filters(u, filters)]
```

### Context Managers

```python
# ✅ GOOD: Context managers для ресурсов
with open('file.txt', 'r') as f:
    content = f.read()

with db.transaction():
    user = db.users.create(data)
    db.audit_log.create({'action': 'user_created'})

# ❌ BAD: Ручное управление ресурсами
f = open('file.txt', 'r')
content = f.read()
f.close()  # Может не выполниться при ошибке
```

## Go Standards

### Error Handling

```go
// ✅ GOOD: Явная обработка ошибок
func GetUser(id string) (*User, error) {
    user, err := db.FindUser(id)
    if err != nil {
        return nil, fmt.Errorf("failed to get user %s: %w", id, err)
    }
    return user, nil
}

// ❌ BAD: Игнорирование ошибок
func GetUser(id string) *User {
    user, _ := db.FindUser(id)
    return user
}
```

### Naming Conventions

```go
// ✅ GOOD: Go naming conventions
type UserService struct {
    db *Database
}

func (s *UserService) GetUserByEmail(email string) (*User, error) { }

const MaxRetryCount = 3
var userCount = len(users)

// ❌ BAD: Non-Go style
type User_Service struct {
    DB *Database
}

func (s *User_Service) get_user_by_email(Email string) (*User, error) { }
```

## Rust Standards

### Ownership & Borrowing

```rust
// ✅ GOOD: Правильное использование borrowing
fn process_user(user: &User) -> String {
    format!("Processing {}", user.name)
}

fn update_user(user: &mut User, name: String) {
    user.name = name;
}

// ✅ GOOD: Ownership transfer когда нужно
fn consume_user(user: User) {
    // user moved here
}
```

### Error Handling

```rust
// ✅ GOOD: Result для обработки ошибок
fn get_user(id: &str) -> Result<User, DatabaseError> {
    db.find_user(id)
        .ok_or(DatabaseError::NotFound)
}

// ✅ GOOD: ? operator для propagation
fn process_user(id: &str) -> Result<ProcessedUser, Error> {
    let user = get_user(id)?;
    let posts = get_posts(id)?;
    Ok(ProcessedUser { user, posts })
}
```

## Code Review Checklist

```
Code Standards Review:
- [ ] Именование понятное и консистентное
- [ ] Функции короткие (< 30 строк) и делают одно дело
- [ ] Нет дублирования кода (DRY)
- [ ] Типы указаны явно (TypeScript/Python)
- [ ] Ошибки обрабатываются правильно
- [ ] Комментарии объясняют "почему", не "что"
- [ ] Нет закомментированного кода
- [ ] Нет magic numbers (используются константы)
- [ ] Нет глубокой вложенности (max 3 уровня)
- [ ] Код следует принципам SOLID
```

## Форматирование

### TypeScript/JavaScript
```bash
# Prettier
npm install --save-dev prettier
npx prettier --write "src/**/*.{ts,tsx,js,jsx}"

# ESLint
npm install --save-dev eslint
npx eslint --fix "src/**/*.{ts,tsx,js,jsx}"
```

### Python
```bash
# Black
pip install black
black .

# isort
pip install isort
isort .

# Ruff (быстрая альтернатива)
pip install ruff
ruff check --fix .
```

### Go
```bash
# gofmt (встроен)
gofmt -w .

# goimports
go install golang.org/x/tools/cmd/goimports@latest
goimports -w .
```

### Rust
```bash
# rustfmt (встроен)
cargo fmt
```

## Метрики качества кода

### Cyclomatic Complexity
- **1-10**: Простой код, легко тестировать
- **11-20**: Умеренная сложность, требует внимания
- **21+**: Высокая сложность, нужен рефакторинг

### Code Coverage
- **Минимум**: 70%
- **Цель**: 80-90%
- **Не гонись за 100%**: Фокус на критичном коде

### Technical Debt
Отслеживай через:
- TODO комментарии
- FIXME комментарии
- Deprecated функции
- Закомментированный код
