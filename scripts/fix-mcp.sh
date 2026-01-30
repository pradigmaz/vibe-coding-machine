#!/bin/bash
################################################################################
# Vibe Coding Machine - MCP Fix Script
# Исправление и настройка MCP серверов
################################################################################

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[✓]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }
log_step()  { echo -e "${BLUE}[→]${NC} $1"; }

KIRO_MCP="$HOME/.kiro/settings/mcp.json"

################################################################################
# Проверка зависимостей MCP
################################################################################

check_mcp_deps() {
    log_step "Проверка зависимостей MCP..."
    
    local missing=0
    
    # Node.js / npx
    if command -v npx &> /dev/null; then
        log_info "npx: $(npx --version 2>/dev/null || echo 'ok')"
    else
        log_error "npx не найден (установите Node.js)"
        missing=1
    fi
    
    # UV/UVX для Python MCP серверов
    if command -v uvx &> /dev/null; then
        log_info "uvx: $(uvx --version 2>/dev/null || echo 'ok')"
    else
        log_warn "uvx не найден (некоторые MCP серверы не будут работать)"
        echo "  Установка: curl -LsSf https://astral.sh/uv/install.sh | sh"
    fi
    
    # Python
    if command -v python3 &> /dev/null; then
        log_info "python3: $(python3 --version)"
    else
        log_warn "python3 не найден"
    fi
    
    return $missing
}

################################################################################
# Тестирование MCP серверов
################################################################################

test_mcp_server() {
    local name=$1
    local cmd=$2
    
    log_step "Тестирование $name..."
    
    # Пробуем запустить с таймаутом
    if timeout 5 $cmd --help &>/dev/null 2>&1; then
        log_info "$name: OK"
        return 0
    else
        log_warn "$name: не отвечает или не установлен"
        return 1
    fi
}

################################################################################
# Создание минимальной конфигурации
################################################################################

create_minimal_config() {
    log_step "Создание минимальной MCP конфигурации..."
    
    mkdir -p "$(dirname "$KIRO_MCP")"
    
    cat > "$KIRO_MCP" << 'EOF'
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
    }
  }
}
EOF
    
    log_info "Минимальная конфигурация создана: $KIRO_MCP"
}

################################################################################
# Создание стабильной конфигурации
################################################################################

create_stable_config() {
    log_step "Создание стабильной MCP конфигурации..."
    
    mkdir -p "$(dirname "$KIRO_MCP")"
    
    cat > "$KIRO_MCP" << 'EOF'
{
  "mcpServers": {
    "Context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"],
      "env": {},
      "disabled": false,
      "autoApprove": ["resolve-library-id"]
    },
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
    "refactor-mcp": {
      "command": "npx",
      "args": ["-y", "@myuon/refactor-mcp"],
      "disabled": false,
      "autoApprove": []
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"],
      "disabled": false,
      "autoApprove": []
    },
    "shadcn": {
      "command": "npx",
      "args": ["shadcn@latest", "mcp"],
      "disabled": false,
      "autoApprove": []
    },
    "pg-aiguide": {
      "url": "https://mcp.tigerdata.com/docs",
      "disabled": false,
      "autoApprove": []
    }
  }
}
EOF
    
    log_info "Стабильная конфигурация создана: $KIRO_MCP"
}

################################################################################
# Создание полной конфигурации с code-index
################################################################################

create_full_config() {
    log_step "Создание полной MCP конфигурации..."
    
    # Запрашиваем путь к проекту для code-index
    local project_path
    read -p "Путь к проекту для code-index (Enter для пропуска): " project_path
    
    mkdir -p "$(dirname "$KIRO_MCP")"
    
    if [ -n "$project_path" ] && [ -d "$project_path" ]; then
        cat > "$KIRO_MCP" << EOF
{
  "mcpServers": {
    "Context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"],
      "env": {},
      "disabled": false,
      "autoApprove": ["resolve-library-id"]
    },
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
    "code-index": {
      "command": "uvx",
      "args": ["--python", "python3.12", "code-index-mcp", "--project-path", "$project_path"],
      "disabled": false,
      "autoApprove": ["get_file_summary", "search_code_advanced", "set_project_path"]
    },
    "refactor-mcp": {
      "command": "npx",
      "args": ["-y", "@myuon/refactor-mcp"],
      "disabled": false,
      "autoApprove": []
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"],
      "disabled": false,
      "autoApprove": []
    },
    "shadcn": {
      "command": "npx",
      "args": ["shadcn@latest", "mcp"],
      "disabled": false,
      "autoApprove": []
    },
    "pg-aiguide": {
      "url": "https://mcp.tigerdata.com/docs",
      "disabled": false,
      "autoApprove": []
    }
  }
}
EOF
    else
        create_stable_config
        return
    fi
    
    log_info "Полная конфигурация создана: $KIRO_MCP"
}

################################################################################
# Main
################################################################################

show_menu() {
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "  Vibe Coding Machine - MCP Fix"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo "  1) Проверить зависимости"
    echo "  2) Создать минимальную конфигурацию (2 сервера)"
    echo "  3) Создать стабильную конфигурацию (7 серверов)"
    echo "  4) Создать полную конфигурацию (с code-index)"
    echo "  5) Показать текущую конфигурацию"
    echo "  0) Выход"
    echo ""
}

main() {
    while true; do
        show_menu
        read -p "Выбор: " choice
        
        case $choice in
            1) check_mcp_deps ;;
            2) create_minimal_config ;;
            3) create_stable_config ;;
            4) create_full_config ;;
            5)
                if [ -f "$KIRO_MCP" ]; then
                    echo ""
                    cat "$KIRO_MCP"
                else
                    log_warn "Конфигурация не найдена: $KIRO_MCP"
                fi
                ;;
            0) exit 0 ;;
            *) log_error "Неверный выбор" ;;
        esac
        
        echo ""
        read -p "Нажмите Enter..." dummy
    done
}

# Если передан аргумент, выполняем без меню
if [ -n "$1" ]; then
    case $1 in
        check) check_mcp_deps ;;
        minimal) create_minimal_config ;;
        stable) create_stable_config ;;
        full) create_full_config ;;
        *) echo "Использование: $0 [check|minimal|stable|full]" ;;
    esac
else
    main
fi
