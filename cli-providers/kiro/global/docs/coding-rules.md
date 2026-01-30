# Правила кода

## Размер файлов — ЖЁСТКОЕ ПРАВИЛО
- **Максимум 300 строк** на файл
- **>320 строк = ОБЯЗАТЕЛЬНО разбить**
- Разбивать по функциональности + index.ts для экспорта

## Логирование
```typescript
console.log('[Module:function] Starting', { params });
console.error('[Module:function] Error:', error);
```

## Проверка перед сдачей
1. `npm run dev` — запустить
2. Проверить вручную
3. Посмотреть логи
4. Исправить ошибки

**Тесты пишет test-automator, не кодер.**

## Quality Gates

**JS/TS:**
```bash
tsc --noEmit
npm run lint
npm run build
npm run dev
```

**Python:**
```bash
mypy .
flake8
pytest
python main.py
```

**ЕСЛИ ПАДАЕТ → ЗАДАЧА НЕ ВЫПОЛНЕНА.**
