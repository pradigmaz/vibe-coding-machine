# React State Management Skill

## Назначение

Modern React state management patterns. Используется frontend агентами для выбора и реализации state management решений.

## Выбор решения

### State Categories

| Type | Description | Solutions |
|------|-------------|-----------|
| **Local State** | Component-specific, UI state | useState, useReducer |
| **Global State** | Shared across components | Redux Toolkit, Zustand, Jotai |
| **Server State** | Remote data, caching | React Query, SWR, RTK Query |
| **URL State** | Route parameters, search | React Router, nuqs |
| **Form State** | Input values, validation | React Hook Form, Formik |

### Selection Criteria

```
Small app, simple state → Zustand или Jotai
Large app, complex state → Redux Toolkit
Heavy server interaction → React Query + light client state
Atomic/granular updates → Jotai
```

## Quick Start Patterns

### Zustand (Simplest)

```typescript
// store/useStore.ts
import { create } from 'zustand';
import { devtools, persist } from 'zustand/middleware';

interface AppState {
  user: User | null;
  theme: 'light' | 'dark';
  setUser: (user: User | null) => void;
  toggleTheme: () => void;
}

export const useStore = create<AppState>()(
  devtools(
    persist(
      (set) => ({
        user: null,
        theme: 'light',
        setUser: (user) => set({ user }),
        toggleTheme: () => set((state) => ({
          theme: state.theme === 'light' ? 'dark' : 'light'
        })),
      }),
      { name: 'app-storage' }
    )
  )
);

// Usage
function Header() {
  const { user, theme, toggleTheme } = useStore();
  return (
    <header className={theme}>
      {user?.name}
      <button onClick={toggleTheme}>Toggle Theme</button>
    </header>
  );
}
```

### Redux Toolkit

```typescript
// store/index.ts
import { configureStore } from '@reduxjs/toolkit';
import { TypedUseSelectorHook, useDispatch, useSelector } from 'react-redux';
import userReducer from './slices/userSlice';

export const store = configureStore({
  reducer: {
    user: userReducer,
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;

// Typed hooks
export const useAppDispatch: () => AppDispatch = useDispatch;
export const useAppSelector: TypedUseSelectorHook<RootState> = useSelector;

// store/slices/userSlice.ts
import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit';

interface UserState {
  current: User | null;
  status: 'idle' | 'loading' | 'succeeded' | 'failed';
  error: string | null;
}

const initialState: UserState = {
  current: null,
  status: 'idle',
  error: null,
};

export const fetchUser = createAsyncThunk(
  'user/fetchUser',
  async (userId: string, { rejectWithValue }) => {
    try {
      const response = await fetch(`/api/users/${userId}`);
      if (!response.ok) throw new Error('Failed to fetch user');
      return await response.json();
    } catch (error) {
      return rejectWithValue((error as Error).message);
    }
  }
);

const userSlice = createSlice({
  name: 'user',
  initialState,
  reducers: {
    setUser: (state, action: PayloadAction<User>) => {
      state.current = action.payload;
      state.status = 'succeeded';
    },
    clearUser: (state) => {
      state.current = null;
      state.status = 'idle';
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchUser.pending, (state) => {
        state.status = 'loading';
        state.error = null;
      })
      .addCase(fetchUser.fulfilled, (state, action) => {
        state.status = 'succeeded';
        state.current = action.payload;
      })
      .addCase(fetchUser.rejected, (state, action) => {
        state.status = 'failed';
        state.error = action.payload as string;
      });
  },
});

export const { setUser, clearUser } = userSlice.actions;
export default userSlice.reducer;
```

### Jotai (Atomic State)

```typescript
// atoms/userAtoms.ts
import { atom } from 'jotai';
import { atomWithStorage } from 'jotai/utils';

// Basic atom
export const userAtom = atom<User | null>(null);

// Derived atom (computed)
export const isAuthenticatedAtom = atom((get) => get(userAtom) !== null);

// Atom с localStorage persistence
export const themeAtom = atomWithStorage<'light' | 'dark'>('theme', 'light');

// Async atom
export const userProfileAtom = atom(async (get) => {
  const user = get(userAtom);
  if (!user) return null;
  const response = await fetch(`/api/users/${user.id}/profile`);
  return response.json();
});

// Write-only atom (action)
export const logoutAtom = atom(null, (get, set) => {
  set(userAtom, null);
  localStorage.removeItem('token');
});

// Usage
function Profile() {
  const [user] = useAtom(userAtom);
  const [, logout] = useAtom(logoutAtom);
  const [profile] = useAtom(userProfileAtom);

  return (
    <Suspense fallback={<Skeleton />}>
      <ProfileContent profile={profile} onLogout={logout} />
    </Suspense>
  );
}
```

### React Query (Server State)

```typescript
// hooks/useUsers.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

// Query keys factory
export const userKeys = {
  all: ['users'] as const,
  lists: () => [...userKeys.all, 'list'] as const,
  list: (filters: UserFilters) => [...userKeys.lists(), filters] as const,
  details: () => [...userKeys.all, 'detail'] as const,
  detail: (id: string) => [...userKeys.details(), id] as const,
};

// Fetch hook
export function useUsers(filters: UserFilters) {
  return useQuery({
    queryKey: userKeys.list(filters),
    queryFn: () => fetchUsers(filters),
    staleTime: 5 * 60 * 1000, // 5 minutes
    gcTime: 30 * 60 * 1000, // 30 minutes
  });
}

// Single user hook
export function useUser(id: string) {
  return useQuery({
    queryKey: userKeys.detail(id),
    queryFn: () => fetchUser(id),
    enabled: !!id,
  });
}

// Mutation с optimistic update
export function useUpdateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: updateUser,
    onMutate: async (newUser) => {
      await queryClient.cancelQueries({ queryKey: userKeys.detail(newUser.id) });
      const previousUser = queryClient.getQueryData(userKeys.detail(newUser.id));
      queryClient.setQueryData(userKeys.detail(newUser.id), newUser);
      return { previousUser };
    },
    onError: (err, newUser, context) => {
      queryClient.setQueryData(
        userKeys.detail(newUser.id),
        context?.previousUser
      );
    },
    onSettled: (data, error, variables) => {
      queryClient.invalidateQueries({ queryKey: userKeys.detail(variables.id) });
    },
  });
}
```

## Advanced Patterns

### Zustand с Slices (Scalable)

```typescript
// store/slices/createUserSlice.ts
import { StateCreator } from 'zustand';

export interface UserSlice {
  user: User | null;
  isAuthenticated: boolean;
  login: (credentials: Credentials) => Promise<void>;
  logout: () => void;
}

export const createUserSlice: StateCreator<
  UserSlice & CartSlice,
  [],
  [],
  UserSlice
> = (set, get) => ({
  user: null,
  isAuthenticated: false,
  login: async (credentials) => {
    const user = await authApi.login(credentials);
    set({ user, isAuthenticated: true });
  },
  logout: () => {
    set({ user: null, isAuthenticated: false });
    get().clearCart();  // Доступ к другим slices
  },
});

// store/index.ts
import { create } from 'zustand';
import { createUserSlice, UserSlice } from './slices/createUserSlice';
import { createCartSlice, CartSlice } from './slices/createCartSlice';

type StoreState = UserSlice & CartSlice;

export const useStore = create<StoreState>()((...args) => ({
  ...createUserSlice(...args),
  ...createCartSlice(...args),
}));

// Selective subscriptions (предотвращает ненужные re-renders)
export const useUser = () => useStore((state) => state.user);
export const useCart = () => useStore((state) => state.cart);
```

### Combining Client + Server State

```typescript
// Zustand для client state
const useUIStore = create<UIState>((set) => ({
  sidebarOpen: true,
  modal: null,
  toggleSidebar: () => set((s) => ({ sidebarOpen: !s.sidebarOpen })),
  openModal: (modal) => set({ modal }),
  closeModal: () => set({ modal: null }),
}));

// React Query для server state
function Dashboard() {
  const { sidebarOpen, toggleSidebar } = useUIStore();
  const { data: users, isLoading } = useUsers({ active: true });
  const { data: stats } = useStats();

  if (isLoading) return <DashboardSkeleton />;

  return (
    <div className={sidebarOpen ? 'with-sidebar' : ''}>
      <Sidebar open={sidebarOpen} onToggle={toggleSidebar} />
      <main>
        <StatsCards stats={stats} />
        <UserTable users={users} />
      </main>
    </div>
  );
}
```

## Best Practices

### Do's

```typescript
// ✅ GOOD: Colocate state близко к использованию
function UserProfile() {
  const [isEditing, setIsEditing] = useState(false);
  // Используется только здесь
}

// ✅ GOOD: Selectors для предотвращения re-renders
const userName = useStore((state) => state.user?.name);

// ✅ GOOD: Normalize data
const usersById = {
  '1': { id: '1', name: 'John' },
  '2': { id: '2', name: 'Jane' },
};

// ✅ GOOD: Type everything
interface UserState {
  current: User | null;
  status: 'idle' | 'loading' | 'succeeded' | 'failed';
}

// ✅ GOOD: Separate concerns
// Server state → React Query
// Client state → Zustand
```

### Don'ts

```typescript
// ❌ BAD: Over-globalize
const useStore = create(() => ({
  mouseX: 0,  // Не нужно в global state!
  mouseY: 0,
}));

// ❌ BAD: Duplicate server state
const [users, setUsers] = useState([]);
useEffect(() => {
  fetchUsers().then(setUsers);  // Используй React Query!
}, []);

// ❌ BAD: Direct mutation
state.user.name = 'John';  // NO!

// ✅ GOOD: Immutable updates
set({ user: { ...state.user, name: 'John' } });

// ❌ BAD: Store derived data
const [items, setItems] = useState([]);
const [count, setCount] = useState(0);  // Derived!

// ✅ GOOD: Compute it
const count = items.length;
```

## Migration Patterns

### From Legacy Redux to RTK

```typescript
// ❌ BAD: Legacy Redux
const ADD_TODO = 'ADD_TODO';
const addTodo = (text) => ({ type: ADD_TODO, payload: text });
function todosReducer(state = [], action) {
  switch (action.type) {
    case ADD_TODO:
      return [...state, { text: action.payload, completed: false }];
    default:
      return state;
  }
}

// ✅ GOOD: Redux Toolkit
const todosSlice = createSlice({
  name: 'todos',
  initialState: [],
  reducers: {
    addTodo: (state, action: PayloadAction<string>) => {
      // Immer позволяет "mutations"
      state.push({ text: action.payload, completed: false });
    },
  },
});
```

## Checklist

```
State Management Review:
- [ ] Правильное решение выбрано (Zustand/Redux/Jotai)
- [ ] Server state в React Query/SWR
- [ ] Client state в Zustand/Redux
- [ ] Local state в useState где возможно
- [ ] Selectors используются для предотвращения re-renders
- [ ] Data normalized
- [ ] TypeScript types полные
- [ ] Нет дублирования server state
- [ ] Immutable updates
- [ ] Нет derived state в useState
```

## Антипаттерны

### ❌ Global State для всего
```typescript
// NO!
const useStore = create(() => ({
  mousePosition: { x: 0, y: 0 },  // Local!
}));
```

### ❌ Дублирование Server State
```typescript
// NO!
const [users, setUsers] = useState([]);
useEffect(() => {
  fetchUsers().then(setUsers);
}, []);
```

### ❌ Direct Mutations
```typescript
// NO!
state.user.name = 'John';
```

### ❌ Derived State в useState
```typescript
// NO!
const [items, setItems] = useState([]);
const [count, setCount] = useState(0);
```

## Ресурсы

- [Redux Toolkit](https://redux-toolkit.js.org/)
- [Zustand](https://github.com/pmndrs/zustand)
- [Jotai](https://jotai.org/)
- [TanStack Query](https://tanstack.com/query)
- [SWR](https://swr.vercel.app/)
