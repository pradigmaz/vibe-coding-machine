# Архитектурные паттерны

## Backend Patterns (FastAPI)

### Layered Architecture
```
Endpoint (router) → Service (business logic) → CRUD (data access) → Model (ORM)
```

**Правила:**
- Endpoint: только валидация input/output, auth check
- Service: вся бизнес-логика
- CRUD: только DB операции
- Model: SQLAlchemy models

### Dependency Injection
```python
from fastapi import Depends

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/items")
def get_items(db: Session = Depends(get_db)):
    return crud.get_items(db)
```

## Frontend Patterns (Next.js 15)

### Server Components (по умолчанию)
```tsx
// app/dashboard/page.tsx
export default async function DashboardPage() {
  const data = await fetchData(); // Server-side
  return <DashboardView data={data} />;
}
```

### Client Components (только когда нужно)
```tsx
'use client';

// Используй только для:
// - useState, useEffect
// - Event handlers (onClick, onChange)
// - Browser APIs (localStorage, window)
// - Third-party libraries с browser dependencies
```

### Data Fetching Patterns
```tsx
// ✅ Good: Server Component
async function getData() {
  const res = await fetch('https://api.example.com/data', {
    cache: 'no-store' // или 'force-cache'
  });
  return res.json();
}

// ❌ Bad: Client Component с useEffect
'use client';
function Component() {
  const [data, setData] = useState(null);
  useEffect(() => {
    fetch('/api/data').then(r => r.json()).then(setData);
  }, []);
}
```

## Database Patterns

### Indexing Strategy
```sql
-- Composite index для частых queries
CREATE INDEX idx_user_created ON notifications(user_id, created_at DESC);

-- Partial index для filtered queries
CREATE INDEX idx_unread ON notifications(user_id) WHERE is_read = false;
```

### Avoiding N+1
```python
# ❌ Bad: N+1 query
users = db.query(User).all()
for user in users:
    user.posts  # Отдельный query для каждого user

# ✅ Good: Eager loading
users = db.query(User).options(joinedload(User.posts)).all()
```

## State Management (Zustand)

```typescript
// stores/notifications.ts
import { create } from 'zustand';

interface NotificationStore {
  notifications: Notification[];
  unreadCount: number;
  addNotification: (n: Notification) => void;
  markAsRead: (id: string) => void;
}

export const useNotificationStore = create<NotificationStore>((set) => ({
  notifications: [],
  unreadCount: 0,
  addNotification: (n) => set((state) => ({
    notifications: [n, ...state.notifications],
    unreadCount: state.unreadCount + 1
  })),
  markAsRead: (id) => set((state) => ({
    notifications: state.notifications.map(n =>
      n.id === id ? { ...n, is_read: true } : n
    ),
    unreadCount: state.unreadCount - 1
  }))
}));
```

## API Design Patterns

### Pagination
```python
@router.get("/items")
def get_items(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db)
):
    items = crud.get_items(db, skip=skip, limit=limit)
    total = crud.count_items(db)
    return {
        "items": items,
        "total": total,
        "skip": skip,
        "limit": limit
    }
```

### Rate Limiting
```python
from slowapi import Limiter
from slowapi.util import get_remote_address

limiter = Limiter(key_func=get_remote_address)

@router.post("/subscribe")
@limiter.limit("10/minute")
def subscribe(request: Request, ...):
    pass
```
