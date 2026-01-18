# Vibe Coding Machine v1.0

> **Экспериментальная система** для автоматизации разработки с использованием нескольких AI CLI инструментов

⚠️ **Версия 1.0 - Early Access**  
Система находится в активной разработке. Используйте на свой риск.

---

## Что это?

Vibe Coding Machine — это набор конфигураций для 4 AI CLI инструментов, которые работают вместе:

1. **OpenCode** (GLM-4.7, бесплатно) — генерация draft кода
2. **Gemini CLI** — review и улучшение спецификаций
3. **Qwen CLI** — создание draft спецификаций
4. **Kiro CLI** (Claude Sonnet 4.5) — production-ready код

### Workflow

```
Qwen → draft spec → Gemini → review → Kiro → production code
         ↓
    OpenCode → draft code → Gemini → review → Kiro → production
```

---

## Требования

### Обязательно
- **Linux** или **WSL2** (Windows Subsystem for Linux)
- Node.js 18+
- npm или pnpm
- Git

### Опционально (для MCP серверов)
- **UV/UVX** - Python package manager (устанавливается автоматически)
  - Нужен для: code-index, Context7, Ref, pg-aiguide
  - Установка: `curl -LsSf https://astral.sh/uv/install.sh | sh`
- Python 3.10+ (если не используете UV)

---

## Быстрый старт

### 1. Клонируй репозиторий
```bash
git clone https://github.com/yourusername/vibe-coding-machine.git
cd vibe-coding-machine
```

### 2. Запусти установщик
```bash
chmod +x setup-all.sh
./setup-all.sh
```

### 3. Выбери CLI для установки
```
1) Все (Kiro + Gemini + Qwen + OpenCode)
2) Только Kiro
3) Только Gemini
4) Только Qwen
5) Только OpenCode
6) Kiro + Gemini
7) OpenCode + Gemini + Kiro (рекомендуется)
```

### 4. Настрой API ключи
Установщик запросит:
- **Context7 API Key** (опционально) - для документации библиотек
- **Ref API Key** (опционально) - для поиска в документации

Если пропустишь, можно добавить позже в `~/.bashrc`:
```bash
export CONTEXT7_API_KEY="your-key"
export REF_API_KEY="your-key"
```

### 5. Установи UV (если пропустил)
UV нужен для некоторых MCP серверов:
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc
```

---

## Установка CLI инструментов

После установки конфигураций, установи сами CLI:

### OpenCode
```bash
npm i -g opencode-ai
```

### Kiro
```bash
npm i -g @kilocode/cli
```

### Gemini CLI
```bash
npm i -g @google/generative-ai-cli
```

### Qwen CLI
```bash
npm i -g qwen-cli
```

---

## Использование

### OpenCode - Draft код
```bash
cd your-project

# Напиши запрос в файл
echo "Создай компонент NotificationList с real-time updates" > .ai/request.md

# Запусти OpenCode
opencode

# Результат в .ai/draft-code/
```

### Gemini - Review
```bash
# Напиши запрос
echo "Проверь код в .ai/draft-code/ на security и performance" > .ai/request.md

# Запусти Gemini
gemini

# Результат в .ai/review.md
```

### Kiro - Production код
```bash
# Запусти orchestrator
kiro agent orchestrator

# Или конкретного агента
kiro agent backend "Реализуй API из .ai/final-spec.md"
```

---

## Структура проекта

```
vibe-coding-machine/
├── README.md              # Эта документация
├── setup-all.sh           # Установщик
├── LICENSE                # MIT License
├── cli-providers/         # Конфигурации CLI
│   ├── opencode/          # OpenCode конфиги
│   ├── gemini/            # Gemini конфиги
│   ├── qwen/              # Qwen конфиги
│   └── kiro/              # Kiro конфиги
├── scripts/               # Вспомогательные скрипты
│   ├── deploy-to-wsl.sh
│   ├── apply-stable-config.sh
│   └── fix-mcp-servers.sh
├── configs/               # MCP конфигурации
└── docs/                  # Документация
    ├── START-HERE.md      # Начало работы
    └── AGENTS.md          # Правила работы агентов
```

---

## Конфигурации

### OpenCode
- **Агенты:** orchestrator, architect, backend, frontend, coder, debugger, reviewer
- **Субагенты:** project-analyzer, implementation-planner, self-reviewer, и др.
- **Skills:** 40+ навыков для разных стеков
- **MCP:** code-index, Context7, postgres, shadcn, и др.

### Kiro
- **Агенты:** orchestrator, architect, backend, frontend, coder, qa, reviewer, debugger, critic-ci
- **Субагенты:** 16 специализированных субагентов
- **Skills:** 40+ навыков
- **MCP:** 8 стабильных серверов

### Gemini
- **Роль:** Review и улучшение спецификаций
- **Примеры:** reviewer-prompt.md

### Qwen
- **Роль:** Генерация draft спецификаций
- **Примеры:** Fullstack-Developer, Database Architect, API Documenter

---

## Архитектура

### Backend
```
Endpoint → Service → CRUD → Model
```
- Файлы до 300 строк
- FastAPI + SQLAlchemy + PostgreSQL
- Logging вместо print()

### Frontend
```
Page → Component → Hook → API
```
- Файлы до 250 строк
- Next.js 15 + React 19 + TypeScript
- Server Components по умолчанию
- Zustand для state management

---

## Примеры использования

### Создать новую фичу
```bash
# 1. Draft spec (Qwen)
echo "Создай спецификацию для JWT аутентификации" > .ai/request.md
qwen

# 2. Review spec (Gemini)
echo "Проверь spec в .ai/10_qwen_spec.md" > .ai/request.md
gemini

# 3. Реализация (Kiro)
kiro agent orchestrator "Реализуй .ai/20_gemini_spec.md"
```

### Быстрый draft код
```bash
# 1. Draft код (OpenCode)
echo "Создай NotificationList компонент" > .ai/request.md
opencode

# 2. Review (Gemini)
echo "Проверь .ai/draft-code/" > .ai/request.md
gemini

# 3. Финализация (Kiro)
kiro agent frontend "Исправь проблемы из .ai/review.md"
```

---

## Известные проблемы

### v1.0
- ⚠️ Не все MCP серверы стабильны
- ⚠️ OpenCode может генерировать неоптимальный код
- ⚠️ Gemini CLI требует ручной настройки API ключей
- ⚠️ Работает только на Linux/WSL

### Workarounds
- Используйте стабильную MCP конфигурацию (8 серверов)
- Всегда делайте review через Gemini перед production
- Проверяйте сгенерированный код вручную

---

## Roadmap

### v1.1
- [ ] Улучшение стабильности MCP серверов
- [ ] Автоматическая настройка API ключей
- [ ] Больше примеров использования

### v2.0
- [ ] Поддержка macOS
- [ ] Web UI для управления
- [ ] Интеграция с CI/CD

---

## Вклад в проект

Проект находится в активной разработке. Pull requests приветствуются!

### Как помочь
1. Тестируйте и сообщайте о багах
2. Улучшайте документацию
3. Добавляйте новые skills и агентов
4. Делитесь примерами использования

---

## Лицензия

MIT License - см. [LICENSE](LICENSE)

---

## Поддержка

- **Issues:** [GitHub Issues](https://github.com/yourusername/vibe-coding-machine/issues)
- **Документация:** [docs/START-HERE.md](docs/START-HERE.md)

---

## Благодарности

- [OpenCode](https://opencode.ai) - Open source AI coding assistant
- [Kiro](https://kiro.ai) - Claude-powered development tool
- Google Gemini - AI review capabilities
- Qwen - Draft specification generation

---

**⚠️ Disclaimer:** Это экспериментальный проект. Используйте на свой риск. Всегда проверяйте сгенерированный код перед использованием в production.
