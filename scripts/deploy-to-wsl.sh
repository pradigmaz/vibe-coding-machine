#!/bin/bash

# Скрипт для развертывания конфигураций CLI инструментов в WSL
# Использование: ./deploy-to-wsl.sh [qwen|gemini|kiro|all]

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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
REPO_DIR="$(dirname "$SCRIPT_DIR")"

deploy_qwen() {
    log_info "Развертывание конфигурации Qwen CLI..."
    
    local SOURCE_DIR="$REPO_DIR/cli-providers/qwen/global"
    local TARGET_DIR="$HOME/.qwen"
    
    if [ ! -d "$SOURCE_DIR" ]; then
        log_error "Директория $SOURCE_DIR не найдена"
        return 1
    fi
    
    mkdir -p "$TARGET_DIR"
    
    [ -d "$SOURCE_DIR/examples" ] && cp -r "$SOURCE_DIR/examples" "$TARGET_DIR/"
    [ -d "$SOURCE_DIR/mcp" ] && cp -r "$SOURCE_DIR/mcp" "$TARGET_DIR/"
    [ -d "$SOURCE_DIR/skills" ] && cp -r "$SOURCE_DIR/skills" "$TARGET_DIR/"
    [ -d "$SOURCE_DIR/subagents" ] && cp -r "$SOURCE_DIR/subagents" "$TARGET_DIR/"
    [ -f "$SOURCE_DIR/QWEN.md" ] && cp "$SOURCE_DIR/QWEN.md" "$TARGET_DIR/"
    [ -f "$SOURCE_DIR/STYLE-GUIDE.md" ] && cp "$SOURCE_DIR/STYLE-GUIDE.md" "$TARGET_DIR/"
    [ -f "$SOURCE_DIR/settings.json" ] && cp "$SOURCE_DIR/settings.json" "$TARGET_DIR/"
    
    log_info "Qwen CLI успешно развернут в $TARGET_DIR"
}

deploy_gemini() {
    log_info "Развертывание конфигурации Gemini CLI..."
    
    local SOURCE_DIR="$REPO_DIR/cli-providers/gemini/global"
    local TARGET_DIR="$HOME/.gemini"
    
    if [ ! -d "$SOURCE_DIR" ]; then
        log_error "Директория $SOURCE_DIR не найдена"
        return 1
    fi
    
    mkdir -p "$TARGET_DIR"
    
    [ -d "$SOURCE_DIR/mcp" ] && cp -r "$SOURCE_DIR/mcp" "$TARGET_DIR/"
    [ -d "$SOURCE_DIR/prompts" ] && cp -r "$SOURCE_DIR/prompts" "$TARGET_DIR/"
    [ -d "$SOURCE_DIR/skills" ] && cp -r "$SOURCE_DIR/skills" "$TARGET_DIR/"
    [ -f "$SOURCE_DIR/settings.json" ] && cp "$SOURCE_DIR/settings.json" "$TARGET_DIR/"
    
    log_info "Gemini CLI успешно развернут в $TARGET_DIR"
}

deploy_kiro() {
    log_info "Развертывание конфигурации Kiro CLI..."
    
    local SOURCE_DIR="$REPO_DIR/cli-providers/kiro/global"
    local TARGET_DIR="$HOME/.kiro"
    
    if [ ! -d "$SOURCE_DIR" ]; then
        log_error "Директория $SOURCE_DIR не найдена"
        return 1
    fi
    
    mkdir -p "$TARGET_DIR"
    
    [ -d "$SOURCE_DIR/agents" ] && cp -r "$SOURCE_DIR/agents" "$TARGET_DIR/"
    [ -d "$SOURCE_DIR/hooks" ] && cp -r "$SOURCE_DIR/hooks" "$TARGET_DIR/"
    [ -d "$SOURCE_DIR/prompts" ] && cp -r "$SOURCE_DIR/prompts" "$TARGET_DIR/"
    [ -d "$SOURCE_DIR/settings" ] && cp -r "$SOURCE_DIR/settings" "$TARGET_DIR/"
    [ -d "$SOURCE_DIR/skills" ] && cp -r "$SOURCE_DIR/skills" "$TARGET_DIR/"
    [ -d "$SOURCE_DIR/steering" ] && cp -r "$SOURCE_DIR/steering" "$TARGET_DIR/"
    [ -d "$SOURCE_DIR/subagents" ] && cp -r "$SOURCE_DIR/subagents" "$TARGET_DIR/"
    
    if [ -f "$REPO_DIR/mcp-working-config.json" ]; then
        log_info "Копирование рабочей MCP конфигурации..."
        cp "$REPO_DIR/mcp-working-config.json" "$TARGET_DIR/settings/mcp-working.json"
        log_warn "Рекомендуется использовать mcp-working.json вместо mcp.json"
        log_warn "cp ~/.kiro/settings/mcp-working.json ~/.kiro/settings/mcp.json"
    fi
    
    log_info "Kiro CLI успешно развернут в $TARGET_DIR"
}

deploy_opencode() {
    log_info "Развертывание конфигурации OpenCode CLI..."
    
    local SOURCE_DIR="$REPO_DIR/cli-providers/opencode/global"
    local TARGET_DIR="$HOME/.config/opencode"
    
    if [ ! -d "$SOURCE_DIR" ]; then
        log_error "Директория $SOURCE_DIR не найдена"
        return 1
    fi
    
    mkdir -p "$TARGET_DIR"
    
    [ -d "$SOURCE_DIR/agents" ] && cp -r "$SOURCE_DIR/agents" "$TARGET_DIR/"
    [ -d "$SOURCE_DIR/skills" ] && cp -r "$SOURCE_DIR/skills" "$TARGET_DIR/"
    [ -f "$SOURCE_DIR/opencode.json" ] && cp "$SOURCE_DIR/opencode.json" "$TARGET_DIR/"
    [ -f "$SOURCE_DIR/AGENTS.md" ] && cp "$SOURCE_DIR/AGENTS.md" "$TARGET_DIR/"
    
    # Запрос API ключей для MCP серверов
    request_opencode_api_keys "$TARGET_DIR"
    
    log_info "OpenCode CLI успешно развернут в $TARGET_DIR"
    
    if ! command -v opencode &> /dev/null; then
        log_warn "OpenCode CLI не установлен"
        log_info "Установите: npm i -g opencode-ai"
    fi
}

request_opencode_api_keys() {
    local CONFIG_FILE="$1/opencode.json"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        return
    fi
    
    log_info "Настройка API ключей для MCP серверов..."
    echo ""
    
    # Context7
    if grep -q "CONTEXT7_API_KEY" "$CONFIG_FILE"; then
        if [ -z "$CONTEXT7_API_KEY" ]; then
            echo -n "Context7 API Key (Enter для пропуска): "
            read -r CONTEXT7_KEY
            if [ -n "$CONTEXT7_KEY" ]; then
                export CONTEXT7_API_KEY="$CONTEXT7_KEY"
                echo "export CONTEXT7_API_KEY=\"$CONTEXT7_KEY\"" >> "$HOME/.bashrc"
                log_info "Context7 API ключ сохранён в ~/.bashrc"
            fi
        else
            log_info "Context7 API ключ уже установлен"
        fi
    fi
    
    # Ref
    if grep -q "REF_API_KEY" "$CONFIG_FILE"; then
        if [ -z "$REF_API_KEY" ]; then
            echo -n "Ref API Key (Enter для пропуска): "
            read -r REF_KEY
            if [ -n "$REF_KEY" ]; then
                export REF_API_KEY="$REF_KEY"
                echo "export REF_API_KEY=\"$REF_KEY\"" >> "$HOME/.bashrc"
                log_info "Ref API ключ сохранён в ~/.bashrc"
            fi
        else
            log_info "Ref API ключ уже установлен"
        fi
    fi
    
    if [ -z "$CONTEXT7_API_KEY" ] && [ -z "$REF_API_KEY" ]; then
        log_warn "API ключи не указаны"
        log_info "Добавьте их позже в ~/.bashrc:"
        echo "  export CONTEXT7_API_KEY=\"your-key\""
        echo "  export REF_API_KEY=\"your-key\""
    fi
    
    echo ""
}

create_backup() {
    local TARGET_DIR=$1
    local BACKUP_DIR="${TARGET_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
    
    if [ -d "$TARGET_DIR" ]; then
        log_warn "Создание бэкапа существующей конфигурации..."
        cp -r "$TARGET_DIR" "$BACKUP_DIR"
        log_info "Бэкап создан: $BACKUP_DIR"
    fi
}

main() {
    local PROVIDER=${1:-all}
    
    log_info "Начало развертывания конфигураций..."
    log_info "Репозиторий: $REPO_DIR"
    
    case $PROVIDER in
        qwen)
            create_backup "$HOME/.qwen"
            deploy_qwen
            ;;
        gemini)
            create_backup "$HOME/.gemini"
            deploy_gemini
            ;;
        kiro)
            create_backup "$HOME/.kiro"
            deploy_kiro
            ;;
        opencode)
            create_backup "$HOME/.config/opencode"
            deploy_opencode
            ;;
        all)
            create_backup "$HOME/.qwen"
            create_backup "$HOME/.gemini"
            create_backup "$HOME/.kiro"
            create_backup "$HOME/.config/opencode"
            
            deploy_qwen
            deploy_gemini
            deploy_kiro
            deploy_opencode
            ;;
        *)
            log_error "Неизвестный провайдер: $PROVIDER"
            echo "Использование: $0 [qwen|gemini|kiro|opencode|all]"
            exit 1
            ;;
    esac
    
    log_info "Развертывание завершено успешно!"
    echo ""
    log_info "Следующие шаги:"
    echo "  1. Проверьте конфигурационные файлы в соответствующих директориях"
    echo "  2. При необходимости настройте API ключи и другие параметры"
    echo "  3. Для Kiro: примените стабильную MCP конфигурацию"
    echo "     ./apply-stable-config.sh"
    echo "  4. Запустите CLI инструмент для проверки"
    echo ""
    log_info "Исправления:"
    echo "  ✓ Горячие клавиши агентов (reviewer: ctrl+shift+r, critic-ci: ctrl+shift+i)"
    echo "  ✓ Стабильная MCP конфигурация (8 работающих серверов)"
}

main "$@"
