# PostgreSQL Table Design Skill

## Назначение

PostgreSQL-специфичное проектирование схем БД. Используется backend и db-architect агентами для создания оптимальных таблиц, индексов и constraints.

## Основные правила

### Primary Keys

```sql
-- ✅ GOOD: BIGINT IDENTITY для большинства случаев
CREATE TABLE users (
  user_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ✅ GOOD: UUID когда нужна глобальная уникальность
CREATE TABLE distributed_events (
  event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  data JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ❌ BAD: SERIAL (deprecated)
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY  -- NO! Используй IDENTITY
);
```

### Data Types

```sql
-- ✅ GOOD: Правильные типы данных
CREATE TABLE products (
  product_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  price NUMERIC(10,2) NOT NULL CHECK (price > 0),  -- Деньги
  stock INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),  -- С timezone
  metadata JSONB DEFAULT '{}'
);

-- ❌ BAD: Неправильные типы
CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  name VARCHAR(255),  -- NO! Используй TEXT
  price FLOAT,  -- NO! Используй NUMERIC для денег
  created_at TIMESTAMP  -- NO! Используй TIMESTAMPTZ
);
```

### Indexes

```sql
-- ✅ GOOD: Индексы на FK и частые запросы
CREATE TABLE orders (
  order_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(user_id),
  status TEXT NOT NULL DEFAULT 'PENDING',
  total NUMERIC(10,2) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- FK индекс (PostgreSQL НЕ создаёт автоматически!)
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Partial index для активных заказов
CREATE INDEX idx_orders_active ON orders(user_id) 
WHERE status IN ('PENDING', 'PROCESSING');

-- Composite index для частых запросов
CREATE INDEX idx_orders_user_status ON orders(user_id, status);

-- ❌ BAD: Забыли индекс на FK
CREATE TABLE orders (
  order_id BIGINT PRIMARY KEY,
  user_id BIGINT REFERENCES users(user_id)
  -- Нет индекса на user_id!
);
```

### Constraints

```sql
-- ✅ GOOD: Полные constraints
CREATE TABLE users (
  user_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email TEXT NOT NULL UNIQUE NULLS NOT DISTINCT,  -- PG15+
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
  user_id BIGINT PRIMARY KEY,
  email TEXT,  -- Может быть NULL!
  age INTEGER  -- Может быть отрицательным!
);
```

## JSONB Best Practices

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

-- ✅ GOOD: Queries
SELECT * FROM profiles 
WHERE settings @> '{"notifications": true}';  -- Использует GIN

SELECT * FROM profiles 
WHERE theme = 'dark';  -- Использует B-tree на extracted column

-- ❌ BAD: Без индекса
SELECT * FROM profiles 
WHERE (settings->>'theme')::TEXT = 'dark';  -- Slow!
```

## Partitioning

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

CREATE TABLE logs_2024_02 PARTITION OF logs
FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

-- Индексы на партициях
CREATE INDEX idx_logs_2024_01_user ON logs_2024_01(user_id);

-- ✅ GOOD: Hash partitioning для равномерного распределения
CREATE TABLE user_sessions (
  session_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id BIGINT NOT NULL,
  data JSONB NOT NULL
) PARTITION BY HASH (user_id);

CREATE TABLE user_sessions_0 PARTITION OF user_sessions
FOR VALUES WITH (MODULUS 4, REMAINDER 0);
```

## Performance Patterns

### Update-Heavy Tables

```sql
-- ✅ GOOD: Разделение hot/cold columns
CREATE TABLE users (
  user_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE user_stats (
  user_id BIGINT PRIMARY KEY REFERENCES users(user_id),
  login_count INTEGER NOT NULL DEFAULT 0,
  last_login TIMESTAMPTZ,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
) WITH (fillfactor=90);  -- Оставляем место для HOT updates
```

### Insert-Heavy Tables

```sql
-- ✅ GOOD: Минимум индексов, UNLOGGED для staging
CREATE UNLOGGED TABLE staging_data (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  data JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Только необходимые индексы
CREATE INDEX idx_staging_created ON staging_data(created_at);
```

## Common Patterns

### Audit Trail

```sql
CREATE TABLE audit_log (
  log_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  table_name TEXT NOT NULL,
  record_id BIGINT NOT NULL,
  action TEXT NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
  old_data JSONB,
  new_data JSONB,
  user_id BIGINT REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
) PARTITION BY RANGE (created_at);

CREATE INDEX idx_audit_table_record ON audit_log(table_name, record_id);
```

### Soft Delete

```sql
CREATE TABLE posts (
  post_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(user_id),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  deleted_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Partial index только для активных
CREATE INDEX idx_posts_active ON posts(user_id) 
WHERE deleted_at IS NULL;
```

### Versioning

```sql
CREATE TABLE document_versions (
  version_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  document_id BIGINT NOT NULL,
  version_number INTEGER NOT NULL,
  content TEXT NOT NULL,
  created_by BIGINT NOT NULL REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (document_id, version_number)
);

CREATE INDEX idx_versions_document ON document_versions(document_id, version_number DESC);
```

## Extensions

```sql
-- ✅ GOOD: Используй нужные extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";      -- UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";       -- Crypto functions
CREATE EXTENSION IF NOT EXISTS "pg_trgm";        -- Fuzzy search
CREATE EXTENSION IF NOT EXISTS "btree_gin";      -- Mixed-type indexes
CREATE EXTENSION IF NOT EXISTS "timescaledb";    -- Time-series
CREATE EXTENSION IF NOT EXISTS "postgis";        -- Geospatial
CREATE EXTENSION IF NOT EXISTS "pgvector";       -- Vector similarity
```

## Checklist

```
PostgreSQL Design Review:
- [ ] PRIMARY KEY определён (BIGINT IDENTITY или UUID)
- [ ] Все FK имеют индексы
- [ ] Используется TEXT вместо VARCHAR
- [ ] Используется TIMESTAMPTZ вместо TIMESTAMP
- [ ] Используется NUMERIC для денег
- [ ] NOT NULL где нужно
- [ ] CHECK constraints для валидации
- [ ] ON DELETE/UPDATE для FK
- [ ] GIN индексы для JSONB
- [ ] Partitioning для больших таблиц (>100M rows)
- [ ] Нет SERIAL (используется IDENTITY)
```

## Антипаттерны

### ❌ Использование VARCHAR вместо TEXT
```sql
-- NO!
name VARCHAR(255)

-- YES!
name TEXT
```

### ❌ Забыли индекс на FK
```sql
-- NO!
CREATE TABLE orders (
  user_id BIGINT REFERENCES users(user_id)
);

-- YES!
CREATE TABLE orders (
  user_id BIGINT REFERENCES users(user_id)
);
CREATE INDEX idx_orders_user_id ON orders(user_id);
```

### ❌ TIMESTAMP без timezone
```sql
-- NO!
created_at TIMESTAMP

-- YES!
created_at TIMESTAMPTZ
```

## Ресурсы

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Use The Index, Luke](https://use-the-index-luke.com/)
- [PostgreSQL Wiki](https://wiki.postgresql.org/)
