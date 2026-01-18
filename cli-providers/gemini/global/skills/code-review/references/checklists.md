# Code Review Checklists

## Backend (Python/FastAPI) Checklist

### Security
- [ ] Нет hardcoded secrets (API keys, passwords)
- [ ] Используется ORM (SQLAlchemy), не raw SQL
- [ ] Input validation (Pydantic models)
- [ ] Authentication на всех protected endpoints
- [ ] Rate limiting на публичных endpoints
- [ ] CORS правильно настроен
- [ ] Secrets в environment variables

### Code Quality
- [ ] Type hints на всех функциях
- [ ] Docstrings на публичных функциях
- [ ] Функции < 50 строк
- [ ] Файлы < 300 строк
- [ ] Нет дублирования кода
- [ ] Понятные имена переменных
- [ ] Logging вместо print()

### Performance
- [ ] Нет N+1 queries
- [ ] Используются indexes на часто запрашиваемых полях
- [ ] Eager loading для relationships
- [ ] Pagination для списков
- [ ] Caching для expensive operations

### Testing
- [ ] Unit tests для business logic
- [ ] Integration tests для API endpoints
- [ ] Test coverage > 80%
- [ ] Fixtures для test data
- [ ] Mocking external dependencies

### Error Handling
- [ ] Specific exceptions (не bare except)
- [ ] Proper HTTP status codes
- [ ] Error logging
- [ ] User-friendly error messages
- [ ] Rollback на DB errors

## Frontend (TypeScript/React) Checklist

### Type Safety
- [ ] Нет any типов
- [ ] Interfaces для всех props
- [ ] Type guards где нужно
- [ ] Strict mode enabled
- [ ] Zod schemas для form validation

### Component Quality
- [ ] Server Components по умолчанию
- [ ] 'use client' только где нужно
- [ ] Компоненты < 250 строк
- [ ] Single Responsibility Principle
- [ ] Props destructuring
- [ ] Понятные имена компонентов

### Performance
- [ ] memo для expensive components
- [ ] useMemo для expensive calculations
- [ ] useCallback для event handlers в deps
- [ ] Dynamic imports для больших компонентов
- [ ] Image optimization (next/image)
- [ ] Lazy loading для off-screen content

### State Management
- [ ] Zustand для global state
- [ ] useState для local state
- [ ] Нет prop drilling (> 2 levels)
- [ ] Immutable updates
- [ ] Cleanup в useEffect

### Accessibility
- [ ] Semantic HTML
- [ ] ARIA labels где нужно
- [ ] Keyboard navigation
- [ ] Focus management
- [ ] Alt text для images

### Testing
- [ ] Component tests (Vitest + Testing Library)
- [ ] User interaction tests
- [ ] Edge cases covered
- [ ] Mocking API calls
- [ ] Snapshot tests для UI

## Database (PostgreSQL) Checklist

### Schema Design
- [ ] Primary keys на всех таблицах
- [ ] Foreign keys для relationships
- [ ] NOT NULL где appropriate
- [ ] Default values где нужно
- [ ] Proper data types
- [ ] Normalization (обычно 3NF)

### Indexes
- [ ] Index на foreign keys
- [ ] Composite indexes для частых queries
- [ ] Partial indexes для filtered queries
- [ ] UNIQUE constraints где нужно
- [ ] Не слишком много indexes (overhead)

### Migrations
- [ ] Reversible (up/down)
- [ ] Atomic operations
- [ ] Data migration отдельно от schema
- [ ] Tested на staging
- [ ] Backup перед production migration

## API Design Checklist

### REST Principles
- [ ] Правильные HTTP methods (GET, POST, PUT, DELETE)
- [ ] Правильные status codes (200, 201, 400, 404, 500)
- [ ] Consistent naming (plural для collections)
- [ ] Versioning (/api/v1/)
- [ ] HATEOAS links (опционально)

### Request/Response
- [ ] Pagination для списков
- [ ] Filtering/sorting параметры
- [ ] Consistent error format
- [ ] Request validation
- [ ] Response schemas documented

### Performance
- [ ] Rate limiting
- [ ] Caching headers
- [ ] Compression (gzip)
- [ ] Batch endpoints где нужно
- [ ] Async operations для long-running tasks

## Git/CI Checklist

### Commits
- [ ] Meaningful commit messages
- [ ] Atomic commits (one logical change)
- [ ] No commented code
- [ ] No debug statements
- [ ] No merge conflicts

### PR
- [ ] Description объясняет "why"
- [ ] Screenshots для UI changes
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No breaking changes (или documented)

### CI/CD
- [ ] All tests passing
- [ ] Linter passing
- [ ] Type checker passing
- [ ] Build successful
- [ ] No security vulnerabilities
