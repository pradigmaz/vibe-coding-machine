# Code Review Masterclass

A comprehensive guide to conducting expert-level code reviews, focusing on Architecture, Security, and Performance.

## 1. Architecture Review

### SOLID Principles
- **SRP:** Classes should have one reason to change.
  - *Bad:* `UserManager` handles DB, Email, and Logging.
  - *Good:* `UserService` orchestrates `UserRepository`, `EmailService`, `Logger`.
- **OCP:** Open for extension, closed for modification.
  - *Bad:* `switch` on payment types inside a processor.
  - *Good:* `PaymentMethod` interface with specific implementations.

### Dependency Injection
- *Bad:* `new PostgresDatabase()` inside a service (Tight Coupling).
- *Good:* Pass `Database` interface via constructor (Inversion of Control).

## 2. Code Quality Analysis

### Cognitive Complexity
- **Rule:** Keep it low (under 10).
- *Bad:* Nested `if`s (arrow code).
- *Good:* Guard clauses (`if (!valid) return;`), extraction to small functions.

### DRY (Don't Repeat Yourself)
- *Bad:* Copy-pasted SQL queries or validation logic.
- *Good:* Shared abstractions, utility functions, or higher-order components.

## 3. Security Review

### Input Validation
- **Rule:** Never trust user input.
- *Bad:* Casting `req.body` to a type without checking.
- *Good:* Use **Zod/Joi** to parse and validate structure at runtime.

### Authentication & Authorization
- **Rule:** Check permissions, not just identity.
- *Bad:* `if (post.authorId === user.id)` (Implicit rule).
- *Good:* RBAC/ABAC logic: `if (can(user, 'delete', post))`.

### Sensitive Data
- **Rule:** Never return full DB objects.
- *Bad:* `res.json(user)` (Leaks hash, salt).
- *Good:* Use DTOs: `res.json(toPublicUser(user))`.

## 4. Performance Review

### N+1 Query Problem
- *Bad:* Fetching list, then looping to fetch related data for each item.
- *Good:* `JOIN`s, `WHERE IN (...)`, or Dataloader (batching).

### Memory Leaks
- *Bad:* Adding event listeners/subscriptions without removal.
- *Good:* Always return cleanup function from `useEffect` or `onMount`.

## 5. Error Handling
- *Bad:* `catch (e) { console.log(e) }` (Swallowing errors).
- *Good:* Custom Error classes, specific catch blocks, proper logging with context.

## 6. Testing
- *Bad:* Tests touching real DB/API (Integration masquerading as Unit).
- *Good:* Mock dependencies for Unit tests. Use containers for Integration.
