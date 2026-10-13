# 入口：Obsidian -> content -> build -> commit -> push
& (Join-Path $PSScriptRoot 'scripts\sync-obsidian.ps1')
exit $LASTEXITCODE
