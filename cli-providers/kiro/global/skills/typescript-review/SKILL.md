---
name: typescript-review
description: Review TypeScript и JavaScript кода на соответствие стандартам, стилю и качеству. Применяется при review pull requests или diffs с TypeS...
---
# TypeScript Code Review

Review TypeScript и JavaScript кода на соответствие стандартам, стилю и качеству. Применяется при review pull requests или diffs с TypeScript/JavaScript кодом.

## Основные аспекты review

### 1. Соответствие стандартам проекта

Проверяйте соблюдение coding standards и conventions:

✅ **Правильно:**
```typescript
// Consistent naming conventions
interface UserProfile {
  firstName: string;
  lastName: string;
  email: string;
}

function getUserProfile(userId: string): Promise<UserProfile> {
  return fetchUser(userId);
}
```

❌ **Неправильно:**
```typescript
// Inconsistent naming
interface user_profile {
  first_name: string;
  LastName: string;
  EMAIL: string;
}

function get_user_profile(user_id: string): Promise<user_profile> {
  return fetchUser(user_id);
}
```

### 2. Type Safety

Проверяйте правильное использование TypeScript типов:

✅ **Правильно:**
```typescript
// Explicit types, no any
interface ApiResponse<T> {
  data: T;
  status: number;
  error?: string;
}

function fetchData<T>(url: string): Promise<ApiResponse<T>> {
  return fetch(url).then(res => res.json());
}
```

❌ **Неправильно:**
```typescript
// Using any, implicit types
function fetchData(url: string): Promise<any> {
  return fetch(url).then(res => res.json());
}

// No type checking
const data = fetchData("/api/users");
data.then(result => {
  console.log(result.whatever); // No type safety
});
```

### 3. JSDoc комментарии

Проверяйте наличие и корректность JSDoc:

✅ **Правильно:**
```typescript
/**
 * Fetches user profile by ID
 * @param userId - The unique user identifier
 * @returns Promise resolving to user profile
 * @throws {NotFoundError} When user doesn't exist
 */
async function getUserProfile(userId: string): Promise<UserProfile> {
  const response = await fetch(`/api/users/${userId}`);
  if (!response.ok) {
    throw new NotFoundError(`User ${userId} not found`);
  }
  return response.json();
}
```


❌ **Неправильно:**
```typescript
// No documentation
async function getUserProfile(userId: string): Promise<UserProfile> {
  const response = await fetch(`/api/users/${userId}`);
  if (!response.ok) {
    throw new NotFoundError(`User ${userId} not found`);
  }
  return response.json();
}
```

### 4. React Best Practices

Для React кода проверяйте:

✅ **Правильно:**
```typescript
// Proper hooks usage
function UserProfile({ userId }: { userId: string }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    
    fetchUser(userId).then(data => {
      if (!cancelled) {
        setUser(data);
        setLoading(false);
      }
    });

    return () => {
      cancelled = true;
    };
  }, [userId]);

  if (loading) return <Spinner />;
  if (!user) return <NotFound />;
  
  return <div>{user.name}</div>;
}
```

❌ **Неправильно:**
```typescript
// Missing cleanup, no loading state
function UserProfile({ userId }: { userId: string }) {
  const [user, setUser] = useState<User | null>(null);

  useEffect(() => {
    fetchUser(userId).then(setUser);
  }, [userId]);

  return <div>{user?.name}</div>; // Can be undefined
}
```

## Code Quality Checklist

### Общее качество

- [ ] Нет использования `any` без веской причины
- [ ] Все функции имеют явные типы возвращаемых значений
- [ ] Используются union types вместо optional chaining где возможно
- [ ] Нет дублирования кода
- [ ] Функции делают одну вещь
- [ ] Переменные имеют понятные имена

### TypeScript специфика

- [ ] Используются type guards для narrowing
- [ ] Generic types используются правильно
- [ ] Нет type assertions без необходимости
- [ ] Используются readonly где возможно
- [ ] Enum vs union types выбраны правильно

### React специфика

- [ ] Hooks используются правильно (порядок, dependencies)
- [ ] Нет лишних re-renders
- [ ] Event handlers мемоизированы где нужно
- [ ] Cleanup в useEffect где необходимо
- [ ] Key props для списков


### Производительность

- [ ] Нет ненужных вычислений в render
- [ ] Используется lazy loading где уместно
- [ ] Оптимизированы bundle sizes
- [ ] Нет memory leaks (subscriptions, timers)

## Антипаттерны

❌ **Type assertions вместо type guards:**
```typescript
function processValue(value: unknown) {
  const str = value as string; // Опасно
  return str.toUpperCase();
}
```

✅ **Правильно:**
```typescript
function processValue(value: unknown): string {
  if (typeof value !== "string") {
    throw new TypeError("Expected string");
  }
  return value.toUpperCase();
}
```

❌ **Мутация props в React:**
```typescript
function Component({ items }: { items: string[] }) {
  items.push("new"); // Мутация props!
  return <div>{items.length}</div>;
}
```

✅ **Правильно:**
```typescript
function Component({ items }: { items: string[] }) {
  const [localItems, setLocalItems] = useState(items);
  
  const addItem = () => {
    setLocalItems([...localItems, "new"]);
  };
  
  return <div>{localItems.length}</div>;
}
```

❌ **Игнорирование ошибок:**
```typescript
async function fetchData() {
  try {
    return await fetch("/api/data");
  } catch (e) {
    // Пустой catch
  }
}
```

✅ **Правильно:**
```typescript
async function fetchData() {
  try {
    return await fetch("/api/data");
  } catch (e) {
    logger.error("Failed to fetch data", e);
    throw new DataFetchError("Unable to fetch data", { cause: e });
  }
}
```

## Review Process

### 1. Первый проход - структура

- Архитектура изменений логична?
- Файлы организованы правильно?
- Нет ли дублирования?

### 2. Второй проход - детали

- Типы корректны?
- Обработка ошибок присутствует?
- Edge cases покрыты?

### 3. Третий проход - стиль

- Соответствие code style?
- JSDoc комментарии?
- Понятные имена?

## Ресурсы

- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [React TypeScript Cheatsheet](https://react-typescript-cheatsheet.netlify.app/)
- [TypeScript Deep Dive](https://basarat.gitbook.io/typescript/)
