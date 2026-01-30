---
name: python-testing-patterns
description: Comprehensive testing strategies с pytest, fixtures, mocking и TDD. Используется backend агентами при написании Python тестов.
---
# Python Testing Patterns Skill

## Назначение

Comprehensive testing strategies с pytest, fixtures, mocking и TDD. Используется backend агентами при написании Python тестов.

## Когда использовать

- Написание unit tests для Python кода
- Настройка test suites и test infrastructure
- Реализация test-driven development (TDD)
- Создание integration tests для APIs и services
- Mocking external dependencies
- Тестирование async кода
- Настройка continuous testing в CI/CD

## Core Concepts

### Test Types
- **Unit Tests**: Тестируют отдельные функции/классы изолированно
- **Integration Tests**: Тестируют взаимодействие между компонентами
- **Functional Tests**: Тестируют complete features end-to-end
- **Performance Tests**: Измеряют скорость и использование ресурсов

### Test Structure (AAA Pattern)
- **Arrange**: Настройка test data и preconditions
- **Act**: Выполнение кода под тестом
- **Assert**: Проверка результатов

## Quick Start

```python
# test_example.py
def add(a, b):
    return a + b

def test_add():
    """Basic test example."""
    result = add(2, 3)
    assert result == 5

def test_add_negative():
    """Test with negative numbers."""
    assert add(-1, 1) == 0

# Run with: pytest test_example.py
```

## Fundamental Patterns

### Pattern 1: Basic pytest Tests

```python
# test_calculator.py
import pytest

class Calculator:
    def add(self, a: float, b: float) -> float:
        return a + b

    def divide(self, a: float, b: float) -> float:
        if b == 0:
            raise ValueError("Cannot divide by zero")
        return a / b


def test_addition():
    """Test addition."""
    calc = Calculator()
    assert calc.add(2, 3) == 5
    assert calc.add(-1, 1) == 0


def test_division_by_zero():
    """Test division by zero raises error."""
    calc = Calculator()
    with pytest.raises(ValueError, match="Cannot divide by zero"):
        calc.divide(5, 0)
```

### Pattern 2: Fixtures для Setup/Teardown

```python
# test_database.py
import pytest
from typing import Generator

class Database:
    def __init__(self, connection_string: str):
        self.connection_string = connection_string
        self.connected = False

    def connect(self):
        self.connected = True

    def disconnect(self):
        self.connected = False

    def query(self, sql: str) -> list:
        if not self.connected:
            raise RuntimeError("Not connected")
        return [{"id": 1, "name": "Test"}]


@pytest.fixture
def db() -> Generator[Database, None, None]:
    """Fixture that provides connected database."""
    # Setup
    database = Database("sqlite:///:memory:")
    database.connect()

    # Provide to test
    yield database

    # Teardown
    database.disconnect()


def test_database_query(db):
    """Test database query with fixture."""
    results = db.query("SELECT * FROM users")
    assert len(results) == 1


@pytest.fixture(scope="session")
def app_config():
    """Session-scoped fixture - created once per test session."""
    return {
        "database_url": "postgresql://localhost/test",
        "api_key": "test-key",
    }


@pytest.fixture(scope="module")
def api_client(app_config):
    """Module-scoped fixture - created once per test module."""
    client = {"config": app_config, "session": "active"}
    yield client
    client["session"] = "closed"
```

### Pattern 3: Parameterized Tests

```python
# test_validation.py
import pytest

def is_valid_email(email: str) -> bool:
    return "@" in email and "." in email.split("@")[1]


@pytest.mark.parametrize("email,expected", [
    ("user@example.com", True),
    ("test.user@domain.co.uk", True),
    ("invalid.email", False),
    ("@example.com", False),
    ("user@domain", False),
    ("", False),
])
def test_email_validation(email, expected):
    """Test email validation with various inputs."""
    assert is_valid_email(email) == expected


@pytest.mark.parametrize("a,b,expected", [
    (2, 3, 5),
    (0, 0, 0),
    (-1, 1, 0),
    (100, 200, 300),
])
def test_addition_parameterized(a, b, expected):
    """Test addition with multiple parameter sets."""
    assert a + b == expected
```

### Pattern 4: Mocking с unittest.mock

```python
# test_api_client.py
import pytest
from unittest.mock import Mock, patch
import requests

class APIClient:
    def __init__(self, base_url: str):
        self.base_url = base_url

    def get_user(self, user_id: int) -> dict:
        response = requests.get(f"{self.base_url}/users/{user_id}")
        response.raise_for_status()
        return response.json()


def test_get_user_success():
    """Test successful API call with mock."""
    client = APIClient("https://api.example.com")

    mock_response = Mock()
    mock_response.json.return_value = {"id": 1, "name": "John Doe"}
    mock_response.raise_for_status.return_value = None

    with patch("requests.get", return_value=mock_response) as mock_get:
        user = client.get_user(1)

        assert user["id"] == 1
        assert user["name"] == "John Doe"
        mock_get.assert_called_once_with("https://api.example.com/users/1")


def test_get_user_not_found():
    """Test API call with 404 error."""
    client = APIClient("https://api.example.com")

    mock_response = Mock()
    mock_response.raise_for_status.side_effect = requests.HTTPError("404")

    with patch("requests.get", return_value=mock_response):
        with pytest.raises(requests.HTTPError):
            client.get_user(999)
```

### Pattern 5: Testing Exceptions

```python
# test_exceptions.py
import pytest

def divide(a: float, b: float) -> float:
    if b == 0:
        raise ZeroDivisionError("Division by zero")
    if not isinstance(a, (int, float)):
        raise TypeError("Arguments must be numbers")
    return a / b


def test_zero_division():
    """Test exception is raised."""
    with pytest.raises(ZeroDivisionError):
        divide(10, 0)


def test_zero_division_with_message():
    """Test exception message."""
    with pytest.raises(ZeroDivisionError, match="Division by zero"):
        divide(5, 0)


def test_exception_info():
    """Test accessing exception info."""
    with pytest.raises(ValueError) as exc_info:
        int("not a number")

    assert "invalid literal" in str(exc_info.value)
```

## Advanced Patterns

### Pattern 6: Testing Async Code

```python
# test_async.py
import pytest
import asyncio

async def fetch_data(url: str) -> dict:
    await asyncio.sleep(0.1)
    return {"url": url, "data": "result"}


@pytest.mark.asyncio
async def test_fetch_data():
    """Test async function."""
    result = await fetch_data("https://api.example.com")
    assert result["url"] == "https://api.example.com"


@pytest.mark.asyncio
async def test_concurrent_fetches():
    """Test concurrent async operations."""
    urls = ["url1", "url2", "url3"]
    tasks = [fetch_data(url) for url in urls]
    results = await asyncio.gather(*tasks)

    assert len(results) == 3
```

### Pattern 7: Monkeypatch для Testing

```python
# test_environment.py
import os
import pytest

def get_database_url() -> str:
    return os.environ.get("DATABASE_URL", "sqlite:///:memory:")


def test_database_url_custom(monkeypatch):
    """Test custom database URL with monkeypatch."""
    monkeypatch.setenv("DATABASE_URL", "postgresql://localhost/test")
    assert get_database_url() == "postgresql://localhost/test"


def test_database_url_not_set(monkeypatch):
    """Test when env var is not set."""
    monkeypatch.delenv("DATABASE_URL", raising=False)
    assert get_database_url() == "sqlite:///:memory:"
```

### Pattern 8: Temporary Files

```python
# test_file_operations.py
import pytest
from pathlib import Path

def save_data(filepath: Path, data: str):
    filepath.write_text(data)


def test_file_operations(tmp_path):
    """Test file operations with temporary directory."""
    test_file = tmp_path / "test_data.txt"

    save_data(test_file, "Hello, World!")

    assert test_file.exists()
    assert test_file.read_text() == "Hello, World!"
```

### Pattern 9: Custom Fixtures (conftest.py)

```python
# conftest.py
import pytest

@pytest.fixture(scope="session")
def database_url():
    """Provide database URL for all tests."""
    return "postgresql://localhost/test_db"


@pytest.fixture(autouse=True)
def reset_database():
    """Auto-use fixture that runs before each test."""
    # Setup
    print("Clearing database")
    yield
    # Teardown
    print("Test completed")


@pytest.fixture
def sample_user():
    """Provide sample user data."""
    return {
        "id": 1,
        "name": "Test User",
        "email": "test@example.com"
    }


@pytest.fixture(params=["sqlite", "postgresql", "mysql"])
def db_backend(request):
    """Parametrized fixture - runs tests with different backends."""
    return request.param
```

## Testing Best Practices

### Test Organization

```
tests/
  __init__.py
  conftest.py           # Shared fixtures
  test_unit/            # Unit tests
    test_models.py
    test_utils.py
  test_integration/     # Integration tests
    test_api.py
    test_database.py
```

### Test Naming

```python
# ✅ GOOD: Clear names
def test_user_creation_with_valid_data():
    pass

def test_login_fails_with_invalid_password():
    pass

# ❌ BAD: Vague names
def test_1():
    pass

def test_user():
    pass
```

### Test Markers

```python
import pytest

@pytest.mark.slow
def test_slow_operation():
    """Mark slow tests."""
    import time
    time.sleep(2)


@pytest.mark.integration
def test_database_integration():
    """Mark integration tests."""
    pass


@pytest.mark.skip(reason="Feature not implemented")
def test_future_feature():
    pass


# Run with:
# pytest -m slow          # Run only slow tests
# pytest -m "not slow"    # Skip slow tests
```

### Coverage Reporting

```bash
# Install coverage
pip install pytest-cov

# Run tests with coverage
pytest --cov=myapp tests/

# Generate HTML report
pytest --cov=myapp --cov-report=html tests/

# Fail if coverage below threshold
pytest --cov=myapp --cov-fail-under=80 tests/
```

## Configuration

```ini
# pytest.ini
[pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts =
    -v
    --strict-markers
    --cov=myapp
    --cov-report=term-missing
markers =
    slow: marks tests as slow
    integration: marks integration tests
    unit: marks unit tests
```

## Checklist

```
Python Testing Review:
- [ ] Tests follow AAA pattern (Arrange, Act, Assert)
- [ ] One assertion per test (when possible)
- [ ] Descriptive test names
- [ ] Fixtures used for setup/teardown
- [ ] External dependencies mocked
- [ ] Parametrized tests for multiple inputs
- [ ] Edge cases tested
- [ ] Coverage > 80%
- [ ] Tests run in CI/CD
```

## Ресурсы

- [pytest documentation](https://docs.pytest.org/)
- [unittest.mock](https://docs.python.org/3/library/unittest.mock.html)
- [pytest-asyncio](https://pytest-asyncio.readthedocs.io/)
- [pytest-cov](https://pytest-cov.readthedocs.io/)
