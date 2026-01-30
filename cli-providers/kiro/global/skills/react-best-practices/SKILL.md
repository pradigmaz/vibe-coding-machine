---
name: react-best-practices
description: React и Next.js performance optimization. Используется frontend агентами для оптимизации производительности, устранения waterfalls и ...
---
# React Best Practices Skill

## Назначение

React и Next.js performance optimization. Используется frontend агентами для оптимизации производительности, устранения waterfalls и улучшения bundle size.

## Дополнительные материалы (steering)

Для детальных паттернов оптимизации смотри steering папку с 40+ правилами:

**Eliminating Waterfalls (КРИТИЧНО):**
- `steering/async-defer-await.md` - Defer await until needed
- `steering/async-dependencies.md` - Dependency-based parallelization
- `steering/async-api-routes.md` - Prevent waterfall chains
- `steering/async-parallel.md` - Promise.all() patterns
- `steering/async-suspense-boundaries.md` - Strategic Suspense

**Bundle Size Optimization:**
- `steering/bundle-barrel-imports.md` - Avoid barrel file imports
- `steering/bundle-conditional.md` - Conditional module loading
- `steering/bundle-defer-third-party.md` - Defer non-critical libraries
- `steering/bundle-dynamic-imports.md` - Dynamic imports
- `steering/bundle-preload.md` - Preload based on user intent

**Server-Side Performance:**
- `steering/server-cache-lru.md` - Cross-request LRU caching
- `steering/server-serialization.md` - Minimize serialization
- `steering/server-parallel-fetching.md` - Parallel data fetching
- `steering/server-cache-react.md` - React.cache() deduplication

**Re-render Optimization:**
- `steering/rerender-defer-reads.md` - Defer state reads
- `steering/rerender-memo.md` - Extract to memoized components
- `steering/rerender-dependencies.md` - Narrow effect dependencies
- `steering/rerender-derived-state.md` - Subscribe to derived state
- `steering/rerender-lazy-state-init.md` - Lazy state initialization
- `steering/rerender-transitions.md` - Use transitions

**JavaScript Performance:**
- `steering/js-*.md` - 12 JavaScript optimization patterns

**Rendering Performance:**
- `steering/rendering-*.md` - 7 rendering optimization patterns

**Advanced Patterns:**
- `steering/advanced-*.md` - Event handlers in refs, useLatest

Полный список: `steering/_sections.md`

## Критические правила

### 1. Eliminate Waterfalls (КРИТИЧНО)

Waterfalls - главный убийца производительности. Каждый последовательный await добавляет полную сетевую задержку.

```typescript
// ❌ BAD: Sequential awaits (waterfall)
async function loadData() {
  const user = await fetchUser();
  const posts = await fetchPosts();  // Ждёт user!
  const comments = await fetchComments();  // Ждёт posts!
  return { user, posts, comments };
}

// ✅ GOOD: Parallel fetching
async function loadData() {
  const [user, posts, comments] = await Promise.all([
    fetchUser(),
    fetchPosts(),
    fetchComments()
  ]);
  return { user, posts, comments };
}

// ✅ GOOD: Defer await до использования
async function loadData(needsComments: boolean) {
  const userPromise = fetchUser();
  const postsPromise = fetchPosts();
  
  const user = await userPromise;
  const posts = await postsPromise;
  
  // Fetch comments только если нужно
  const comments = needsComments ? await fetchComments() : null;
  
  return { user, posts, comments };
}
```

### 2. Bundle Size Optimization (КРИТИЧНО)

```typescript
// ❌ BAD: Barrel imports (загружает всю библиотеку)
import { Check, X, Plus } from 'lucide-react';

// ✅ GOOD: Direct imports
import Check from 'lucide-react/dist/esm/icons/check';
import X from 'lucide-react/dist/esm/icons/x';
import Plus from 'lucide-react/dist/esm/icons/plus';

// ❌ BAD: Загружаем всё сразу
import MonacoEditor from '@monaco-editor/react';

// ✅ GOOD: Dynamic import
const MonacoEditor = dynamic(
  () => import('@monaco-editor/react'),
  { ssr: false }
);

// ✅ GOOD: Conditional loading
const HeavyChart = dynamic(
  () => import('./heavy-chart'),
  { 
    loading: () => <ChartSkeleton />,
    ssr: false 
  }
);
```

### 3. Server Components (Next.js)

```typescript
// ✅ GOOD: Server Component (default)
async function UserProfile({ userId }: Props) {
  const user = await fetchUser(userId);
  const posts = await fetchPosts(userId);
  
  return (
    <div>
      <h1>{user.name}</h1>
      <PostList posts={posts} />
    </div>
  );
}

// ✅ GOOD: Client Component только где нужно
'use client';

function InteractiveButton() {
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(c => c + 1)}>{count}</button>;
}

// ❌ BAD: 'use client' на всём
'use client';

function UserProfile({ userId }: Props) {
  const [user, setUser] = useState(null);
  
  useEffect(() => {
    fetchUser(userId).then(setUser);
  }, [userId]);
  
  // Waterfall + client-side fetching!
}
```

## Re-render Optimization

### Memoization

```typescript
// ✅ GOOD: Memo для дорогих компонентов
const ExpensiveList = memo(function ExpensiveList({ items }: Props) {
  return (
    <ul>
      {items.map(item => (
        <ExpensiveItem key={item.id} item={item} />
      ))}
    </ul>
  );
});

// ✅ GOOD: useMemo для дорогих вычислений
function DataTable({ data }: Props) {
  const sortedData = useMemo(
    () => data.sort((a, b) => a.value - b.value),
    [data]
  );
  
  return <Table data={sortedData} />;
}

// ✅ GOOD: useCallback для стабильных функций
function Parent() {
  const [count, setCount] = useState(0);
  
  const handleClick = useCallback(() => {
    setCount(c => c + 1);
  }, []);
  
  return <Child onClick={handleClick} />;
}

// ❌ BAD: Без memoization
function Parent() {
  const [count, setCount] = useState(0);
  
  // Новая функция каждый рендер!
  const handleClick = () => setCount(c => c + 1);
  
  return <Child onClick={handleClick} />;
}
```

### Derived State

```typescript
// ✅ GOOD: Вычисляемое состояние
function UserList({ users }: Props) {
  const [filter, setFilter] = useState('');
  
  // Вычисляется каждый рендер, но это быстро
  const filteredUsers = users.filter(u => 
    u.name.toLowerCase().includes(filter.toLowerCase())
  );
  
  return (
    <>
      <input value={filter} onChange={e => setFilter(e.target.value)} />
      <ul>
        {filteredUsers.map(u => <li key={u.id}>{u.name}</li>)}
      </ul>
    </>
  );
}

// ❌ BAD: Дублирование состояния
function UserList({ users }: Props) {
  const [filter, setFilter] = useState('');
  const [filteredUsers, setFilteredUsers] = useState(users);
  
  useEffect(() => {
    setFilteredUsers(
      users.filter(u => u.name.toLowerCase().includes(filter.toLowerCase()))
    );
  }, [users, filter]);  // Синхронизация - антипаттерн!
}
```

### Narrow Dependencies

```typescript
// ✅ GOOD: Узкие зависимости
function UserProfile({ user }: Props) {
  useEffect(() => {
    trackPageView(user.id);
  }, [user.id]);  // Только id, не весь user
}

// ❌ BAD: Широкие зависимости
function UserProfile({ user }: Props) {
  useEffect(() => {
    trackPageView(user.id);
  }, [user]);  // Перезапуск при любом изменении user!
}
```

## Data Fetching Patterns

### SWR для Client-Side

```typescript
// ✅ GOOD: SWR с автоматической дедупликацией
import useSWR from 'swr';

function UserProfile({ userId }: Props) {
  const { data: user, error, isLoading } = useSWR(
    `/api/users/${userId}`,
    fetcher,
    {
      revalidateOnFocus: false,
      dedupingInterval: 2000
    }
  );
  
  if (isLoading) return <Skeleton />;
  if (error) return <Error />;
  
  return <div>{user.name}</div>;
}

// Несколько компонентов используют один запрос - автоматическая дедупликация!
```

### React Query

```typescript
// ✅ GOOD: React Query для сложных сценариев
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

function UserProfile({ userId }: Props) {
  const queryClient = useQueryClient();
  
  const { data: user } = useQuery({
    queryKey: ['user', userId],
    queryFn: () => fetchUser(userId),
    staleTime: 5 * 60 * 1000  // 5 минут
  });
  
  const updateMutation = useMutation({
    mutationFn: updateUser,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['user', userId] });
    }
  });
  
  return <div>{user?.name}</div>;
}
```

## Rendering Performance

### Conditional Rendering

```typescript
// ✅ GOOD: Явное условное рендеринг
function UserCard({ user, showDetails }: Props) {
  if (!showDetails) {
    return <UserCardCompact user={user} />;
  }
  
  return <UserCardDetailed user={user} />;
}

// ❌ BAD: Скрытие через CSS
function UserCard({ user, showDetails }: Props) {
  return (
    <>
      <div style={{ display: showDetails ? 'none' : 'block' }}>
        <UserCardCompact user={user} />
      </div>
      <div style={{ display: showDetails ? 'block' : 'none' }}>
        <UserCardDetailed user={user} />
      </div>
    </>
  );
}
```

### Hoist Static JSX

```typescript
// ✅ GOOD: Статичный JSX вне компонента
const EMPTY_STATE = (
  <div className="empty">
    <Icon />
    <p>No items found</p>
  </div>
);

function ItemList({ items }: Props) {
  if (items.length === 0) {
    return EMPTY_STATE;
  }
  
  return <ul>{items.map(renderItem)}</ul>;
}

// ❌ BAD: Создаётся каждый рендер
function ItemList({ items }: Props) {
  if (items.length === 0) {
    return (
      <div className="empty">
        <Icon />
        <p>No items found</p>
      </div>
    );
  }
}
```

### Content Visibility

```typescript
// ✅ GOOD: CSS content-visibility для длинных списков
function LongList({ items }: Props) {
  return (
    <div className="list">
      {items.map(item => (
        <div 
          key={item.id}
          style={{ contentVisibility: 'auto' }}
        >
          <ExpensiveItem item={item} />
        </div>
      ))}
    </div>
  );
}
```

## JavaScript Performance

### Cache Property Access

```typescript
// ✅ GOOD: Кэшируем доступ к свойствам
function processItems(items: Item[]) {
  const length = items.length;
  for (let i = 0; i < length; i++) {
    const item = items[i];
    process(item);
  }
}

// ❌ BAD: Повторный доступ
function processItems(items: Item[]) {
  for (let i = 0; i < items.length; i++) {
    process(items[i]);
  }
}
```

### Use Set/Map for Lookups

```typescript
// ✅ GOOD: Set для O(1) lookup
function filterUnique(items: Item[], excludeIds: string[]) {
  const excludeSet = new Set(excludeIds);
  return items.filter(item => !excludeSet.has(item.id));
}

// ❌ BAD: Array.includes для O(n) lookup
function filterUnique(items: Item[], excludeIds: string[]) {
  return items.filter(item => !excludeIds.includes(item.id));
}
```

### Immutable Array Methods

```typescript
// ✅ GOOD: toSorted() (immutable)
const sorted = items.toSorted((a, b) => a.value - b.value);

// ❌ BAD: sort() (mutates)
const sorted = items.sort((a, b) => a.value - b.value);
```

## Checklist

```
React Performance Review:
- [ ] Нет sequential awaits (используется Promise.all)
- [ ] Direct imports вместо barrel imports
- [ ] Dynamic imports для тяжёлых компонентов
- [ ] Server Components где возможно
- [ ] Memo для дорогих компонентов
- [ ] useMemo/useCallback где нужно
- [ ] Derived state вместо дублирования
- [ ] Узкие зависимости в useEffect
- [ ] SWR/React Query для data fetching
- [ ] Явное условное рендеринг
- [ ] Статичный JSX hoisted
- [ ] Set/Map для lookups
```

## Антипаттерны

### ❌ Waterfall Fetching
```typescript
// NO!
const user = await fetchUser();
const posts = await fetchPosts();
```

### ❌ Barrel Imports
```typescript
// NO!
import { Icon1, Icon2 } from 'icon-library';
```

### ❌ Client Component Everywhere
```typescript
// NO!
'use client';
function Page() { /* ... */ }
```

### ❌ Derived State in useState
```typescript
// NO!
const [filtered, setFiltered] = useState([]);
useEffect(() => {
  setFiltered(items.filter(...));
}, [items]);
```

## Ресурсы

- [React Documentation](https://react.dev)
- [Next.js Documentation](https://nextjs.org)
- [Vercel Performance Guide](https://vercel.com/blog/how-we-made-the-vercel-dashboard-twice-as-fast)
