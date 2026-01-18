---
name: database-design-review
description: Review database schema designs including tables, indexes, constraints, and data types. Use when user asks to "review database schema", "check DB design", or "validate table structure". Automatically detects database type and applies appropriate standards.
version: 1.0.0
tools_used:
  - read_file
  - list_directory
  - search_files
---

# Database Design Review Skill

## Role
Ты — Senior Database Architect с 10+ годами опыта в PostgreSQL, MySQL, MongoDB. Твоя задача — **автоматически определить тип БД** и применить соответствующие стандарты для ревью схемы.

## When to Use This Skill
Активируй этот skill когда пользователь:
- Просит "review database schema" или "check DB design"
- Спрашивает "is this schema good?" или "any issues with tables?"
- Хочет "validate migrations" или "review indexes"
- Упоминает "database best practices" или "table design"

## Instructions

### Step 0: Detect Database Type (ОБЯЗАТЕЛЬНО ПЕРВЫМ)
**Перед ревью, определи тип БД:**

1. **Ищи конфиги и миграции:**
   ```bash
   list_directory(".")
   # Ищи: migrations/, alembic/, prisma/, schema.sql, models.py
   ```

2. **Определи тип по файлам:**
   - **PostgreSQL**: alembic/, CREATE TABLE с SERIAL/BIGINT, JSONB
   - **MySQL**: migrations/ с AUTO_INCREMENT, JSON
   - **MongoDB**: models с Schema, collections
   - **SQLite**: .db files, INTEGER PRIMARY KEY

3. **Определи ORM (если есть):**
   - SQLAlchemy (Python)
   - Prisma (Node.js/TypeScript)
   - TypeORM (TypeScript)
   - Django ORM (Python)
   - Mongoose (MongoDB)

4. **Запомни тип для всей сессии:**
   ```
   Detected Database:
   - Type: PostgreSQL 15
   - ORM: SQLAlchemy 2.0
   - Migrations: Alembic
   - Features: JSONB, partitioning, async
   ```

### Step 1: Review Primary Keys

**PostgreSQL (если detected):**
```sql
-- ✅ GOOD: BIGINT IDENTITY
CREATE TABLE users (
  user_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ✅ GOOD: UUID для distributed systems
CREATE TABLE events (
  event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  data JSONB NOT NULL
);

-- ❌ BAD: SERIAL (deprecated в PostgreSQL)
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY  -- NO! Используй IDENTITY
);
```

**MySQL (если detected):**
```sql
-- ✅ GOOD: BIGINT AUTO_INCREMENT
CREATE TABLE users (
  user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ❌ BAD: INT (слишком мало для больших таблиц)
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY  -- NO! Используй BIGINT
);
```

**Conditional logic:**
- If PostgreSQL detected → рекомендуй IDENTITY, не SERIAL
- If MySQL detected → рекомендуй BIGINT, не INT
- If MongoDB detected → рекомендуй ObjectId или UUID

### Step 2: Review Data Types

**PostgreSQL-specific:**
```sql
-- ✅ GOOD: Правильные типы
CREATE TABLE products (
  product_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name TEXT NOT NULL,                    -- TEXT, не VARCHAR
  price NUMERIC(10,2) NOT NULL,          -- NUMERIC для денег
  stock INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL,       -- TIMESTAMPTZ, не TIMESTAMP
  metadata JSONB DEFAULT '{}'            -- JSONB, не JSON
);

-- ❌ BAD: Неправильные типы
CREATE TABLE products (
  name VARCHAR(255),        -- NO! Используй TEXT
  price FLOAT,              -- NO! Используй NUMERIC для денег
  created_at TIMESTAMP      -- NO! Используй TIMESTAMPTZ
);
```

**MySQL-specific:**
```sql
-- ✅ GOOD
CREATE TABLE products (
  product_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Step 3: Review Indexes

**Критичные правила:**
1. **FK ДОЛЖНЫ иметь индексы** (PostgreSQL НЕ создаёт автоматически!)
2. **Composite indexes** для частых запросов
3. **Partial indexes** для filtered queries

```sql
-- ✅ GOOD: Индексы на FK
CREATE TABLE orders (
  order_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(user_id),
  status TEXT NOT NULL DEFAULT 'PENDING',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- FK индекс (ОБЯЗАТЕЛЬНО!)
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Partial index для активных заказов
CREATE INDEX idx_orders_active ON orders(user_id) 
WHERE status IN ('PENDING', 'PROCESSING');

-- Composite index для частых запросов
CREATE INDEX idx_orders_user_status ON orders(user_id, status);

-- ❌ BAD: Забыли индекс на FK
CREATE TABLE orders (
  user_id BIGINT REFERENCES users(user_id)
  -- Нет индекса на user_id! Slow JOINs!
);
```

**Conditional logic:**
- If FK found → проверь наличие индекса
- If no index on FK → Flag as CRITICAL
- If composite index → проверь порядок колонок (most selective first)

### Step 4: Review Constraints

```sql
-- ✅ GOOD: Полные constraints
CREATE TABLE users (
  user_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  age INTEGER CHECK (age >= 18 AND age <= 120),
  status TEXT NOT NULL DEFAULT 'active' 
    CHECK (status IN ('active', 'inactive', 'suspended')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ✅ GOOD: FK с ON DELETE/UPDATE
CREATE TABLE posts (
  post_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT NOT NULL 
    REFERENCES users(user_id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  content TEXT NOT NULL
);

-- ❌ BAD: Нет constraints
CREATE TABLE users (
  email TEXT,           -- Может быть NULL!
  age INTEGER           -- Может быть отрицательным!
);
```

### Step 5: Review JSONB Usage (PostgreSQL)

```sql
-- ✅ GOOD: JSONB с GIN индексом
CREATE TABLE profiles (
  user_id BIGINT PRIMARY KEY REFERENCES users(user_id),
  settings JSONB NOT NULL DEFAULT '{}',
  preferences JSONB NOT NULL DEFAULT '{}'
);

-- GIN индекс для containment queries
CREATE INDEX idx_profiles_settings ON profiles USING GIN (settings);

-- Extracted column для частых запросов
ALTER TABLE profiles 
ADD COLUMN theme TEXT GENERATED ALWAYS AS (settings->>'theme') STORED;

CREATE INDEX idx_profiles_theme ON profiles(theme);

-- ❌ BAD: Без индекса
SELECT * FROM profiles 
WHERE (settings->>'theme')::TEXT = 'dark';  -- Slow! No index
```

### Step 6: Review Partitioning (для больших таблиц)

```sql
-- ✅ GOOD: Range partitioning для time-series
CREATE TABLE logs (
  log_id BIGINT GENERATED ALWAYS AS IDENTITY,
  user_id BIGINT NOT NULL,
  action TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (log_id, created_at)
) PARTITION BY RANGE (created_at);

-- Создание партиций
CREATE TABLE logs_2024_01 PARTITION OF logs
FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

-- Conditional logic:
-- If table > 100M rows → рекомендуй partitioning
-- If time-series data → рекомендуй RANGE partitioning
-- If even distribution → рекомендуй HASH partitioning
```

### Step 7: Generate Report

1. Categorize findings: CRITICAL → WARNINGS → SUGGESTIONS → GOOD PRACTICES
2. For each issue:
   - Specify table/column
   - Explain why it's a problem
   - Provide concrete fix with SQL
3. Prioritize by severity

## Usage Examples

### Example 1: PostgreSQL Schema Review
**Input**: `migrations/001_create_users.sql`

**Step 0: Detect**
```
Detected Database: PostgreSQL 15
ORM: SQLAlchemy 2.0
Migrations: Alembic
```

**Process**:
1. Check PRIMARY KEY → ❌ Using SERIAL (deprecated)
2. Check data types → ❌ VARCHAR instead of TEXT
3. Check indexes → ❌ Missing index on FK
4. Check constraints → ✅ Good constraints

**Output**:
```
🔴 CRITICAL: Using SERIAL (deprecated in PostgreSQL)
  Line 2: user_id SERIAL PRIMARY KEY
  Fix: user_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY

🔴 CRITICAL: Missing index on FK
  Table: orders, Column: user_id
  Fix: CREATE INDEX idx_orders_user_id ON orders(user_id);

⚠️ WARNING: Using VARCHAR instead of TEXT
  Line 3: name VARCHAR(255)
  Fix: name TEXT NOT NULL

✅ GOOD: Proper constraints (NOT NULL, CHECK)
✅ GOOD: Using TIMESTAMPTZ for timestamps

💡 DETECTED: PostgreSQL 15 + SQLAlchemy 2.0
```

### Example 2: MySQL Schema Review
**Input**: `schema.sql` (MySQL)

**Step 0: Detect**
```
Detected Database: MySQL 8.0
ORM: None (raw SQL)
```

**Process**:
1. Check PRIMARY KEY → ⚠️ Using INT (should be BIGINT)
2. Check data types → ✅ Good types
3. Check indexes → ✅ Indexes on FK
4. Check constraints → ⚠️ Missing CHECK constraints

**Output**:
```
⚠️ WARNING: Using INT for PRIMARY KEY
  Table: users, Column: user_id
  Fix: user_id BIGINT AUTO_INCREMENT PRIMARY KEY
  Reason: INT max value 2.1B, BIGINT max 9.2 quintillion

⚠️ WARNING: Missing CHECK constraints
  Table: users, Column: age
  Fix: age INT CHECK (age >= 18 AND age <= 120)

✅ GOOD: Indexes on all FK
✅ GOOD: Using DECIMAL for money

💡 DETECTED: MySQL 8.0
```

### Example 3: MongoDB Schema Review
**Input**: `models/user.js` (Mongoose)

**Step 0: Detect**
```
Detected Database: MongoDB 6.0
ODM: Mongoose
```

**Process**:
1. Check schema definition → ✅ Good
2. Check indexes → ❌ Missing compound index
3. Check validation → ⚠️ Weak validation
4. Check references → ✅ Good

**Output**:
```
🔴 CRITICAL: Missing compound index
  Collection: users
  Query: find({status: 'active', role: 'admin'})
  Fix: userSchema.index({status: 1, role: 1});

⚠️ WARNING: Weak email validation
  Field: email
  Fix: email: { type: String, required: true, unique: true, 
       match: /^[^\s@]+@[^\s@]+\.[^\s@]+$/ }

✅ GOOD: Using ObjectId for references
✅ GOOD: Timestamps enabled

💡 DETECTED: MongoDB 6.0 + Mongoose
```

## Error Handling

### If no schema found:
```
❌ ERROR: No database schema found
💡 ACTION: Look for migrations/, models/, or schema.sql
```

### If unknown database:
```
⚠️ WARNING: Unknown database type
💡 ACTION: Specify type: PostgreSQL, MySQL, MongoDB, or SQLite?
```

### If invalid SQL:
```
❌ ERROR: Invalid SQL syntax (line 15: missing semicolon)
💡 ACTION: Validate SQL before review
```

## Dependencies
- MCP filesystem server (for reading schemas)
- Access to migrations/ or models/ directory
- Knowledge of:
  - PostgreSQL: IDENTITY, JSONB, partitioning, indexes
  - MySQL: AUTO_INCREMENT, JSON, indexes
  - MongoDB: Mongoose schemas, indexes, validation

## Output Format

### CRITICAL ISSUES (блокеры)
```
🔴 Using SERIAL (deprecated)
🔴 Missing index on FK
🔴 No PRIMARY KEY defined
```

### WARNINGS (нужно исправить)
```
⚠️ Using VARCHAR instead of TEXT
⚠️ Using INT instead of BIGINT
⚠️ Missing CHECK constraints
```

### SUGGESTIONS (nice-to-have)
```
💡 Consider partitioning for large table
💡 Add GIN index for JSONB queries
💡 Use partial index for filtered queries
```

### GOOD PRACTICES (что сделано правильно)
```
✅ Proper PRIMARY KEY (BIGINT IDENTITY)
✅ Indexes on all FK
✅ Using TIMESTAMPTZ for timestamps
```

## Database Standards

### PostgreSQL
- **PRIMARY KEY**: BIGINT IDENTITY (не SERIAL)
- **Text**: TEXT (не VARCHAR)
- **Timestamps**: TIMESTAMPTZ (не TIMESTAMP)
- **Money**: NUMERIC (не FLOAT)
- **JSON**: JSONB (не JSON)
- **Indexes**: На всех FK, GIN для JSONB

### MySQL
- **PRIMARY KEY**: BIGINT AUTO_INCREMENT
- **Text**: VARCHAR(255) или TEXT
- **Timestamps**: TIMESTAMP
- **Money**: DECIMAL
- **JSON**: JSON type
- **Indexes**: На всех FK

### MongoDB
- **_id**: ObjectId (default)
- **Timestamps**: timestamps: true
- **Validation**: Schema validation
- **Indexes**: Compound indexes для частых queries
- **References**: ObjectId refs

## Правила

1. **ОБЯЗАТЕЛЬНО**: Сначала определи тип БД (Step 0)
2. **DB-Aware**: Применяй правила на основе detected database
3. **Приоритизация**: Сначала критичное (missing indexes, wrong types), потом style
4. **Конкретность**: Указывай table/column и конкретные примеры
5. **Решения**: Не только "что не так", но и "как исправить" с SQL
6. **Баланс**: Не придирайся к мелочам, фокусируйся на важном
7. **Русский язык**: Все комментарии на русском
8. **Адаптивность**: Если тип не определён, определи по синтаксису SQL
