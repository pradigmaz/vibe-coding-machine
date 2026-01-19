---
name: optimizing-performance
description: Performance optimization для frontend, backend, database. Используется всеми агентами для диагностики slowness, улучшения load times, оптими...
---
# Optimizing Performance Skill

## Назначение

Performance optimization для frontend, backend, database. Используется всеми агентами для диагностики slowness, улучшения load times, оптимизации queries.

## Performance Workflow

```
Performance Optimization Progress:
- [ ] Step 1: Measure baseline performance
- [ ] Step 2: Identify bottlenecks
- [ ] Step 3: Apply targeted optimizations
- [ ] Step 4: Measure again and compare
- [ ] Step 5: Repeat if targets not met
```

**Critical Rule**: Never optimize without data. Always profile before and after.

## Step 1: Measure Baseline

### Profiling Commands

```bash
# Node.js profiling
node --prof app.js
node --prof-process isolate*.log > profile.txt

# Python profiling
python -m cProfile -o profile.stats app.py

# Web performance
lighthouse https://example.com --output=json
```

## Step 2: Identify Bottlenecks

### Common Bottleneck Categories

| Category | Symptoms | Tools |
|----------|----------|-------|
| CPU | High CPU usage, slow computation | Profiler, flame graphs |
| Memory | High RAM, GC pauses, OOM | Heap snapshots |
| I/O | Slow disk/network, waiting | strace, network inspector |
| Database | Slow queries, lock contention | Query analyzer, EXPLAIN |

## Step 3: Apply Optimizations

### Frontend Optimizations

**Bundle Size:**
```javascript
// ❌ Import entire library
import _ from 'lodash';

// ✅ Import only needed functions
import debounce from 'lodash/debounce';

// ✅ Dynamic imports для code splitting
const HeavyComponent = lazy(() => import('./HeavyComponent'));
```

**Rendering:**
```javascript
// ❌ Render on every parent update
function Child({ data }) {
  return <ExpensiveComponent data={data} />;
}

// ✅ Memoize когда props не меняются
const Child = memo(function Child({ data }) {
  return <ExpensiveComponent data={data} />;
});

// ✅ useMemo для expensive computations
const processed = useMemo(() => expensiveCalc(data), [data]);
```


**Images:**
```html
<!-- ❌ Unoptimized -->
<img src="large-image.jpg" />

<!-- ✅ Optimized -->
<img
  src="image.webp"
  srcset="image-300.webp 300w, image-600.webp 600w"
  sizes="(max-width: 600px) 300px, 600px"
  loading="lazy"
  decoding="async"
/>
```

### Backend Optimizations

**Database Queries:**
```sql
-- ❌ N+1 Query Problem
SELECT * FROM users;
-- Then for each user:
SELECT * FROM orders WHERE user_id = ?;

-- ✅ Single query с JOIN
SELECT u.*, o.*
FROM users u
LEFT JOIN orders o ON u.id = o.user_id;

-- ✅ Or use pagination
SELECT * FROM users LIMIT 100 OFFSET 0;
```

**Caching Strategy:**
```javascript
// Multi-layer caching
const getUser = async (id) => {
  // L1: In-memory cache (fastest)
  let user = memoryCache.get(`user:${id}`);
  if (user) return user;

  // L2: Redis cache (fast)
  user = await redis.get(`user:${id}`);
  if (user) {
    memoryCache.set(`user:${id}`, user, 60);
    return JSON.parse(user);
  }

  // L3: Database (slow)
  user = await db.users.findById(id);
  await redis.setex(`user:${id}`, 3600, JSON.stringify(user));
  memoryCache.set(`user:${id}`, user, 60);

  return user;
};
```

**Async Processing:**
```javascript
// ❌ Blocking operation
app.post('/upload', async (req, res) => {
  await processVideo(req.file);  // Takes 5 minutes
  res.send('Done');
});

// ✅ Queue для background processing
app.post('/upload', async (req, res) => {
  const jobId = await queue.add('processVideo', { file: req.file });
  res.send({ jobId, status: 'processing' });
});
```

### Algorithm Optimizations

```javascript
// ❌ O(n²) - nested loops
function findDuplicates(arr) {
  const duplicates = [];
  for (let i = 0; i < arr.length; i++) {
    for (let j = i + 1; j < arr.length; j++) {
      if (arr[i] === arr[j]) duplicates.push(arr[i]);
    }
  }
  return duplicates;
}

// ✅ O(n) - hash map
function findDuplicates(arr) {
  const seen = new Set();
  const duplicates = new Set();
  for (const item of arr) {
    if (seen.has(item)) duplicates.add(item);
    seen.add(item);
  }
  return [...duplicates];
}
```

## Performance Targets

### Web Vitals

| Metric | Good | Needs Work | Poor |
|--------|------|------------|------|
| LCP | < 2.5s | 2.5-4s | > 4s |
| FID | < 100ms | 100-300ms | > 300ms |
| CLS | < 0.1 | 0.1-0.25 | > 0.25 |
| TTFB | < 800ms | 800ms-1.8s | > 1.8s |

### API Performance

| Metric | Target |
|--------|--------|
| P50 Latency | < 100ms |
| P95 Latency | < 500ms |
| P99 Latency | < 1s |
| Error Rate | < 0.1% |

## Validation

```
Performance Validation:
- [ ] Metrics improved from baseline
- [ ] No functionality regressions
- [ ] No new errors introduced
- [ ] Changes are sustainable
- [ ] Performance gains documented
```

## Best Practices

```javascript
// ✅ GOOD: Profile first
const start = performance.now();
// code
console.log(`Took ${performance.now() - start}ms`);

// ✅ GOOD: Use appropriate data structures
const userMap = new Map();  // O(1) lookup
const userSet = new Set();  // O(1) membership

// ✅ GOOD: Cache expensive operations
const memoized = useMemo(() => expensiveCalc(data), [data]);

// ✅ GOOD: Lazy load
const Heavy = lazy(() => import('./Heavy'));

// ✅ GOOD: Batch operations
await Promise.all([op1(), op2(), op3()]);

// ❌ BAD: Premature optimization
// Optimize hot paths, not everything

// ❌ BAD: Nested loops
for (let i = 0; i < n; i++) {
  for (let j = 0; j < n; j++) {  // O(n²)
  }
}

// ❌ BAD: Synchronous I/O
const data = fs.readFileSync('file.txt');  // Blocks!
```

## Checklist

```
Performance Optimization Review:
- [ ] Baseline metrics измерены
- [ ] Bottlenecks identified
- [ ] Optimizations applied
- [ ] After metrics измерены
- [ ] Improvement documented
- [ ] No regressions
- [ ] Targets met
```

## Ресурсы

- [Web Vitals](https://web.dev/vitals/)
- [Lighthouse](https://developers.google.com/web/tools/lighthouse)
- [Chrome DevTools](https://developer.chrome.com/docs/devtools/)
