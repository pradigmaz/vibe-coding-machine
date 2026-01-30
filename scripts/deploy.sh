#!/bin/bash
################################################################################
# Vibe Coding Machine - Deploy Script
# Развертывание конфигураций CLI провайдеров
################################################################################

set -e

# Цвета
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
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

################################################################################
# Функции развертывания
################################################################################

deploy_opencode() {
    log_step "Развертывание OpenCode..."
    
    local src="$ROOT_DIR/cli-providers/opencode/global"
    local dest="$HOME/.config/opencode"
    
    mkdir -p "$dest"
    
    # Копируем основные файлы
    cp -f "$src/opencode.json" "$dest/" 2>/dev/null || true
    cp -f "$src/AGENTS.md" "$dest/" 2>/dev/null || true
    cp -f "$src/CODING_RULES.md" "$dest/" 2>/dev/null || true
    cp -f "$src/SUBAGENT_RULES.md" "$dest/" 2>/dev/null || true
    
    # Копируем директории
    for dir in agents skills docs contexts command plugin; do
        if [ -d "$src/$dir" ]; then
            rm -rf "$dest/$dir"
            cp -r "$src/$dir" "$dest/"
            log_info "  $dir/"
        fi
    done
    
    log_info "OpenCode развернут в $dest"
}

deploy_kiro() {
    log_step "Развертывание Kiro..."
    
    local src="$ROOT_DIR/cli-providers/kiro/global"
    local dest="$HOME/.kiro"
    
    mkdir -p "$dest/settings"
    mkdir -p "$dest/prompts"
    mkdir -p "$dest/agents"
    mkdir -p "$dest/skills"
    mkdir -p "$dest/docs"
    
    # Копируем settings
    if [ -d "$src/settings" ]; then
        cp -f "$src/settings/"*.json "$dest/settings/" 2>/dev/null || true
        log_info "  settings/"
    fi
    
    # Копируем директории
    for dir in agents prompts skills docs; do
        if [ -d "$src/$dir" ]; then
            rm -rf "$dest/$dir"
            cp -r "$src/$dir" "$dest/"
            log_info "  $dir/ ($(find "$src/$dir" -type f | wc -l) файлов)"
        fi
    done
    
    # Копируем AGENTS.md
    cp -f "$src/AGENTS.md" "$dest/" 2>/dev/null || true
    
    log_info "Kiro развернут в $dest"
}

################################################################################
# Подсчет файлов
################################################################################

count_files() {
    local provider=$1
    local base_dir
    
    case $provider in
        opencode) base_dir="$HOME/.config/opencode" ;;
        kiro) base_dir="$HOME/.kiro" ;;
        *) return ;;
    esac
    
    if [ -d "$base_dir" ]; then
        local agents=$(find "$base_dir/agents" -type f -name "*.json" 2>/dev/null | wc -l)
        local prompts=$(find "$base_dir/prompts" -type f -name "*.md" 2>/dev/null | wc -l)
        local skills=$(find "$base_dir/skills" -type d -mindepth 1 -maxdepth 1 2>/dev/null | wc -l)
        echo "  Агенты: $agents, Промпты: $prompts, Навыки: $skills"
    fi
}

################################################################################
# Main
################################################################################

show_usage() {
    echo "Использование: $0 [provider]"
    echo ""
    echo "Провайдеры:"
    echo "  all       - Все провайдеры"
    echo "  opencode  - Только OpenCode"
    echo "  kiro      - Только Kiro"
    echo ""
}

main() {
    local provider="${1:-all}"
    
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  Vibe Coding Machine - Deploy${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    case $provider in
        all)
            deploy_opencode
            count_files opencode
            echo ""
            deploy_kiro
            count_files kiro
            ;;
        opencode)
            deploy_opencode
            count_files opencode
            ;;
        kiro)
            deploy_kiro
            count_files kiro
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            log_error "Неизвестный провайдер: $provider"
            show_usage
            exit 1
            ;;
    esac
    
    echo ""
    log_info "Развертывание завершено!"
}

main "$@"
