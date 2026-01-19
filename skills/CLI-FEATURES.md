# CLI-Specific Features для Skills

## Что доступно в CLI, чего нет в IDE

### 1. Shell Commands в примерах

В CLI можно показывать реальные команды для выполнения:

```markdown
## Запуск тестов

\`\`\`bash
# Запустить все тесты
pytest -n auto

# С покрытием
pytest --cov=src --cov-report=html

# Конкретный файл
pytest tests/test_api.py -v
\`\`\`
```

**В IDE:** Команды менее актуальны, так как есть встроенные UI для запуска тестов.

### 2. Workflow Scripts

CLI агенты могут выполнять последовательности команд:

```markdown
## Полный workflow

\`\`\`bash
# 1. Установить зависимости
uv sync

# 2. Запустить линтеры
ruff check . --fix
black .

# 3. Запустить тесты
pytest -n auto

# 4. Проверить типы
mypy src/
\`\`\`
```

**В IDE:** Обычно есть встроенные задачи и UI для этого.

### 3. Git Commands

CLI агенты работают с git напрямую:

```markdown
## Git Workflow

\`\`\`bash
# Создать feature branch
git checkout -b feature/new-api

# Коммит с Conventional Commits
git commit -m "feat(api): add user endpoint"

# Push и создать PR
git push origin feature/new-api
gh pr create --title "feat: Add user endpoint"
\`\`\`
```

**В IDE:** Обычно есть встроенный Git UI.

### 4. Package Manager Commands

CLI skills могут включать команды установки:

```markdown
## Установка зависимостей

\`\`\`bash
# npm
npm install react-query

# pnpm
pnpm add react-query

# uv (Python)
uv add fastapi uvicorn
\`\`\`
```

**В IDE:** Часто есть UI для управления зависимостями.

### 5. Build & Deploy Commands

```markdown
## Production Build

\`\`\`bash
# Next.js build
pnpm build

# Docker build
docker build -t myapp:latest .

# Deploy
vercel deploy --prod
\`\`\`
```

**В IDE:** Обычно настраивается через конфигурацию задач.

### 6. Database Migrations

```markdown
## Database Setup

\`\`\`bash
# Создать миграцию
alembic revision --autogenerate -m "add users table"

# Применить миграции
alembic upgrade head

# Откатить
alembic downgrade -1
\`\`\`
```

**В IDE:** Может быть UI для миграций, но CLI более универсален.

### 7. Environment Setup

```markdown
## Настройка окружения

\`\`\`bash
# Создать .env файл
cp .env.example .env

# Установить переменные
export DATABASE_URL="postgresql://localhost/mydb"
export API_KEY="your-key-here"

# Или через direnv
echo "export DATABASE_URL=..." > .envrc
direnv allow
\`\`\`
```

**В IDE:** Обычно настраивается через UI настроек.

### 8. Debugging Commands

```markdown
## Отладка

\`\`\`bash
# Python с отладчиком
python -m pdb app.py

# Node.js с инспектором
node --inspect app.js

# Профилирование
py-spy record -o profile.svg -- python app.py
\`\`\`
```

**В IDE:** Встроенный отладчик с UI.

### 9. Log Analysis

```markdown
## Анализ логов

\`\`\`bash
# Последние ошибки
tail -f logs/error.log | grep ERROR

# Статистика запросов
cat access.log | awk '{print $7}' | sort | uniq -c | sort -rn

# Docker logs
docker logs -f container_name --tail 100
\`\`\`
```

**В IDE:** Может быть UI для просмотра логов, но CLI более гибкий.

### 10. Performance Profiling

```markdown
## Профилирование

\`\`\`bash
# Python
py-spy top --pid $(pgrep python)

# Node.js
clinic doctor -- node app.js

# Load testing
k6 run load-test.js
ab -n 1000 -c 10 http://localhost:3000/
\`\`\`
```

**В IDE:** Обычно требует плагины или внешние инструменты.

### 11. CI/CD Integration

```markdown
## CI/CD Commands

\`\`\`bash
# GitHub Actions локально
act -j test

# GitLab CI локально
gitlab-runner exec docker test

# Проверка CI конфигурации
yamllint .github/workflows/test.yml
\`\`\`
```

**В IDE:** Обычно просто редактирование YAML файлов.

### 12. Code Generation

```markdown
## Генерация кода

\`\`\`bash
# OpenAPI клиент
openapi-generator-cli generate -i api.yaml -g typescript-axios

# Prisma клиент
prisma generate

# GraphQL типы
graphql-codegen
\`\`\`
```

**В IDE:** Может быть интегрировано, но CLI более универсален.

## Что использовать в Skills для CLI

### ✅ Включай в CLI Skills:

1. **Полные команды** с флагами и опциями
2. **Workflow scripts** - последовательности команд
3. **Environment setup** - настройка окружения
4. **Git workflows** - ветки, коммиты, PR
5. **Package management** - установка, обновление
6. **Build & deploy** - сборка, деплой
7. **Database operations** - миграции, бэкапы
8. **Debugging commands** - отладка, профилирование
9. **Log analysis** - анализ логов
10. **CI/CD integration** - локальный запуск CI

### ❌ Не нужно в CLI Skills:

1. **UI-специфичные инструкции** - "нажми на кнопку"
2. **IDE shortcuts** - Ctrl+Shift+P и т.д.
3. **Визуальные элементы** - "в правой панели"
4. **Плагины IDE** - "установи расширение"

## Примеры адаптации

### Плохо (IDE-ориентированный):

```markdown
## Запуск тестов

1. Открой панель Testing (Ctrl+Shift+T)
2. Нажми на кнопку "Run All Tests"
3. Посмотри результаты в панели снизу
```

### Хорошо (CLI-ориентированный):

```markdown
## Запуск тестов

\`\`\`bash
# Все тесты параллельно
pytest -n auto

# С покрытием
pytest --cov=src --cov-report=html

# Конкретный файл
pytest tests/test_api.py -v

# Watch mode
pytest-watch
\`\`\`
```

## Структура CLI Skill

```markdown
# [Название] Skill

## Назначение
Краткое описание

## Установка (если нужно)
\`\`\`bash
npm install package
\`\`\`

## Основные команды
\`\`\`bash
command --flag value
\`\`\`

## Workflow
\`\`\`bash
# Шаг 1
command1

# Шаг 2
command2
\`\`\`

## Примеры кода
\`\`\`typescript
// Код с комментариями
\`\`\`

## Troubleshooting
\`\`\`bash
# Проверка проблемы
diagnostic-command

# Исправление
fix-command
\`\`\`

## Checklist
- [ ] Пункт 1
- [ ] Пункт 2

## Ресурсы
- [Документация](url)
```

## Заключение

CLI Skills должны быть **command-first**, с акцентом на:
- Реальные команды для выполнения
- Workflow scripts
- Troubleshooting через CLI
- Автоматизация через shell

Это делает их более универсальными и полезными для агентов, работающих в терминале.
