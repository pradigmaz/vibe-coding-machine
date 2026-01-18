#!/bin/bash

# Добавляет frontmatter в SKILL.md файлы для OpenCode

set -e

SKILLS_DIR="cli-providers/opencode/global/skills"

if [ ! -d "$SKILLS_DIR" ]; then
    echo "Error: $SKILLS_DIR not found"
    exit 1
fi

count=0

for skill_dir in "$SKILLS_DIR"/*; do
    if [ ! -d "$skill_dir" ]; then
        continue
    fi
    
    skill_file="$skill_dir/SKILL.md"
    
    if [ ! -f "$skill_file" ]; then
        continue
    fi
    
    # Проверяем, есть ли уже frontmatter
    if head -n 1 "$skill_file" | grep -q "^---$"; then
        echo "Skip: $(basename "$skill_dir") - already has frontmatter"
        continue
    fi
    
    skill_name=$(basename "$skill_dir")
    
    # Извлекаем первую строку после заголовка как description
    description=$(grep -m 1 "^## Назначение" "$skill_file" -A 1 | tail -n 1 | sed 's/^[[:space:]]*//')
    
    if [ -z "$description" ]; then
        # Если нет "Назначение", берём первый параграф
        description=$(grep -v "^#" "$skill_file" | grep -v "^$" | head -n 1 | sed 's/^[[:space:]]*//')
    fi
    
    # Ограничиваем длину description до 200 символов
    if [ ${#description} -gt 200 ]; then
        description="${description:0:197}..."
    fi
    
    # Создаём временный файл с frontmatter
    temp_file=$(mktemp)
    
    echo "---" > "$temp_file"
    echo "name: $skill_name" >> "$temp_file"
    echo "description: $description" >> "$temp_file"
    echo "---" >> "$temp_file"
    echo "" >> "$temp_file"
    cat "$skill_file" >> "$temp_file"
    
    # Заменяем оригинальный файл
    mv "$temp_file" "$skill_file"
    
    echo "Fixed: $skill_name"
    ((count++))
done

echo ""
echo "Fixed $count SKILL.md files"
