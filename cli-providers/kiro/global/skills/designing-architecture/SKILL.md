---
name: designing-architecture
description: Software architecture design и pattern selection. Используется architect агентами для designing systems, choosing patterns, structuring projects.
---
# Designing Architecture Skill

## Назначение

Software architecture design и pattern selection. Используется architect агентами для designing systems, choosing patterns, structuring projects.

## Architecture Decision Workflow

```
Architecture Design Progress:
- [ ] Step 1: Understand requirements
- [ ] Step 2: Assess project size
- [ ] Step 3: Select architecture pattern
- [ ] Step 4: Define directory structure
- [ ] Step 5: Document trade-offs
- [ ] Step 6: Validate decision
```

## Pattern Selection Guide

### By Project Size

| Size | Pattern |
|------|---------|
| Small (<10K LOC) | Simple MVC/Layered |
| Medium (10K-100K) | Clean Architecture |
| Large (>100K) | Modular Monolith/Microservices |

### By Team Size

| Team | Recommended |
|------|-------------|
| 1-3 devs | Monolith с clear modules |
| 4-10 devs | Modular Monolith |
| 10+ devs | Microservices (if justified) |

## Common Patterns

### 1. Layered Architecture

```
┌─────────────────────────────┐
│       Presentation          │  ← UI, Controllers
├─────────────────────────────┤
│       Application           │  ← Use Cases
├─────────────────────────────┤
│         Domain              │  ← Business Logic
├─────────────────────────────┤
│      Infrastructure         │  ← Database, APIs
└─────────────────────────────┘
```

**Use when**: Simple CRUD apps, small teams

### 2. Clean Architecture

```
┌─────────────────────────────────────┐
│       Frameworks & Drivers           │
│  ┌─────────────────────────────┐    │
│  │   Interface Adapters         │    │
│  │  ┌─────────────────────┐    │    │
│  │  │   Application       │    │    │
│  │  │  ┌─────────────┐    │    │    │
│  │  │  │   Domain    │    │    │    │
│  │  │  └─────────────┘    │    │    │
│  │  └─────────────────────┘    │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

**Use when**: Complex business logic, testability key


### 3. Event-Driven Architecture

```
Producer → Event Bus → Consumer
              │
              ├─→ Consumer
              └─→ Consumer
```

**Use when**: Loose coupling, async processing, scalability

### 4. CQRS

```
Commands (Write) → Write Model
Queries (Read)   → Read Model
```

**Use when**: Different read/write scaling, complex domains

## Directory Structure Patterns

### Feature-Based (Recommended)

```
src/
├── features/
│   ├── users/
│   │   ├── api/
│   │   ├── components/
│   │   ├── hooks/
│   │   └── types/
│   └── orders/
│       └── ...
├── shared/
│   ├── components/
│   └── utils/
└── app/
```

### Layer-Based (Simple)

```
src/
├── controllers/
├── services/
├── models/
├── repositories/
└── utils/
```

## Decision Framework

Evaluate against:
1. **Simplicity** - Start simple
2. **Team Skills** - Match capabilities
3. **Requirements** - Business needs drive
4. **Scalability** - Growth trajectory
5. **Maintainability** - Optimize для change

## Trade-off Analysis Template

```markdown
## Decision: [What]

### Context
[Why needed]

### Options
1. Option A: [Description]
2. Option B: [Description]

### Trade-offs
| Criteria | A | B |
|----------|---|---|
| Complexity | Low | High |
| Scalability | Medium | High |

### Decision
We chose [Option] because [reasoning].

### Consequences
- [Enables]
- [Constrains]
```

## Validation Checklist

```
Architecture Validation:
- [ ] Matches project size
- [ ] Aligns с team skills
- [ ] Supports requirements
- [ ] Allows growth
- [ ] Dependencies flow inward
- [ ] Clear boundaries
- [ ] Testing strategy feasible
- [ ] Trade-offs documented
```

## Best Practices

```typescript
// ✅ GOOD: Clear layer separation
// domain/user.ts
export class User {
  constructor(public id: string, public name: string) {}
}

// infrastructure/user-repository.ts
export class UserRepository {
  async save(user: User): Promise<void> {
    await db.users.insert(user);
  }
}

// ✅ GOOD: Feature-based organization
features/
  users/
    domain/
    infrastructure/
    api/

// ❌ BAD: Mixed concerns
class UserService {
  async createUser(data) {
    // Business logic
    const user = new User(data);
    // Database access
    await db.insert(user);
    // Email sending
    await sendEmail(user.email);
  }
}

// ❌ BAD: Circular dependencies
// A depends on B, B depends on A
```

## Checklist

```
Architecture Design Review:
- [ ] Pattern selected
- [ ] Directory structure defined
- [ ] Dependencies mapped
- [ ] Trade-offs documented
- [ ] Team alignment achieved
- [ ] Validation passed
```

## Ресурсы

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Domain-Driven Design](https://martinfowler.com/bliki/DomainDrivenDesign.html)
- [Microservices Patterns](https://microservices.io/patterns/)
