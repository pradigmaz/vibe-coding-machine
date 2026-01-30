# Checkpoint Command

Создание или проверка checkpoint в workflow.

## Использование

```
/checkpoint create <name>   # Создать checkpoint
/checkpoint verify <name>   # Проверить против checkpoint
/checkpoint list            # Показать все checkpoints
/checkpoint clear           # Удалить старые (оставить 5)
```

## Create Checkpoint

1. Запусти `/verify quick` — убедись что состояние чистое
2. Создай git stash или commit с именем checkpoint
3. Залогируй в `.ai/checkpoints.log`:
```bash
echo "$(date +%Y-%m-%d-%H:%M) | $NAME | $(git rev-parse --short HEAD)" >> .ai/checkpoints.log
```
4. Репортуй создание

## Verify Checkpoint

1. Прочитай checkpoint из лога
2. Сравни текущее состояние:
   - Файлы добавленные с checkpoint
   - Файлы изменённые с checkpoint
   - Test pass rate сейчас vs тогда
   - Coverage сейчас vs тогда

3. Репорт:
```
CHECKPOINT COMPARISON: $NAME
============================
Files changed: X
Tests: +Y passed / -Z failed
Coverage: +X% / -Y%
Build: [PASS/FAIL]
```

## List Checkpoints

Показать все checkpoints:
- Name
- Timestamp
- Git SHA
- Status (current, behind, ahead)

## Типичный workflow

```
[Start] --> /checkpoint create "feature-start"
   |
[Implement] --> /checkpoint create "core-done"
   |
[Test] --> /checkpoint verify "core-done"
   |
[Refactor] --> /checkpoint create "refactor-done"
   |
[PR] --> /checkpoint verify "feature-start"
```

## Хранение

```
.ai/checkpoints.log
```

Формат строки:
```
2026-01-25-15:30 | feature-auth | a1b2c3d
```
