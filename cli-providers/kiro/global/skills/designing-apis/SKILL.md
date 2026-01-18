# Designing APIs Skill

## Назначение

Дизайн REST и GraphQL APIs включая endpoints, error handling, versioning и documentation. Используется backend агентами при создании APIs.

## Дополнительные материалы (steering)

Для шаблонов смотри:
- `steering/OPENAPI-TEMPLATE.md` - Готовый шаблон OpenAPI 3.0 спецификации

## API Design Workflow

```
API Design Progress:
- [ ] Step 1: Define resources and relationships
- [ ] Step 2: Design endpoint structure
- [ ] Step 3: Define request/response formats
- [ ] Step 4: Plan error handling
- [ ] Step 5: Add authentication/authorization
- [ ] Step 6: Document with OpenAPI spec
- [ ] Step 7: Validate design against checklist
```

## REST API Design

### URL Structure

```
# Resource-based URLs (nouns, not verbs)
GET    /users              # List users
GET    /users/:id          # Get user
POST   /users              # Create user
PUT    /users/:id          # Replace user (full update)
PATCH  /users/:id          # Update user (partial)
DELETE /users/:id          # Delete user

# Nested resources
GET    /users/:id/orders   # User's orders
POST   /users/:id/orders   # Create order for user
GET    /users/:id/orders/:orderId  # Specific order

# Query parameters for filtering/pagination
GET    /users?role=admin&status=active
GET    /users?page=2&limit=20&sort=-createdAt
GET    /products?category=electronics&minPrice=100
```

### HTTP Status Codes

| Code | Meaning | Use Case |
|------|---------|----------|
| 200 | OK | Successful GET, PUT, PATCH |
| 201 | Created | Successful POST |
| 204 | No Content | Successful DELETE |
| 400 | Bad Request | Invalid input |
| 401 | Unauthorized | Missing/invalid auth |
| 403 | Forbidden | Valid auth, no permission |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Duplicate, state conflict |
| 422 | Unprocessable | Validation failed |
| 429 | Too Many Requests | Rate limited |
| 500 | Internal Error | Server error |
| 503 | Service Unavailable | Temporary unavailable |

### Response Formats

**Success Response:**
```json
{
  "data": {
    "id": "123",
    "type": "user",
    "attributes": {
      "name": "John Doe",
      "email": "john@example.com",
      "createdAt": "2024-01-15T10:30:00Z"
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
  "data": [
    {"id": "1", "name": "User 1"},
    {"id": "2", "name": "User 2"}
  ],
  "meta": {
    "total": 100,
    "page": 1,
    "limit": 20,
    "totalPages": 5
  },
  "links": {
    "self": "/users?page=1",
    "first": "/users?page=1",
    "prev": null,
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
        "message": "Must be a valid email address",
        "code": "INVALID_EMAIL"
      },
      {
        "field": "age",
        "message": "Must be at least 18",
        "code": "MIN_VALUE"
      }
    ]
  },
  "meta": {
    "requestId": "abc-123",
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
```

## API Versioning

**URL Versioning (Рекомендуется):**
```
/api/v1/users
/api/v2/users
```

**Header Versioning:**
```
Accept: application/vnd.api+json; version=1
API-Version: 2024-01-15
```

**Query Parameter (Не рекомендуется):**
```
/api/users?version=1
```

## Authentication Patterns

### JWT Bearer Token
```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
```

```typescript
// Middleware
async function authenticate(req, res, next) {
  const token = req.headers.authorization?.replace('Bearer ', '');
  
  if (!token) {
    return res.status(401).json({ error: 'Missing token' });
  }
  
  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    req.user = payload;
    next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid token' });
  }
}
```

### API Key
```http
X-API-Key: your-api-key
```

### OAuth 2.0
```http
Authorization: Bearer <access_token>
```

## Rate Limiting

### Headers
```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1609459200
Retry-After: 60
```

### Implementation
```typescript
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // 100 requests per window
  message: 'Too many requests, please try again later',
  standardHeaders: true,
  legacyHeaders: false,
});

app.use('/api/', limiter);
```

## GraphQL Patterns

### Schema Design

```graphql
type Query {
  user(id: ID!): User
  users(
    filter: UserFilter
    pagination: Pagination
  ): UserConnection!
}

type Mutation {
  createUser(input: CreateUserInput!): UserPayload!
  updateUser(id: ID!, input: UpdateUserInput!): UserPayload!
  deleteUser(id: ID!): DeletePayload!
}

type User {
  id: ID!
  name: String!
  email: String!
  createdAt: DateTime!
  orders(first: Int, after: String): OrderConnection!
}

input CreateUserInput {
  name: String!
  email: String!
  password: String!
}

input UpdateUserInput {
  name: String
  email: String
}

input UserFilter {
  role: Role
  status: Status
  search: String
}

input Pagination {
  first: Int
  after: String
  last: Int
  before: String
}

type UserConnection {
  edges: [UserEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type UserEdge {
  node: User!
  cursor: String!
}

type PageInfo {
  hasNextPage: Boolean!
  hasPreviousPage: Boolean!
  startCursor: String
  endCursor: String
}

type UserPayload {
  user: User
  errors: [Error!]
}

type Error {
  field: String
  message: String!
  code: String!
}
```

### Resolver Pattern

```typescript
const resolvers = {
  Query: {
    user: async (_, { id }, context) => {
      return await context.db.user.findUnique({ where: { id } });
    },
    
    users: async (_, { filter, pagination }, context) => {
      const { first = 20, after } = pagination || {};
      
      const users = await context.db.user.findMany({
        where: buildFilter(filter),
        take: first + 1,
        cursor: after ? { id: after } : undefined,
      });
      
      const hasNextPage = users.length > first;
      const edges = users.slice(0, first);
      
      return {
        edges: edges.map(user => ({
          node: user,
          cursor: user.id,
        })),
        pageInfo: {
          hasNextPage,
          endCursor: edges[edges.length - 1]?.id,
        },
      };
    },
  },
  
  Mutation: {
    createUser: async (_, { input }, context) => {
      try {
        const user = await context.db.user.create({ data: input });
        return { user, errors: [] };
      } catch (error) {
        return {
          user: null,
          errors: [{ message: error.message, code: 'CREATE_FAILED' }],
        };
      }
    },
  },
  
  User: {
    orders: async (user, { first, after }, context) => {
      return await context.loaders.ordersByUser.load({
        userId: user.id,
        first,
        after,
      });
    },
  },
};
```

## API Documentation

### OpenAPI 3.0 Example

```yaml
openapi: 3.0.0
info:
  title: User API
  version: 1.0.0
  description: API for managing users

servers:
  - url: https://api.example.com/v1
    description: Production server

paths:
  /users:
    get:
      summary: List users
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            default: 1
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserList'
    
    post:
      summary: Create user
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserInput'
      responses:
        '201':
          description: User created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'

components:
  schemas:
    User:
      type: object
      properties:
        id:
          type: string
        name:
          type: string
        email:
          type: string
          format: email
    
    CreateUserInput:
      type: object
      required:
        - name
        - email
      properties:
        name:
          type: string
        email:
          type: string
          format: email
```

## Security Checklist

```
API Security Review:
- [ ] HTTPS only (no HTTP)
- [ ] Authentication on all endpoints
- [ ] Authorization checks (RBAC/ABAC)
- [ ] Input validation (all fields)
- [ ] Rate limiting implemented
- [ ] Request size limits
- [ ] CORS properly configured
- [ ] No sensitive data in URLs
- [ ] Audit logging enabled
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] CSRF protection
- [ ] Secrets in environment variables
```

## API Design Validation

```
Design Validation Checklist:
- [ ] All endpoints use nouns, not verbs
- [ ] HTTP methods match operations correctly
- [ ] Consistent response format across endpoints
- [ ] Error responses include actionable details
- [ ] Pagination implemented for list endpoints
- [ ] Authentication defined for protected endpoints
- [ ] Rate limiting headers documented
- [ ] OpenAPI spec is complete and valid
- [ ] Versioning strategy defined
- [ ] Breaking changes documented
```

## Best Practices

### ✅ DO

- Use nouns for resources, not verbs
- Use HTTP methods correctly (GET, POST, PUT, PATCH, DELETE)
- Return appropriate status codes
- Provide clear error messages
- Implement pagination for lists
- Version your API
- Document with OpenAPI/Swagger
- Use HTTPS everywhere
- Implement rate limiting

### ❌ DON'T

- Don't use verbs in URLs (`/getUsers` ❌, `/users` ✅)
- Don't return 200 for errors
- Don't expose internal IDs without validation
- Don't return sensitive data
- Don't ignore security
- Don't skip documentation
- Don't break backward compatibility without versioning

## Ресурсы

- [REST API Tutorial](https://restfulapi.net/)
- [OpenAPI Specification](https://swagger.io/specification/)
- [GraphQL Best Practices](https://graphql.org/learn/best-practices/)
- [HTTP Status Codes](https://httpstatuses.com/)
