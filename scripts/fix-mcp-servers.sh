#!/bin/bash

# Скрипт для диагностики и исправления проблем с MCP серверами

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

check_prerequisites() {
    log_step "Проверка необходимых инструментов..."
    
    local missing_tools=()
    
    if ! command -v node &> /dev/null; then
        missing_tools+=("node")
    else
        log_info "Node.js: $(node --version)"
    fi
    
    if ! command -v npm &> /dev/null; then
        missing_tools+=("npm")
    else
        log_info "npm: $(npm --version)"
    fi
    
    if ! command -v npx &> /dev/null; then
        missing_tools+=("npx")
    else
        log_info "npx: $(npx --version)"
    fi
    
    if ! command -v uv &> /dev/null; then
        log_warn "uv не найден (требуется для uvx команд)"
        log_info "Установка: curl -LsSf https://astral.sh/uv/install.sh | sh"
    else
        log_info "uv: $(uv --version)"
    fi
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        log_error "Отсутствуют необходимые инструменты: ${missing_tools[*]}"
        return 1
    fi
    
    log_info "Все основные инструменты установлены"
}

fix_servers() {
    log_step "Попытка исправления проблемных серверов..."
    
    log_info "Очистка npm кэша..."
    npm cache clean --force 2>/dev/null || true
    
    log_info "Предварительная установка MCP пакетов..."
    
    local packages=(
        "@modelcontextprotocol/server-sequential-thinking"
        "@modelcontextprotocol/server-memory"
        "@myuon/refactor-mcp"
        "@playwright/mcp@0.0.38"
        "@upstash/context7-mcp"
    )
    
    for package in "${packages[@]}"; do
        log_info "Проверка $package..."
        npx -y "$package" --version &> /dev/null || log_warn "Не удалось проверить $package"
    done
}

create_minimal_config() {
    log_step "Создание минимальной рабочей конфигурации..."
    
    local config_file="$HOME/.kiro/settings/mcp-minimal.json"
    
    cat > "$config_file" << 'EOF'
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"],
      "disabled": false,
      "autoApprove": []
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "disabled": false,
      "autoApprove": ["add_observations"]
    },
    "Ref": {
      "url": "https://api.ref.tools/mcp",
      "headers": {
        "x-ref-api-key": "ref-1a3d13f091161ab1232d"
      },
      "disabled": false,
      "autoApprove": ["ref_search_documentation", "ref_read_url"]
    },
    "pg-aiguide": {
      "url": "https://mcp.tigerdata.com/docs",
      "disabled": false,
      "autoApprove": []
    }
  }
}
EOF
    
    log_info "Минимальная конфигурация создана: $config_file"
}

show_recommendations() {
    log_step "Рекомендации по исправлению проблем:"
    echo ""
    echo "1. Для стабильной работы используйте:"
    echo "   ./apply-stable-config.sh"
    echo ""
    echo "2. Для минимальной конфигурации:"
    echo "   cp ~/.kiro/settings/mcp-minimal.json ~/.kiro/settings/mcp.json"
    echo ""
    echo "3. Установите UV для дополнительных серверов:"
    echo "   curl -LsSf https://astral.sh/uv/install.sh | sh"
    echo ""
    echo "4. Запустите с детальными логами:"
    echo "   KIRO_LOG_LEVEL=trace kiro-cli"
}

main() {
    echo "========================================="
    echo "  Диагностика MCP серверов для Kiro"
    echo "========================================="
    echo ""
    
    check_prerequisites || {
        log_error "Установите недостающие инструменты и запустите скрипт снова"
        exit 1
    }
    
    echo ""
    fix_servers
    
    echo ""
    create_minimal_config
    
    echo ""
    show_recommendations
    
    echo ""
    log_info "Диагностика завершена!"
}

main "$@"
