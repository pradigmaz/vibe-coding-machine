# Example: Good Code Review

## File: `services/user_service.py`

```python
from typing import Optional
from sqlalchemy.orm import Session
from models.user import User
from schemas.user import UserCreate, UserUpdate
import logging

logger = logging.getLogger(__name__)

class UserService:
    """Service for user management operations."""
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_user(self, user_id: int) -> Optional[User]:
        """Get user by ID.
        
        Args:
            user_id: User ID to fetch
            
        Returns:
            User object or None if not found
        """
        try:
            return self.db.query(User).filter(User.id == user_id).first()
        except Exception as e:
            logger.error(f"Error fetching user {user_id}: {e}")
            raise
    
    def create_user(self, user_data: UserCreate) -> User:
        """Create new user.
        
        Args:
            user_data: User creation data
            
        Returns:
            Created user object
            
        Raises:
            ValueError: If email already exists
        """
        existing = self.db.query(User).filter(
            User.email == user_data.email
        ).first()
        
        if existing:
            raise ValueError(f"User with email {user_data.email} already exists")
        
        user = User(**user_data.dict())
        self.db.add(user)
        self.db.commit()
        self.db.refresh(user)
        
        logger.info(f"Created user {user.id}")
        return user
```

## Review Output

### ✅ GOOD PRACTICES

**Type Safety**
- ✅ All functions have type hints (args and return types)
- ✅ Using Pydantic schemas (UserCreate, UserUpdate)
- ✅ Optional[User] for nullable returns

**Error Handling**
- ✅ Specific exception handling (not bare except)
- ✅ Logging errors with context
- ✅ Re-raising exceptions for upper layers
- ✅ Validation before DB operations

**Code Quality**
- ✅ Docstrings on all public methods (Google style)
- ✅ Clear function names (get_user, create_user)
- ✅ Single Responsibility Principle
- ✅ File size: 45 lines (< 300 limit)

**Security**
- ✅ Using SQLAlchemy ORM (prevents SQL injection)
- ✅ Input validation via Pydantic schemas
- ✅ No hardcoded secrets

**Performance**
- ✅ Using .first() instead of .all()[0]
- ✅ Specific column filtering (not SELECT *)

### 💡 MINOR SUGGESTIONS

**1. Add rate limiting for create_user**
```python
from slowapi import Limiter

@limiter.limit("10/minute")
def create_user(self, user_data: UserCreate) -> User:
    ...
```

**2. Consider caching for get_user**
```python
from functools import lru_cache

@lru_cache(maxsize=128)
def get_user(self, user_id: int) -> Optional[User]:
    ...
```

**3. Add unit tests**
```python
# tests/test_user_service.py
def test_create_user_success():
    service = UserService(db)
    user = service.create_user(UserCreate(email="test@example.com"))
    assert user.id is not None
```

## Summary

**Score: 9/10**

Отличный код! Следует всем best practices:
- Type safety ✅
- Error handling ✅
- Documentation ✅
- Security ✅
- Performance ✅

Минорные улучшения (rate limiting, caching, tests) не критичны, но повысят качество.

**Recommendation**: ✅ Approve for merge
