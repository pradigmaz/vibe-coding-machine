#!/bin/bash
################################################################################
# Vibe Coding Machine - Status Script
# Проверка статуса установки и конфигураций
################################################################################

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[✓]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }

################################################################################
# Проверка CLI инструментов
################################################################################

check_cli_tools() {
    echo -e "${CYAN}═══ CLI Инструменты ═══${NC}"
    echo ""
    
    # OpenCode
    if command -v opencode &> /dev/null; then
        log_info "opencode: $(opencode --version 2>/dev/null || echo 'установлен')"
    else
        log_warn "opencode: не установлен (npm i -g opencode-ai)"
    fi
    
    # Kiro
    if command -v kiro &> /dev/null; then
        log_info "kiro: $(kiro --version 2>/dev/null || echo 'установлен')"
    elif command -v kiro-cli &> /dev/null; then
        log_info "kiro-cli: $(kiro-cli --version 2>/dev/null || echo 'установлен')"
    else
        log_warn "kiro: не установлен (npm i -g @kilocode/cli)"
    fi
    
    echo ""
}

################################################################################
# Проверка конфигураций
################################################################################

check_configs() {
    echo -e "${CYAN}═══ Конфигурации ═══${NC}"
    echo ""
    
    # OpenCode
    local oc_dir="$HOME/.config/opencode"
    if [ -d "$oc_dir" ]; then
        log_info "OpenCode: $oc_dir"
        
        # Подсчет файлов
        local agents=$(find "$oc_dir/agents" -name "*.md" -type f 2>/dev/null | wc -l)
        local skills=$(find "$oc_dir/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
        
        echo "    Агенты: $agents"
        echo "    Навыки: $skills"
        
        # Проверка opencode.json
        if [ -f "$oc_dir/opencode.json" ]; then
            if python3 -m json.tool "$oc_dir/opencode.json" &>/dev/null; then
                echo "    opencode.json: ${GREEN}валиден${NC}"
            else
                echo "    opencode.json: ${RED}невалидный JSON${NC}"
            fi
        else
            echo "    opencode.json: ${YELLOW}не найден${NC}"
        fi
    else
        log_warn "OpenCode: не установлен"
    fi
    
    echo ""
    
    # Kiro
    local kiro_dir="$HOME/.kiro"
    if [ -d "$kiro_dir" ]; then
        log_info "Kiro: $kiro_dir"
        
        # Подсчет файлов
        local agents=$(find "$kiro_dir/agents" -name "*.json" -type f 2>/dev/null | wc -l)
        local prompts=$(find "$kiro_dir/prompts" -name "*.md" -type f 2>/dev/null | wc -l)
        local skills=$(find "$kiro_dir/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
        
        echo "    Агенты (json): $agents"
        echo "    Промпты (md): $prompts"
        echo "    Навыки: $skills"
        
        # Проверка mcp.json
        if [ -f "$kiro_dir/settings/mcp.json" ]; then
            if python3 -m json.tool "$kiro_dir/settings/mcp.json" &>/dev/null; then
                local servers=$(python3 -c "import json; print(len(json.load(open('$kiro_dir/settings/mcp.json')).get('mcpServers', {})))" 2>/dev/null || echo "?")
                echo "    mcp.json: ${GREEN}валиден${NC} ($servers серверов)"
            else
                echo "    mcp.json: ${RED}невалидный JSON${NC}"
            fi
        else
            echo "    mcp.json: ${YELLOW}не найден${NC}"
        fi
    else
        log_warn "Kiro: не установлен"
    fi
    
    echo ""
}

################################################################################
# Проверка зависимостей
################################################################################

check_deps() {
    echo -e "${CYAN}═══ Зависимости ═══${NC}"
    echo ""
    
    # Node.js
    if command -v node &> /dev/null; then
        log_info "node: $(node --version)"
    else
        log_error "node: не установлен"
    fi
    
    # npm
    if command -v npm &> /dev/null; then
        log_info "npm: $(npm --version)"
    else
        log_error "npm: не установлен"
    fi
    
    # UV/UVX
    if command -v uv &> /dev/null; then
        log_info "uv: $(uv --version 2>/dev/null || echo 'установлен')"
    else
        log_warn "uv: не установлен (опционально)"
    fi
    
    if command -v uvx &> /dev/null; then
        log_info "uvx: установлен"
    else
        log_warn "uvx: не установлен (опционально)"
    fi
    
    # Python
    if command -v python3 &> /dev/null; then
        log_info "python3: $(python3 --version 2>&1 | head -1)"
    else
        log_warn "python3: не установлен"
    fi
    
    # Git
    if command -v git &> /dev/null; then
        log_info "git: $(git --version | cut -d' ' -f3)"
    else
        log_error "git: не установлен"
    fi
    
    echo ""
}

################################################################################
# Структура агентов
################################################################################

show_agent_structure() {
    echo -e "${CYAN}═══ Структура агентов ═══${NC}"
    echo ""
    
    local oc_agents="$HOME/.config/opencode/agents"
    local kiro_agents="$HOME/.kiro/agents"
    
    if [ -d "$oc_agents" ]; then
        echo "OpenCode агенты:"
        for category in "$oc_agents"/*/; do
            if [ -d "$category" ]; then
                local name=$(basename "$category")
                local count=$(find "$category" -name "*.md" -type f 2>/dev/null | wc -l)
                [ "$count" -gt 0 ] && echo "  $name/: $count"
            fi
        done
        echo ""
    fi
    
    if [ -d "$kiro_agents" ]; then
        echo "Kiro агенты:"
        # JSON файлы в корне
        local root_count=$(find "$kiro_agents" -maxdepth 1 -name "*.json" -type f 2>/dev/null | wc -l)
        echo "  (корень): $root_count json"
        
        # Категории с md файлами
        for category in "$kiro_agents"/*/; do
            if [ -d "$category" ]; then
                local name=$(basename "$category")
                local count=$(find "$category" -name "*.md" -type f 2>/dev/null | wc -l)
                [ "$count" -gt 0 ] && echo "  $name/: $count md"
            fi
        done
        echo ""
    fi
}

################################################################################
# Main
################################################################################

main() {
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  Vibe Coding Machine - Status${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    check_deps
    check_cli_tools
    check_configs
    
    if [ "$1" = "-v" ] || [ "$1" = "--verbose" ]; then
        show_agent_structure
    fi
}

main "$@"
