# Eval Harness Skill

Формальный evaluation framework для сессий разработки. Реализует Eval-Driven Development (EDD).

## Философия

Eval-Driven Development — evals как "unit tests для AI разработки":
- Определи ожидаемое поведение ДО имплементации
- Запускай evals непрерывно во время разработки
- Отслеживай регрессии с каждым изменением
- Используй pass@k метрики для измерения надёжности

## Типы Evals

### Capability Evals
Тестируют может ли система сделать что-то новое:
```markdown
[CAPABILITY EVAL: feature-name]
Task: Описание что должно быть сделано
Success Criteria:
  - [ ] Критерий 1
  - [ ] Критерий 2
  - [ ] Критерий 3
Expected Output: Описание ожидаемого результата
```

### Regression Evals
Проверяют что изменения не сломали существующее:
```markdown
[REGRESSION EVAL: feature-name]
Baseline: SHA или checkpoint name
Tests:
  - existing-test-1: PASS/FAIL
  - existing-test-2: PASS/FAIL
Result: X/Y passed (previously Y/Y)
```

## Типы Graders

### 1. Code-Based Grader
Детерминированные проверки кодом:
```bash
# Проверка паттерна в файле
grep -q "export function handleAuth" src/auth.ts && echo "PASS" || echo "FAIL"

# Проверка тестов
npm test -- --testPathPattern="auth" && echo "PASS" || echo "FAIL"

# Проверка сборки
npm run build && echo "PASS" || echo "FAIL"
```

### 2. Model-Based Grader
Использует LLM для оценки open-ended outputs:
```markdown
[MODEL GRADER PROMPT]
Оцени следующее изменение кода:
1. Решает ли заявленную проблему?
2. Хорошо ли структурировано?
3. Обработаны ли edge cases?
4. Адекватен ли error handling?

Score: 1-5 (1=плохо, 5=отлично)
Reasoning: [объяснение]
```

### 3. Human Grader
Флаг для ручной проверки:
```markdown
[HUMAN REVIEW REQUIRED]
Change: Описание изменения
Reason: Почему нужна ручная проверка
Risk Level: LOW/MEDIUM/HIGH
```

## Метрики

### pass@k
"Хотя бы один успех за k попыток"
- pass@1: Успех с первой попытки
- pass@3: Успех за 3 попытки
- Типичная цель: pass@3 > 90%

### pass^k
"Все k попыток успешны"
- Более высокая планка надёжности
- pass^3: 3 последовательных успеха
- Используй для критических путей

## Workflow

### 1. Define (До кодирования)
```markdown
## EVAL DEFINITION: feature-xyz

### Capability Evals
1. Может создать аккаунт пользователя
2. Может валидировать email формат
3. Может хэшировать пароль безопасно

### Regression Evals
1. Существующий login работает
2. Session management не изменился
3. Logout flow intact

### Success Metrics
- pass@3 > 90% для capability evals
- pass^3 = 100% для regression evals
```

### 2. Implement
Пиши код чтобы пройти определённые evals.

### 3. Evaluate
```bash
# Запуск capability evals
[Запусти каждый eval, запиши PASS/FAIL]

# Запуск regression evals
npm test -- --testPathPattern="existing"
```

### 4. Report
```markdown
EVAL REPORT: feature-xyz
========================

Capability Evals:
  create-user:     PASS (pass@1)
  validate-email:  PASS (pass@2)
  hash-password:   PASS (pass@1)
  Overall:         3/3 passed

Regression Evals:
  login-flow:      PASS
  session-mgmt:    PASS
  logout-flow:     PASS
  Overall:         3/3 passed

Metrics:
  pass@1: 67% (2/3)
  pass@3: 100% (3/3)

Status: READY FOR REVIEW
```

## JSON формат для агентов

```json
{
  "eval_name": "feature-xyz",
  "capability_evals": {
    "total": 3,
    "passed": 3,
    "results": [
      {"name": "create-user", "passed": true, "attempts": 1},
      {"name": "validate-email", "passed": true, "attempts": 2},
      {"name": "hash-password", "passed": true, "attempts": 1}
    ]
  },
  "regression_evals": {
    "total": 3,
    "passed": 3
  },
  "metrics": {
    "pass_at_1": 0.67,
    "pass_at_3": 1.0
  },
  "status": "ready_for_review"
}
```

## Хранение Evals

```
.ai/evals/
├── feature-xyz.md      # Eval definition
├── feature-xyz.log     # История запусков
└── baseline.json       # Regression baselines
```

## Best Practices

1. **Определяй evals ДО кодирования** — Заставляет чётко думать о критериях успеха
2. **Запускай evals часто** — Ловить регрессии рано
3. **Отслеживай pass@k во времени** — Мониторить тренды надёжности
4. **Используй code graders когда возможно** — Детерминированное > вероятностное
5. **Human review для security** — Никогда полностью не автоматизируй security checks
6. **Держи evals быстрыми** — Медленные evals не запускают
