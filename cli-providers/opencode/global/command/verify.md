# Verify Command

Запуск комплексной верификации текущего состояния кодбейза.

## Использование

```
/verify [quick|full|pre-commit|pre-pr]
```

## Режимы

| Режим | Что проверяет |
|-------|---------------|
| `quick` | Build + Types |
| `full` | Все проверки (default) |
| `pre-commit` | Проверки для коммита |
| `pre-pr` | Полные проверки + security scan |

## Инструкции

Загрузи skill и выполни:
```bash
skill(name="verification-loop")
```

Выполни верификацию в точном порядке:

1. **Build Check** — Если fails → СТОП
2. **Type Check** — Репортуй ошибки с file:line
3. **Lint Check** — Репортуй warnings и errors
4. **Test Suite** — pass/fail count + coverage %
5. **Console.log Audit** — Поиск console.log в src
6. **Git Status** — Uncommitted changes

## Формат вывода

```
VERIFICATION: [PASS/FAIL]

Build:    [OK/FAIL]
Types:    [OK/X errors]
Lint:     [OK/X issues]
Tests:    [X/Y passed, Z% coverage]
Secrets:  [OK/X found]
Logs:     [OK/X console.logs]

Ready for PR: [YES/NO]
```

Если критические issues → список с fix suggestions.
