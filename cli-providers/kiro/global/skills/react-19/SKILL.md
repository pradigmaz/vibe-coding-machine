# React 19 Skill

## Назначение

React 19 паттерны с React Compiler. Используется frontend агентами при работе с React 19 компонентами и хуками.

## No Manual Memoization (ОБЯЗАТЕЛЬНО)

React Compiler автоматически оптимизирует код. **Не используй** `useMemo`, `useCallback`, `React.memo` вручную.

```typescript
// ✅ GOOD: React Compiler handles optimization automatically
function Component({ items }) {
  const filtered = items.filter(x => x.active);
  const sorted = filtered.sort((a, b) => a.name.localeCompare(b.name));

  const handleClick = (id) => {
    console.log(id);
  };

  return <List items={sorted} onClick={handleClick} />;
}

// ❌ BAD: Manual memoization (unnecessary with React Compiler)
const filtered = useMemo(() => items.filter(x => x.active), [items]);
const handleClick = useCallback((id) => console.log(id), []);
```

## Imports (ОБЯЗАТЕЛЬНО)

Всегда используй **named imports** из "react".

```typescript
// ✅ GOOD: Named imports
import { useState, useEffect, useRef } from "react";

// ❌ BAD: Default or namespace imports
import React from "react";
import * as React from "react";
```

## Server Components First

По умолчанию все компоненты - Server Components. Используй `"use client"` только когда необходимо.

```typescript
// ✅ GOOD: Server Component (default) - no directive needed
export default async function Page() {
  const data = await fetchData();
  return <ClientComponent data={data} />;
}

// ✅ GOOD: Client Component - only when needed
"use client";
export function Interactive() {
  const [state, setState] = useState(false);
  return <button onClick={() => setState(!state)}>Toggle</button>;
}
```

### Когда использовать "use client"

Используй `"use client"` когда нужно:
- **State**: `useState`, `useReducer`
- **Effects**: `useEffect`, `useLayoutEffect`
- **Refs**: `useRef`
- **Context**: `useContext`
- **Event handlers**: `onClick`, `onChange`, `onSubmit`
- **Browser APIs**: `window`, `document`, `localStorage`
- **Third-party libraries** с browser dependencies

## use() Hook

Новый хук `use()` для чтения promises и context.

### Reading Promises

```typescript
import { use } from "react";

// Suspends until promise resolves
function Comments({ commentsPromise }) {
  const comments = use(commentsPromise);
  return (
    <div>
      {comments.map(c => (
        <div key={c.id}>{c.text}</div>
      ))}
    </div>
  );
}

// Usage
function Page() {
  const commentsPromise = fetchComments();
  return (
    <Suspense fallback={<Loading />}>
      <Comments commentsPromise={commentsPromise} />
    </Suspense>
  );
}
```

### Conditional Context Reading

В отличие от `useContext`, `use()` можно вызывать условно!

```typescript
import { use } from "react";

function Theme({ showTheme }) {
  // ✅ GOOD: Conditional context reading (not possible with useContext!)
  if (showTheme) {
    const theme = use(ThemeContext);
    return <div style={{ color: theme.primary }}>Themed</div>;
  }
  return <div>Plain</div>;
}

// ❌ BAD: useContext cannot be called conditionally
function Theme({ showTheme }) {
  if (showTheme) {
    const theme = useContext(ThemeContext); // Error!
  }
}
```

## Actions & useActionState

### Server Actions

```typescript
"use server";

async function submitForm(formData: FormData) {
  const email = formData.get('email');
  const name = formData.get('name');
  
  await saveToDatabase({ email, name });
  revalidatePath('/users');
  
  return { success: true };
}
```

### useActionState Hook

Заменяет старый `useFormState`. Предоставляет pending state.

```typescript
"use client";
import { useActionState } from "react";

function Form() {
  const [state, action, isPending] = useActionState(submitForm, null);
  
  return (
    <form action={action}>
      <input name="email" type="email" required />
      <input name="name" type="text" required />
      
      <button disabled={isPending}>
        {isPending ? "Saving..." : "Save"}
      </button>
      
      {state?.success && <p>Saved successfully!</p>}
    </form>
  );
}
```

### useOptimistic Hook

Оптимистичные обновления UI.

```typescript
"use client";
import { useOptimistic } from "react";

function TodoList({ todos }) {
  const [optimisticTodos, addOptimisticTodo] = useOptimistic(
    todos,
    (state, newTodo) => [...state, { ...newTodo, pending: true }]
  );
  
  async function handleAdd(formData) {
    const title = formData.get('title');
    addOptimisticTodo({ id: Date.now(), title });
    await addTodo(title);
  }
  
  return (
    <div>
      {optimisticTodos.map(todo => (
        <div key={todo.id} style={{ opacity: todo.pending ? 0.5 : 1 }}>
          {todo.title}
        </div>
      ))}
      <form action={handleAdd}>
        <input name="title" />
        <button>Add</button>
      </form>
    </div>
  );
}
```

## ref as Prop (No forwardRef)

В React 19 `ref` - это обычный prop. **Не нужен** `forwardRef`.

```typescript
// ✅ GOOD: React 19 - ref is just a prop
function Input({ ref, placeholder, ...props }) {
  return <input ref={ref} placeholder={placeholder} {...props} />;
}

// Usage
function Form() {
  const inputRef = useRef(null);
  return <Input ref={inputRef} placeholder="Enter text" />;
}

// ❌ BAD: Old way (unnecessary in React 19)
const Input = forwardRef((props, ref) => {
  return <input ref={ref} {...props} />;
});
```

## useFormStatus Hook

Получение статуса формы из любого компонента внутри `<form>`.

```typescript
"use client";
import { useFormStatus } from "react-dom";

function SubmitButton() {
  const { pending, data, method, action } = useFormStatus();
  
  return (
    <button disabled={pending}>
      {pending ? "Submitting..." : "Submit"}
    </button>
  );
}

function Form() {
  return (
    <form action={submitAction}>
      <input name="email" />
      <SubmitButton />
    </form>
  );
}
```

## Document Metadata

Встроенная поддержка `<title>`, `<meta>`, `<link>` в компонентах.

```typescript
// ✅ GOOD: Metadata in components
function BlogPost({ post }) {
  return (
    <article>
      <title>{post.title} - My Blog</title>
      <meta name="description" content={post.excerpt} />
      <meta property="og:title" content={post.title} />
      
      <h1>{post.title}</h1>
      <p>{post.content}</p>
    </article>
  );
}

// Next.js App Router still prefers metadata export
export const metadata = {
  title: 'My Page',
  description: 'Page description'
};
```

## Stylesheet Priority

Контроль порядка загрузки стилей через `precedence`.

```typescript
function Component() {
  return (
    <>
      <link rel="stylesheet" href="/base.css" precedence="low" />
      <link rel="stylesheet" href="/theme.css" precedence="high" />
      <div>Content</div>
    </>
  );
}
```

## Async Scripts

Скрипты с `async` больше не блокируют гидратацию.

```typescript
function Page() {
  return (
    <>
      <script async src="/analytics.js" />
      <script async src="/ads.js" />
      <div>Content loads immediately</div>
    </>
  );
}
```

## Checklist

```
React 19 Review:
- [ ] No useMemo/useCallback/React.memo (Compiler handles it)
- [ ] Named imports from "react"
- [ ] Server Components by default
- [ ] "use client" only when needed (state, effects, events)
- [ ] use() for promises and conditional context
- [ ] useActionState instead of useFormState
- [ ] ref as prop (no forwardRef)
- [ ] useFormStatus for form state
- [ ] useOptimistic for optimistic updates
```

## Migration from React 18

### useMemo/useCallback removal

```typescript
// React 18
const filtered = useMemo(() => items.filter(x => x.active), [items]);
const handleClick = useCallback(() => console.log('clicked'), []);

// React 19 - just remove them
const filtered = items.filter(x => x.active);
const handleClick = () => console.log('clicked');
```

### forwardRef removal

```typescript
// React 18
const Input = forwardRef((props, ref) => <input ref={ref} {...props} />);

// React 19
function Input({ ref, ...props }) {
  return <input ref={ref} {...props} />;
}
```

### useFormState → useActionState

```typescript
// React 18
import { useFormState } from "react-dom";
const [state, formAction] = useFormState(action, initialState);

// React 19
import { useActionState } from "react";
const [state, formAction, isPending] = useActionState(action, initialState);
```

## Ресурсы

- [React 19 Release Notes](https://react.dev/blog/2024/04/25/react-19)
- [React Compiler](https://react.dev/learn/react-compiler)
- [Server Components](https://react.dev/reference/rsc/server-components)
