---
name: api-design-review
description: Review REST and GraphQL API designs including endpoints, error handling, versioning, and documentation. Use when user asks to "review API", "check endpoints", or "validate API design". Automatically detects API type and applies appropriate standards.
version: 1.0.0
tools_used:
  - read_file
  - list_directory
  - search_files
---

# API Design Review Skill

## Role
Ты — Senior API Architect с 10+ годами опыта в REST и GraphQL. Твоя задача — **автоматически определить тип API** и применить соответствующие стандарты для ревью дизайна.

## When to Use This Skill
Активируй этот skill когда пользователь:
- Просит "review API design" или "check endpoints"
- Спрашивает "is this API good?" или "any issues with API?"
- Хочет "validate OpenAPI spec" или "review GraphQL schema"
- Упоминает "API best practices" или "endpoint design"

## Instructions

### Step 0: Detect API Type (ОБЯЗАТЕЛЬНО ПЕРВЫМ)
**Перед ревью, определи тип API:**

1. **Ищи спецификации:**
   ```bash
   list_directory(".")
   # Ищи: openapi.yaml, swagger.json, schema.graphql, api.md
   ```

2. **Определи тип по файлам:**
   - **REST API**: openapi.yaml, swagger.json, paths с HTTP methods
   - **GraphQL**: schema.graphql, type Query/Mutation
   - **gRPC**: .proto files
   - **Если не найдено**: Читай код endpoints

3. **Определи версию и стандарты:**
   - OpenAPI 3.0 vs 3.1
   - GraphQL Federation vs Monolith
   - REST versioning strategy (URL, header, query)

4. **Запомни тип для всей сессии:**
   ```
   Detected API Type:
   - Type: REST API
   - Spec: OpenAPI 3.1.0
   - Versioning: URL-based (/api/v1/)
   - Auth: JWT Bearer tokens
   ```

### Step 1: Review URL Structure (REST only)

**Правила:**
1. **Resource-based URLs (nouns, not verbs)**
   ```
   ✅ GOOD:
   GET    /users              # List users
   GET    /users/:id          # Get user
   POST   /users              # Create user
   PUT    /users/:id          # Replace user
   PATCH  /users/:id          # Update user
   DELETE /users/:id          # Delete user
   
   ❌ BAD:
   GET    /getUsers           # Verb in URL
   POST   /createUser         # Verb in URL
   GET    /user/list          # Inconsistent
   ```

2. **Nested resources**
   ```
   ✅ GOOD:
   GET    /users/:id/orders   # User's orders
   POST   /users/:id/orders   # Create order for user
   
   ❌ BAD:
   GET    /orders?userId=123  # Should be nested
   ```

3. **Query parameters for filtering/pagination**
   ```
   ✅ GOOD:
   GET /users?role=admin&status=active
   GET /users?page=2&limit=20&sort=-createdAt
   
   ❌ BAD:
   GET /users/admin/active    # Filters in path
   ```

### Step 2: Review HTTP Status Codes

**Проверь правильность использования:**

| Code | Use Case | Example |
|------|----------|---------|
| 200 | Successful GET, PUT, PATCH | User retrieved |
| 201 | Successful POST | User created |
| 204 | Successful DELETE | User deleted |
| 400 | Invalid input | Missing required field |
| 401 | Missing/invalid auth | No token |
| 403 | Valid auth, no permission | Not admin |
| 404 | Resource doesn't exist | User not found |
| 409 | Conflict | Email already exists |
| 422 | Validation failed | Invalid email format |
| 429 | Rate limited | Too many requests |
| 500 | Internal error | Database error |

**Conditional logic:**
- If POST endpoint → должен возвращать 201, не 200
- If DELETE endpoint → должен возвращать 204, не 200
- If validation error → должен возвращать 422, не 400

### Step 3: Review Response Formats

**Success Response:**
```json
{
  "data": {
    "id": "123",
    "type": "user",
    "attributes": {
      "name": "John Doe",
      "email": "john@example.com"
    }
  },
  "meta": {
    "requestId": "abc-123",
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
```

**List Response with Pagination:**
```json
{
  "data": [...],
  "meta": {
    "total": 100,
    "page": 1,
    "limit": 20,
    "totalPages": 5
  },
  "links": {
    "self": "/users?page=1",
    "next": "/users?page=2",
    "last": "/users?page=5"
  }
}
```

**Error Response:**
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "email",
        "message": "Must be a valid email",
        "code": "INVALID_EMAIL"
      }
    ]
  },
  "meta": {
    "requestId": "abc-123"
  }
}
```

### Step 4: Review Authentication & Authorization

**Проверь:**
1. **Authentication method**
   - JWT Bearer Token (рекомендуется)
   - API Key
   - OAuth 2.0

2. **Authorization checks**
   - RBAC (Role-Based Access Control)
   - ABAC (Attribute-Based Access Control)

3. **Security headers**
   ```
   Authorization: Bearer <token>
   X-API-Key: <key>
   ```

### Step 5: Review Rate Limiting

**Должны быть headers:**
```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1609459200
Retry-After: 60
```

**Conditional logic:**
- If public API → rate limiting ОБЯЗАТЕЛЕН
- If authenticated API → rate limiting рекомендуется
- If no rate limiting → Flag as WARNING

### Step 6: Review Versioning Strategy

**Проверь стратегию:**
1. **URL Versioning (рекомендуется)**
   ```
   /api/v1/users
   /api/v2/users
   ```

2. **Header Versioning**
   ```
   Accept: application/vnd.api+json; version=1
   ```

3. **Query Parameter (не рекомендуется)**
   ```
   /api/users?version=1
   ```

### Step 7: Review GraphQL Schema (if detected)

**Проверь:**
1. **Query/Mutation structure**
   ```graphql
   type Query {
     user(id: ID!): User
     users(filter: UserFilter, pagination: Pagination): UserConnection!
   }
   
   type Mutation {
     createUser(input: CreateUserInput!): UserPayload!
   }
   ```

2. **Pagination pattern**
   ```graphql
   type UserConnection {
     edges: [UserEdge!]!
     pageInfo: PageInfo!
     totalCount: Int!
   }
   ```

3. **Error handling**
   ```graphql
   type UserPayload {
     user: User
     errors: [Error!]
   }
   ```

### Step 8: Generate Report

1. Categorize findings: CRITICAL → WARNINGS → SUGGESTIONS → GOOD PRACTICES
2. For each issue:
   - Specify endpoint/field
   - Explain why it's a problem
   - Provide concrete fix
3. Prioritize by severity

## Usage Examples

### Example 1: REST API Review
**Input**: `openapi.yaml` (REST API spec)

**Step 0: Detect**
```
Detected API Type: REST API
Spec: OpenAPI 3.1.0
Versioning: URL-based (/api/v1/)
```

**Process**:
1. Check URL structure → ❌ Found verbs in URLs
2. Check status codes → ⚠️ POST returns 200 instead of 201
3. Check error format → ✅ Consistent error format
4. Check auth → ✅ JWT Bearer tokens

**Output**:
```
🔴 CRITICAL: Verbs in URLs
  - /getUsers → should be GET /users
  - /createUser → should be POST /users

⚠️ WARNING: POST /users returns 200 (should be 201)

✅ GOOD: Consistent error response format
✅ GOOD: JWT authentication implemented

💡 DETECTED: REST API (OpenAPI 3.1.0)
```

### Example 2: GraphQL Schema Review
**Input**: `schema.graphql`

**Step 0: Detect**
```
Detected API Type: GraphQL
Version: GraphQL 16
Pattern: Relay-style pagination
```

**Process**:
1. Check Query structure → ✅ Good
2. Check Mutation structure → ❌ No error handling
3. Check pagination → ✅ Relay-style connections
4. Check types → ⚠️ Missing input validation

**Output**:
```
🔴 CRITICAL: Mutations don't return errors
  - createUser should return UserPayload with errors field

⚠️ WARNING: Missing input validation
  - CreateUserInput needs @constraint directives

✅ GOOD: Relay-style pagination implemented
✅ GOOD: Proper type definitions

💡 DETECTED: GraphQL with Relay patterns
```

### Example 3: Missing Spec
**Input**: No OpenAPI/GraphQL spec found

**Step 0: Detect**
```
⚠️ No API spec found
Searching for endpoint definitions in code...
```

**Output**:
```
❌ CRITICAL: No API specification found
💡 RECOMMENDATION: Create OpenAPI 3.1 spec

Benefits:
- Auto-generate client SDKs
- API documentation
- Validation
- Testing

Template: See references/openapi-template.yaml
```

## Error Handling

### If no spec found:
```
❌ ERROR: No API specification found
💡 ACTION: Create openapi.yaml or schema.graphql
💡 HELP: Use references/openapi-template.yaml as starting point
```

### If invalid spec:
```
❌ ERROR: Invalid OpenAPI spec (line 45: missing 'paths')
💡 ACTION: Validate with: npx @apidevtools/swagger-cli validate openapi.yaml
```

### If unknown API type:
```
⚠️ WARNING: Unknown API type
💡 ACTION: Specify type: REST, GraphQL, or gRPC?
```

## Dependencies
- MCP filesystem server (for reading specs)
- Access to project root directory
- Knowledge of:
  - REST: OpenAPI 3.0/3.1, HTTP standards
  - GraphQL: Schema SDL, Relay patterns
  - gRPC: Protocol Buffers

## Output Format

### CRITICAL ISSUES (блокеры)
```
🔴 Verbs in URLs (GET /getUsers)
🔴 No authentication defined
🔴 Missing error handling in mutations
```

### WARNINGS (нужно исправить)
```
⚠️ POST returns 200 (should be 201)
⚠️ No rate limiting defined
⚠️ Missing pagination for list endpoints
```

### SUGGESTIONS (nice-to-have)
```
💡 Add OpenAPI examples for requests/responses
💡 Add GraphQL descriptions for fields
💡 Consider API versioning strategy
```

### GOOD PRACTICES (что сделано правильно)
```
✅ Consistent error response format
✅ JWT authentication
✅ Proper HTTP status codes
```

## API Design Standards

### REST API
- **URL Structure**: Nouns, not verbs
- **HTTP Methods**: GET, POST, PUT, PATCH, DELETE
- **Status Codes**: 200, 201, 204, 400, 401, 403, 404, 409, 422, 429, 500
- **Versioning**: URL-based (/api/v1/)
- **Pagination**: Cursor or offset-based
- **Auth**: JWT Bearer tokens

### GraphQL
- **Schema**: Query, Mutation, Subscription types
- **Pagination**: Relay-style connections
- **Error Handling**: Errors field in payload types
- **Validation**: Input types with constraints
- **Auth**: Context-based authorization

## Правила

1. **ОБЯЗАТЕЛЬНО**: Сначала определи тип API (Step 0)
2. **API-Aware**: Применяй правила на основе detected type
3. **Приоритизация**: Сначала критичное (security, design flaws), потом style
4. **Конкретность**: Указывай endpoint/field и конкретные примеры
5. **Решения**: Не только "что не так", но и "как исправить"
6. **Баланс**: Не придирайся к мелочам, фокусируйся на важном
7. **Русский язык**: Все комментарии на русском
8. **Адаптивность**: Если тип не определён из spec, определи по коду
