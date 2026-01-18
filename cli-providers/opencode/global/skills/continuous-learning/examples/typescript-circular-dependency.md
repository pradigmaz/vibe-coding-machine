# TypeScript Circular Dependency Detection and Resolution Skill

## Назначение

Detect и resolve TypeScript/JavaScript circular import dependencies. Используется когда:
- "Cannot access 'X' before initialization" at runtime
- Import возвращает undefined неожиданно
- "ReferenceError: Cannot access X before initialization"
- Type errors которые исчезают когда меняешь import order
- Jest/Vitest тесты падают с undefined imports которые работают в browser

## Проблема

Circular dependencies возникают когда module A импортирует из module B, который импортирует (прямо или косвенно) из module A. TypeScript компилируется успешно, но at runtime один из imports evaluates to `undefined` потому что module еще не закончил инициализацию.

## Trigger Conditions

**Частые error messages**:

```
ReferenceError: Cannot access 'UserService' before initialization
```

```
TypeError: Cannot read properties of undefined (reading 'create')
```

```
TypeError: (0 , _service.doSomething) is not a function
```

**Симптомы circular imports**:

- Import `undefined` хотя export существует
- Ошибка только at runtime, не во время TypeScript compilation
- Перемещение import statement меняет какой import undefined
- Тесты падают но app работает (или наоборот)
- Добавление `console.log` в начале файла меняет поведение

## Решение

### Шаг 1: Detect цикл

Используй инструмент для визуализации dependencies:

```bash
# Установи madge
npm install -g madge

# Найди circular dependencies
madge --circular --extensions ts,tsx src/

# Сгенерируй visual graph
madge --circular --image graph.svg src/
```

Или используй TypeScript compiler:

```bash
# Проверь cycles (требует tsconfig setting)
npx tsc --listFiles | head -50
```

### Шаг 2: Идентифицируй паттерн

**Частые circular dependency паттерны**:

**Pattern A: Service-to-Service**
```
services/userService.ts → services/orderService.ts → services/userService.ts
```

**Pattern B: Type imports**
```
types/user.ts → types/order.ts → types/user.ts
```

**Pattern C: Index barrel files**
```
components/index.ts → components/Button.tsx → components/index.ts
```

### Шаг 3: Resolution Strategies

**Strategy 1: Extract Shared Dependencies**

**До**:
```typescript
// userService.ts
import { OrderService } from './orderService';
export class UserService { ... }

// orderService.ts  
import { UserService } from './userService';
export class OrderService { ... }
```

**После**:
```typescript
// types/interfaces.ts (новый файл - нет imports из services)
export interface IUserService { ... }
export interface IOrderService { ... }

// userService.ts
import { IOrderService } from '../types/interfaces';
export class UserService implements IUserService { ... }
```

**Strategy 2: Dependency Injection**

```typescript
// orderService.ts
export class OrderService {
  constructor(private userService: IUserService) {}
  
  // Вместо прямого import UserService
}

// main.ts
const userService = new UserService();
const orderService = new OrderService(userService);
```

**Strategy 3: Dynamic Imports**

```typescript
// Импортируй только когда нужно, не на module level
async function processOrder() {
  const { UserService } = await import('./userService');
  // ...
}
```

**Strategy 4: Use Type-Only Imports**

Если нужны только types (не values), используй type-only imports:

```typescript
// Это не создает runtime dependency
import type { User } from './userService';
```

**Strategy 5: Restructure Barrel Files**

**До** (проблемно):
```typescript
// components/index.ts
export * from './Button';
export * from './Modal';  // Modal импортирует Button из './index'
```

**После**:
```typescript
// components/Modal.tsx
import { Button } from './Button';  // Прямой import, не из index
```

### Шаг 4: Prevent Future Cycles

Добавь в CI/build process:

```json
// package.json
{
  "scripts": {
    "check:circular": "madge --circular --extensions ts,tsx src/"
  }
}
```

Или настрой ESLint:

```javascript
// .eslintrc.js
module.exports = {
  plugins: ['import'],
  rules: {
    'import/no-cycle': ['error', { maxDepth: 10 }]
  }
}
```

## Проверка

1. Запусти `madge --circular src/` - должен сообщить no cycles
2. Запусти test suite - ранее undefined imports должны работать
3. Удали `node_modules` и reinstall - app должен работать
4. Build для production - нет runtime errors

## Пример

**Проблема**: `OrderService` undefined когда импортирован в `UserService`

**Detection**:
```bash
$ madge --circular src/
Circular dependencies found!
  src/services/userService.ts → src/services/orderService.ts → src/services/userService.ts
```

**Fix**: Extract shared interface

```typescript
// НОВЫЙ: src/types/services.ts
export interface IOrderService {
  createOrder(userId: string): Promise<Order>;
}

// ИЗМЕНЕН: src/services/userService.ts
import type { IOrderService } from '../types/services';

export class UserService {
  constructor(private orderService: IOrderService) {}
}

// ИЗМЕНЕН: src/services/orderService.ts  
// Больше не импортирует UserService
export class OrderService implements IOrderService {
  async createOrder(userId: string): Promise<Order> { ... }
}
```

## Заметки

- TypeScript `import type` твой друг — стирается at runtime и не может вызвать cycles
- Barrel files (`index.ts`) частый источник случайных cycles
- Порядок exports в файле может иметь значение когда есть cycle
- Jest/Vitest могут обрабатывать module resolution иначе чем bundler
- Некоторые bundlers (Webpack, Vite) лучше обрабатывают cycles чем другие
- `require()` иногда может маскировать circular dependency issues которые `import` expose

## References

- [TypeScript Module Resolution](https://www.typescriptlang.org/docs/handbook/module-resolution.html)
- [ESLint import/no-cycle](https://github.com/import-js/eslint-plugin-import/blob/main/docs/rules/no-cycle.md)
- [Madge - Module Dependency Graph](https://github.com/pahen/madge)
