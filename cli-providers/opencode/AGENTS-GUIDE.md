# OpenCode - Полное руководство по агентам

## Введение в агенты

Агенты в OpenCode - это специализированные AI ассистенты, которые можно настроить для конкретных задач и рабочих процессов. Они позволяют создавать фокусированные инструменты с кастомными промптами, моделями и доступом к инструментам.

## Типы агентов

### Primary Agents (Основные агенты)

Основные агенты - это главные ассистенты, с которыми вы взаимодействуете напрямую.

**Характеристики**:
- Обрабатывают основной разговор
- Доступ ко всем настроенным инструментам
- Переключение через `Tab` или настроенный keybind
- Управляют основной сессией

**Встроенные primary агенты**:
- **Build** - Полный доступ к инструментам для разработки
- **Plan** - Ограниченный доступ для планирования

### Subagents (Подагенты)

Подагенты - это специализированные ассистенты, которые primary агенты могут вызывать для конкретных задач.

**Характеристики**:
- Вызываются через @ mention
- Создают дочерние сессии
- Фокусируются на конкретной задаче
- Возвращают результат в основную сессию

**Встроенные subagents**:
- **General** - Исследование, поиск кода, многошаговые задачи
- **Explore** - Быстрое исследование кодовой базы

## Встроенные агенты

### Build Agent

**Режим**: Primary  
**Назначение**: Основной агент для разработки

**Конфигурация по умолчанию**:
```json
{
  "mode": "primary",
  "tools": {
    "write": true,
    "edit": true,
    "bash": true,
    "read": true,
    "grep": true,
    "glob": true,
    "list": true,
    "webfetch": true,
    "lsp": true,
    "skill": true,
    "todowrite": true,
    "todoread": true,
    "question": true
  }
}
```

**Когда использовать**:
- Написание нового кода
- Рефакторинг существующего кода
- Исправление багов
- Добавление функций
- Выполнение команд

### Plan Agent

**Режим**: Primary  
**Назначение**: Планирование и анализ без изменений

**Конфигурация по умолчанию**:
```json
{
  "mode": "primary",
  "permissions": {
    "write": "ask",
    "edit": "ask",
    "bash": "ask",
    "patch": "ask"
  }
}
```

**Когда использовать**:
- Создание плана реализации
- Анализ кода без изменений
- Обзор архитектуры
- Оценка задач
- Проверка подхода

**Переключение**:
```
Tab - переключение между Build и Plan
```

### General Subagent

**Режим**: Subagent  
**Назначение**: Универсальный агент для сложных задач

**Возможности**:
- Исследование сложных вопросов
- Поиск кода по ключевым словам
- Многошаговые задачи
- Когда не уверены в первой попытке поиска

**Использование**:
```
@general Find all authentication-related code and explain the flow
```

### Explore Subagent

**Режим**: Subagent  
**Назначение**: Быстрое исследование кодовой базы

**Возможности**:
- Поиск файлов по паттернам
- Поиск кода по ключевым словам
- Ответы на вопросы о кодовой базе
- Быстрый анализ структуры

**Использование**:
```
@explore What files handle user authentication?
```

## Создание кастомных агентов

### Через CLI

```bash
opencode agent create
```

Интерактивный процесс:
1. **Расположение**: Global или project-specific
2. **Описание**: Что делает агент и когда использовать
3. **System prompt**: Автоматическая генерация или кастомный
4. **Инструменты**: Выбор доступных инструментов
5. **Создание**: Markdown файл с конфигурацией

### Через JSON конфигурацию

**Файл**: `~/.config/opencode/opencode.json` или `.opencode/opencode.json`

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agents": {
    "code-reviewer": {
      "description": "Reviews code for best practices and potential issues",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "temperature": 0.3,
      "maxTokens": 5000,
      "maxSteps": 5,
      "prompt": "You are a code reviewer. Focus on:\n- Security vulnerabilities\n- Performance issues\n- Code maintainability\n- Best practices\n- Potential bugs",
      "tools": {
        "write": false,
        "edit": false,
        "bash": false,
        "read": true,
        "grep": true,
        "glob": true
      },
      "permissions": {
        "read": "allow",
        "grep": "allow"
      }
    }
  }
}
```

### Через Markdown файл

**Расположение**:
- Global: `~/.config/opencode/agents/`
- Project: `.opencode/agents/`

**Файл**: `code-reviewer.md`

```markdown
---
description: Reviews code for best practices and potential issues
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.3
maxTokens: 5000
tools:
  write: false
  edit: false
  read: true
  grep: true
permissions:
  read: allow
---

# Code Reviewer Agent

You are an expert code reviewer with years of experience.

## Your responsibilities:

1. **Security Analysis**
   - Identify potential security vulnerabilities
   - Check for SQL injection, XSS, CSRF
   - Validate input sanitization

2. **Performance Review**
   - Identify performance bottlenecks
   - Check for N+1 queries
   - Review algorithm complexity

3. **Code Quality**
   - Check code maintainability
   - Verify adherence to best practices
   - Suggest improvements

4. **Bug Detection**
   - Identify potential bugs
   - Check edge cases
   - Verify error handling

## Review format:

For each issue found, provide:
- **Severity**: Critical / High / Medium / Low
- **Location**: File and line number
- **Issue**: Clear description
- **Recommendation**: How to fix
- **Example**: Code example if helpful
```

## Конфигурация агентов

### Основные параметры

#### description
Краткое описание агента и когда его использовать.

```json
{
  "description": "Reviews code for security and performance issues"
}
```

**Обязательный параметр**.

#### mode
Режим работы агента.

```json
{
  "mode": "primary" | "subagent" | "all"
}
```

- `primary` - Основной агент, переключение через Tab
- `subagent` - Вызов через @ mention
- `all` - Может быть и primary, и subagent (по умолчанию)

#### model
Модель для использования агентом.

```json
{
  "model": "anthropic/claude-sonnet-4-20250514"
}
```

Формат: `provider/model-id`

Примеры:
- `anthropic/claude-sonnet-4-20250514`
- `openai/gpt-4-turbo`
- `opencode/gpt-5.1-codex`
- `google/gemini-2.0-flash`

#### temperature
Контроль случайности и креативности ответов.

```json
{
  "temperature": 0.7
}
```

- `0.0` - Детерминированный, фокусированный
- `0.5` - Сбалансированный
- `1.0` - Креативный, вариативный

По умолчанию: 0 для большинства моделей, 0.55 для Qwen.

#### maxTokens
Максимальное количество токенов в ответе.

```json
{
  "maxTokens": 5000
}
```

#### maxSteps
Максимальное количество итераций агента.

```json
{
  "maxSteps": 10
}
```

Ограничивает количество agentic действий для контроля стоимости.

При достижении лимита агент получает инструкцию суммировать работу и рекомендовать оставшиеся задачи.

#### prompt
Путь к файлу с system prompt.

```json
{
  "prompt": "{file:./prompts/reviewer.md}"
}
```

Путь относительно расположения конфига.

#### disabled
Отключить агента.

```json
{
  "disabled": true
}
```

#### hidden
Скрыть subagent из @ autocomplete меню.

```json
{
  "hidden": true
}
```

Полезно для внутренних subagents, вызываемых только программно.

### Инструменты (tools)

Контроль доступных инструментов для агента.

```json
{
  "tools": {
    "write": true,
    "edit": true,
    "bash": false,
    "read": true,
    "grep": true,
    "glob": true,
    "list": true,
    "webfetch": true,
    "lsp": true,
    "skill": true,
    "todowrite": true,
    "todoread": true,
    "question": true
  }
}
```

#### Wildcards для MCP инструментов

```json
{
  "tools": {
    "mcp_sentry*": false,
    "mcp_context7*": true
  }
}
```

### Разрешения (permissions)

Контроль действий агента.

```json
{
  "permissions": {
    "edit": "ask",
    "bash": "deny",
    "write": "allow"
  }
}
```

**Уровни**:
- `allow` - Автоматическое выполнение
- `ask` - Запрос подтверждения (по умолчанию)
- `deny` - Блокировка

#### Разрешения для bash команд

```json
{
  "permissions": {
    "bash": {
      "*": "ask",
      "npm install": "allow",
      "git push": "ask",
      "rm -rf": "deny",
      "git *": "ask"
    }
  }
}
```

Поддержка glob паттернов. Последнее совпадающее правило имеет приоритет.

#### Task permissions

Контроль вызова subagents через Task tool.

```json
{
  "permissions": {
    "task": {
      "code-reviewer": "allow",
      "security-*": "ask",
      "internal-*": "deny"
    }
  }
}
```

При `deny` subagent удаляется из описания Task tool.

### Дополнительные параметры

Любые дополнительные параметры передаются напрямую провайдеру.

```json
{
  "reasoning_effort": "high",
  "top_p": 0.9,
  "frequency_penalty": 0.5
}
```

Специфичны для модели и провайдера. Проверяйте документацию провайдера.

## Использование агентов

### Primary агенты

#### Переключение через Tab

```
Tab - переключение между primary агентами
```

Индикатор в правом нижнем углу показывает текущего агента.

#### Через keybind

Настройка в конфигурации:
```json
{
  "keybinds": {
    "switch_agent": "alt+tab"
  }
}
```

### Subagents

#### Через @ mention

```
@code-reviewer Review this authentication code for security issues
```

#### Через команду

```
/agent code-reviewer
```

#### Программный вызов

Primary агент может вызвать subagent через Task tool:
```
Use the code-reviewer agent to analyze this file
```

### Навигация между сессиями

Когда subagent создает дочернюю сессию:

- `Ctrl+A` - Переключение между родительской и дочерними сессиями
- Список сессий показывает иерархию

## Примеры агентов

### 1. Documentation Agent

**Назначение**: Создание и обновление документации

```markdown
---
description: Creates and updates project documentation
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.5
tools:
  write: true
  edit: true
  read: true
  grep: true
permissions:
  write: ask
  edit: ask
---

# Documentation Agent

You are a technical writer specializing in clear, comprehensive documentation.

## Your tasks:

1. **API Documentation**
   - Document all public APIs
   - Include examples
   - Explain parameters and return values

2. **README Files**
   - Clear project overview
   - Installation instructions
   - Usage examples
   - Contributing guidelines

3. **Code Comments**
   - Explain complex logic
   - Document assumptions
   - Add JSDoc/docstrings

## Style guide:

- Use clear, concise language
- Include code examples
- Add diagrams when helpful
- Keep it up-to-date
```

**Использование**:
```
@documentation Create API documentation for the auth module
```

### 2. Security Auditor

**Назначение**: Аудит безопасности кода

```json
{
  "security-auditor": {
    "description": "Performs security audits on code",
    "mode": "subagent",
    "model": "anthropic/claude-sonnet-4-20250514",
    "temperature": 0.2,
    "prompt": "You are a security expert. Analyze code for:\n- SQL injection\n- XSS vulnerabilities\n- CSRF issues\n- Authentication flaws\n- Authorization bypasses\n- Sensitive data exposure\n- Insecure dependencies",
    "tools": {
      "write": false,
      "edit": false,
      "read": true,
      "grep": true,
      "glob": true,
      "bash": true
    },
    "permissions": {
      "bash": {
        "*": "deny",
        "npm audit": "allow",
        "safety check": "allow"
      }
    }
  }
}
```

**Использование**:
```
@security-auditor Audit the payment processing code
```

### 3. Test Engineer

**Назначение**: Создание тестов

```markdown
---
description: Creates comprehensive test suites
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.4
maxSteps: 8
tools:
  write: true
  edit: true
  read: true
  bash: true
permissions:
  write: ask
  bash:
    "*": "ask"
    "npm test": "allow"
    "pytest": "allow"
---

# Test Engineer Agent

You are a QA engineer specializing in comprehensive testing.

## Test types:

1. **Unit Tests**
   - Test individual functions
   - Mock dependencies
   - Cover edge cases
   - Aim for 80%+ coverage

2. **Integration Tests**
   - Test component interactions
   - Test API endpoints
   - Test database operations

3. **E2E Tests**
   - Test user workflows
   - Test critical paths
   - Use realistic scenarios

## Best practices:

- Follow AAA pattern (Arrange, Act, Assert)
- Use descriptive test names
- One assertion per test when possible
- Test both happy and error paths
- Keep tests independent
```

**Использование**:
```
@test-engineer Create unit tests for the user service
```

### 4. Performance Optimizer

**Назначение**: Оптимизация производительности

```json
{
  "performance-optimizer": {
    "description": "Analyzes and optimizes code performance",
    "mode": "subagent",
    "model": "anthropic/claude-sonnet-4-20250514",
    "temperature": 0.3,
    "prompt": "You are a performance optimization expert. Focus on:\n- Algorithm complexity\n- Database query optimization\n- Caching strategies\n- Memory usage\n- Network requests\n- Bundle size\n- Rendering performance",
    "tools": {
      "read": true,
      "grep": true,
      "bash": true,
      "edit": true
    },
    "permissions": {
      "edit": "ask",
      "bash": {
        "*": "ask",
        "npm run build": "allow",
        "npm run analyze": "allow"
      }
    }
  }
}
```

**Использование**:
```
@performance-optimizer Optimize the data fetching logic
```

### 5. Database Architect

**Назначение**: Проектирование баз данных

```markdown
---
description: Designs database schemas and optimizes queries
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.4
tools:
  write: true
  read: true
  grep: true
  skill: true
permissions:
  write: ask
---

# Database Architect Agent

You are a database expert specializing in schema design and optimization.

## Responsibilities:

1. **Schema Design**
   - Normalize data appropriately
   - Choose correct data types
   - Design indexes
   - Plan relationships

2. **Query Optimization**
   - Analyze slow queries
   - Suggest indexes
   - Optimize joins
   - Reduce N+1 queries

3. **Migrations**
   - Safe migration strategies
   - Backward compatibility
   - Data integrity

## Principles:

- Start with normalized design
- Denormalize only when needed
- Index foreign keys
- Use appropriate constraints
- Plan for scale
```

**Использование**:
```
@database-architect Design a schema for the e-commerce system
```

### 6. Frontend Specialist

**Назначение**: Разработка frontend

```json
{
  "frontend-specialist": {
    "description": "Specializes in React, TypeScript, and modern frontend",
    "mode": "primary",
    "model": "anthropic/claude-sonnet-4-20250514",
    "temperature": 0.5,
    "prompt": "You are a frontend expert. Focus on:\n- React best practices\n- TypeScript types\n- Component composition\n- State management\n- Performance\n- Accessibility\n- Responsive design",
    "tools": {
      "write": true,
      "edit": true,
      "bash": true,
      "read": true,
      "lsp": true
    },
    "permissions": {
      "bash": {
        "*": "ask",
        "npm install": "allow",
        "npm run dev": "deny"
      }
    }
  }
}
```

**Использование**:
```
Tab - переключиться на frontend-specialist
Create a reusable modal component with TypeScript
```

### 7. Backend Specialist

**Назначение**: Разработка backend

```markdown
---
description: Specializes in Node.js, APIs, and backend systems
mode: primary
model: anthropic/claude-sonnet-4-20250514
temperature: 0.4
tools:
  write: true
  edit: true
  bash: true
  read: true
  lsp: true
permissions:
  bash:
    "*": "ask"
    "npm install": "allow"
---

# Backend Specialist Agent

You are a backend expert specializing in scalable systems.

## Expertise:

1. **API Design**
   - RESTful principles
   - GraphQL schemas
   - API versioning
   - Error handling

2. **Database**
   - Query optimization
   - Transactions
   - Migrations
   - Connection pooling

3. **Architecture**
   - Microservices
   - Event-driven
   - Caching strategies
   - Message queues

4. **Security**
   - Authentication
   - Authorization
   - Input validation
   - Rate limiting

## Best practices:

- Validate all inputs
- Use transactions appropriately
- Implement proper error handling
- Log important events
- Monitor performance
```

**Использование**:
```
Tab - переключиться на backend-specialist
Create a REST API for user management
```

### 8. Refactoring Specialist

**Назначение**: Рефакторинг кода

```json
{
  "refactoring-specialist": {
    "description": "Refactors code for better maintainability",
    "mode": "subagent",
    "model": "anthropic/claude-sonnet-4-20250514",
    "temperature": 0.3,
    "maxSteps": 10,
    "prompt": "You are a refactoring expert. Focus on:\n- Code smells\n- Design patterns\n- SOLID principles\n- DRY principle\n- Separation of concerns\n- Testability",
    "tools": {
      "read": true,
      "edit": true,
      "grep": true,
      "bash": true
    },
    "permissions": {
      "edit": "ask",
      "bash": {
        "*": "ask",
        "npm test": "allow"
      }
    }
  }
}
```

**Использование**:
```
@refactoring-specialist Refactor this 500-line component
```

## Лучшие практики

### 1. Специализация агентов

Создавайте агентов для конкретных задач:
- ✅ `code-reviewer` - фокус на review
- ✅ `test-engineer` - фокус на тестах
- ❌ `general-helper` - слишком широко

### 2. Четкие промпты

Давайте агентам четкие инструкции:
```markdown
You are a security auditor. Focus on:
1. SQL injection vulnerabilities
2. XSS attacks
3. CSRF protection
4. Authentication flaws
```

### 3. Правильные разрешения

Ограничивайте опасные операции:
```json
{
  "permissions": {
    "bash": {
      "*": "ask",
      "rm -rf": "deny",
      "git push": "ask"
    }
  }
}
```

### 4. Подходящие модели

Выбирайте модели по задаче:
- **Планирование**: Быстрые модели (Haiku, Flash)
- **Реализация**: Мощные модели (Sonnet, GPT-4)
- **Review**: Средние модели (Sonnet)

### 5. Контроль стоимости

Используйте `maxSteps` для ограничения:
```json
{
  "maxSteps": 5,
  "model": "anthropic/claude-haiku-4-20250514"
}
```

### 6. Организация агентов

**Global агенты** (`~/.config/opencode/agents/`):
- Универсальные агенты
- Используются во всех проектах

**Project агенты** (`.opencode/agents/`):
- Специфичные для проекта
- Знание контекста проекта

### 7. Тестирование агентов

Тестируйте новых агентов:
1. Создайте агента
2. Попробуйте на простой задаче
3. Проверьте результат
4. Настройте промпт/разрешения
5. Повторите

### 8. Документирование агентов

Добавляйте четкие описания:
```json
{
  "description": "Reviews code for security issues. Use when: adding authentication, handling user input, processing payments"
}
```

### 9. Использование навыков

Загружайте навыки в промпт:
```markdown
Load the skill for PostgreSQL best practices before designing the schema.
```

### 10. Композиция агентов

Primary агент может использовать subagents:
```
Use @code-reviewer to review the changes, then @test-engineer to add tests
```

## Troubleshooting

### Агент не появляется

**Проблема**: Агент не виден в списке

**Решения**:
1. Проверьте синтаксис JSON/YAML
2. Убедитесь что `disabled: false`
3. Проверьте расположение файла
4. Перезапустите OpenCode

```bash
# Список агентов
opencode agent list
```

### Агент не может выполнить действие

**Проблема**: "Permission denied" или инструмент недоступен

**Решения**:
1. Проверьте `tools` конфигурацию
2. Проверьте `permissions`
3. Убедитесь что инструмент включен глобально

```json
{
  "tools": {
    "write": true  // Включить инструмент
  },
  "permissions": {
    "write": "allow"  // Разрешить использование
  }
}
```

### Агент дает неправильные ответы

**Проблема**: Агент не следует инструкциям

**Решения**:
1. Улучшите system prompt
2. Добавьте примеры
3. Уменьшите temperature
4. Попробуйте другую модель

```json
{
  "temperature": 0.2,  // Более детерминированный
  "model": "anthropic/claude-sonnet-4-20250514"  // Более мощная модель
}
```

### Агент слишком дорогой

**Проблема**: Высокая стоимость использования

**Решения**:
1. Используйте более дешевую модель
2. Установите `maxSteps`
3. Ограничьте `maxTokens`
4. Оптимизируйте промпт

```json
{
  "model": "anthropic/claude-haiku-4-20250514",
  "maxSteps": 5,
  "maxTokens": 2000
}
```

### Агент слишком медленный

**Проблема**: Долгое время ответа

**Решения**:
1. Используйте более быструю модель
2. Уменьшите `maxTokens`
3. Ограничьте доступные инструменты
4. Оптимизируйте промпт

```json
{
  "model": "google/gemini-2.0-flash",
  "maxTokens": 2000
}
```

## Продвинутые техники

### 1. Цепочки агентов

Создайте workflow из нескольких агентов:

```
1. @architect Design the system
2. @backend-specialist Implement the API
3. @test-engineer Add tests
4. @code-reviewer Review everything
```

### 2. Условные разрешения

Разные разрешения для разных команд:

```json
{
  "permissions": {
    "bash": {
      "npm install *": "allow",
      "npm uninstall *": "ask",
      "git commit *": "ask",
      "git push *": "deny"
    }
  }
}
```

### 3. Контекстные агенты

Агенты с загруженным контекстом проекта:

```markdown
---
description: Backend specialist for this e-commerce project
---

# E-commerce Backend Specialist

You are working on an e-commerce platform with:
- Node.js + Express
- PostgreSQL database
- Redis for caching
- Stripe for payments
- AWS S3 for images

Always consider:
- PCI compliance for payments
- GDPR for user data
- High availability requirements
```

### 4. Динамические промпты

Промпты с переменными:

```markdown
You are working on the {{PROJECT_NAME}} project.
Tech stack: {{TECH_STACK}}
Current task: {{CURRENT_TASK}}
```

### 5. Агенты с навыками

Агенты, загружающие навыки:

```markdown
Before starting, load these skills:
- PostgreSQL best practices
- REST API design patterns
- Security checklist
```

## Примеры workflow

### Code Review Workflow

```
1. Создать PR
2. @code-reviewer Review the changes
3. @security-auditor Check for security issues
4. @test-engineer Verify test coverage
5. Исправить найденные проблемы
6. Merge
```

### Feature Development Workflow

```
1. Plan mode: Create implementation plan
2. Build mode: Implement the feature
3. @test-engineer: Add tests
4. @code-reviewer: Review code
5. @documentation: Update docs
```

### Refactoring Workflow

```
1. @explore: Analyze current code structure
2. @refactoring-specialist: Suggest improvements
3. Plan mode: Review refactoring plan
4. Build mode: Apply refactoring
5. @test-engineer: Ensure tests pass
```

### Bug Fix Workflow

```
1. @explore: Find related code
2. @debugger: Analyze the bug
3. Build mode: Fix the bug
4. @test-engineer: Add regression test
5. @code-reviewer: Review the fix
```

---

*Документация актуальна на январь 2026*
*Источник: https://opencode.ai/docs/agents*
