#!/bin/bash
################################################################################
# Vibe Coding Machine v1.0 - Setup Script
# Автоматическая установка и настройка CLI провайдеров
################################################################################

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[✓]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }
log_step()  { echo -e "${BLUE}[→]${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

################################################################################
# Проверка зависимостей
################################################################################

check_dependencies() {
    echo -e "${CYAN}═══ Проверка зависимостей ═══${NC}"
    echo ""
    
    local missing=0
    
    # Node.js
    if command -v node &> /dev/null; then
        log_info "Node.js: $(node --version)"
    else
        log_error "Node.js не установлен"
        missing=1
    fi
    
    # npm
    if command -v npm &> /dev/null; then
        log_info "npm: $(npm --version)"
    else
        log_error "npm не установлен"
        missing=1
    fi
    
    # Git
    if command -v git &> /dev/null; then
        log_info "git: $(git --version | cut -d' ' -f3)"
    else
        log_error "git не установлен"
        missing=1
    fi
    
    # UV/UVX (опционально)
    if command -v uv &> /dev/null; then
        log_info "uv: $(uv --version 2>/dev/null || echo 'ok')"
    else
        log_warn "uv не установлен (опционально, для MCP серверов)"
        echo ""
        read -p "Установить UV/UVX? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_step "Установка UV..."
            curl -LsSf https://astral.sh/uv/install.sh | sh
            export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
            
            # Добавляем в shell profile
            for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
                [ -f "$rc" ] && grep -q 'cargo/bin' "$rc" || echo 'export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"' >> "$rc"
            done
            
            if command -v uv &> /dev/null; then
                log_info "UV установлен"
            else
                log_warn "UV установлен, перезапустите терминал"
            fi
        fi
    fi
    
    echo ""
    
    if [ $missing -eq 1 ]; then
        log_error "Установите недостающие зависимости"
        exit 1
    fi
}

################################################################################
# Развертывание конфигураций
################################################################################

deploy_opencode() {
    "$SCRIPT_DIR/scripts/deploy.sh" opencode
}

deploy_kiro() {
    "$SCRIPT_DIR/scripts/deploy.sh" kiro
}

################################################################################
# Выбор провайдеров
################################################################################

select_providers() {
    echo -e "${CYAN}═══ Выбор провайдеров ═══${NC}"
    echo ""
    echo "  1) Все (OpenCode + Kiro)"
    echo "  2) Только OpenCode"
    echo "  3) Только Kiro"
    echo ""
    read -p "Выбор (1-3): " choice
    
    case $choice in
        1)
            deploy_opencode
            deploy_kiro
            ;;
        2)
            deploy_opencode
            ;;
        3)
            deploy_kiro
            ;;
        *)
            log_error "Неверный выбор"
            exit 1
            ;;
    esac
    
    echo ""
}

################################################################################
# Настройка MCP
################################################################################

setup_mcp() {
    if [ ! -d "$HOME/.kiro" ]; then
        return
    fi
    
    echo -e "${CYAN}═══ Настройка MCP (Kiro) ═══${NC}"
    echo ""
    echo "  1) Стабильная (7 серверов, рекомендуется)"
    echo "  2) Минимальная (2 сервера)"
    echo "  3) Полная (с code-index)"
    echo "  4) Пропустить"
    echo ""
    read -p "Выбор (1-4): " mcp_choice
    
    case $mcp_choice in
        1) "$SCRIPT_DIR/scripts/fix-mcp.sh" stable ;;
        2) "$SCRIPT_DIR/scripts/fix-mcp.sh" minimal ;;
        3) "$SCRIPT_DIR/scripts/fix-mcp.sh" full ;;
        4) log_warn "MCP настройка пропущена" ;;
        *) "$SCRIPT_DIR/scripts/fix-mcp.sh" stable ;;
    esac
    
    echo ""
}

################################################################################
# Финальная проверка
################################################################################

final_check() {
    echo -e "${CYAN}═══ Проверка установки ═══${NC}"
    echo ""
    
    "$SCRIPT_DIR/scripts/status.sh" 2>/dev/null || {
        # Fallback если status.sh не работает
        [ -d "$HOME/.config/opencode" ] && log_info "OpenCode: установлен"
        [ -d "$HOME/.kiro" ] && log_info "Kiro: установлен"
    }
}

################################################################################
# Следующие шаги
################################################################################

show_next_steps() {
    echo -e "${CYAN}═══ Следующие шаги ═══${NC}"
    echo ""
    
    echo "1. Установите CLI (если еще не установлены):"
    echo "   ${GREEN}npm i -g opencode-ai${NC}"
    echo "   ${GREEN}npm i -g @kilocode/cli${NC}"
    echo ""
    
    echo "2. Запустите:"
    [ -d "$HOME/.config/opencode" ] && echo "   ${CYAN}opencode${NC} - Draft код"
    [ -d "$HOME/.kiro" ] && echo "   ${CYAN}kiro${NC} - Production код"
    echo ""
    
    echo "3. При проблемах с MCP:"
    echo "   ${YELLOW}./scripts/fix-mcp.sh${NC}"
    echo ""
    
    echo "4. Проверка статуса:"
    echo "   ${YELLOW}./scripts/status.sh -v${NC}"
    echo ""
    
    log_info "Установка завершена!"
}

################################################################################
# Main
################################################################################

main() {
    clear
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  Vibe Coding Machine v1.0 - Setup${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Делаем скрипты исполняемыми
    chmod +x "$SCRIPT_DIR/scripts/"*.sh 2>/dev/null || true
    
    check_dependencies
    select_providers
    setup_mcp
    final_check
    show_next_steps
}

main "$@"
