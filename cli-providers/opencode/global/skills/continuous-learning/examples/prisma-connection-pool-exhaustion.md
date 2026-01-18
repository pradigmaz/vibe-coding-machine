# Prisma Connection Pool Exhaustion в Serverless Skill

## Назначение

Fix Prisma "Too many connections" и connection pool exhaustion ошибок в serverless окружениях (Vercel, AWS Lambda, Netlify). Используется когда:
- Error "P2024: Timed out fetching a new connection from the pool"
- PostgreSQL "too many connections for role"
- Database работает локально но падает в production serverless
- Intermittent database timeouts под нагрузкой

## Проблема

Serverless функции создают новый Prisma client instance при каждом cold start. Каждый instance открывает несколько database connections (default: 5 per instance). При многих concurrent requests это быстро исчерпывает connection limit базы (часто 20-100 для managed databases).

## Trigger Conditions

- `P2024: Timed out fetching a new connection from the connection pool`
- PostgreSQL: `FATAL: too many connections for role "username"`
- MySQL: `Too many connections`
- Работает локально с `npm run dev` но падает в production
- Ошибки появляются при traffic spikes, потом исчезают
- Database dashboard показывает connections на или около лимита

**Environment индикаторы**:
- Deploy на Vercel, AWS Lambda, Netlify Functions, или похожие
- Используется Prisma с PostgreSQL, MySQL, или другой connection-based database
- Database managed (PlanetScale, Supabase, Neon, RDS, etc.)

## Решение

### Шаг 1: Используй Connection Pooling Service

Рекомендуемое решение — использовать connection pooler типа PgBouncer или Prisma Accelerate, который находится между serverless функциями и базой.

**Для Supabase:**
```env
# .env
# Используй pooled connection string (port 6543, не 5432)
DATABASE_URL="postgresql://user:pass@db.xxx.supabase.co:6543/postgres?pgbouncer=true"
```

**Для Neon:**
```env
# .env  
DATABASE_URL="postgresql://user:pass@ep-xxx.us-east-2.aws.neon.tech/dbname?sslmode=require"
# Neon имеет встроенный pooling
```

**Для Prisma Accelerate:**
```bash
npx prisma generate --accelerate
```

### Шаг 2: Настрой Prisma Connection Limits

В `schema.prisma`:

```prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
  // Ограничь connections per Prisma instance
  relationMode = "prisma"
}
```

В connection URL или Prisma client:

```typescript
// lib/prisma.ts
import { PrismaClient } from '@prisma/client'

const globalForPrisma = global as unknown as { prisma: PrismaClient }

export const prisma = globalForPrisma.prisma || new PrismaClient({
  datasources: {
    db: {
      url: process.env.DATABASE_URL + '?connection_limit=1'
    }
  }
})

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma
```

### Шаг 3: Singleton Pattern (Development)

Предотврати hot-reload от создания новых clients:

```typescript
// lib/prisma.ts
import { PrismaClient } from '@prisma/client'

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined
}

export const prisma = globalForPrisma.prisma ?? new PrismaClient()

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma
```

### Шаг 4: URL Parameters

Добавь в connection string:

```
?connection_limit=1&pool_timeout=20&connect_timeout=10
```

- `connection_limit=1`: Одно connection per serverless instance
- `pool_timeout=20`: Жди до 20s для available connection
- `connect_timeout=10`: Fail fast если не можешь подключиться за 10s

## Проверка

После применения фиксов:

1. Deploy в production
2. Запусти load test: `npx autocannon -c 100 -d 30 https://your-app.com/api/test`
3. Проверь database dashboard — connections должны оставаться в пределах лимитов
4. Нет больше P2024 ошибок в логах

## Пример

**До** (ошибка под нагрузкой):
```
[ERROR] PrismaClientKnownRequestError:
Invalid `prisma.user.findMany()` invocation:
Timed out fetching a new connection from the connection pool.
```

**После** (с connection pooling):
```env
# Используя Supabase pooler URL
DATABASE_URL="postgresql://...@db.xxx.supabase.co:6543/postgres?pgbouncer=true&connection_limit=1"
```

Database connections стабильны на 10-15 даже под heavy load.

## Заметки

- Разные managed databases имеют разные pooling решения — проверь доки провайдера
- PlanetScale (MySQL) использует другую архитектуру и не имеет этой проблемы
- `connection_limit=1` агрессивно; начни с этого и увеличь если видишь latency
- Singleton pattern помогает только в development; в production serverless каждый instance изолирован
- Если используешь Prisma с Next.js API routes, каждый route invocation может быть отдельной serverless функцией
- Рассмотри Prisma Accelerate для встроенного caching + pooling: https://www.prisma.io/accelerate

## References

- [Prisma Connection Management](https://www.prisma.io/docs/guides/performance-and-optimization/connection-management)
- [Supabase Connection Pooling](https://supabase.com/docs/guides/database/connecting-to-postgres#connection-pooler)
- [Neon Serverless Driver](https://neon.tech/docs/serverless/serverless-driver)
