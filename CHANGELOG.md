# Changelog

Все значимые изменения в проекте документируются в этом файле.

Формат основан на [Keep a Changelog](https://keepachangelog.com/ru/1.0.0/),
и проект следует [Semantic Versioning](https://semver.org/lang/ru/).

## [1.0.0] - 2025-01-18

### Добавлено
- Начальный релиз Vibe Coding Machine
- Конфигурации для 4 AI CLI инструментов:
  - OpenCode (draft код)
  - Gemini CLI (review)
  - Qwen CLI (draft спецификации)
  - Kiro CLI (production код)
- Автоматический установщик `setup-all.sh`
- 40+ skills для разных стеков
- 16 субагентов для специализированных задач
- 8 стабильных MCP серверов
- Документация на русском языке
- Примеры использования

### Архитектура
- Backend: Endpoint → Service → CRUD → Model
- Frontend: Page → Component → Hook → API
- Файлы до 300 строк (backend), 250 строк (frontend)

### Известные проблемы
- Работает только на Linux/WSL
- Не все MCP серверы стабильны
- Требует ручной настройки некоторых API ключей

### Технические детали
- Node.js 18+ required
- Python 3.10+ optional (для MCP)
- UV/UVX optional (для некоторых MCP серверов)

---

## [Unreleased]

### Планируется
- Поддержка macOS
- Улучшение стабильности MCP серверов
- Автоматическая настройка API ключей
- Web UI для управления
- Больше примеров использования
- Интеграция с CI/CD

---

[1.0.0]: https://github.com/yourusername/vibe-coding-machine/releases/tag/v1.0.0
