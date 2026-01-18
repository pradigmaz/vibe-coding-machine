---
name: error-resolver
description: Систематическая диагностика и решение ошибок используя first-principle анализ. Применяется при любых error messages, stack ...
---
# Error Resolver

## Назначение

Систематическая диагностика и решение ошибок используя first-principle анализ. Применяется при любых error messages, stack traces или неожиданном поведении. Поддерживает replay функциональность для записи и повторного использования решений.

## Когда использовать

- Диагностика любых error messages
- Анализ stack traces
- Расследование неожиданного поведения
- Debugging production issues
- Решение build/compile errors
- Troubleshooting dependency issues
- Анализ network/API errors
- Memory/performance issues
- Создание базы знаний решений (replay system)

## Core Philosophy

**The 5-step Error Resolution Process:**

```
1. CLASSIFY  ->  2. PARSE  ->  3. MATCH  ->  4. ANALYZE  ->  5. RESOLVE
     |              |             |             |              |
  What type?    Extract key    Known       Root cause      Fix +
               information    pattern?     analysis       Prevent
```

## Quick Start

When you encounter an error:

1. **Paste the full error** (including stack trace if available)
2. **Provide context** (what were you trying to do?)
3. **Share relevant code** (the file/function involved)

## Error Classification Framework

### Primary Categories

| Category | Indicators | Common Causes |
|----------|------------|---------------|
| **Syntax** | Parse error, Unexpected token | Typos, missing brackets, invalid syntax |
| **Type** | TypeError, type mismatch | Wrong data type, null/undefined access |
| **Reference** | ReferenceError, NameError | Undefined variable, scope issues |
| **Runtime** | RuntimeError, Exception | Logic errors, invalid operations |
| **Network** | ECONNREFUSED, timeout, 4xx/5xx | Connection issues, wrong URL, server down |
| **Permission** | EACCES, PermissionError | File/directory access, sudo needed |
| **Dependency** | ModuleNotFound, Cannot find module | Missing package, version mismatch |
| **Configuration** | Config error, env missing | Wrong settings, missing env vars |
| **Database** | Connection refused, query error | DB down, wrong credentials, bad query |
| **Memory** | OOM, heap out of memory | Memory leak, large data processing |

### Secondary Attributes

- **Severity**: Fatal / Error / Warning / Info
- **Scope**: Build-time / Runtime / Test-time
- **Origin**: User code / Framework / Third-party / System

## Analysis Workflow

### Step 1: Classify

Identify the error category by examining:
- Error name/code (e.g., `ENOENT`, `TypeError`)
- Error message keywords
- Where it occurred (compile, runtime, test)

### Step 2: Parse

Extract key information:
```
- Error code: [specific code if any]
- File path: [where the error originated]
- Line number: [exact line if available]
- Function/method: [context of the error]
- Variable/value: [what was involved]
- Stack trace depth: [how deep is the call stack]
```

### Step 3: Match Patterns

Check against known error patterns:
- See `patterns/` directory for language-specific patterns
- Match error signatures to known solutions
- Check replay history for previous solutions

### Step 4: Root Cause Analysis

Apply the **5 Whys** technique:
```
Error: Cannot read property 'name' of undefined
  Why 1? -> user object is undefined
  Why 2? -> API call returned null
  Why 3? -> User ID doesn't exist in database
  Why 4? -> ID was from stale cache
  Why 5? -> Cache invalidation not implemented

Root Cause: Missing cache invalidation logic
```

### Step 5: Resolve

Generate actionable solution:
1. **Immediate fix** - Get it working now
2. **Proper fix** - The right way to solve it
3. **Prevention** - How to avoid in the future

## Output Format

When resolving an error, provide:

```
## Error Diagnosis

**Classification**: [Category] / [Severity] / [Scope]

**Error Signature**:
- Code: [error code]
- Type: [error type]
- Location: [file:line]

## Root Cause

[Explanation of why this error occurred]

**Contributing Factors**:
1. [Factor 1]
2. [Factor 2]

## Solution

### Immediate Fix
[Quick steps to resolve]

### Code Change
[Specific code to add/modify]

### Verification
[How to verify the fix works]

## Prevention

[How to prevent this error in the future]

## Replay Tag

[Unique identifier for this solution - for future reference]
```

## Replay System

The replay system records successful solutions for future reference.

### Recording a Solution

After resolving an error, record it:

```bash
# Create solution record in project
mkdir -p .claude/error-solutions

# Solution file format: [error-type]-[hash].yaml
```

### Solution Record Format

```yaml
# .claude/error-solutions/[error-signature].yaml
id: "nodejs-module-not-found-express"
created: "2024-01-15T10:30:00Z"
updated: "2024-01-20T14:22:00Z"

error:
  type: "dependency"
  category: "ModuleNotFound"
  language: "nodejs"
  pattern: "Cannot find module 'express'"
  context: "npm project, missing dependency"

diagnosis:
  root_cause: "Package not installed or node_modules corrupted"
  factors:
    - "Missing npm install after git clone"
    - "Corrupted node_modules directory"
    - "Package not in package.json"

solution:
  immediate:
    - "Run: npm install express"
  proper:
    - "Check package.json has express listed"
    - "Run: rm -rf node_modules && npm install"
  code_change: null

verification:
  - "Run the application again"
  - "Check express is in node_modules"

prevention:
  - "Add npm install to project setup docs"
  - "Use npm ci in CI/CD pipelines"

metadata:
  occurrences: 5
  last_resolved: "2024-01-20T14:22:00Z"
  success_rate: 1.0
  tags: ["nodejs", "npm", "dependency"]
```

### Replay Lookup

When encountering an error:
1. Generate error signature from the error message
2. Search `.claude/error-solutions/` for matching patterns
3. If found, apply the recorded solution
4. If new, proceed with full analysis and record the solution

### Error Signature Generation

```
signature = hash(
  error_type +
  error_code +
  normalized_message +  # remove specific values
  language +
  framework
)
```

Example transformations:
- `Cannot find module 'express'` -> `Cannot find module '{module}'`
- `TypeError: Cannot read property 'name' of undefined` -> `TypeError: Cannot read property '{prop}' of undefined`

## CLI Commands для Error Resolution

### Node.js/TypeScript Debugging

```bash
# Verbose error output
NODE_DEBUG=* node app.js
NODE_DEBUG=http,net node app.js  # Specific modules

# Memory debugging
node --inspect app.js
node --inspect-brk app.js  # Break on start

# Heap snapshot
node --heap-prof app.js

# CPU profiling
node --cpu-prof app.js

# Check installed packages
npm ls [package-name]
npm ls --depth=0  # Top-level only

# Verify package integrity
npm audit
npm audit fix

# Clear cache
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

### Python Debugging

```bash
# Debug mode
python -m pdb script.py

# Post-mortem debugging
python -c "import sys; sys.excepthook = lambda *args: __import__('pdb').post_mortem()"

# Check installed packages
pip show [package-name]
pip list
pip list --outdated

# Verify dependencies
pip check

# Reinstall package
pip uninstall [package-name]
pip install [package-name]

# Virtual environment issues
deactivate
rm -rf venv
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Database Debugging

```bash
# PostgreSQL connection test
psql -h localhost -U user -d database -c "SELECT 1;"

# Check connections
psql -c "SELECT * FROM pg_stat_activity;"

# MySQL connection test
mysql -h localhost -u user -p -e "SELECT 1;"

# MongoDB connection test
mongosh "mongodb://localhost:27017" --eval "db.adminCommand('ping')"

# Redis connection test
redis-cli ping
redis-cli info
```

### Network/API Debugging

```bash
# Test endpoint
curl -v http://localhost:3000/api/health

# Check DNS
nslookup api.example.com
dig api.example.com

# Test connectivity
ping api.example.com
telnet api.example.com 443

# Check port usage
lsof -i :3000
netstat -an | grep 3000

# Trace route
traceroute api.example.com

# Check SSL certificate
openssl s_client -connect api.example.com:443 -servername api.example.com
```

### Docker/Container Debugging

```bash
# Container logs
docker logs container-name
docker logs -f container-name  # Follow
docker logs --tail 100 container-name

# Container shell
docker exec -it container-name /bin/bash
docker exec -it container-name sh

# Container inspect
docker inspect container-name
docker stats container-name

# Network debugging
docker network ls
docker network inspect bridge

# Volume debugging
docker volume ls
docker volume inspect volume-name
```

### Git Debugging

```bash
# Find which commit broke it
git bisect start
git bisect bad
git bisect good v1.0.0
# Test each commit
git bisect reset

# Check file history
git log --follow -- path/to/file
git blame path/to/file

# Diff between commits
git diff commit1 commit2

# Stash issues
git stash list
git stash show -p stash@{0}
git stash drop stash@{0}
```

### System Debugging

```bash
# Check file permissions
ls -la [file]
chmod 644 [file]
chown user:group [file]

# Check environment variables
env | grep [VAR_NAME]
printenv [VAR_NAME]
echo $VAR_NAME

# Check disk space
df -h
du -sh *

# Check memory
free -m  # Linux
vm_stat  # macOS

# Check processes
ps aux | grep node
top
htop

# Kill process
kill -9 [PID]
pkill -f "node app.js"
```

### Build/Compile Debugging

```bash
# TypeScript
tsc --noEmit  # Check types only
tsc --listFiles  # Show all files
tsc --traceResolution  # Debug module resolution

# Webpack
webpack --display-error-details
webpack --profile --json > stats.json

# Next.js
next build --debug
ANALYZE=true next build

# Vite
vite build --debug
vite build --mode development
```

## Best Practices

### Error Resolution Process
1. **Read Full Error** - Не игнорируй stack trace
2. **Classify Error** - Определи категорию (syntax, type, network, etc.)
3. **Extract Key Info** - File, line, function, variable
4. **Search Known Patterns** - Проверь replay history
5. **Root Cause Analysis** - 5 Whys technique

### Debugging Approach
6. **Reproduce Consistently** - Найди reliable repro steps
7. **Isolate Problem** - Minimal reproduction case
8. **Binary Search** - Comment out half, narrow down
9. **Add Logging** - Strategic console.log/print statements
10. **Use Debugger** - Breakpoints лучше чем logging

### Documentation
11. **Record Solutions** - Используй replay system
12. **Document Context** - Что пытался сделать
13. **Share Findings** - Помоги команде
14. **Update Docs** - Добавь в troubleshooting guide
15. **Create Tests** - Prevent regression

## Checklist для Error Resolution

Когда встречаешь ошибку:
- [ ] Прочитал полный error message и stack trace
- [ ] Классифицировал тип ошибки (syntax, type, network, etc.)
- [ ] Извлек key information (file, line, function)
- [ ] Проверил replay history для known solutions
- [ ] Воспроизвел ошибку consistently
- [ ] Создал minimal reproduction case
- [ ] Применил root cause analysis (5 Whys)
- [ ] Проверил recent changes (git log, git diff)
- [ ] Проверил environment variables
- [ ] Проверил dependencies versions
- [ ] Проверил configuration files
- [ ] Добавил logging для debugging
- [ ] Использовал debugger с breakpoints
- [ ] Нашел immediate fix
- [ ] Реализовал proper fix
- [ ] Добавил prevention measures
- [ ] Записал solution в replay system
- [ ] Создал test для regression prevention
- [ ] Обновил documentation

## Антипаттерны

❌ **Ignoring Stack Trace:**
```bash
# BAD: Только читаешь первую строку
Error: Cannot find module 'express'
# Игнорируешь остальное!
```

✅ **Правильно - Read Full Stack:**
```bash
# GOOD: Читаешь весь stack trace
Error: Cannot find module 'express'
    at Function.Module._resolveFilename (internal/modules/cjs/loader.js:880:15)
    at Function.Module._load (internal/modules/cjs/loader.js:725:27)
    at Module.require (internal/modules/cjs/loader.js:952:19)
    at require (internal/modules/cjs/helpers.js:88:18)
    at Object.<anonymous> (/app/server.js:3:17)  # <-- Твой код!
```

❌ **Random Changes:**
```bash
# BAD: Меняешь все подряд
npm install
rm -rf node_modules
npm cache clean --force
npm install --legacy-peer-deps
# Что помогло?!
```

✅ **Правильно - Systematic Approach:**
```bash
# GOOD: Одно изменение за раз
# 1. Check if package exists
npm ls express
# 2. If missing, install
npm install express
# 3. Verify
npm ls express
# 4. Test
node server.js
```

❌ **No Logging:**
```typescript
// BAD: Нет logging
async function fetchUser(id: string) {
    const user = await db.query('SELECT * FROM users WHERE id = ?', id);
    return user;  // Что если null?
}
```

✅ **Правильно - Strategic Logging:**
```typescript
// GOOD: Logging для debugging
async function fetchUser(id: string) {
    console.log('Fetching user:', id);
    const user = await db.query('SELECT * FROM users WHERE id = ?', id);
    console.log('User found:', user ? 'yes' : 'no');
    if (!user) {
        console.error('User not found:', id);
    }
    return user;
}
```

❌ **Assuming Root Cause:**
```bash
# BAD: Предполагаешь без проверки
# "Наверное это cache issue"
rm -rf node_modules
npm install
# Не помогло... что теперь?
```

✅ **Правильно - Verify Hypothesis:**
```bash
# GOOD: Проверяй гипотезы
# Hypothesis 1: Cache issue
npm cache verify
# Result: Cache OK

# Hypothesis 2: Wrong Node version
node --version
# Result: v16.0.0 (need v18+)

# Solution: Update Node
nvm install 18
nvm use 18
```

## Ресурсы

- **Stack Overflow**: https://stackoverflow.com/
- **GitHub Issues**: Поиск по error message
- **Error Documentation**: Официальная документация языка/фреймворка
- **Community Forums**: Reddit, Discord, Slack communities
- **AI Assistants**: ChatGPT, Claude для анализа ошибок

## Common Debugging Patterns

### Pattern 1: Binary Search
When the error location is unclear:
1. Comment out half the code
2. If error persists, it's in the remaining half
3. Repeat until you find the exact line

### Pattern 2: Minimal Reproduction
Create the smallest code that reproduces the error:
1. Start with empty file
2. Add code piece by piece
3. Stop when error appears
4. That's your minimal repro case

### Pattern 3: Rubber Duck Debugging
Explain the problem out loud (or to Claude):
1. What should happen?
2. What actually happens?
3. What changed recently?
4. What assumptions am I making?

### Pattern 4: Git Bisect
Find which commit introduced the bug:
```bash
git bisect start
git bisect bad  # current commit is bad
git bisect good [last-known-good-commit]
# Git will checkout commits for you to test
git bisect good/bad  # mark each as good or bad
git bisect reset  # when done
```

## Reference Files

- **patterns/** - Language-specific error patterns
  - `nodejs.md` - Node.js common errors
  - `python.md` - Python common errors
  - `react.md` - React/Next.js errors
  - `database.md` - Database errors
  - `docker.md` - Docker/container errors
  - `git.md` - Git errors
  - `network.md` - Network/API errors

- **analysis/** - Analysis methodologies
  - `stack-trace.md` - Stack trace parsing guide
  - `root-cause.md` - Root cause analysis techniques

- **replay/** - Replay system
  - `solution-template.yaml` - Template for recording solutions
