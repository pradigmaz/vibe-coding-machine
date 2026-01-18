$skillsDir = "cli-providers/opencode/global/skills"
$count = 0

Get-ChildItem -Path $skillsDir -Directory | ForEach-Object {
    $skillFile = Join-Path $_.FullName "SKILL.md"
    
    if (Test-Path $skillFile) {
        $content = Get-Content $skillFile -Raw
        
        # Проверяем frontmatter
        if ($content -match "^---\r?\n") {
            Write-Host "Skip: $($_.Name) - already has frontmatter"
            return
        }
        
        $skillName = $_.Name
        
        # Извлекаем description
        $lines = Get-Content $skillFile
        $description = ""
        
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match "^## Назначение") {
                if ($i + 1 -lt $lines.Count) {
                    $description = $lines[$i + 1].Trim()
                    break
                }
            }
        }
        
        if ([string]::IsNullOrWhiteSpace($description)) {
            # Берём первую непустую строку без заголовка
            foreach ($line in $lines) {
                if ($line -notmatch "^#" -and ![string]::IsNullOrWhiteSpace($line)) {
                    $description = $line.Trim()
                    break
                }
            }
        }
        
        # Ограничиваем длину
        if ($description.Length -gt 200) {
            $description = $description.Substring(0, 197) + "..."
        }
        
        # Создаём новый контент
        $frontmatter = @"
---
name: $skillName
description: $description
---

"@
        
        $newContent = $frontmatter + $content
        Set-Content -Path $skillFile -Value $newContent -NoNewline
        
        Write-Host "Fixed: $skillName"
        $count++
    }
}

Write-Host ""
Write-Host "Fixed $count SKILL.md files"
