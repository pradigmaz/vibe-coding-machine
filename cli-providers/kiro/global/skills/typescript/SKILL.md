# TypeScript Skill

## Назначение

TypeScript strict patterns и best practices. Используется frontend и backend агентами при работе с TypeScript кодом.

## Const Types Pattern (ОБЯЗАТЕЛЬНО)

**Всегда** создавай const object первым, затем извлекай тип.

```typescript
// ✅ GOOD: Const object → type
const STATUS = {
  ACTIVE: "active",
  INACTIVE: "inactive",
  PENDING: "pending",
} as const;

type Status = (typeof STATUS)[keyof typeof STATUS];

// Usage
function setStatus(status: Status) {
  console.log(STATUS.ACTIVE); // Autocomplete works!
}

// ❌ BAD: Direct union types
type Status = "active" | "inactive" | "pending";
```

**Почему?**
- Single source of truth
- Runtime values доступны
- Autocomplete работает
- Легче рефакторить
- Нет дублирования строк

## Flat Interfaces (ОБЯЗАТЕЛЬНО)

Интерфейсы должны быть **плоскими** (один уровень вложенности).

```typescript
// ✅ GOOD: Flat interfaces с references
interface UserAddress {
  street: string;
  city: string;
  zipCode: string;
}

interface User {
  id: string;
  name: string;
  email: string;
  address: UserAddress;  // Reference, не inline
}

interface Admin extends User {
  permissions: string[];
  department: string;
}

// ❌ BAD: Inline nested objects
interface User {
  id: string;
  name: string;
  address: {  // NO! Inline nested object
    street: string;
    city: string;
  };
}
```

## Never Use `any`

```typescript
// ✅ GOOD: unknown для неизвестных типов
function parse(input: unknown): User {
  if (isUser(input)) {
    return input;
  }
  throw new Error("Invalid input");
}

// ✅ GOOD: Generics для гибких типов
function first<T>(arr: T[]): T | undefined {
  return arr[0];
}

function map<T, U>(arr: T[], fn: (item: T) => U): U[] {
  return arr.map(fn);
}

// ❌ BAD: any везде
function parse(input: any): any {
  return input;
}
```

## Type Guards

```typescript
// Type guard для проверки типов
function isUser(value: unknown): value is User {
  return (
    typeof value === "object" &&
    value !== null &&
    "id" in value &&
    "name" in value &&
    "email" in value
  );
}

// Usage
function processData(data: unknown) {
  if (isUser(data)) {
    console.log(data.name); // TypeScript knows it's User
  }
}

// Type guard для union types
type Shape = Circle | Square;

function isCircle(shape: Shape): shape is Circle {
  return "radius" in shape;
}

function getArea(shape: Shape): number {
  if (isCircle(shape)) {
    return Math.PI * shape.radius ** 2;
  }
  return shape.size ** 2;
}
```

## Utility Types

```typescript
// Pick - выбрать поля
type UserPreview = Pick<User, "id" | "name">;

// Omit - исключить поля
type UserWithoutPassword = Omit<User, "password">;

// Partial - все поля optional
type PartialUser = Partial<User>;

// Required - все поля required
type RequiredUser = Required<User>;

// Readonly - все поля readonly
type ReadonlyUser = Readonly<User>;

// Record - object type
type UserMap = Record<string, User>;

// Extract - извлечь из union
type AdminRole = Extract<Role, "admin" | "superadmin">;

// Exclude - исключить из union
type NonAdminRole = Exclude<Role, "admin">;

// NonNullable - убрать null/undefined
type NonNullableUser = NonNullable<User | null>;

// ReturnType - тип возвращаемого значения
type Result = ReturnType<typeof fetchUser>;

// Parameters - tuple параметров функции
type Params = Parameters<typeof createUser>;
```

## Advanced Types

### Discriminated Unions

```typescript
// ✅ GOOD: Discriminated union
type Success = {
  status: "success";
  data: User;
};

type Error = {
  status: "error";
  message: string;
};

type Result = Success | Error;

function handleResult(result: Result) {
  if (result.status === "success") {
    console.log(result.data); // TypeScript knows it's Success
  } else {
    console.log(result.message); // TypeScript knows it's Error
  }
}
```

### Mapped Types

```typescript
// Сделать все поля optional
type Optional<T> = {
  [K in keyof T]?: T[K];
};

// Сделать все поля nullable
type Nullable<T> = {
  [K in keyof T]: T[K] | null;
};

// Выбрать только string поля
type StringKeys<T> = {
  [K in keyof T]: T[K] extends string ? K : never;
}[keyof T];
```

### Conditional Types

```typescript
// Если T extends U, то X, иначе Y
type IsString<T> = T extends string ? true : false;

// Unwrap Promise
type Awaited<T> = T extends Promise<infer U> ? U : T;

// Flatten array
type Flatten<T> = T extends Array<infer U> ? U : T;
```

### Template Literal Types

```typescript
type EventName = "click" | "focus" | "blur";
type EventHandler = `on${Capitalize<EventName>}`;
// "onClick" | "onFocus" | "onBlur"

type HTTPMethod = "GET" | "POST" | "PUT" | "DELETE";
type Endpoint = `/${string}`;
type Route = `${HTTPMethod} ${Endpoint}`;
// "GET /users" | "POST /users" | ...
```

## Import Types

```typescript
// ✅ GOOD: Type-only imports
import type { User, Product } from "./types";
import { createUser, type Config } from "./utils";

// ❌ BAD: Regular imports для types
import { User, Product } from "./types";
```

## Function Overloads

```typescript
// Overloads для разных сигнатур
function createElement(tag: "div"): HTMLDivElement;
function createElement(tag: "span"): HTMLSpanElement;
function createElement(tag: string): HTMLElement;
function createElement(tag: string): HTMLElement {
  return document.createElement(tag);
}

// Usage
const div = createElement("div"); // Type: HTMLDivElement
const span = createElement("span"); // Type: HTMLSpanElement
```

## Generics Best Practices

```typescript
// ✅ GOOD: Descriptive generic names
function groupBy<TItem, TKey extends string | number>(
  items: TItem[],
  keyFn: (item: TItem) => TKey
): Record<TKey, TItem[]> {
  return items.reduce((acc, item) => {
    const key = keyFn(item);
    acc[key] = acc[key] || [];
    acc[key].push(item);
    return acc;
  }, {} as Record<TKey, TItem[]>);
}

// ✅ GOOD: Constraints на generics
function merge<T extends object, U extends object>(
  obj1: T,
  obj2: U
): T & U {
  return { ...obj1, ...obj2 };
}

// ❌ BAD: Single letter без контекста
function process<T>(data: T): T {
  return data;
}
```

## Strict Mode Configuration

```json
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictBindCallApply": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "alwaysStrict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true
  }
}
```

## Type Assertions

```typescript
// ✅ GOOD: as для type assertions
const input = document.querySelector("#input") as HTMLInputElement;

// ✅ GOOD: Non-null assertion когда уверен
const value = getValue()!; // Я знаю, что не null

// ❌ BAD: Избегай as any
const data = response as any; // NO!

// ✅ BETTER: unknown → type guard
const data = response as unknown;
if (isValidData(data)) {
  // Use data
}
```

## Enum Alternatives

```typescript
// ❌ BAD: Enum (генерирует runtime код)
enum Status {
  Active = "active",
  Inactive = "inactive",
}

// ✅ GOOD: Const object (как в начале)
const STATUS = {
  ACTIVE: "active",
  INACTIVE: "inactive",
} as const;

type Status = (typeof STATUS)[keyof typeof STATUS];
```

## Checklist

```
TypeScript Review:
- [ ] Const types pattern используется
- [ ] Interfaces плоские (не nested)
- [ ] Нет any (используется unknown или generics)
- [ ] Type guards для проверки типов
- [ ] Type-only imports (import type)
- [ ] Utility types используются где нужно
- [ ] Generics с descriptive names
- [ ] Strict mode включён
- [ ] Discriminated unions для сложных типов
```

## Ресурсы

- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [TypeScript Deep Dive](https://basarat.gitbook.io/typescript/)
- [Type Challenges](https://github.com/type-challenges/type-challenges)
