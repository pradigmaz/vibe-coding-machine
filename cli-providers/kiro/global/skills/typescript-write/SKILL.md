# TypeScript Development

Написание TypeScript и JavaScript кода следуя best practices и стандартам. Применяется при разработке или рефакторинге TypeScript/JavaScript кода.

## Основные принципы

### 1. Type-First подход

Начинайте с определения типов:

✅ **Правильно:**
```typescript
// Сначала типы
interface User {
  id: string;
  name: string;
  email: string;
  role: "admin" | "user" | "guest";
}

interface UserRepository {
  findById(id: string): Promise<User | null>;
  create(data: Omit<User, "id">): Promise<User>;
  update(id: string, data: Partial<User>): Promise<User>;
  delete(id: string): Promise<void>;
}

// Потом реализация
class UserRepositoryImpl implements UserRepository {
  async findById(id: string): Promise<User | null> {
    // Implementation
  }
  // ...
}
```

### 2. Избегайте any

Используйте unknown или конкретные типы:

✅ **Правильно:**
```typescript
function parseJSON<T>(json: string): T {
  return JSON.parse(json) as T;
}

function processValue(value: unknown): string {
  if (typeof value === "string") {
    return value.toUpperCase();
  }
  if (typeof value === "number") {
    return value.toString();
  }
  throw new TypeError("Unsupported type");
}
```

❌ **Неправильно:**
```typescript
function parseJSON(json: string): any {
  return JSON.parse(json);
}

function processValue(value: any): string {
  return value.toUpperCase(); // Может упасть
}
```

### 3. Используйте Type Guards

Создавайте type guards для runtime проверок:

✅ **Правильно:**
```typescript
interface Dog {
  type: "dog";
  bark(): void;
}

interface Cat {
  type: "cat";
  meow(): void;
}

type Animal = Dog | Cat;

function isDog(animal: Animal): animal is Dog {
  return animal.type === "dog";
}

function makeSound(animal: Animal) {
  if (isDog(animal)) {
    animal.bark(); // TypeScript знает что это Dog
  } else {
    animal.meow(); // TypeScript знает что это Cat
  }
}
```


### 4. Generics для переиспользования

Используйте generics для гибких типов:

✅ **Правильно:**
```typescript
interface ApiResponse<T> {
  data: T;
  status: number;
  timestamp: Date;
}

async function fetchApi<T>(url: string): Promise<ApiResponse<T>> {
  const response = await fetch(url);
  const data = await response.json();
  return {
    data,
    status: response.status,
    timestamp: new Date(),
  };
}

// Type-safe usage
const users = await fetchApi<User[]>("/api/users");
users.data.forEach(user => console.log(user.name));
```

### 5. Readonly для иммутабельности

Используйте readonly где возможно:

✅ **Правильно:**
```typescript
interface Config {
  readonly apiUrl: string;
  readonly timeout: number;
  readonly retries: number;
}

function createConfig(overrides?: Partial<Config>): Readonly<Config> {
  return Object.freeze({
    apiUrl: "https://api.example.com",
    timeout: 5000,
    retries: 3,
    ...overrides,
  });
}
```

## React Patterns

### Functional Components с TypeScript

✅ **Правильно:**
```typescript
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: "primary" | "secondary";
  disabled?: boolean;
}

function Button({ 
  label, 
  onClick, 
  variant = "primary",
  disabled = false 
}: ButtonProps) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`btn btn-${variant}`}
    >
      {label}
    </button>
  );
}
```

### Custom Hooks

✅ **Правильно:**
```typescript
interface UseApiOptions<T> {
  url: string;
  initialData?: T;
}

interface UseApiResult<T> {
  data: T | null;
  loading: boolean;
  error: Error | null;
  refetch: () => Promise<void>;
}

function useApi<T>({ url, initialData }: UseApiOptions<T>): UseApiResult<T> {
  const [data, setData] = useState<T | null>(initialData ?? null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  const fetchData = useCallback(async () => {
    try {
      setLoading(true);
      const response = await fetch(url);
      const json = await response.json();
      setData(json);
      setError(null);
    } catch (e) {
      setError(e as Error);
    } finally {
      setLoading(false);
    }
  }, [url]);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  return { data, loading, error, refetch: fetchData };
}
```


## Error Handling

### Typed Errors

Создавайте типизированные классы ошибок:

✅ **Правильно:**
```typescript
class ApiError extends Error {
  constructor(
    message: string,
    public statusCode: number,
    public response?: unknown
  ) {
    super(message);
    this.name = "ApiError";
  }
}

class ValidationError extends Error {
  constructor(
    message: string,
    public field: string,
    public value: unknown
  ) {
    super(message);
    this.name = "ValidationError";
  }
}

async function fetchUser(id: string): Promise<User> {
  const response = await fetch(`/api/users/${id}`);
  
  if (!response.ok) {
    throw new ApiError(
      "Failed to fetch user",
      response.status,
      await response.json()
    );
  }
  
  return response.json();
}
```

## Utility Types

Используйте встроенные utility types:

```typescript
// Partial - все поля optional
type UpdateUser = Partial<User>;

// Pick - выбрать поля
type UserCredentials = Pick<User, "email" | "password">;

// Omit - исключить поля
type CreateUser = Omit<User, "id" | "createdAt">;

// Record - объект с ключами типа K и значениями типа T
type UserMap = Record<string, User>;

// ReturnType - тип возвращаемого значения
type FetchResult = ReturnType<typeof fetchUser>;

// Parameters - типы параметров функции
type FetchParams = Parameters<typeof fetchUser>;
```

## Best Practices Checklist

### Типы

- [ ] Нет использования `any` без веской причины
- [ ] Используется `unknown` вместо `any` где возможно
- [ ] Все функции имеют явные типы возвращаемых значений
- [ ] Используются type guards для narrowing
- [ ] Generic types используются для переиспользования
- [ ] Readonly используется для иммутабельных данных

### Код

- [ ] Функции делают одну вещь
- [ ] Нет дублирования кода
- [ ] Переменные имеют понятные имена
- [ ] Обработка ошибок присутствует
- [ ] JSDoc комментарии для публичных API

### React

- [ ] Props интерфейсы определены
- [ ] Hooks используются правильно
- [ ] Dependencies в useEffect корректны
- [ ] Cleanup функции где необходимо
- [ ] Мемоизация где нужна

## Антипаттерны

❌ **Type assertions вместо proper typing:**
```typescript
const data = JSON.parse(json) as User; // Опасно
```

✅ **Правильно:**
```typescript
function parseUser(json: string): User {
  const data = JSON.parse(json);
  if (!isUser(data)) {
    throw new ValidationError("Invalid user data");
  }
  return data;
}
```


❌ **Игнорирование null/undefined:**
```typescript
function getUser(id: string): User {
  return users.find(u => u.id === id); // Может быть undefined
}
```

✅ **Правильно:**
```typescript
function getUser(id: string): User | undefined {
  return users.find(u => u.id === id);
}

function getUserOrThrow(id: string): User {
  const user = users.find(u => u.id === id);
  if (!user) {
    throw new NotFoundError(`User ${id} not found`);
  }
  return user;
}
```

❌ **Мутация данных:**
```typescript
function addItem(items: Item[], item: Item): Item[] {
  items.push(item); // Мутация
  return items;
}
```

✅ **Правильно:**
```typescript
function addItem(items: readonly Item[], item: Item): Item[] {
  return [...items, item]; // Иммутабельно
}
```

## Ресурсы

- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [TypeScript Deep Dive](https://basarat.gitbook.io/typescript/)
- [React TypeScript Cheatsheet](https://react-typescript-cheatsheet.netlify.app/)
- [Effective TypeScript](https://effectivetypescript.com/)
