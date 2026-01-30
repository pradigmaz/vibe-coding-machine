#!/bin/bash
################################################################################
# OpenCode Restart Script
# Перезапуск OpenCode с очисткой кэша
################################################################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Автоопределение путей
OPENCODE_DIR="$HOME/.config/opencode"
OPENCODE_BIN=$(command -v opencode 2>/dev/null || echo "$HOME/.opencode/bin/opencode")
LOG_FILE="$OPENCODE_DIR/restart.log"

MCP_CACHE_DIR="$HOME/.cache/opencode-mcp"
SESSIONS_DIR="$OPENCODE_DIR/sessions"

log()         { echo -e "$(date '+%H:%M:%S') $1" | tee -a "$LOG_FILE"; }
log_info()    { log "${GREEN}[✓]${NC} $1"; }
log_warn()    { log "${YELLOW}[!]${NC} $1"; }
log_error()   { log "${RED}[✗]${NC} $1"; }
log_step()    { log "${BLUE}[→]${NC} $1"; }

################################################################################
# Функции
################################################################################

is_running() {
    pgrep -f "opencode" > /dev/null 2>&1
}

stop_opencode() {
    log_step "Остановка OpenCode..."
    
    if ! is_running; then
        log_warn "OpenCode не запущен"
        return 0
    fi
    
    local pids=$(pgrep -f "opencode")
    log_info "Найдено процессов: $(echo $pids | wc -w)"
    
    for pid in $pids; do
        kill "$pid" 2>/dev/null || true
    done
    
    sleep 2
    
    if is_running; then
        log_warn "Force kill..."
        pkill -9 -f "opencode" 2>/dev/null || true
        sleep 1
    fi
    
    is_running && log_error "Не удалось остановить" || log_info "Остановлен"
}

clear_cache() {
    log_step "Очистка кэша..."
    
    local cleared=0
    
    if [ -d "$MCP_CACHE_DIR" ]; then
        rm -rf "$MCP_CACHE_DIR"/* 2>/dev/null && cleared=1
        log_info "MCP кэш очищен"
    fi
    
    if [ -d "$SESSIONS_DIR" ]; then
        rm -rf "$SESSIONS_DIR"/* 2>/dev/null && cleared=1
        log_info "Сессии очищены"
    fi
    
    rm -f /tmp/opencode-* 2>/dev/null && cleared=1
    
    [ $cleared -eq 1 ] && log_info "Кэш очищен" || log_info "Нечего очищать"
}

check_config() {
    log_step "Проверка конфигурации..."
    
    local ok=1
    
    if [ ! -d "$OPENCODE_DIR" ]; then
        log_error "Директория не найдена: $OPENCODE_DIR"
        ok=0
    fi
    
    if [ -f "$OPENCODE_DIR/opencode.json" ]; then
        if python3 -m json.tool "$OPENCODE_DIR/opencode.json" &>/dev/null; then
            log_info "opencode.json: валиден"
        else
            log_error "opencode.json: невалидный JSON"
            ok=0
        fi
    else
        log_error "opencode.json не найден"
        ok=0
    fi
    
    [ -f "$OPENCODE_DIR/AGENTS.md" ] && log_info "AGENTS.md: ok" || log_warn "AGENTS.md не найден"
    
    if [ -d "$OPENCODE_DIR/agents" ]; then
        local count=$(find "$OPENCODE_DIR/agents" -name "*.md" -type f | wc -l)
        log_info "Агенты: $count"
    fi
    
    return $((1 - ok))
}

start_opencode() {
    log_step "Запуск OpenCode..."
    
    if is_running; then
        log_warn "Уже запущен"
        return 1
    fi
    
    if [ ! -x "$OPENCODE_BIN" ] && ! command -v opencode &>/dev/null; then
        log_error "opencode не найден"
        log_info "Установите: npm i -g opencode-ai"
        return 1
    fi
    
    # Выбор директории
    local start_dir="$PWD"
    echo ""
    read -p "Директория [$start_dir]: " input_dir
    [ -n "$input_dir" ] && [ -d "$input_dir" ] && start_dir="$input_dir"
    
    log_info "Запуск в: $start_dir"
    cd "$start_dir"
    
    # Запуск
    if command -v opencode &>/dev/null; then
        opencode
    else
        "$OPENCODE_BIN"
    fi
}

show_status() {
    echo ""
    echo -e "${CYAN}═══ Статус ═══${NC}"
    
    if is_running; then
        log_info "OpenCode: запущен (PID: $(pgrep -f opencode | tr '\n' ' '))"
    else
        log_warn "OpenCode: не запущен"
    fi
    
    # Кэш
    [ -d "$MCP_CACHE_DIR" ] && echo "MCP кэш: $(du -sh "$MCP_CACHE_DIR" 2>/dev/null | cut -f1)"
    [ -d "$SESSIONS_DIR" ] && echo "Сессии: $(find "$SESSIONS_DIR" -type f 2>/dev/null | wc -l) файлов"
    
    # Конфиг
    [ -f "$OPENCODE_DIR/opencode.json" ] && echo "Конфиг: ok" || echo "Конфиг: не найден"
}

################################################################################
# Меню
################################################################################

show_menu() {
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  OpenCode Manager${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "  1) Полный перезапуск (стоп + очистка + старт)"
    echo "  2) Только перезапуск"
    echo "  3) Проверка конфигурации"
    echo "  4) Статус"
    echo "  5) Очистить кэш"
    echo "  6) Остановить"
    echo "  7) Запустить"
    echo "  0) Выход"
    echo ""
}

main() {
    mkdir -p "$OPENCODE_DIR"
    touch "$LOG_FILE"
    
    while true; do
        show_menu
        read -p "Выбор: " choice
        
        case $choice in
            1)
                stop_opencode
                clear_cache
                sleep 1
                start_opencode
                ;;
            2)
                stop_opencode
                sleep 1
                start_opencode
                ;;
            3) check_config ;;
            4) show_status ;;
            5) clear_cache ;;
            6) stop_opencode ;;
            7) start_opencode ;;
            0) exit 0 ;;
            *) log_error "Неверный выбор" ;;
        esac
        
        echo ""
        read -p "Enter..." dummy
    done
}

# Быстрые команды
case "${1:-}" in
    start)   start_opencode ;;
    stop)    stop_opencode ;;
    restart) stop_opencode; sleep 1; start_opencode ;;
    status)  show_status ;;
    clear)   clear_cache ;;
    check)   check_config ;;
    *)       main ;;
esac
