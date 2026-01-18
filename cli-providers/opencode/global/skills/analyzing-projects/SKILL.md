---
name: analyzing-projects
description: 
---

# Analyzing Projects Skill

## Назначение

Анализ codebase для понимания структуры, tech stack, patterns. Используется всеми агентами при onboarding к новому проекту, исследовании unfamiliar code.

## Project Analysis Workflow

```
Project Analysis Progress:
- [ ] Step 1: Quick overview (README, root files)
- [ ] Step 2: Detect tech stack
- [ ] Step 3: Map project structure
- [ ] Step 4: Identify key patterns
- [ ] Step 5: Find development workflow
- [ ] Step 6: Generate summary report
```

## Step 1: Quick Overview

```bash
# Check для common project markers
ls -la
cat README.md 2>/dev/null | head -50
```

## Step 2: Tech Stack Detection

### Package Managers & Dependencies

- `package.json` → Node.js/JavaScript/TypeScript
- `requirements.txt` / `pyproject.toml` → Python
- `go.mod` → Go
- `Cargo.toml` → Rust
- `pom.xml` / `build.gradle` → Java
- `Gemfile` → Ruby

### Frameworks

- React, Vue, Angular, Next.js, Nuxt
- Express, FastAPI, Django, Flask, Rails
- Spring Boot, Gin, Echo

### Infrastructure

- `Dockerfile`, `docker-compose.yml` → Containerized
- `kubernetes/`, `k8s/` → Kubernetes
- `terraform/`, `.tf` files → IaC
- `.github/workflows/` → GitHub Actions

## Step 3: Project Structure

```
project/
├── src/              # Source code
│   ├── components/   # UI components
│   ├── services/     # Business logic
│   ├── models/       # Data models
│   └── utils/        # Shared utilities
├── tests/            # Test files
├── docs/             # Documentation
└── config/           # Configuration
```


## Step 4: Key Patterns

Look for:
- **Architecture**: Monolith, Microservices, Serverless, Monorepo
- **API Style**: REST, GraphQL, gRPC, tRPC
- **State Management**: Redux, Zustand, MobX, Context
- **Database**: SQL, NoSQL, ORM used
- **Authentication**: JWT, OAuth, Sessions
- **Testing**: Jest, Pytest, Go test

## Step 5: Development Workflow

Check for:
- `.eslintrc`, `.prettierrc` → Linting/Formatting
- `.husky/` → Git hooks
- `Makefile` → Build commands
- `scripts/` в package.json → NPM scripts

## Step 6: Output Format

```markdown
# Project: [Name]

## Overview
[1-2 sentence description]

## Tech Stack
| Category | Technology |
|----------|------------|
| Language | TypeScript |
| Framework | Next.js 14 |
| Database | PostgreSQL |

## Architecture
[Description с simple ASCII diagram]

## Key Directories
- `src/` - [purpose]
- `lib/` - [purpose]

## Entry Points
- Main: `src/index.ts`
- API: `src/api/`
- Tests: `npm test`

## Conventions
- [Naming conventions]
- [File organization patterns]
- [Code style preferences]

## Quick Commands
| Action | Command |
|--------|---------|
| Install | `npm install` |
| Dev | `npm run dev` |
| Test | `npm test` |
| Build | `npm run build` |
```

## Analysis Validation

```
Analysis Validation:
- [ ] All major directories explained
- [ ] Tech stack accurately identified
- [ ] Entry points documented
- [ ] Development commands verified working
- [ ] No assumptions made without evidence
```

## Best Practices

```typescript
// ✅ GOOD: Check actual files
const hasTypeScript = fs.existsSync('tsconfig.json');

// ✅ GOOD: Read package.json для dependencies
const pkg = JSON.parse(fs.readFileSync('package.json'));
const framework = pkg.dependencies.react ? 'React' : 'Unknown';

// ✅ GOOD: Verify commands work
try {
  execSync('npm test --version');
  hasTests = true;
} catch {}

// ❌ BAD: Assume без проверки
// "This looks like a React project" (без package.json check)

// ❌ BAD: Guess structure
// "Probably uses Redux" (без проверки dependencies)
```

## Checklist

```
Project Analysis Review:
- [ ] README прочитан
- [ ] package.json/requirements.txt проверен
- [ ] Directory structure mapped
- [ ] Tech stack identified
- [ ] Entry points найдены
- [ ] Development commands documented
- [ ] Patterns identified
- [ ] No assumptions без evidence
```

## Ресурсы

- [Project Structure Best Practices](https://github.com/goldbergyoni/nodebestpractices)
- [Architecture Patterns](https://martinfowler.com/architecture/)
