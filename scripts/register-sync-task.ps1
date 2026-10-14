# 注册 Windows 计划任务：每一周运行一次 sync-notes.ps1
# 运行方式：在 PowerShell 中执行 .\scripts\register-sync-task.ps1
$taskName = 'Quartz Obsidian Sync'
$existing = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existing) {
    $interval = ($existing.Triggers | ForEach-Object { $_.Repetition.Interval }) -join ','
    if ($interval -and $interval -notmatch '^P7D|^168') {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
        Write-Host "[update] 已移除旧任务（间隔 $interval），重新注册为每周一次"
    } else {
        Write-Host "[skip] 任务已存在且为每周一次: $taskName"
        exit 0
    }
}

$action = New-ScheduledTaskAction `
    -Execute 'powershell.exe' `
    -Argument '-NoProfile -ExecutionPolicy Bypass -File "D:\workpace\quartz\my-site\sync-notes.ps1"' `
    -WorkingDirectory 'D:\workpace\quartz\my-site'

$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 9:00am

$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -MultipleInstances IgnoreNew

try {
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings `
        -Description 'Obsidian public notes -> Quartz build -> git push -> vercel deploy, every week' | Out-Null
    Write-Host "[ok] 已创建计划任务 '$taskName'，每周一 09:00 运行一次。"
    Write-Host "     注意：任务只在你的 Windows 会话登录时运行（交互式登录）。"
} catch {
    Write-Error "创建计划任务失败：$($_.Exception.Message)`n请以当前登录用户身份运行本脚本；若仍失败，请检查 Task Scheduler 服务是否被禁用。"
    exit 1
}
