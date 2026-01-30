#!/bin/bash

################################################################################
# OpenCode Restart Script
# Скрипт для перезапуска OpenCode с очисткой кэша
################################################################################

set -e  # Остановка при ошибках

################################################################################
# Цвета для вывода
################################################################################
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

################################################################################
# Переменные
################################################################################
OPENCODE_DIR="/home/zaikana/.config/opencode"
OPENCODE_BIN="/home/zaikana/.opencode/bin/opencode"
LOG_FILE="$OPENCODE_DIR/restart.log"

# Пути к очищаемым файлам
MCP_CACHE_DIR="$HOME/.cache/opencode-mcp"
SESSIONS_DIR="$OPENCODE_DIR/sessions"
TEMP_PATTERN="/tmp/opencode-*"

################################################################################
# Функция логирования
# Аргументы: $1 - сообщение
################################################################################
log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "[$timestamp] $1" | tee -a "$LOG_FILE"
}

################################################################################
# Функция вывода успешного сообщения
# Аргументы: $1 - сообщение
################################################################################
log_success() {
    log "${GREEN}✓ $1${NC}"
}

################################################################################
# Функция вывода предупреждения
# Аргументы: $1 - сообщение
################################################################################
log_warning() {
    log "${YELLOW}⚠ $1${NC}"
}

################################################################################
# Функция вывода ошибки
# Аргументы: $1 - сообщение
################################################################################
log_error() {
    log "${RED}✗ $1${NC}"
}

################################################################################
# Функция вывода информационного сообщения
# Аргументы: $1 - сообщение
################################################################################
log_info() {
    log "${BLUE}ℹ $1${NC}"
}

################################################################################
# Функция проверки запущен ли OpenCode
# Возвращает: 0 если запущен, 1 если не запущен
################################################################################
is_opencode_running() {
    pgrep -f "opencode" > /dev/null 2>&1
}

################################################################################
# Функция остановки процесса OpenCode
################################################################################
stop_opencode() {
    log_info "Проверка запущенных процессов OpenCode..."

    if ! is_opencode_running; then
        log_warning "OpenCode не запущен"
        return 0
    fi

    local pids=$(pgrep -f "opencode")
    log_info "Найдено запущенных процессов: $(echo $pids | wc -w)"

    # Спрашиваем подтверждение
    read -p "Остановить все процессы OpenCode? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_warning "Отмена остановки процессов"
        return 1
    fi

    # Останавливаем процессы
    for pid in $pids; do
        log_info "Остановка процесса PID $pid..."
        kill "$pid" 2>/dev/null || log_error "Не удалось остановить процесс $pid"
    done

    # Ждем завершения процессов
    sleep 2

    # Проверяем остались ли процессы
    if is_opencode_running; then
        log_warning "Некоторые процессы всё ещё запущены, пробуем force kill..."
        pkill -9 -f "opencode" || true
        sleep 1
    fi

    if ! is_opencode_running; then
        log_success "Все процессы OpenCode остановлены"
    else
        log_error "Не удалось остановить все процессы"
        return 1
    fi
}

################################################################################
# Функция очистки кэша
################################################################################
clear_cache() {
    log_info "Начало очистки кэша..."

    local cleared_any=0

    # Очистка MCP кэша
    if [ -d "$MCP_CACHE_DIR" ]; then
        local mcp_size=$(du -sh "$MCP_CACHE_DIR" 2>/dev/null | cut -f1)
        log_info "MCP кэш найден: $MCP_CACHE_DIR ($mcp_size)"
    else
        log_info "MCP кэш не найден, создаем директорию..."
        mkdir -p "$MCP_CACHE_DIR"
    fi

    # Очистка сессий
    if [ -d "$SESSIONS_DIR" ]; then
        local session_count=$(ls -1 "$SESSIONS_DIR" 2>/dev/null | wc -l)
        if [ "$session_count" -gt 0 ]; then
            log_info "Сессии найдены: $SESSIONS_DIR ($session_count файлов)"
        else
            log_info "Директория сессий пуста"
        fi
    else
        log_info "Директория сессий не найдена, создаем..."
        mkdir -p "$SESSIONS_DIR"
    fi

    # Поиск временных файлов
    local temp_files=$(ls -1 $TEMP_PATTERN 2>/dev/null | wc -l)
    if [ "$temp_files" -gt 0 ]; then
        log_info "Временные файлы найдены: $temp_patterns ($temp_files файлов)"
    else
        log_info "Временные файлы не найдены"
    fi

    # Спрашиваем подтверждение перед очисткой
    echo
    read -p "Очистить весь кэш? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_warning "Отмена очистки кэша"
        return 0
    fi

    # Очистка MCP кэша
    if [ -d "$MCP_CACHE_DIR" ]; then
        log_info "Очистка MCP кэша..."
        rm -rf "$MCP_CACHE_DIR"/*
        if [ $? -eq 0 ]; then
            log_success "MCP кэш очищен"
            cleared_any=1
        else
            log_error "Ошибка при очистке MCP кэша"
        fi
    fi

    # Очистка сессий
    if [ -d "$SESSIONS_DIR" ]; then
        log_info "Очистка сессий..."
        rm -rf "$SESSIONS_DIR"/*
        if [ $? -eq 0 ]; then
            log_success "Сессии очищены"
            cleared_any=1
        else
            log_error "Ошибка при очистке сессий"
        fi
    fi

    # Очистка временных файлов
    if ls $TEMP_PATTERN 1> /dev/null 2>&1; then
        log_info "Очистка временных файлов..."
        rm -f $TEMP_PATTERN
        if [ $? -eq 0 ]; then
            log_success "Временные файлы очищены"
            cleared_any=1
        else
            log_error "Ошибка при очистке временных файлов"
        fi
    fi

    if [ $cleared_any -eq 1 ]; then
        log_success "Кэш успешно очищен"
    else
        log_info "Нечего очищать"
    fi
}

################################################################################
# Функция проверки конфигурации
################################################################################
check_config() {
    log_info "Проверка конфигурации OpenCode..."

    local all_good=1

    # Проверка существования директории конфигурации
    if [ ! -d "$OPENCODE_DIR" ]; then
        log_error "Директория конфигурации не найдена: $OPENCODE_DIR"
        all_good=0
    else
        log_success "Директория конфигурации существует"
    fi

    # Проверка существования opencode.json
    if [ ! -f "$OPENCODE_DIR/opencode.json" ]; then
        log_error "Файл конфигурации не найден: $OPENCODE_DIR/opencode.json"
        all_good=0
    else
        log_success "Файл opencode.json существует"

        # Проверка валидности JSON
        log_info "Проверка валидности JSON..."
        if python3 -m json.tool "$OPENCODE_DIR/opencode.json" > /dev/null 2>&1; then
            log_success "JSON валиден"
        else
            log_error "JSON невалиден"
            all_good=0
        fi
    fi

    # Проверка AGENTS.md
    if [ ! -f "$OPENCODE_DIR/AGENTS.md" ]; then
        log_error "Файл инструкций агентов не найден: $OPENCODE_DIR/AGENTS.md"
        all_good=0
    else
        log_success "Файл AGENTS.md существует"
    fi

    # Проверка директории agents
    if [ ! -d "$OPENCODE_DIR/agents" ]; then
        log_error "Директория агентов не найдена: $OPENCODE_DIR/agents"
        all_good=0
    else
        local agent_count=$(ls -1 "$OPENCODE_DIR/agents"/*.md 2>/dev/null | wc -l)
        log_success "Директория агентов существует ($agent_count файлов)"
    fi

    # Проверка существования исполняемого файла opencode
    if [ ! -f "$OPENCODE_BIN" ]; then
        log_error "Исполняемый файл не найден: $OPENCODE_BIN"
        all_good=0
    else
        log_success "Исполняемый файл существует"
    fi

    if [ $all_good -eq 1 ]; then
        log_success "Конфигурация валидна"
        return 0
    else
        log_error "Обнаружены ошибки в конфигурации"
        return 1
    fi
}

################################################################################
# Функция запуска OpenCode
################################################################################
start_opencode() {
    log_info "Запуск OpenCode..."

    # Проверяем не запущен ли уже OpenCode
    if is_opencode_running; then
        log_warning "OpenCode уже запущен"
        show_status
        return 1
    fi

    # Проверяем конфигурацию перед запуском
    if ! check_config; then
        log_error "Ошибка конфигурации. Запуск отменен."
        read -p "Всё равно запустить? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_warning "Запуск отменен"
            return 1
        fi
    fi

    # Запускаем opencode в фоновом режиме с перенаправлением вывода
    log_info "Запуск: $OPENCODE_BIN"

    # Спрашиваем в какой директории запускать
    local start_dir="/media/zaikana/my_hdd/универ/platforma_maga"
    read -p "Директория для запуска [$start_dir]: " input_dir
    if [ -n "$input_dir" ]; then
        if [ -d "$input_dir" ]; then
            start_dir="$input_dir"
        else
            log_warning "Директория не найдена, используем по умолчанию"
        fi
    fi

    cd "$start_dir" || {
        log_error "Не удалось перейти в директорию: $start_dir"
        return 1
    }

    # Запуск (интерактивный режим)
    log_info "Запуск OpenCode в директории: $start_dir"
    log_info "Для выхода нажмите Ctrl+C"

    # Запускаем opencode интерактивно
    "$OPENCODE_BIN" 2>&1 | tee -a "$LOG_FILE"
}

################################################################################
# Функция показа статуса
################################################################################
show_status() {
    echo
    log_info "=== Статус OpenCode ==="

    # Проверка процесса
    if is_opencode_running; then
        local pids=$(pgrep -f "opencode")
        log_success "OpenCode запущен (PID: $pids)"

        # Вывод информации о процессах
        echo
        log_info "Детали процессов:"
        ps aux | grep -E "PID|$pids" | grep -v grep
    else
        log_warning "OpenCode не запущен"
    fi

    # Проверка кэша
    echo
    log_info "=== Статус кэша ==="

    if [ -d "$MCP_CACHE_DIR" ]; then
        local mcp_size=$(du -sh "$MCP_CACHE_DIR" 2>/dev/null | cut -f1)
        local mcp_files=$(find "$MCP_CACHE_DIR" -type f 2>/dev/null | wc -l)
        log_info "MCP кэш: $mcp_size ($mcp_files файлов)"
    else
        log_info "MCP кэш: не найден"
    fi

    if [ -d "$SESSIONS_DIR" ]; then
        local session_size=$(du -sh "$SESSIONS_DIR" 2>/dev/null | cut -f1)
        local session_files=$(find "$SESSIONS_DIR" -type f 2>/dev/null | wc -l)
        log_info "Сессии: $session_size ($session_files файлов)"
    else
        log_info "Сессии: не найдены"
    fi

    local temp_count=$(ls -1 $TEMP_PATTERN 2>/dev/null | wc -l)
    if [ "$temp_count" -gt 0 ]; then
        log_info "Временные файлы: $temp_count"
    else
        log_info "Временные файлы: не найдены"
    fi

    # Проверка конфигурации
    echo
    log_info "=== Статус конфигурации ==="

    if [ -f "$OPENCODE_DIR/opencode.json" ]; then
        log_success "opencode.json: существует"
    else
        log_error "opencode.json: не найден"
    fi

    if [ -f "$OPENCODE_DIR/AGENTS.md" ]; then
        log_success "AGENTS.md: существует"
    else
        log_error "AGENTS.md: не найден"
    fi

    echo
    log_info "Лог-файл: $LOG_FILE"
}

################################################################################
# Главное меню
################################################################################
show_menu() {
    echo
    echo "═══════════════════════════════════════════════════════════════"
    echo "                 OpenCode Restart Script"
    echo "═══════════════════════════════════════════════════════════════"
    echo
    echo "  1) Полный перезапуск с очисткой кэша"
    echo "  2) Только перезапуск"
    echo "  3) Проверка конфигурации"
    echo "  4) Показать статус"
    echo "  5) Очистить кэш"
    echo "  6) Остановить OpenCode"
    echo "  7) Запустить OpenCode"
    echo "  8) Просмотр лога"
    echo "  0) Выход"
    echo
    echo "═══════════════════════════════════════════════════════════════"
    echo
}

################################################################################
# Главная функция
################################################################################
main() {
    # Инициализация лог-файла
    touch "$LOG_FILE"
    log "=== Запуск скрипта перезапуска OpenCode ==="

    # Меню
    while true; do
        show_menu
        read -p "Выберите опцию: " choice

        case $choice in
            1)
                log_info "Полный перезапуск с очисткой кэша"
                stop_opencode || true
                clear_cache
                sleep 1
                start_opencode
                ;;
            2)
                log_info "Только перезапуск"
                stop_opencode || true
                sleep 1
                start_opencode
                ;;
            3)
                log_info "Проверка конфигурации"
                check_config
                ;;
            4)
                show_status
                ;;
            5)
                log_info "Очистка кэша"
                clear_cache
                ;;
            6)
                log_info "Остановить OpenCode"
                stop_opencode
                ;;
            7)
                log_info "Запустить OpenCode"
                start_opencode
                ;;
            8)
                log_info "Просмотр лога"
                echo
                echo "=== Последние 50 строк лога ==="
                tail -50 "$LOG_FILE"
                ;;
            0)
                log_info "Выход"
                log "=== Завершение работы скрипта ==="
                exit 0
                ;;
            *)
                log_error "Неверный выбор"
                ;;
        esac

        echo
        read -p "Нажмите Enter для продолжения..." dummy
    done
}

################################################################################
# Точка входа
################################################################################
main "$@"
