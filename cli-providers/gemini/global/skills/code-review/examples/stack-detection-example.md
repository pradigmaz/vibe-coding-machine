# Example: Automatic Stack Detection

## Scenario: User asks to review a file without specifying stack

**User Request**: "Review services/user_service.py"

## Step 0: Detect Stack (ОБЯЗАТЕЛЬНО ПЕРВЫМ)

### 1. List project root
```bash
list_directory(".")
```

**Output**:
```
.
├── package.json
├── pyproject.toml
├── requirements.txt
├── next.config.js
├── tsconfig.json
├── .eslintrc.json
├── backend/
│   ├── services/
│   │   └── user_service.py
│   └── models/
└── frontend/
    ├── app/
    └── components/
```

### 2. Read backend config
```bash
read_file("pyproject.toml")
```

**Output**:
```toml
[tool.poetry]
name = "my-project"
version = "0.1.0"

[tool.poetry.dependencies]
python = "^3.11"
fastapi = "^0.115.0"
sqlalchemy = "^2.0.0"
pydantic = "^2.0.0"
uvicorn = "^0.30.0"

[tool.black]
line-length = 88

[tool.ruff]
line-length = 88
select = ["E", "F", "I"]

[tool.mypy]
strict = true
```

### 3. Read frontend config
```bash
read_file("package.json")
```

**Output**:
```json
{
  "name": "my-project-frontend",
  "version": "0.1.0",
  "dependencies": {
    "react": "^19.0.0",
    "next": "^15.1.0",
    "zustand": "^5.0.0",
    "tailwindcss": "^4.0.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "eslint": "^9.0.0",
    "prettier": "^3.0.0"
  }
}
```

### 4. Detected Stack Summary
```
✅ DETECTED STACK:

Backend:
- Language: Python 3.11
- Framework: FastAPI 0.115.0
- ORM: SQLAlchemy 2.0
- Validation: Pydantic 2.0
- Standards: black (88 chars), ruff, mypy (strict)

Frontend:
- Framework: Next.js 15.1.0 (App Router)
- UI Library: React 19.0.0
- State: Zustand 5.0.0
- Styling: Tailwind CSS 4.0
- Standards: TypeScript 5.0, ESLint 9.0, Prettier 3.0

Patterns to apply:
- FastAPI: async/await, Pydantic models, dependency injection
- Next.js 15: Server Components by default, 'use client' for interactivity
- SQLAlchemy 2.0: Modern async patterns
- React 19: React Compiler patterns
```

## Step 1: Review File with Stack-Specific Rules

### File: `backend/services/user_service.py`

```python
from sqlalchemy.orm import Session
from models.user import User
from schemas.user import UserCreate

def get_user(db, user_id):
    return db.query(User).filter(User.id == user_id).first()

def create_user(db, user_data):
    user = User(**user_data.dict())
    db.add(user)
    db.commit()
    return user
```

### Review Output (Stack-Aware)

#### 🔴 CRITICAL ISSUES

**1. Not using FastAPI async patterns (detected FastAPI 0.115.0)**
```python
# ❌ Current (sync)
def get_user(db, user_id):
    return db.query(User).filter(User.id == user_id).first()

# ✅ FastAPI async pattern
from sqlalchemy.ext.asyncio import AsyncSession

async def get_user(db: AsyncSession, user_id: int) -> User | None:
    result = await db.execute(
        select(User).where(User.id == user_id)
    )
    return result.scalar_one_or_none()
```
**Why**: FastAPI 0.115.0 + SQLAlchemy 2.0 → async patterns recommended

**2. Missing type hints (mypy strict mode detected)**
```python
# ❌ Current
def get_user(db, user_id):

# ✅ With type hints (mypy strict)
from sqlalchemy.ext.asyncio import AsyncSession

async def get_user(db: AsyncSession, user_id: int) -> User | None:
```
**Why**: pyproject.toml has `[tool.mypy] strict = true`

**3. Not using Pydantic validation (detected Pydantic 2.0)**
```python
# ❌ Current
def create_user(db, user_data):
    user = User(**user_data.dict())

# ✅ With Pydantic validation
from schemas.user import UserCreate

async def create_user(db: AsyncSession, user_data: UserCreate) -> User:
    # Pydantic automatically validates
    user = User(**user_data.model_dump())
    db.add(user)
    await db.commit()
    await db.refresh(user)
    return user
```
**Why**: Detected Pydantic 2.0 in dependencies

#### ⚠️ WARNINGS

**4. Not using FastAPI dependency injection**
```python
# ❌ Current
def get_user(db, user_id):

# ✅ FastAPI dependency injection
from fastapi import Depends
from database import get_db

async def get_user(
    user_id: int,
    db: AsyncSession = Depends(get_db)
) -> User | None:
```
**Why**: FastAPI best practice for DB session management

#### 💡 SUGGESTIONS

**5. Add error handling**
```python
from fastapi import HTTPException
import logging

logger = logging.getLogger(__name__)

async def get_user(db: AsyncSession, user_id: int) -> User:
    try:
        result = await db.execute(select(User).where(User.id == user_id))
        user = result.scalar_one_or_none()
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        return user
    except Exception as e:
        logger.exception(f"Error fetching user {user_id}")
        raise HTTPException(status_code=500, detail="Internal server error")
```

**6. Add docstring (Google style from detected standards)**
```python
async def get_user(db: AsyncSession, user_id: int) -> User:
    """Get user by ID.
    
    Args:
        db: Database session
        user_id: User ID to fetch
        
    Returns:
        User object
        
    Raises:
        HTTPException: If user not found (404) or database error (500)
    """
```

## Summary

**Detected Stack**: FastAPI 0.115.0 + SQLAlchemy 2.0 + Pydantic 2.0 + mypy strict

**Applied Standards**:
- ✅ Async patterns (FastAPI + SQLAlchemy 2.0)
- ✅ Type hints (mypy strict mode)
- ✅ Pydantic validation (Pydantic 2.0)
- ✅ Dependency injection (FastAPI pattern)
- ✅ Error handling (FastAPI HTTPException)
- ✅ Docstrings (Google style)

**Score**: 3/10 → 9/10 after fixes

**Key Insight**: Автоматическое определение стека позволило применить ПРАВИЛЬНЫЕ паттерны (async FastAPI), а не общие Python правила!
