---
name: javascript-testing-patterns
description: Testing strategies с Jest, Vitest, Testing Library. Используется frontend и backend агентами для написания unit, integration, e2e тестов.
---
# JavaScript Testing Patterns Skill

## Назначение

Testing strategies с Jest, Vitest, Testing Library. Используется frontend и backend агентами для написания unit, integration, e2e тестов.

## Testing Frameworks

### Jest - Full-Featured

```typescript
// jest.config.ts
import type { Config } from 'jest';

const config: Config = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src'],
  testMatch: ['**/__tests__/**/*.ts', '**/?(*.)+(spec|test).ts'],
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
    },
  },
};

export default config;
```

### Vitest - Fast, Vite-Native

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
    },
  },
});
```

## Unit Testing Patterns

### Pattern 1: Testing Pure Functions

```typescript
// utils/calculator.ts
export function add(a: number, b: number): number {
  return a + b;
}

export function divide(a: number, b: number): number {
  if (b === 0) {
    throw new Error('Division by zero');
  }
  return a / b;
}

// utils/calculator.test.ts
import { describe, it, expect } from 'vitest';
import { add, divide } from './calculator';

describe('Calculator', () => {
  describe('add', () => {
    it('should add two positive numbers', () => {
      expect(add(2, 3)).toBe(5);
    });

    it('should add negative numbers', () => {
      expect(add(-2, -3)).toBe(-5);
    });
  });

  describe('divide', () => {
    it('should divide two numbers', () => {
      expect(divide(10, 2)).toBe(5);
    });

    it('should throw error when dividing by zero', () => {
      expect(() => divide(10, 0)).toThrow('Division by zero');
    });
  });
});
```


### Pattern 2: Testing Async Functions

```typescript
// services/api.service.ts
export class ApiService {
  async fetchUser(id: string): Promise<User> {
    const response = await fetch(`https://api.example.com/users/${id}`);
    if (!response.ok) {
      throw new Error('User not found');
    }
    return response.json();
  }
}

// services/api.service.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { ApiService } from './api.service';

global.fetch = vi.fn();

describe('ApiService', () => {
  let service: ApiService;

  beforeEach(() => {
    service = new ApiService();
    vi.clearAllMocks();
  });

  it('should fetch user successfully', async () => {
    const mockUser = { id: '1', name: 'John' };

    (fetch as any).mockResolvedValueOnce({
      ok: true,
      json: async () => mockUser,
    });

    const user = await service.fetchUser('1');

    expect(user).toEqual(mockUser);
    expect(fetch).toHaveBeenCalledWith('https://api.example.com/users/1');
  });

  it('should throw error if user not found', async () => {
    (fetch as any).mockResolvedValueOnce({ ok: false });

    await expect(service.fetchUser('999')).rejects.toThrow('User not found');
  });
});
```

## Mocking Patterns

### Pattern 3: Dependency Injection

```typescript
// services/user.service.ts
export interface IUserRepository {
  findById(id: string): Promise<User | null>;
  create(user: User): Promise<User>;
}

export class UserService {
  constructor(private userRepository: IUserRepository) {}

  async getUser(id: string): Promise<User> {
    const user = await this.userRepository.findById(id);
    if (!user) {
      throw new Error('User not found');
    }
    return user;
  }
}

// services/user.service.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { UserService, IUserRepository } from './user.service';

describe('UserService', () => {
  let service: UserService;
  let mockRepository: IUserRepository;

  beforeEach(() => {
    mockRepository = {
      findById: vi.fn(),
      create: vi.fn(),
    };
    service = new UserService(mockRepository);
  });

  it('should return user if found', async () => {
    const mockUser = { id: '1', name: 'John' };
    vi.mocked(mockRepository.findById).mockResolvedValue(mockUser);

    const user = await service.getUser('1');

    expect(user).toEqual(mockUser);
    expect(mockRepository.findById).toHaveBeenCalledWith('1');
  });

  it('should throw error if user not found', async () => {
    vi.mocked(mockRepository.findById).mockResolvedValue(null);

    await expect(service.getUser('999')).rejects.toThrow('User not found');
  });
});
```

## Frontend Testing

### Pattern 4: React Component Testing

```typescript
// components/UserForm.tsx
import { useState } from 'react';

interface Props {
  onSubmit: (user: { name: string; email: string }) => void;
}

export function UserForm({ onSubmit }: Props) {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSubmit({ name, email });
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        placeholder="Name"
        value={name}
        onChange={(e) => setName(e.target.value)}
        data-testid="name-input"
      />
      <input
        type="email"
        placeholder="Email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        data-testid="email-input"
      />
      <button type="submit">Submit</button>
    </form>
  );
}

// components/UserForm.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { describe, it, expect, vi } from 'vitest';
import { UserForm } from './UserForm';

describe('UserForm', () => {
  it('should call onSubmit with form data', () => {
    const onSubmit = vi.fn();
    render(<UserForm onSubmit={onSubmit} />);

    fireEvent.change(screen.getByTestId('name-input'), {
      target: { value: 'John Doe' },
    });
    fireEvent.change(screen.getByTestId('email-input'), {
      target: { value: 'john@example.com' },
    });
    fireEvent.click(screen.getByRole('button', { name: 'Submit' }));

    expect(onSubmit).toHaveBeenCalledWith({
      name: 'John Doe',
      email: 'john@example.com',
    });
  });
});
```

### Pattern 5: Testing Hooks

```typescript
// hooks/useCounter.ts
import { useState, useCallback } from 'react';

export function useCounter(initialValue = 0) {
  const [count, setCount] = useState(initialValue);

  const increment = useCallback(() => setCount((c) => c + 1), []);
  const decrement = useCallback(() => setCount((c) => c - 1), []);
  const reset = useCallback(() => setCount(initialValue), [initialValue]);

  return { count, increment, decrement, reset };
}

// hooks/useCounter.test.ts
import { renderHook, act } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import { useCounter } from './useCounter';

describe('useCounter', () => {
  it('should increment count', () => {
    const { result } = renderHook(() => useCounter());

    act(() => {
      result.current.increment();
    });

    expect(result.current.count).toBe(1);
  });

  it('should reset to initial value', () => {
    const { result } = renderHook(() => useCounter(10));

    act(() => {
      result.current.increment();
      result.current.increment();
    });

    expect(result.current.count).toBe(12);

    act(() => {
      result.current.reset();
    });

    expect(result.current.count).toBe(10);
  });
});
```

## Best Practices

```typescript
// ✅ GOOD: AAA Pattern (Arrange, Act, Assert)
it('should add two numbers', () => {
  // Arrange
  const a = 2;
  const b = 3;

  // Act
  const result = add(a, b);

  // Assert
  expect(result).toBe(5);
});

// ✅ GOOD: Descriptive test names
it('should throw error when dividing by zero', () => {});

// ✅ GOOD: Use beforeEach для setup
beforeEach(() => {
  service = new UserService();
});

// ✅ GOOD: Mock external dependencies
vi.mock('nodemailer');

// ✅ GOOD: Test edge cases
it('should handle empty array', () => {});
it('should handle null input', () => {});

// ❌ BAD: Vague test names
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
- [ ] AAA pattern используется
- [ ] Descriptive test names
- [ ] beforeEach/afterEach для setup/teardown
- [ ] External dependencies mocked
- [ ] Edge cases tested
- [ ] Async operations tested правильно
- [ ] Error handling tested
- [ ] Coverage > 80%
- [ ] Tests изолированы
- [ ] No implementation details tested
```

## Ресурсы

- [Jest Documentation](https://jestjs.io/)
- [Vitest Documentation](https://vitest.dev/)
- [Testing Library](https://testing-library.com/)
