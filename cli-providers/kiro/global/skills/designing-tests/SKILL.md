# Designing Tests Skill

## Назначение

Testing strategies design и implementation. Используется QA агентами для adding tests, improving coverage, setting up testing infrastructure.

## Test Implementation Workflow

```
Test Implementation Progress:
- [ ] Step 1: Identify what to test
- [ ] Step 2: Select test type
- [ ] Step 3: Write tests
- [ ] Step 4: Run и verify
- [ ] Step 5: Check coverage
- [ ] Step 6: Fix failures
```

## Testing Pyramid

```
        /\
       /  \     E2E (10%)
      /----\    
     /      \   Integration (20%)
    /--------\  
   /          \ Unit (70%)
  /____________\
```

## Framework Selection

### JavaScript/TypeScript
| Type | Recommended |
|------|-------------|
| Unit | Vitest |
| Integration | Vitest + MSW |
| E2E | Playwright |
| Component | Testing Library |

### Python
| Type | Recommended |
|------|-------------|
| Unit | pytest |
| Integration | pytest + httpx |
| E2E | Playwright |

## Test Structure Templates

### Unit Test

```javascript
describe('[Unit] ComponentName', () => {
  describe('methodName', () => {
    it('should [behavior] when [condition]', () => {
      // Arrange
      const input = createTestInput();

      // Act
      const result = methodName(input);

      // Assert
      expect(result).toEqual(expectedOutput);
    });
  });
});
```

### Integration Test

```javascript
describe('[Integration] API /users', () => {
  beforeAll(async () => {
    await setupTestDatabase();
  });

  it('should create user and return 201', async () => {
    const response = await request(app)
      .post('/users')
      .send({ name: 'Test', email: 'test@example.com' });

    expect(response.status).toBe(201);
  });
});
```

### E2E Test

```javascript
describe('[E2E] User Registration', () => {
  it('should complete registration', async ({ page }) => {
    await page.goto('/register');
    await page.fill('[data-testid="email"]', 'new@example.com');
    await page.click('[data-testid="submit"]');
    await expect(page).toHaveURL('/dashboard');
  });
});
```

## Coverage Strategy

### What to Cover
- ✅ Business logic (100%)
- ✅ Edge cases (90%+)
- ✅ API contracts (100%)
- ✅ Critical user paths
- ❌ Third-party internals
- ❌ Simple getters/setters

### Coverage Thresholds

```json
{
  "coverageThreshold": {
    "global": {
      "branches": 80,
      "functions": 80,
      "lines": 80
    }
  }
}
```

## Test Data Management

### Factories

```javascript
export const userFactory = (overrides = {}) => ({
  id: faker.string.uuid(),
  name: faker.person.fullName(),
  email: faker.internet.email(),
  ...overrides,
});

// Usage
const admin = userFactory({ role: 'admin' });
```

## Mocking Strategy

### When to Mock
- ✅ External APIs
- ✅ Database в unit tests
- ✅ Time/Date
- ❌ Internal modules
- ❌ Code under test

### Mock Examples

```javascript
// API mocking с MSW
import { http, HttpResponse } from 'msw';

export const handlers = [
  http.get('/api/users', () => {
    return HttpResponse.json([{ id: 1, name: 'John' }]);
  }),
];

// Time mocking
vi.useFakeTimers();
vi.setSystemTime(new Date('2024-01-01'));
```

## Test Validation

```
Test Validation:
- [ ] All tests pass
- [ ] Coverage meets thresholds
- [ ] No flaky tests
- [ ] Tests independent
- [ ] Names describe behavior
```

## Best Practices

```javascript
// ✅ GOOD: AAA Pattern
it('should add numbers', () => {
  // Arrange
  const a = 2, b = 3;
  // Act
  const result = add(a, b);
  // Assert
  expect(result).toBe(5);
});

// ✅ GOOD: Descriptive names
it('should throw error when dividing by zero', () => {});

// ✅ GOOD: Mock external dependencies
vi.mock('nodemailer');

// ❌ BAD: Vague names
it('should work', () => {});

// ❌ BAD: Multiple unrelated assertions
it('should do everything', () => {
  expect(a).toBe(1);
  expect(b).toBe(2);
  expect(c).toBe(3);
});
```

## Checklist

```
Testing Review:
- [ ] AAA pattern used
- [ ] Descriptive test names
- [ ] External dependencies mocked
- [ ] Edge cases tested
- [ ] Coverage > 80%
- [ ] Tests isolated
- [ ] Error handling tested
```

## Ресурсы

- [Jest](https://jestjs.io/)
- [Vitest](https://vitest.dev/)
- [Testing Library](https://testing-library.com/)
- [Playwright](https://playwright.dev/)
