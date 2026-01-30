# Verification Loop Skill

Комплексная система верификации для сессий разработки.

## Когда использовать

- После завершения фичи или значительного изменения кода
- Перед созданием PR
- Когда нужно убедиться что quality gates пройдены
- После рефакторинга

## Фазы верификации

### Фаза 1: Build Verification
```bash
# Проверка сборки
npm run build 2>&1 | tail -20
# ИЛИ
pnpm build 2>&1 | tail -20
```

Если build fails → СТОП, исправь перед продолжением.

### Фаза 2: Type Check
```bash
# TypeScript
npx tsc --noEmit 2>&1 | head -30

# Python
pyright . 2>&1 | head -30
```

Репортуй все type errors. Исправь критические.

### Фаза 3: Lint Check
```bash
# JavaScript/TypeScript
npm run lint 2>&1 | head -30

# Python
ruff check . 2>&1 | head -30
```

### Фаза 4: Test Suite
```bash
# Тесты с coverage
npm run test -- --coverage 2>&1 | tail -50

# Цель: 80% minimum coverage
```

Репорт:
- Total tests: X
- Passed: X
- Failed: X
- Coverage: X%

### Фаза 5: Security Scan
```bash
# Проверка секретов
grep -rn "sk-" --include="*.ts" --include="*.js" . 2>/dev/null | head -10
grep -rn "api_key" --include="*.ts" --include="*.js" . 2>/dev/null | head -10

# Проверка console.log
grep -rn "console.log" --include="*.ts" --include="*.tsx" src/ 2>/dev/null | head -10
```

### Фаза 6: Diff Review
```bash
# Что изменилось
git diff --stat
git diff HEAD~1 --name-only
```

Проверь каждый изменённый файл на:
- Непреднамеренные изменения
- Отсутствующий error handling
- Потенциальные edge cases

## Формат вывода

```
VERIFICATION REPORT
==================

Build:     [PASS/FAIL]
Types:     [PASS/FAIL] (X errors)
Lint:      [PASS/FAIL] (X warnings)
Tests:     [PASS/FAIL] (X/Y passed, Z% coverage)
Security:  [PASS/FAIL] (X issues)
Diff:      [X files changed]

Overall:   [READY/NOT READY] for PR

Issues to Fix:
1. ...
2. ...
```

## JSON формат для агентов

```json
{
  "status": "success",
  "verification": {
    "build": {"passed": true},
    "types": {"passed": true, "errors": 0},
    "lint": {"passed": true, "warnings": 2},
    "tests": {"passed": true, "total": 45, "passed_count": 45, "coverage": 87},
    "security": {"passed": true, "issues": 0},
    "diff": {"files_changed": 5}
  },
  "ready_for_pr": true,
  "issues": []
}
```

## Continuous Mode

Для долгих сессий запускай верификацию:
- После завершения каждой функции
- После завершения компонента
- Перед переходом к следующей задаче

## Интеграция с QA Pipeline

Этот skill дополняет QA pipeline:
- **QA Pipeline** (test-automator, code-reviewer) — автоматический после кодера
- **Verification Loop** — ручной, более глубокий, перед PR
