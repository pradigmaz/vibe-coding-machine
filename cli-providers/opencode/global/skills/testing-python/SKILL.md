---
name: testing-python
description: Эффективное тестирование Python кода с использованием pytest. Применяется при написании тестов, review тестового ко...
---
# Python Testing Strategies

Эффективное тестирование Python кода с использованием pytest. Применяется при написании тестов, review тестового кода, отладке падающих тестов и улучшении покрытия.

## Основные принципы

### 1. Атомарность тестов

Каждый тест должен проверять одно поведение. Название теста должно говорить, что сломалось.

✅ **Правильно:**
```python
def test_user_creation_sets_defaults():
    user = User(name="Alice")
    assert user.role == "member"
    assert user.id is not None
    assert user.created_at is not None
```

❌ **Неправильно:**
```python
def test_user():  # Что сломалось, если тест упал?
    user = User(name="Alice")
    assert user.role == "member"
    user.promote()
    assert user.role == "admin"
    assert user.can_delete_others()
```

### 2. Параметризация для вариаций

Используйте параметризацию для тестирования одной концепции с разными данными:

✅ **Правильно:**
```python
import pytest

@pytest.mark.parametrize("input,expected", [
    ("hello", "HELLO"),
    ("World", "WORLD"),
    ("", ""),
    ("123", "123"),
])
def test_uppercase_conversion(input, expected):
    assert input.upper() == expected
```

❌ **Неправильно:**
```python
# Не параметризуйте несвязанное поведение
@pytest.mark.parametrize("operation", ["create", "update", "delete"])
def test_user_operations(operation):
    if operation == "create":
        # Совершенно другая логика
    elif operation == "update":
        # Другая логика
```

## Структура тестов

### Именование тестов


Используйте описательные имена, объясняющие сценарий:

✅ **Правильно:**
```python
def test_login_fails_with_invalid_password():
def test_user_can_update_own_profile():
def test_admin_can_delete_any_user():
```

❌ **Неправильно:**
```python
def test_login():
def test_update():
def test_delete():
```

### Импорты на уровне модуля

Все импорты должны быть в начале файла:

✅ **Правильно:**
```python
import pytest
from fastmcp import FastMCP
from fastmcp.client import Client

async def test_something():
    mcp = FastMCP("test")
    ...
```

❌ **Неправильно:**
```python
async def test_something():
    from fastmcp import FastMCP  # Не делайте так
    ...
```

## Асинхронные тесты

### Без async маркеров

Если проект использует `asyncio_mode = "auto"`, пишите async тесты без декораторов:

✅ **Правильно:**
```python
async def test_async_operation():
    result = await some_async_function()
    assert result == expected
```

❌ **Неправильно:**
```python
@pytest.mark.asyncio  # Не нужно
async def test_async_operation():
    ...
```

### In-memory transport для тестирования

Передавайте FastMCP серверы напрямую клиентам:

✅ **Правильно:**
```python
from fastmcp import FastMCP
from fastmcp.client import Client

mcp = FastMCP("TestServer")

@mcp.tool
def greet(name: str) -> str:
    return f"Hello, {name}!"

async def test_greet_tool():
    async with Client(mcp) as client:
        result = await client.call_tool("greet", {"name": "World"})
        assert result[0].text == "Hello, World!"
```

## Fixtures

### Function-scoped fixtures


Предпочитайте fixtures с областью видимости function:

```python
@pytest.fixture
def client():
    return Client()

async def test_with_client(client):
    result = await client.ping()
    assert result is not None
```

### tmp_path для файловых операций

```python
def test_file_writing(tmp_path):
    file = tmp_path / "test.txt"
    file.write_text("content")
    assert file.read_text() == "content"
```

## Mocking

### Mock на границе

Мокируйте внешние сервисы, не внутренние классы:

✅ **Правильно:**
```python
from unittest.mock import patch, AsyncMock

async def test_external_api_call():
    with patch("mymodule.external_client.fetch", new_callable=AsyncMock) as mock:
        mock.return_value = {"data": "test"}
        result = await my_function()
        assert result == {"data": "test"}
```

❌ **Неправильно:**
```python
# Не мокируйте то, что вы контролируете
with patch("mymodule.MyClass.method"):
    ...
```

## Тестирование ошибок

```python
import pytest

def test_raises_on_invalid_input():
    with pytest.raises(ValueError, match="must be positive"):
        calculate(-1)

async def test_async_raises():
    with pytest.raises(ConnectionError):
        await connect_to_invalid_host()
```

## Inline Snapshots

Используйте `inline-snapshot` для тестирования JSON схем и сложных структур:

```python
from inline_snapshot import snapshot

def test_schema_generation():
    schema = generate_schema(MyModel)
    assert schema == snapshot()  # Автоматически заполнится при первом запуске
```

Команды:
- `pytest --inline-snapshot=create` - заполнить пустые snapshots
- `pytest --inline-snapshot=fix` - обновить после изменений

## Запуск тестов

```bash
uv run pytest -n auto              # Все тесты параллельно
uv run pytest -n auto -x           # Остановка на первой ошибке
uv run pytest path/to/test.py      # Конкретный файл
uv run pytest -k "test_name"       # Тесты по паттерну
uv run pytest -m "not integration" # Исключить integration тесты
```

## Checklist для review


Перед отправкой тестов:
- [ ] Каждый тест проверяет одну вещь
- [ ] Нет `@pytest.mark.asyncio` декораторов (если используется auto mode)
- [ ] Импорты на уровне модуля
- [ ] Описательные имена тестов
- [ ] Используется in-memory transport (не HTTP) если не тестируется networking
- [ ] Параметризация для вариаций одного поведения
- [ ] Отдельные тесты для разного поведения
- [ ] Моки на границе системы, не внутри
- [ ] Используется tmp_path для файловых операций

## Антипаттерны

❌ **Тесты с множественным поведением:**
```python
def test_user_lifecycle():
    user = create_user()
    user.login()
    user.update_profile()
    user.logout()
    user.delete()
```

❌ **Зависимые тесты:**
```python
# test_1 создает данные, test_2 их использует
# Тесты должны быть независимыми!
```

❌ **Тестирование implementation details:**
```python
def test_internal_cache_structure():
    obj = MyClass()
    assert obj._cache == {}  # Не тестируйте приватные детали
```

❌ **Слишком много моков:**
```python
# Если мокаете все, что тестируете?
with patch("module.a"), patch("module.b"), patch("module.c"):
    ...
```

## Ресурсы

- [pytest documentation](https://docs.pytest.org/)
- [pytest-asyncio](https://pytest-asyncio.readthedocs.io/)
- [inline-snapshot](https://15r10nk.github.io/inline-snapshot/)
- [unittest.mock](https://docs.python.org/3/library/unittest.mock.html)
