---
name: debugging-strategies
description: Систематические техники отладки, инструменты профилирования и анализ первопричин для эффективного отслеж...
---
# Debugging Strategies

## Назначение

Систематические техники отладки, инструменты профилирования и анализ первопричин для эффективного отслеживания багов в любой кодовой базе или технологическом стеке. Применяется при расследовании багов, проблем производительности или неожиданного поведения.

## Когда использовать

- Отслеживание неуловимых багов
- Расследование проблем производительности
- Понимание незнакомых кодовых баз
- Отладка production issues
- Анализ crash dumps и stack traces
- Профилирование производительности приложения
- Расследование memory leaks
- Отладка распределенных систем
- Debugging intermittent/flaky bugs
- Root cause analysis

## Core Principles

### 1. The Scientific Method

**1. Observe**: What's the actual behavior?
**2. Hypothesize**: What could be causing it?
**3. Experiment**: Test your hypothesis
**4. Analyze**: Did it prove/disprove your theory?
**5. Repeat**: Until you find the root cause

### 2. Debugging Mindset

**Don't Assume:**
- "It can't be X" - Yes it can
- "I didn't change Y" - Check anyway
- "It works on my machine" - Find out why

**Do:**
- Reproduce consistently
- Isolate the problem
- Keep detailed notes
- Question everything
- Take breaks when stuck

### 3. Rubber Duck Debugging

Explain your code and problem out loud (to a rubber duck, colleague, or yourself). Often reveals the issue.

## Systematic Debugging Process

### Phase 1: Reproduce

```markdown
## Reproduction Checklist

1. **Can you reproduce it?**
   - Always? Sometimes? Randomly?
   - Specific conditions needed?
   - Can others reproduce it?

2. **Create minimal reproduction**
   - Simplify to smallest example
   - Remove unrelated code
   - Isolate the problem

3. **Document steps**
   - Write down exact steps
   - Note environment details
   - Capture error messages
```

### Phase 2: Gather Information

```markdown
## Information Collection

1. **Error Messages**
   - Full stack trace
   - Error codes
   - Console/log output

2. **Environment**
   - OS version
   - Language/runtime version
   - Dependencies versions
   - Environment variables

3. **Recent Changes**
   - Git history
   - Deployment timeline
   - Configuration changes

4. **Scope**
   - Affects all users or specific ones?
   - All browsers or specific ones?
   - Production only or also dev?
```

### Phase 3: Form Hypothesis

```markdown
## Hypothesis Formation

Based on gathered info, ask:

1. **What changed?**
   - Recent code changes
   - Dependency updates
   - Infrastructure changes

2. **What's different?**
   - Working vs broken environment
   - Working vs broken user
   - Before vs after

3. **Where could this fail?**
   - Input validation
   - Business logic
   - Data layer
   - External services
```

### Phase 4: Test & Verify

```markdown
## Testing Strategies

1. **Binary Search**
   - Comment out half the code
   - Narrow down problematic section
   - Repeat until found

2. **Add Logging**
   - Strategic console.log/print
   - Track variable values
   - Trace execution flow

3. **Isolate Components**
   - Test each piece separately
   - Mock dependencies
   - Remove complexity

4. **Compare Working vs Broken**
   - Diff configurations
   - Diff environments
   - Diff data
```

## Debugging Tools

### JavaScript/TypeScript Debugging

```typescript
// Chrome DevTools Debugger
function processOrder(order: Order) {
    debugger;  // Execution pauses here

    const total = calculateTotal(order);
    console.log('Total:', total);

    // Conditional breakpoint
    if (order.items.length > 10) {
        debugger;  // Only breaks if condition true
    }

    return total;
}

// Console debugging techniques
console.log('Value:', value);                    // Basic
console.table(arrayOfObjects);                   // Table format
console.time('operation'); /* code */ console.timeEnd('operation');  // Timing
console.trace();                                 // Stack trace
console.assert(value > 0, 'Value must be positive');  // Assertion

// Performance profiling
performance.mark('start-operation');
// ... operation code
performance.mark('end-operation');
performance.measure('operation', 'start-operation', 'end-operation');
console.log(performance.getEntriesByType('measure'));
```

**VS Code Debugger Configuration:**
```json
// .vscode/launch.json
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "node",
            "request": "launch",
            "name": "Debug Program",
            "program": "${workspaceFolder}/src/index.ts",
            "preLaunchTask": "tsc: build - tsconfig.json",
            "outFiles": ["${workspaceFolder}/dist/**/*.js"],
            "skipFiles": ["<node_internals>/**"]
        },
        {
            "type": "node",
            "request": "launch",
            "name": "Debug Tests",
            "program": "${workspaceFolder}/node_modules/jest/bin/jest",
            "args": ["--runInBand", "--no-cache"],
            "console": "integratedTerminal"
        }
    ]
}
```

### Python Debugging

```python
# Built-in debugger (pdb)
import pdb

def calculate_total(items):
    total = 0
    pdb.set_trace()  # Debugger starts here

    for item in items:
        total += item.price * item.quantity

    return total

# Breakpoint (Python 3.7+)
def process_order(order):
    breakpoint()  # More convenient than pdb.set_trace()
    # ... code

# Post-mortem debugging
try:
    risky_operation()
except Exception:
    import pdb
    pdb.post_mortem()  # Debug at exception point

# IPython debugging (ipdb)
from ipdb import set_trace
set_trace()  # Better interface than pdb

# Logging for debugging
import logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

def fetch_user(user_id):
    logger.debug(f'Fetching user: {user_id}')
    user = db.query(User).get(user_id)
    logger.debug(f'Found user: {user}')
    return user

# Profile performance
import cProfile
import pstats

cProfile.run('slow_function()', 'profile_stats')
stats = pstats.Stats('profile_stats')
stats.sort_stats('cumulative')
stats.print_stats(10)  # Top 10 slowest
```

### Go Debugging

```go
// Delve debugger
// Install: go install github.com/go-delve/delve/cmd/dlv@latest
// Run: dlv debug main.go

import (
    "fmt"
    "runtime"
    "runtime/debug"
)

// Print stack trace
func debugStack() {
    debug.PrintStack()
}

// Panic recovery with debugging
func processRequest() {
    defer func() {
        if r := recover(); r != nil {
            fmt.Println("Panic:", r)
            debug.PrintStack()
        }
    }()

    // ... code that might panic
}

// Memory profiling
import _ "net/http/pprof"
// Visit http://localhost:6060/debug/pprof/

// CPU profiling
import (
    "os"
    "runtime/pprof"
)

f, _ := os.Create("cpu.prof")
pprof.StartCPUProfile(f)
defer pprof.StopCPUProfile()
// ... code to profile
```

## Advanced Debugging Techniques

### Technique 1: Binary Search Debugging

```bash
# Git bisect for finding regression
git bisect start
git bisect bad                    # Current commit is bad
git bisect good v1.0.0            # v1.0.0 was good

# Git checks out middle commit
# Test it, then:
git bisect good   # if it works
git bisect bad    # if it's broken

# Continue until bug found
git bisect reset  # when done
```

### Technique 2: Differential Debugging

Compare working vs broken:

```markdown
## What's Different?

| Aspect       | Working         | Broken          |
|--------------|-----------------|-----------------|
| Environment  | Development     | Production      |
| Node version | 18.16.0         | 18.15.0         |
| Data         | Empty DB        | 1M records      |
| User         | Admin           | Regular user    |
| Browser      | Chrome          | Safari          |
| Time         | During day      | After midnight  |

Hypothesis: Time-based issue? Check timezone handling.
```

### Technique 3: Trace Debugging

```typescript
// Function call tracing
function trace(target: any, propertyKey: string, descriptor: PropertyDescriptor) {
    const originalMethod = descriptor.value;

    descriptor.value = function(...args: any[]) {
        console.log(`Calling ${propertyKey} with args:`, args);
        const result = originalMethod.apply(this, args);
        console.log(`${propertyKey} returned:`, result);
        return result;
    };

    return descriptor;
}

class OrderService {
    @trace
    calculateTotal(items: Item[]): number {
        return items.reduce((sum, item) => sum + item.price, 0);
    }
}
```

### Technique 4: Memory Leak Detection

```typescript
// Chrome DevTools Memory Profiler
// 1. Take heap snapshot
// 2. Perform action
// 3. Take another snapshot
// 4. Compare snapshots

// Node.js memory debugging
if (process.memoryUsage().heapUsed > 500 * 1024 * 1024) {
    console.warn('High memory usage:', process.memoryUsage());

    // Generate heap dump
    require('v8').writeHeapSnapshot();
}

// Find memory leaks in tests
let beforeMemory: number;

beforeEach(() => {
    beforeMemory = process.memoryUsage().heapUsed;
});

afterEach(() => {
    const afterMemory = process.memoryUsage().heapUsed;
    const diff = afterMemory - beforeMemory;

    if (diff > 10 * 1024 * 1024) {  // 10MB threshold
        console.warn(`Possible memory leak: ${diff / 1024 / 1024}MB`);
    }
});
```

## Debugging Patterns by Issue Type

### Pattern 1: Intermittent Bugs

```markdown
## Strategies for Flaky Bugs

1. **Add extensive logging**
   - Log timing information
   - Log all state transitions
   - Log external interactions

2. **Look for race conditions**
   - Concurrent access to shared state
   - Async operations completing out of order
   - Missing synchronization

3. **Check timing dependencies**
   - setTimeout/setInterval
   - Promise resolution order
   - Animation frame timing

4. **Stress test**
   - Run many times
   - Vary timing
   - Simulate load
```

### Pattern 2: Performance Issues

```markdown
## Performance Debugging

1. **Profile first**
   - Don't optimize blindly
   - Measure before and after
   - Find bottlenecks

2. **Common culprits**
   - N+1 queries
   - Unnecessary re-renders
   - Large data processing
   - Synchronous I/O

3. **Tools**
   - Browser DevTools Performance tab
   - Lighthouse
   - Python: cProfile, line_profiler
   - Node: clinic.js, 0x
```

### Pattern 3: Production Bugs

```markdown
## Production Debugging

1. **Gather evidence**
   - Error tracking (Sentry, Bugsnag)
   - Application logs
   - User reports
   - Metrics/monitoring

2. **Reproduce locally**
   - Use production data (anonymized)
   - Match environment
   - Follow exact steps

3. **Safe investigation**
   - Don't change production
   - Use feature flags
   - Add monitoring/logging
   - Test fixes in staging
```

## CLI Commands для Debugging

### Node.js/TypeScript Debugging

```bash
# Запуск с debugger
node --inspect app.js
node --inspect-brk app.js  # Break on first line

# Chrome DevTools
# Открой chrome://inspect

# VS Code debugging
# Создай .vscode/launch.json (см. примеры выше)

# Debug тестов
node --inspect-brk node_modules/.bin/jest --runInBand

# Memory profiling
node --inspect --expose-gc app.js

# Heap snapshot
node --heap-prof app.js

# CPU profiling
node --cpu-prof app.js
```

### Python Debugging

```bash
# Запуск с debugger
python -m pdb app.py

# IPython debugger (лучше чем pdb)
pip install ipdb
python -m ipdb app.py

# Post-mortem debugging
python -c "import sys; sys.excepthook = lambda *args: __import__('pdb').post_mortem()"

# Memory profiling
pip install memory_profiler
python -m memory_profiler script.py

# Line profiling
pip install line_profiler
kernprof -l -v script.py

# CPU profiling
python -m cProfile -o profile.stats script.py
python -c "import pstats; p = pstats.Stats('profile.stats'); p.sort_stats('cumulative'); p.print_stats(20)"

# Trace execution
python -m trace --trace script.py
```

### Go Debugging

```bash
# Delve debugger
go install github.com/go-delve/delve/cmd/dlv@latest

# Debug program
dlv debug main.go

# Debug tests
dlv test

# Attach to running process
dlv attach <PID>

# CPU profiling
go test -cpuprofile=cpu.prof
go tool pprof cpu.prof

# Memory profiling
go test -memprofile=mem.prof
go tool pprof mem.prof

# Live profiling
go tool pprof http://localhost:6060/debug/pprof/profile
```

### Git Bisect для Finding Regressions

```bash
# Найти коммит, который сломал код
git bisect start
git bisect bad                    # Текущий коммит сломан
git bisect good v1.0.0            # v1.0.0 работал

# Git проверяет средний коммит
# Тестируй его, затем:
git bisect good   # если работает
git bisect bad    # если сломан

# Продолжай пока не найдешь
git bisect reset  # когда закончил

# Автоматический bisect
git bisect start HEAD v1.0.0
git bisect run npm test
```

### Системные инструменты

```bash
# Linux: strace (system calls)
strace -p <PID>
strace -c python app.py  # Count calls

# macOS: dtruss
sudo dtruss -p <PID>

# Network debugging
tcpdump -i any port 8080
wireshark

# Process monitoring
top
htop
ps aux | grep node

# File descriptors
lsof -p <PID>
lsof -i :8080  # What's using port 8080?

# Memory usage
free -h
vmstat 1

# Disk I/O
iostat -x 1
```

## Best Practices

### Процесс отладки
1. **Reproduce First**: Не можешь починить то, что не можешь воспроизвести
2. **Isolate the Problem**: Убирай сложность до минимального случая
3. **Read Error Messages**: Они обычно полезны
4. **Check Recent Changes**: Большинство багов недавние
5. **Use Version Control**: Git bisect, blame, history

### Инструменты
6. **Use Debugger**: console.log не всегда лучший выбор
7. **Profile Before Optimize**: Не оптимизируй вслепую
8. **Take Breaks**: Свежий взгляд видит лучше
9. **Document Findings**: Помоги будущему себе
10. **Fix Root Cause**: Не только симптомы

### Коммуникация
11. **Rubber Duck Debug**: Объясни проблему вслух
12. **Ask for Help**: Когда застрял >30 минут
13. **Share Findings**: Помоги команде учиться
14. **Write Reproduction Steps**: Для bug reports
15. **Test the Fix**: Проверь, что действительно работает

## Checklist для debugging

Когда застрял, проверь:
- [ ] Spelling errors (опечатки в именах переменных)
- [ ] Case sensitivity (fileName vs filename)
- [ ] Null/undefined values
- [ ] Array index off-by-one
- [ ] Async timing (race conditions)
- [ ] Scope issues (closure, hoisting)
- [ ] Type mismatches
- [ ] Missing dependencies
- [ ] Environment variables
- [ ] File paths (absolute vs relative)
- [ ] Cache issues (очисти cache)
- [ ] Stale data (обнови database)
- [ ] Recent git changes (git log, git diff)
- [ ] Dependency versions (package.json, requirements.txt)
- [ ] Configuration files (.env, config.json)

## Антипаттерны

❌ **Making Multiple Changes:**
```bash
# BAD: Изменил 5 вещей сразу
git diff
# 100+ lines changed
```

✅ **Правильно - One Change at a Time:**
```bash
# GOOD: Одно изменение, проверь, повтори
# Change 1: Add logging
# Test
# Change 2: Fix typo
# Test
```

❌ **Not Reading Error Messages:**
```python
# BAD: Игнорирование stack trace
try:
    result = process_data()
except Exception:
    print("Error occurred")  # Что за ошибка?!
```

✅ **Правильно - Read Full Error:**
```python
# GOOD: Читай полный stack trace
try:
    result = process_data()
except Exception as e:
    logger.exception(f"Failed to process: {e}")
    # Смотри полный traceback в логах
    raise
```

❌ **Debug Logging in Production:**
```typescript
// BAD: Оставил debug код
console.log('User data:', user);  // Утечка PII!
console.log('API key:', process.env.API_KEY);  // Утечка секретов!
```

✅ **Правильно - Remove Debug Code:**
```typescript
// GOOD: Используй proper logging
logger.debug('Processing user', { userId: user.id });  // Только ID
// Удали перед коммитом
```

## Ресурсы

- **Chrome DevTools**: https://developer.chrome.com/docs/devtools/
- **VS Code Debugging**: https://code.visualstudio.com/docs/editor/debugging
- **Python pdb**: https://docs.python.org/3/library/pdb.html
- **Go Delve**: https://github.com/go-delve/delve
- **Git Bisect**: https://git-scm.com/docs/git-bisect
