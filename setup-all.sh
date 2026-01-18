#!/bin/bash

# Полная автоматическая установка и настройка всех CLI провайдеров
# Использование: ./setup-all.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[→]${NC} $1"
}

log_header() {
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}=========================================${NC}"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Проверка зависимостей
check_dependencies() {
    log_header "Проверка зависимостей"
    
    local missing=0
    
    if ! command -v node &> /dev/null; then
        log_error "Node.js не установлен"
        missing=1
    else
        log_info "Node.js: $(node --version)"
    fi
    
    if ! command -v npm &> /dev/null; then
        log_error "npm не установлен"
        missing=1
    else
        log_info "npm: $(npm --version)"
    fi
    
    if ! command -v git &> /dev/null; then
        log_error "git не установлен"
        missing=1
    else
        log_info "git: $(git --version)"
    fi
    
    if ! command -v uv &> /dev/null; then
        log_warn "uv не установлен (опционально, нужен для некоторых MCP серверов)"
        echo ""
        read -p "Установить UV/UVX? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_step "Установка UV..."
            curl -LsSf https://astral.sh/uv/install.sh | sh
            
            # Добавляем в PATH для текущей сессии
            export PATH="$HOME/.cargo/bin:$PATH"
            
            # Добавляем в shell profile для будущих сессий
            if [ -f "$HOME/.bashrc" ]; then
                echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$HOME/.bashrc"
            fi
            if [ -f "$HOME/.zshrc" ]; then
                echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$HOME/.zshrc"
            fi
            
            # Проверяем установку
            if command -v uv &> /dev/null; then
                log_info "UV установлен: $(uv --version)"
            else
                log_error "UV установлен, но не найден в PATH. Перезапустите терминал."
                log_info "Или выполните: source ~/.bashrc"
            fi
        else
            log_warn "UV не установлен. Некоторые MCP серверы не будут работать."
            log_info "Можно установить позже: curl -LsSf https://astral.sh/uv/install.sh | sh"
        fi
    else
        log_info "uv: $(uv --version)"
    fi
    
    if [ $missing -eq 1 ]; then
        log_error "Установите недостающие зависимости и запустите скрипт снова"
        exit 1
    fi
    
    echo ""
}

# Подготовка скриптов
prepare_scripts() {
    log_header "Подготовка скриптов"
    
    log_step "Делаем скрипты исполняемыми..."
    chmod +x "$SCRIPT_DIR/scripts/deploy-to-wsl.sh"
    chmod +x "$SCRIPT_DIR/scripts/apply-stable-config.sh"
    chmod +x "$SCRIPT_DIR/scripts/fix-mcp-servers.sh"
    
    log_info "Скрипты готовы"
    echo ""
}

# Развертывание конфигураций
deploy_configs() {
    log_header "Развертывание конфигураций"
    
    echo ""
    echo "Выберите провайдеры для развертывания:"
    echo "  1) Все (Kiro + Gemini + Qwen + OpenCode)"
    echo "  2) Только Kiro"
    echo "  3) Только Gemini"
    echo "  4) Только Qwen"
    echo "  5) Только OpenCode"
    echo "  6) Kiro + Gemini"
    echo "  7) OpenCode + Gemini + Kiro (рекомендуется для vibe coding)"
    echo ""
    read -p "Ваш выбор (1-7): " choice
    
    case $choice in
        1)
            log_step "Развертывание всех провайдеров..."
            "$SCRIPT_DIR/scripts/deploy-to-wsl.sh" all
            ;;
        2)
            log_step "Развертывание Kiro..."
            "$SCRIPT_DIR/scripts/deploy-to-wsl.sh" kiro
            ;;
        3)
            log_step "Развертывание Gemini..."
            "$SCRIPT_DIR/scripts/deploy-to-wsl.sh" gemini
            ;;
        4)
            log_step "Развертывание Qwen..."
            "$SCRIPT_DIR/scripts/deploy-to-wsl.sh" qwen
            ;;
        5)
            log_step "Развертывание OpenCode..."
            "$SCRIPT_DIR/scripts/deploy-to-wsl.sh" opencode
            ;;
        6)
            log_step "Развертывание Kiro и Gemini..."
            "$SCRIPT_DIR/scripts/deploy-to-wsl.sh" kiro
            "$SCRIPT_DIR/scripts/deploy-to-wsl.sh" gemini
            ;;
        7)
            log_step "Развертывание OpenCode, Gemini и Kiro..."
            "$SCRIPT_DIR/scripts/deploy-to-wsl.sh" opencode
            "$SCRIPT_DIR/scripts/deploy-to-wsl.sh" gemini
            "$SCRIPT_DIR/scripts/deploy-to-wsl.sh" kiro
            ;;
        *)
            log_error "Неверный выбор"
            exit 1
            ;;
    esac
    
    log_info "Развертывание завершено"
    echo ""
}

# Запрос API ключей
request_api_keys() {
    log_header "Настройка API ключей"
    
    echo ""
    echo "Некоторые MCP серверы требуют API ключи:"
    echo ""
    
    # Context7
    echo -n "Context7 API Key (Enter для пропуска): "
    read -r CONTEXT7_KEY
    
    # Ref
    echo -n "Ref API Key (Enter для пропуска): "
    read -r REF_KEY
    
    # Сохраняем в переменные окружения
    if [ -n "$CONTEXT7_KEY" ]; then
        export CONTEXT7_API_KEY="$CONTEXT7_KEY"
        echo "export CONTEXT7_API_KEY=\"$CONTEXT7_KEY\"" >> "$HOME/.bashrc"
        log_info "Context7 API ключ сохранён"
    fi
    
    if [ -n "$REF_KEY" ]; then
        export REF_API_KEY="$REF_KEY"
        echo "export REF_API_KEY=\"$REF_KEY\"" >> "$HOME/.bashrc"
        log_info "Ref API ключ сохранён"
    fi
    
    if [ -z "$CONTEXT7_KEY" ] && [ -z "$REF_KEY" ]; then
        log_warn "API ключи не указаны, некоторые MCP серверы не будут работать"
        log_info "Добавьте их позже в ~/.bashrc или ~/.zshrc:"
        echo "  export CONTEXT7_API_KEY=\"your-key\""
        echo "  export REF_API_KEY=\"your-key\""
    fi
    
    echo ""
}

# Настройка MCP для Kiro
setup_mcp() {
    log_header "Настройка MCP серверов (Kiro)"
    
    if [ ! -d "$HOME/.kiro" ]; then
        log_warn "Kiro не развернут, пропускаем настройку MCP"
        return
    fi
    
    echo ""
    echo "Выберите конфигурацию MCP:"
    echo "  1) Стабильная (8 серверов, рекомендуется)"
    echo "  2) Расширенная (все серверы, могут быть проблемы)"
    echo "  3) Минимальная (4 сервера, только самые надежные)"
    echo "  4) Пропустить"
    echo ""
    read -p "Ваш выбор (1-4): " mcp_choice
    
    case $mcp_choice in
        1)
            log_step "Применение стабильной конфигурации..."
            "$SCRIPT_DIR/scripts/apply-stable-config.sh"
            ;;
        2)
            log_step "Применение расширенной конфигурации..."
            cp "$SCRIPT_DIR/configs/mcp-working-config.json" "$HOME/.kiro/settings/mcp.json"
            log_info "Расширенная конфигурация применена"
            ;;
        3)
            log_step "Создание минимальной конфигурации..."
            "$SCRIPT_DIR/scripts/fix-mcp-servers.sh"
            cp "$HOME/.kiro/settings/mcp-minimal.json" "$HOME/.kiro/settings/mcp.json"
            log_info "Минимальная конфигурация применена"
            ;;
        4)
            log_warn "Настройка MCP пропущена"
            ;;
        *)
            log_error "Неверный выбор, используем стабильную конфигурацию"
            "$SCRIPT_DIR/scripts/apply-stable-config.sh"
            ;;
    esac
    
    echo ""
}

# Проверка установки
verify_installation() {
    log_header "Проверка установки"
    
    # Проверка OpenCode
    if [ -d "$HOME/.config/opencode" ]; then
        log_info "OpenCode: установлен в ~/.config/opencode"
        echo "  - Агенты: $(ls -1 ~/.config/opencode/agents/ 2>/dev/null | wc -l)"
        echo "  - Навыки: $(ls -1d ~/.config/opencode/skills/*/ 2>/dev/null | wc -l)"
        if command -v opencode &> /dev/null; then
            echo "  - CLI: $(opencode --version 2>/dev/null || echo 'не установлен')"
        else
            log_warn "  - CLI не установлен (установите: npm i -g opencode-ai)"
        fi
    else
        log_warn "OpenCode: не установлен"
    fi
    
    # Проверка Kiro
    if [ -d "$HOME/.kiro" ]; then
        log_info "Kiro: установлен в ~/.kiro"
        echo "  - Агенты: $(ls -1 ~/.kiro/agents/ 2>/dev/null | wc -l)"
        echo "  - Навыки: $(ls -1d ~/.kiro/skills/*/ 2>/dev/null | wc -l)"
        echo "  - Субагенты: $(ls -1 ~/.kiro/subagents/ 2>/dev/null | wc -l)"
    else
        log_warn "Kiro: не установлен"
    fi
    
    # Проверка Gemini
    if [ -d "$HOME/.gemini" ]; then
        log_info "Gemini: установлен в ~/.gemini"
        echo "  - Навыки: $(ls -1d ~/.gemini/skills/*/ 2>/dev/null | wc -l)"
    else
        log_warn "Gemini: не установлен"
    fi
    
    # Проверка Qwen
    if [ -d "$HOME/.qwen" ]; then
        log_info "Qwen: установлен в ~/.qwen"
        echo "  - Агенты: $(ls -1 ~/.qwen/agents/ 2>/dev/null | wc -l)"
        echo "  - Навыки: $(ls -1d ~/.qwen/skills/*/ 2>/dev/null | wc -l)"
    else
        log_warn "Qwen: не установлен"
    fi
    
    echo ""
}

# Показать следующие шаги
show_next_steps() {
    log_header "Следующие шаги"
    
    echo ""
    echo "1. Запустите CLI инструмент:"
    if [ -d "$HOME/.config/opencode" ]; then
        echo "   ${GREEN}opencode${NC} - Draft код (GLM-4.7 бесплатно)"
    fi
    if [ -d "$HOME/.gemini" ]; then
        echo "   ${GREEN}gemini-cli${NC} - Review кода"
    fi
    if [ -d "$HOME/.kiro" ]; then
        echo "   ${GREEN}kiro-cli${NC} - Production код"
    fi
    if [ -d "$HOME/.qwen" ]; then
        echo "   ${GREEN}qwen-cli${NC} - Draft спеки"
    fi
    
    echo ""
    echo "2. Vibe Coding Workflow:"
    echo "   ${CYAN}opencode${NC} → генерация draft кода в .ai/draft-code/"
    echo "   ${CYAN}gemini-cli${NC} → review кода из .ai/draft-code/"
    echo "   ${CYAN}kiro-cli${NC} → финализация в production"
    
    echo ""
    echo "3. OpenCode субагенты:"
    echo "   ${CYAN}@project-analyzer${NC} - анализ проекта"
    echo "   ${CYAN}@implementation-planner${NC} - план реализации"
    echo "   ${CYAN}@self-reviewer${NC} - проверка кода"
    
    echo ""
    echo "4. Проверьте горячие клавиши (Kiro):"
    echo "   - Code Review: ${CYAN}ctrl+shift+r${NC}"
    echo "   - CI/CD проверки: ${CYAN}ctrl+shift+i${NC}"
    
    echo ""
    echo "5. Изучите документацию:"
    echo "   - ${BLUE}docs/START-HERE.md${NC} - Начало работы"
    echo "   - ${BLUE}docs/AGENTS.md${NC} - Правила работы агентов"
    
    echo ""
    echo "6. Настройте API ключи (если нужно):"
    echo "   - Context7: ~/.kiro/settings/mcp.json"
    echo "   - Ref: ~/.kiro/settings/mcp.json"
    
    echo ""
    echo "7. При проблемах с MCP:"
    echo "   ${YELLOW}./scripts/fix-mcp-servers.sh${NC}"
    echo "   ${YELLOW}KIRO_LOG_LEVEL=trace kiro-cli${NC}"
    
    echo ""
    log_info "Установка завершена успешно!"
}

# Основная функция
main() {
    clear
    log_header "Vibe Coding Machine - Автоматическая установка"
    echo ""
    
    check_dependencies
    prepare_scripts
    request_api_keys
    deploy_configs
    setup_mcp
    verify_installation
    show_next_steps
}

main "$@"
