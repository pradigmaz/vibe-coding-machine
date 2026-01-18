# Example: Bad Code Review

## File: `services/user_service.py`

```python
def get_user(db, id):
    try:
        user = db.execute(f"SELECT * FROM users WHERE id = {id}").fetchone()
        return user
    except:
        print("Error getting user")
        return None

def create_user(db, email, name, password):
    try:
        db.execute(f"INSERT INTO users (email, name, password) VALUES ('{email}', '{name}', '{password}')")
        db.commit()
        return True
    except:
        return False

def update_user(db, id, data):
    fields = []
    for key, value in data.items():
        fields.append(f"{key} = '{value}'")
    query = f"UPDATE users SET {', '.join(fields)} WHERE id = {id}"
    db.execute(query)
    db.commit()

def delete_user(db, id):
    db.execute(f"DELETE FROM users WHERE id = {id}")
    db.commit()

def get_all_users(db):
    users = db.execute("SELECT * FROM users").fetchall()
    return users

def search_users(db, query):
    results = db.execute(f"SELECT * FROM users WHERE name LIKE '%{query}%' OR email LIKE '%{query}%'").fetchall()
    return results

API_KEY = "sk-1234567890abcdef"  # TODO: move to env
```

## Review Output

### 🔴 CRITICAL ISSUES (блокеры)

**1. SQL Injection Vulnerability (SECURITY)**
```python
# ❌ BAD (lines 3, 11, 19, 25, 30)
db.execute(f"SELECT * FROM users WHERE id = {id}")
db.execute(f"INSERT INTO users ... VALUES ('{email}', '{name}', '{password}')")

# ✅ GOOD: Use SQLAlchemy ORM
from sqlalchemy.orm import Session
from models.user import User

def get_user(db: Session, user_id: int) -> Optional[User]:
    return db.query(User).filter(User.id == user_id).first()
```
**Impact**: Attacker can execute arbitrary SQL → data breach, data loss
**Priority**: FIX IMMEDIATELY

**2. Hardcoded API Key (SECURITY)**
```python
# ❌ BAD (line 33)
API_KEY = "sk-1234567890abcdef"

# ✅ GOOD: Use environment variables
import os
API_KEY = os.getenv("API_KEY")
if not API_KEY:
    raise ValueError("API_KEY environment variable not set")
```
**Impact**: Secret exposed in git history → unauthorized access
**Priority**: FIX IMMEDIATELY + rotate key

**3. Storing Plain Text Passwords (SECURITY)**
```python
# ❌ BAD (line 11)
# Storing password directly

# ✅ GOOD: Hash passwords
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def create_user(db: Session, user_data: UserCreate) -> User:
    hashed_password = pwd_context.hash(user_data.password)
    user = User(email=user_data.email, hashed_password=hashed_password)
    db.add(user)
    db.commit()
    return user
```
**Impact**: Password breach → all user accounts compromised
**Priority**: FIX IMMEDIATELY

### ⚠️ WARNINGS (нужно исправить)

**4. No Type Hints**
```python
# ❌ BAD
def get_user(db, id):

# ✅ GOOD
def get_user(db: Session, user_id: int) -> Optional[User]:
```
**Impact**: No type checking, harder to maintain
**Lines**: All functions (1, 9, 16, 23, 27, 31)

**5. Bare Except Clauses**
```python
# ❌ BAD (lines 5, 13)
except:
    print("Error getting user")

# ✅ GOOD
except SQLAlchemyError as e:
    logger.error(f"Database error: {e}")
    raise HTTPException(status_code=500, detail="Database error")
```
**Impact**: Catches all errors (even KeyboardInterrupt), hard to debug

**6. Using print() Instead of Logging**
```python
# ❌ BAD (line 6)
print("Error getting user")

# ✅ GOOD
import logging
logger = logging.getLogger(__name__)
logger.error(f"Error getting user {user_id}: {e}")
```
**Impact**: No log levels, no structured logging, lost in production

**7. No Input Validation**
```python
# ❌ BAD: No validation
def create_user(db, email, name, password):

# ✅ GOOD: Use Pydantic
from pydantic import BaseModel, EmailStr

class UserCreate(BaseModel):
    email: EmailStr
    name: str = Field(min_length=1, max_length=100)
    password: str = Field(min_length=8)

def create_user(db: Session, user_data: UserCreate) -> User:
    ...
```
**Impact**: Invalid data in database, potential crashes

### 💡 SUGGESTIONS (nice-to-have)

**8. No Docstrings**
- Add docstrings to all functions
- Explain parameters, return values, exceptions

**9. No Error Handling for Duplicates**
```python
# Add check for existing email
existing = db.query(User).filter(User.email == user_data.email).first()
if existing:
    raise ValueError("Email already exists")
```

**10. SELECT * is Inefficient**
```python
# ❌ BAD
SELECT * FROM users

# ✅ GOOD: Select only needed columns
db.query(User.id, User.email, User.name).all()
```

### ❌ GOOD PRACTICES (ничего)
- No good practices found in this code

## Summary

**Score: 1/10**

**CRITICAL SECURITY ISSUES:**
- 🔴 SQL Injection (3 locations)
- 🔴 Hardcoded secrets
- 🔴 Plain text passwords

**CODE QUALITY ISSUES:**
- ⚠️ No type hints
- ⚠️ Bare except clauses
- ⚠️ print() instead of logging
- ⚠️ No input validation
- ⚠️ No docstrings

**Recommendation**: ❌ BLOCK MERGE

**Required Actions:**
1. Rewrite using SQLAlchemy ORM (eliminate SQL injection)
2. Move API_KEY to environment variables + rotate key
3. Add password hashing (bcrypt)
4. Add type hints to all functions
5. Replace print() with proper logging
6. Add input validation (Pydantic schemas)
7. Add proper error handling
8. Add docstrings
9. Add unit tests

**Estimated effort**: 4-6 hours to fix properly
