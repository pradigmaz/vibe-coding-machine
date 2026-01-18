# UV Package Manager

Быстрый Python package manager написанный на Rust. Применяется для управления зависимостями, виртуальными окружениями и Python проектами.

## Когда использовать

- Настройка новых Python проектов
- Управление зависимостями (быстрее pip в 10-100x)
- Создание виртуальных окружений
- Установка Python интерпретаторов
- Разрешение конфликтов зависимостей
- Миграция с pip/poetry
- Оптимизация CI/CD pipelines
- Работа с lockfiles для воспроизводимых сборок

## Установка

```bash
# macOS/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# Windows (PowerShell)
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"

# Через pip
pip install uv

# Через Homebrew
brew install uv

# Проверка
uv --version
```

## Quick Start

### Создание проекта

```bash
# Новый проект
uv init my-project
cd my-project

# В текущей директории
uv init .

# Создается:
# - .python-version (версия Python)
# - pyproject.toml (конфигурация)
# - README.md
# - .gitignore
```

### Установка зависимостей

```bash
# Установка пакетов (создает venv автоматически)
uv add requests pandas

# Dev зависимости
uv add --dev pytest black ruff

# Из requirements.txt
uv pip install -r requirements.txt

# Из pyproject.toml
uv sync
```

## Виртуальные окружения

### Создание venv

```bash
# Создать виртуальное окружение
uv venv

# С конкретной версией Python
uv venv --python 3.12

# С кастомным именем
uv venv my-env

# С system site packages
uv venv --system-site-packages
```

### Использование uv run

Не нужно активировать venv:

```bash
# Запуск Python скрипта
uv run python app.py

# Запуск установленного CLI tool
uv run black .
uv run pytest

# С конкретной версией Python
uv run --python 3.11 python script.py

# С аргументами
uv run python script.py --arg value
```


## Управление зависимостями

### Добавление пакетов

```bash
# Добавить пакет (добавляется в pyproject.toml)
uv add requests

# С версией
uv add "django>=4.0,<5.0"

# Несколько пакетов
uv add numpy pandas matplotlib

# Dev зависимость
uv add --dev pytest pytest-cov

# Optional dependency group
uv add --optional docs sphinx

# Из git
uv add git+https://github.com/user/repo.git

# Из git с версией
uv add git+https://github.com/user/repo.git@v1.0.0

# Локальный пакет
uv add ./local-package

# Editable локальный пакет
uv add -e ./local-package
```

### Удаление пакетов

```bash
# Удалить пакет
uv remove requests

# Удалить dev зависимость
uv remove --dev pytest

# Удалить несколько
uv remove numpy pandas matplotlib
```

### Обновление зависимостей

```bash
# Обновить конкретный пакет
uv add --upgrade requests

# Обновить все пакеты
uv sync --upgrade

# Показать устаревшие
uv tree --outdated
```

## Lockfiles

### Работа с uv.lock

```bash
# Создать lockfile
uv lock

# Обновить lockfile
uv lock --upgrade

# Lock без установки
uv lock --no-install

# Lock конкретного пакета
uv lock --upgrade-package requests

# Установка из lockfile (точные версии)
uv sync --frozen

# Проверить актуальность lockfile
uv lock --check

# Экспорт в requirements.txt
uv export --format requirements-txt > requirements.txt

# С хешами для безопасности
uv export --format requirements-txt --hash > requirements.txt
```

## Управление Python версиями

### Установка Python

```bash
# Установить версию Python
uv python install 3.12

# Несколько версий
uv python install 3.11 3.12 3.13

# Последняя версия
uv python install

# Список установленных
uv python list

# Все доступные версии
uv python list --all-versions
```

### Выбор версии Python

```bash
# Закрепить версию для проекта
uv python pin 3.12

# Создается/обновляется .python-version

# Использовать конкретную версию
uv --python 3.11 run python script.py

# Создать venv с версией
uv venv --python 3.12
```


## Конфигурация проекта

### pyproject.toml с uv

```toml
[project]
name = "my-project"
version = "0.1.0"
description = "My awesome project"
readme = "README.md"
requires-python = ">=3.8"
dependencies = [
    "requests>=2.31.0",
    "pydantic>=2.0.0",
    "click>=8.1.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "pytest-cov>=4.1.0",
    "black>=23.0.0",
    "ruff>=0.1.0",
]
docs = [
    "sphinx>=7.0.0",
    "sphinx-rtd-theme>=1.3.0",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.uv]
dev-dependencies = [
    # Дополнительные dev зависимости
]

[tool.uv.sources]
# Кастомные источники пакетов
my-package = { git = "https://github.com/user/repo.git" }
```

## CI/CD Integration

### GitHub Actions

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Install uv
        uses: astral-sh/setup-uv@v2
        with:
          enable-cache: true

      - name: Set up Python
        run: uv python install 3.12

      - name: Install dependencies
        run: uv sync --all-extras --dev

      - name: Run tests
        run: uv run pytest

      - name: Run linting
        run: |
          uv run ruff check .
          uv run black --check .
```

### Docker Integration

```dockerfile
# Dockerfile
FROM python:3.12-slim

# Установить uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app

# Скопировать файлы зависимостей
COPY pyproject.toml uv.lock ./

# Установить зависимости
RUN uv sync --frozen --no-dev

# Скопировать код
COPY . .

# Запустить приложение
CMD ["uv", "run", "python", "app.py"]
```

## Типичные workflow

### Новый проект

```bash
# Полный workflow
uv init my-project
cd my-project

# Закрепить версию Python
uv python pin 3.12

# Добавить зависимости
uv add fastapi uvicorn pydantic

# Добавить dev зависимости
uv add --dev pytest black ruff mypy

# Создать структуру
mkdir -p src/my_project tests

# Запустить тесты
uv run pytest

# Форматировать код
uv run black .
uv run ruff check .
```


### Существующий проект

```bash
# Клонировать репозиторий
git clone https://github.com/user/project.git
cd project

# Установить зависимости (создает venv автоматически)
uv sync

# С dev зависимостями
uv sync --all-extras

# Обновить зависимости
uv lock --upgrade

# Запустить приложение
uv run python app.py

# Запустить тесты
uv run pytest

# Добавить новую зависимость
uv add new-package

# Закоммитить изменения
git add pyproject.toml uv.lock
git commit -m "Add new-package dependency"
```

## Сравнение с другими инструментами

### uv vs pip

```bash
# pip
python -m venv .venv
source .venv/bin/activate
pip install requests pandas numpy
# ~30 секунд

# uv
uv venv
uv add requests pandas numpy
# ~2 секунды (10-15x быстрее)
```

### uv vs poetry

```bash
# poetry
poetry init
poetry add requests pandas
poetry install
# ~20 секунд

# uv
uv init
uv add requests pandas
uv sync
# ~3 секунды (6-7x быстрее)
```

## Best Practices

### Настройка проекта

1. **Всегда используйте lockfiles** для воспроизводимости
2. **Закрепляйте версию Python** с .python-version
3. **Разделяйте dev зависимости** от production
4. **Используйте uv run** вместо активации venv
5. **Коммитьте uv.lock** в version control
6. **Используйте --frozen в CI** для консистентных сборок
7. **Используйте workspace** для monorepo проектов
8. **Экспортируйте requirements.txt** для совместимости

### Производительность

```bash
# Используйте frozen installs в CI
uv sync --frozen

# Offline mode когда возможно
uv sync --offline

# UV автоматически использует глобальный кэш
# Linux: ~/.cache/uv
# macOS: ~/Library/Caches/uv
# Windows: %LOCALAPPDATA%\uv\cache

# Очистить кэш
uv cache clean

# Проверить размер кэша
uv cache dir
```

## Troubleshooting

```bash
# uv не найден
# Добавьте в PATH
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc

# Неправильная версия Python
uv python pin 3.12
uv venv --python 3.12

# Конфликт зависимостей
uv lock --verbose

# Проблемы с кэшем
uv cache clean

# Lockfile не синхронизирован
uv lock --upgrade
```

## Команды Reference

```bash
# Управление проектом
uv init [PATH]              # Инициализировать проект
uv add PACKAGE              # Добавить зависимость
uv remove PACKAGE           # Удалить зависимость
uv sync                     # Установить зависимости
uv lock                     # Создать/обновить lockfile

# Виртуальные окружения
uv venv [PATH]              # Создать venv
uv run COMMAND              # Запустить в venv

# Python управление
uv python install VERSION   # Установить Python
uv python list              # Список установленных
uv python pin VERSION       # Закрепить версию

# pip-совместимые команды
uv pip install PACKAGE      # Установить пакет
uv pip uninstall PACKAGE    # Удалить пакет
uv pip freeze               # Список установленных
uv pip list                 # Список пакетов

# Утилиты
uv cache clean              # Очистить кэш
uv cache dir                # Показать кэш
uv --version                # Версия
```

## Ресурсы

- [UV Documentation](https://docs.astral.sh/uv/)
- [GitHub Repository](https://github.com/astral-sh/uv)
- [Migration Guides](https://docs.astral.sh/uv/guides/)
- [Astral Blog](https://astral.sh/blog)
