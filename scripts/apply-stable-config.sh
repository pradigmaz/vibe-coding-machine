#!/bin/bash

# Быстрое применение стабильной конфигурации MCP

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$HOME/.kiro/settings/mcp.json"
STABLE_CONFIG="$SCRIPT_DIR/mcp-stable-only.json"

echo "========================================="
echo "  Применение стабильной MCP конфигурации"
echo "========================================="
echo ""

if [ ! -f "$STABLE_CONFIG" ]; then
    log_error "Файл $STABLE_CONFIG не найден"
    exit 1
fi

mkdir -p "$HOME/.kiro/settings"

if [ -f "$CONFIG_FILE" ]; then
    BACKUP_FILE="${CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    log_warn "Создание бэкапа текущей конфигурации..."
    cp "$CONFIG_FILE" "$BACKUP_FILE"
    log_info "Бэкап создан: $BACKUP_FILE"
fi

log_info "Применение стабильной конфигурации..."
cp "$STABLE_CONFIG" "$CONFIG_FILE"

echo ""
log_info "✓ Конфигурация успешно применена!"
echo ""
echo "Включенные серверы (8 стабильных):"
echo "  ✓ sequential-thinking - Последовательное мышление"
echo "  ✓ memory - Память контекста"
echo "  ✓ Ref - Документация и поиск"
echo "  ✓ pg-aiguide - PostgreSQL/TimescaleDB"
echo "  ✓ Context7 - Библиотеки и фреймворки"
echo "  ✓ refactor-mcp - Рефакторинг кода"
echo "  ✓ playwright - Автоматизация браузера"
echo "  ✓ shadcn - UI компоненты"
echo ""
echo "Отключенные серверы (нестабильные):"
echo "  ✗ serena - падает при инициализации"
echo "  ✗ code-index - падает при инициализации"
echo "  ✗ sourcerer - падает при инициализации"
echo "  ✗ context-awesome - падает при инициализации"
echo "  ✗ mcp-compass - падает при инициализации"
echo "  ✗ scaffold - падает при инициализации"
echo ""
log_info "Перезапустите Kiro для применения изменений"
