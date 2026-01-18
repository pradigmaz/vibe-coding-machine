# TypeScript Advanced Types Skill

## Назначение

Advanced TypeScript type system. Используется всеми агентами для создания type-safe кода с generics, conditional types, mapped types.

## Core Concepts

### 1. Generics

```typescript
// ✅ GOOD: Generic function
function identity<T>(value: T): T {
  return value;
}

const num = identity<number>(42);
const str = identity<string>("hello");
const auto = identity(true);  // Type inferred

// ✅ GOOD: Generic constraints
interface HasLength {
  length: number;
}

function logLength<T extends HasLength>(item: T): T {
  console.log(item.length);
  return item;
}

logLength("hello");        // OK
logLength([1, 2, 3]);      // OK
// logLength(42);          // Error

// ✅ GOOD: Multiple type parameters
function merge<T, U>(obj1: T, obj2: U): T & U {
  return { ...obj1, ...obj2 };
}
```

### 2. Conditional Types

```typescript
// Basic conditional type
type IsString<T> = T extends string ? true : false;

type A = IsString<string>;  // true
type B = IsString<number>;  // false

// Extract return type
type ReturnType<T> = T extends (...args: any[]) => infer R ? R : never;

function getUser() {
  return { id: 1, name: "John" };
}

type User = ReturnType<typeof getUser>;
// Type: { id: number; name: string; }

// Distributive conditional types
type ToArray<T> = T extends any ? T[] : never;

type StrOrNumArray = ToArray<string | number>;
// Type: string[] | number[]
```


### 3. Mapped Types

```typescript
// Basic mapped type
type Readonly<T> = {
  readonly [P in keyof T]: T[P];
};

interface User {
  id: number;
  name: string;
}

type ReadonlyUser = Readonly<User>;
// Type: { readonly id: number; readonly name: string; }

// Optional properties
type Partial<T> = {
  [P in keyof T]?: T[P];
};

// Key remapping
type Getters<T> = {
  [K in keyof T as `get${Capitalize<string & K>}`]: () => T[K]
};

interface Person {
  name: string;
  age: number;
}

type PersonGetters = Getters<Person>;
// Type: { getName: () => string; getAge: () => number; }

// Filtering properties
type PickByType<T, U> = {
  [K in keyof T as T[K] extends U ? K : never]: T[K]
};

interface Mixed {
  id: number;
  name: string;
  age: number;
  active: boolean;
}

type OnlyNumbers = PickByType<Mixed, number>;
// Type: { id: number; age: number; }
```

### 4. Template Literal Types

```typescript
// Basic template literal
type EventName = "click" | "focus" | "blur";
type EventHandler = `on${Capitalize<EventName>}`;
// Type: "onClick" | "onFocus" | "onBlur"

// String manipulation
type UppercaseGreeting = Uppercase<"hello">;  // "HELLO"
type LowercaseGreeting = Lowercase<"HELLO">;  // "hello"
type CapitalizedName = Capitalize<"john">;    // "John"

// Path building
type Path<T> = T extends object
  ? { [K in keyof T]: K extends string
      ? `${K}` | `${K}.${Path<T[K]>}`
      : never
    }[keyof T]
  : never;

interface Config {
  server: {
    host: string;
    port: number;
  };
}

type ConfigPath = Path<Config>;
// Type: "server" | "server.host" | "server.port"
```

### 5. Utility Types

```typescript
// Built-in utility types
type PartialUser = Partial<User>;           // All optional
type RequiredUser = Required<PartialUser>;  // All required
type ReadonlyUser = Readonly<User>;         // All readonly

type UserName = Pick<User, "name" | "email">;  // Select props
type UserWithoutPassword = Omit<User, "password">;  // Remove props

type T1 = Exclude<"a" | "b" | "c", "a">;  // "b" | "c"
type T2 = Extract<"a" | "b" | "c", "a" | "b">;  // "a" | "b"

type T3 = NonNullable<string | null | undefined>;  // string

type PageInfo = Record<"home" | "about", { title: string }>;
```

## Advanced Patterns

### Type-Safe Event Emitter

```typescript
type EventMap = {
  "user:created": { id: string; name: string };
  "user:updated": { id: string };
  "user:deleted": { id: string };
};

class TypedEventEmitter<T extends Record<string, any>> {
  private listeners: {
    [K in keyof T]?: Array<(data: T[K]) => void>;
  } = {};

  on<K extends keyof T>(event: K, callback: (data: T[K]) => void): void {
    if (!this.listeners[event]) {
      this.listeners[event] = [];
    }
    this.listeners[event]!.push(callback);
  }

  emit<K extends keyof T>(event: K, data: T[K]): void {
    const callbacks = this.listeners[event];
    if (callbacks) {
      callbacks.forEach(callback => callback(data));
    }
  }
}

const emitter = new TypedEventEmitter<EventMap>();

emitter.on("user:created", (data) => {
  console.log(data.id, data.name);  // Type-safe!
});
```

### Type-Safe API Client

```typescript
type HTTPMethod = "GET" | "POST" | "PUT" | "DELETE";

type EndpointConfig = {
  "/users": {
    GET: { response: User[] };
    POST: { body: { name: string; email: string }; response: User };
  };
  "/users/:id": {
    GET: { params: { id: string }; response: User };
    PUT: { params: { id: string }; body: Partial<User>; response: User };
  };
};

type ExtractParams<T> = T extends { params: infer P } ? P : never;
type ExtractBody<T> = T extends { body: infer B } ? B : never;
type ExtractResponse<T> = T extends { response: infer R } ? R : never;

class APIClient<Config extends Record<string, Record<HTTPMethod, any>>> {
  async request<
    Path extends keyof Config,
    Method extends keyof Config[Path]
  >(
    path: Path,
    method: Method,
    options?: {
      params?: ExtractParams<Config[Path][Method]>;
      body?: ExtractBody<Config[Path][Method]>;
    }
  ): Promise<ExtractResponse<Config[Path][Method]>> {
    // Implementation
    return {} as any;
  }
}

const api = new APIClient<EndpointConfig>();

// Type-safe API calls
const users = await api.request("/users", "GET");
// Type: User[]

const newUser = await api.request("/users", "POST", {
  body: { name: "John", email: "john@example.com" }
});
// Type: User
```

### Builder Pattern

```typescript
type BuilderState<T> = {
  [K in keyof T]: T[K] | undefined;
};

type RequiredKeys<T> = {
  [K in keyof T]-?: {} extends Pick<T, K> ? never : K;
}[keyof T];

type IsComplete<T, S> =
  RequiredKeys<T> extends keyof S
    ? S[RequiredKeys<T>] extends undefined
      ? false
      : true
    : false;

class Builder<T, S extends BuilderState<T> = {}> {
  private state: S = {} as S;

  set<K extends keyof T>(
    key: K,
    value: T[K]
  ): Builder<T, S & Record<K, T[K]>> {
    this.state[key] = value;
    return this as any;
  }

  build(
    this: IsComplete<T, S> extends true ? this : never
  ): T {
    return this.state as T;
  }
}

interface User {
  id: string;
  name: string;
  email: string;
}

const user = new Builder<User>()
  .set("id", "1")
  .set("name", "John")
  .set("email", "john@example.com")
  .build();  // OK

// const incomplete = new Builder<User>()
//   .set("id", "1")
//   .build();  // Error: missing required fields
```

### Deep Readonly/Partial

```typescript
type DeepReadonly<T> = {
  readonly [P in keyof T]: T[P] extends object
    ? T[P] extends Function
      ? T[P]
      : DeepReadonly<T[P]>
    : T[P];
};

type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends object
    ? T[P] extends Array<infer U>
      ? Array<DeepPartial<U>>
      : DeepPartial<T[P]>
    : T[P];
};
```

### Discriminated Unions

```typescript
type Success<T> = {
  status: "success";
  data: T;
};

type Error = {
  status: "error";
  error: string;
};

type Loading = {
  status: "loading";
};

type AsyncState<T> = Success<T> | Error | Loading;

function handleState<T>(state: AsyncState<T>): void {
  switch (state.status) {
    case "success":
      console.log(state.data);  // Type: T
      break;
    case "error":
      console.log(state.error);  // Type: string
      break;
    case "loading":
      console.log("Loading...");
      break;
  }
}
```

## Type Inference

### Infer Keyword

```typescript
// Extract array element type
type ElementType<T> = T extends (infer U)[] ? U : never;

type Num = ElementType<number[]>;  // number

// Extract promise type
type PromiseType<T> = T extends Promise<infer U> ? U : never;

type AsyncNum = PromiseType<Promise<number>>;  // number

// Extract function parameters
type Parameters<T> = T extends (...args: infer P) => any ? P : never;

function foo(a: string, b: number) {}
type FooParams = Parameters<typeof foo>;  // [string, number]
```

### Type Guards

```typescript
function isString(value: unknown): value is string {
  return typeof value === "string";
}

function isArrayOf<T>(
  value: unknown,
  guard: (item: unknown) => item is T
): value is T[] {
  return Array.isArray(value) && value.every(guard);
}

const data: unknown = ["a", "b", "c"];

if (isArrayOf(data, isString)) {
  data.forEach(s => s.toUpperCase());  // Type: string[]
}
```

### Assertion Functions

```typescript
function assertIsString(value: unknown): asserts value is string {
  if (typeof value !== "string") {
    throw new Error("Not a string");
  }
}

function processValue(value: unknown) {
  assertIsString(value);
  // value is now typed as string
  console.log(value.toUpperCase());
}
```

## Best Practices

```typescript
// ✅ GOOD: Use unknown over any
function parse(input: unknown): User {
  if (isUser(input)) {
    return input;
  }
  throw new Error("Invalid input");
}

// ✅ GOOD: Prefer interface for object shapes
interface User {
  id: string;
  name: string;
}

// ✅ GOOD: Use type for unions
type Status = "active" | "inactive" | "pending";

// ✅ GOOD: Leverage type inference
const user = { id: "1", name: "John" };  // Type inferred

// ✅ GOOD: Use const assertions
const COLORS = {
  RED: "#ff0000",
  GREEN: "#00ff00",
} as const;

// ✅ GOOD: Document complex types
/**
 * Extracts the return type of an async function
 */
type AsyncReturnType<T extends (...args: any) => Promise<any>> =
  T extends (...args: any) => Promise<infer R> ? R : never;
```

## Checklist

```
TypeScript Advanced Types Review:
- [ ] Generics используются с constraints
- [ ] Conditional types для type logic
- [ ] Mapped types для transformations
- [ ] Template literal types для string patterns
- [ ] Utility types используются где нужно
- [ ] Type guards для runtime checks
- [ ] Discriminated unions для complex types
- [ ] unknown вместо any
- [ ] Type inference используется
- [ ] Complex types документированы
```

## Антипаттерны

### ❌ Using any
```typescript
// NO!
function process(data: any): any { }
```

### ❌ Ignoring Type Guards
```typescript
// NO!
const data = response as User;  // Unsafe!

// YES!
if (isUser(response)) {
  // Use response
}
```

### ❌ Over-complex Types
```typescript
// NO! Слишком сложно
type ComplexType<T> = T extends ...  // 50 строк
```

## Ресурсы

- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/)
- [Type Challenges](https://github.com/type-challenges/type-challenges)
- [TypeScript Deep Dive](https://basarat.gitbook.io/typescript/)
