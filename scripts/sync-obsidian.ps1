# Obsidian 公开笔记 -> Quartz content\notes 同步 + 构建 + 提交 + 推送
# 源目录: D:\chd\data\Obsidian Vault\0.数字花园
# 目标:   D:\workpace\quartz\my-site\content\notes
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$Source  = 'D:\chd\data\Obsidian Vault\0.数字花园'
$Quartz  = 'D:\workpace\quartz\my-site'
$Target  = Join-Path $Quartz 'content\notes'
$Branch  = 'v4'

# 1. 校验路径
if (-not (Test-Path -LiteralPath $Source)) {
    New-Item -ItemType Directory -Path $Source -Force | Out-Null
    Write-Host "[init] 已创建公开笔记目录: $Source"
}
if (-not (Test-Path -LiteralPath (Join-Path $Quartz 'quartz.config.ts'))) {
    Write-Error "Quartz 仓库不存在: $Quartz"; exit 1
}
if (-not (Test-Path -LiteralPath $Target)) {
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
}

# 2+3+6. robocopy /MIR 递归镜像，删除目标中源端已删除的文件（仅限 content\notes 内），排除系统/私密目录
$rob = robocopy $Source $Target /MIR `
    /XD ".obsidian" ".git" ".trash" ".sync" ".cache" "Templatetmp" `
    /XF ".DS_Store" "Thumbs.db" "desktop.ini" "ehthumbs.db" `$RECYCLE.BIN `
    /R:1 /W:1 /NP /ndl
$rc = $LASTEXITCODE
if ($rc -ge 8) {
    Write-Error "robocopy 同步失败 (code=$rc)"; exit 1
}
$copied  = @($rob | Where-Object { $_ -match '^\s*(New File|Newer File|.*Copy)' -and $_ -notmatch 'Files\s*:' })
Write-Host "`n[robocopy 摘要]"
$rob | Select-String -Pattern '^\s*(Dirs|Files|Bytes):' | ForEach-Object { $_.Line }

# 4. 绝不触碰 content\index.md 与 Quartz 配置（本脚本只写入 content\notes）

# 5/8. 变更检测（git 视角）
Push-Location $Quartz
try {
    $changes = @(git status --porcelain -- "content/notes" "sync-notes.ps1" "scripts")
    if ($changes.Count -eq 0) {
        Write-Host "`n[sync] 无变化，直接退出。"
        exit 0
    }
    Write-Host "`n[变更文件]"
    $changes | ForEach-Object { Write-Host "  $_" }

    # 断链扫描：报告指向公开目录外/不存在的 wiki 链接，仅提示不修改
    $notes = Get-ChildItem -LiteralPath $Target -Recurse -Filter *.md -ErrorAction SilentlyContinue
    $suspect = @()
    foreach ($f in $notes) {
        $text = Get-Content -LiteralPath $f.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
        if (-not $text) { continue }
        foreach ($m in [regex]::Matches($text, '\[\[([^\]\|#]+)')) {
            $link = $m.Groups[1].Value.Trim()
            if ($link -match '^[a-zA-Z]:\\' -or $link -match '^\.\./\.\.' -or $link -match '^/') {
                $suspect += "$($f.Name) -> [[$link]]"
            }
        }
    }
    if ($suspect.Count -gt 0) {
        Write-Host "`n[警告] 可能指向公开目录外的链接（未自动处理）:"
        $suspect | ForEach-Object { Write-Host "  $_" }
    }

    # 9+10. 构建，失败禁止提交
    Write-Host "`n[build] npx quartz build"
    npx quartz build
    if ($LASTEXITCODE -ne 0) {
        Write-Error "构建失败，已中止 commit/push。本地文件未受影响。"
        exit 1
    }

    # 11+12+13. 提交并推送（只加同步相关内容，不加凭证/缓存）
    git add -- "content/notes" "sync-notes.ps1" "scripts/sync-obsidian.ps1" "scripts/register-sync-task.ps1" ".gitignore"
    git commit -m "chore: sync Obsidian notes" | Out-String | Write-Host
    if ($LASTEXITCODE -ne 0) { Write-Error "commit 失败"; exit 1 }
    git push origin $Branch
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "push 失败（多为 GitHub 授权问题），本地提交已完成，文件未受影响。请完成浏览器登录后重跑 ."
        exit 1
    }
    Write-Host "`n[sync] 完成：已同步、构建、提交并推送到 origin/$Branch"
} finally {
    Pop-Location
}
