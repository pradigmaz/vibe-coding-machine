# ОБЯЗАТЕЛЬНЫЕ ПРАВИЛА ДЛЯ ВСЕХ CODING АГЕНТОВ

## 🚨 КРИТИЧЕСКОЕ ПРАВИЛО #1: РАЗМЕР ФАЙЛОВ

**МАКСИМУМ 300 СТРОК НА ФАЙЛ**

### Почему 300 строк?
- Легче читать и понимать
- Проще тестировать
- Меньше конфликтов при merge
- Быстрее находить баги

### Что делать если файл > 300 строк?

```typescript
// ❌ НЕПРАВИЛЬНО - всё в одном файле (500+ строк)
// src/api/users.ts
export function createUser() { /* 100 строк */ }
export function updateUser() { /* 100 строк */ }
export function deleteUser() { /* 100 строк */ }
export function getUserProfile() { /* 100 строк */ }
export function validateUser() { /* 100 строк */ }

// ✅ ПРАВИЛЬНО - разбито на модули
// src/api/users/create.ts (80 строк)
export function createUser() { /* ... */ }

// src/api/users/update.ts (80 строк)
export function updateUser() { /* ... */ }

// src/api/users/delete.ts (60 строк)
export function deleteUser() { /* ... */ }

// src/api/users/profile.ts (90 строк)
export function getUserProfile() { /* ... */ }

// src/api/users/validation.ts (70 строк)
export function validateUser() { /* ... */ }

// src/api/users/index.ts (20 строк)
export * from './create';
export * from './update';
export * from './delete';
export * from './profile';
export * from './validation';
```

### Правила разбиения:

1. **По функциональности:**
   - `users/create.ts` - создание
   - `users/update.ts` - обновление
   - `users/delete.ts` - удаление

2. **По слоям:**
   - `users/controller.ts` - контроллеры
   - `users/service.ts` - бизнес-логика
   - `users/repository.ts` - работа с БД

3. **По типам:**
   - `users/types.ts` - типы
   - `users/validation.ts` - валидация
   - `users/utils.ts` - утилиты

### Чеклист перед сдачей:

```bash
# Проверь размер файлов
find src -name "*.ts" -o -name "*.py" -o -name "*.js" | xargs wc -l | sort -rn | head -20

# Если файл > 300 строк → РАЗБЕЙ НА МОДУЛИ
```

---

## 🚨 КРИТИЧЕСКОЕ ПРАВИЛО #2: ЛОГИРОВАНИЕ + ПРОВЕРКА

**КАЖДЫЙ coding агент ОБЯЗАН:**

### 1. ВСЕГДА ДОБАВЛЯТЬ ЛОГИРОВАНИЕ

```typescript
// ✅ ПРАВИЛЬНО - с логами
export async function createUser(data: UserData) {
  console.log('[createUser] Starting with data:', data);
  
  try {
    const user = await db.user.create({ data });
    console.log('[createUser] Success:', user.id);
    return user;
  } catch (error) {
    console.error('[createUser] Error:', error);
    throw error;
  }
}

// ❌ НЕПРАВИЛЬНО - без логов
export async function createUser(data: UserData) {
  return await db.user.create({ data });
}
```

### 2. ВСЕГДА ПРОВЕРЯТЬ РАБОТОСПОСОБНОСТЬ (НЕ ПИСАТЬ ТЕСТЫ!)

**⚠️ ВАЖНО: Ты НЕ пишешь тесты! Тесты пишет @test-automator**

**Ты ТОЛЬКО проверяешь что код работает:**

```bash
# 1. Написал код
# 2. Запусти dev сервер и проверь логи
npm run dev

# 3. Проверь в браузере/API вручную
# 4. Смотри логи в консоли
# 5. Если ошибка - ИСПРАВЬ СРАЗУ
# 6. Повтори пока не заработает

# ❌ НЕ ПИШИ: npm test, jest, vitest
# ❌ НЕ СОЗДАВАЙ: *.test.ts, *.spec.ts
# ✅ ТОЛЬКО: npm run dev + ручная проверка
```

### 3. ФОРМАТ ЛОГОВ

**Используй префиксы для поиска:**

```typescript
// Backend
console.log('[API:users] GET /api/users called');
console.log('[DB:query] Executing query:', sql);
console.error('[Auth:error] Token validation failed:', error);

// Frontend
console.log('[Component:Header] Rendering with props:', props);
console.log('[Hook:useAuth] User state changed:', user);
console.error('[API:fetch] Request failed:', error);
```

### 4. ОБЯЗАТЕЛЬНЫЙ WORKFLOW

```
1. Написал код
   ↓
2. Добавил логи (console.log/error)
   ↓
3. Запустил dev сервер (npm run dev)
   ↓
4. Проверил функционал ВРУЧНУЮ
   ↓
5. Смотрю логи в консоли
   ↓
6. Есть ошибка? → ИСПРАВЛЯЮ → возврат к шагу 3
   ↓
7. Всё работает? → Готово ✅

❌ НЕ ПИШИ ТЕСТЫ - это делает @test-automator
✅ ТОЛЬКО ручная проверка работоспособности
```

### 5. ЧТО ЛОГИРОВАТЬ

**Backend:**
- Входные параметры функций
- SQL запросы
- API вызовы
- Ошибки с полным стеком
- Результаты операций

**Frontend:**
- Props компонентов
- State изменения
- API запросы/ответы
- User actions
- Ошибки рендеринга

### 6. УРОВНИ ЛОГОВ

```typescript
// INFO - обычная работа
console.log('[Module] Normal operation');

// WARN - потенциальная проблема
console.warn('[Module] Deprecated API used');

// ERROR - ошибка
console.error('[Module] Operation failed:', error);

// DEBUG - детальная отладка
console.debug('[Module] Internal state:', state);
```

### 7. PRODUCTION ЛОГИ

Для production используй библиотеки:
- **Backend:** winston, pino, bunyan
- **Frontend:** loglevel, debug

```typescript
// Development
if (process.env.NODE_ENV === 'development') {
  console.log('[Debug] Detailed info');
}

// Production
logger.info('Operation completed', { userId, action });
```

---

## 🔥 ANTI-PATTERNS (НЕ ДЕЛАЙ ТАК)

### ❌ Написал код и сдал без проверки
```typescript
// Написал функцию
export function calculate(x: number) {
  return x * 2;
}
// Сдал задачу ✅ - НЕТ! Не проверил!
```

### ❌ Нет логов - не видишь ошибки
```typescript
async function fetchData() {
  const res = await fetch('/api/data');
  return res.json(); // Что если ошибка? Не узнаешь!
}
```

### ❌ Не запустил dev сервер
```
Agent: "Я написал код, задача выполнена"
Reality: Код не компилируется, есть 10 ошибок
```

---

## ✅ ПРАВИЛЬНЫЙ ПРИМЕР

```typescript
// 1. Пишу функцию с логами
export async function updateUserProfile(userId: string, data: ProfileData) {
  console.log('[updateUserProfile] Starting', { userId, data });
  
  try {
    // Валидация
    if (!userId) {
      console.error('[updateUserProfile] Missing userId');
      throw new Error('User ID required');
    }
    
    // Запрос к БД
    console.log('[updateUserProfile] Updating database');
    const user = await db.user.update({
      where: { id: userId },
      data
    });
    
    console.log('[updateUserProfile] Success', { userId: user.id });
    return user;
    
  } catch (error) {
    console.error('[updateUserProfile] Error:', error);
    throw error;
  }
}

// 2. Запускаю dev сервер
// npm run dev

// 3. Тестирую через API/UI
// curl -X PUT /api/users/123 -d '{"name":"John"}'

// 4. Смотрю логи в консоли:
// [updateUserProfile] Starting { userId: '123', data: { name: 'John' } }
// [updateUserProfile] Updating database
// [updateUserProfile] Success { userId: '123' }

// 5. Работает? ✅ Готово!
// 6. Ошибка? → Исправляю → повторяю с шага 2
```

---

## 📋 ЧЕКЛИСТ ПЕРЕД СДАЧЕЙ ЗАДАЧИ

- [ ] **Размер файлов:** Все файлы < 300 строк
- [ ] **Разбиение:** Большие файлы разбиты на модули
- [ ] Код написан
- [ ] Логи добавлены (console.log/error)
- [ ] Dev сервер запущен (npm run dev)
- [ ] Функционал проверен вручную (НЕ тестами!)
- [ ] Логи просмотрены - нет ошибок
- [ ] Если были ошибки - исправлены
- [ ] Всё работает корректно
- [ ] ❌ Тесты НЕ написаны (это делает @test-automator)
- [ ] Только теперь можно сдавать ✅

---

## 🎯 ПОМНИ

**"Написал код" ≠ "Задача выполнена"**

**"Задача выполнена" = "Написал + Проверил вручную + Исправил ошибки + Работает"**

**БЕЗ ЛОГОВ = СЛЕПОЙ КОД**

**БЕЗ ПРОВЕРКИ = СЛОМАННЫЙ КОД**

**ТЕСТЫ ПИШЕТ ТОЛЬКО @test-automator**
