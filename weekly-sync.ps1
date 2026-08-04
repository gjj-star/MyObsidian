# 每周沉淀同步脚本（周五 Obsidian 运行时自动执行）
# 职责：拉取 CC 对话仓库 → 新笔记复制到 Clippings（原料区）→ 更新清单 → 提交推送 MyObsidian
# 触发：Windows 任务计划程序 "ObsidianWeeklySync"（周五 08:00-22:00 每 30 分钟检查）

$ErrorActionPreference = 'Stop'
$vault    = 'C:\Users\EDY\Documents\Obsidian Vault'
$ccRepo   = 'D:\CC\conversation-memories'
$manifest = "$vault\Clippings\新沉淀清单.json"
$staging  = "$vault\Clippings"
$logFile  = "$vault\Clippings\沉淀日志.md"

function Log($msg) {
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm')] $msg"
    Add-Content -Path $logFile -Value $line -Encoding UTF8
}

# 1. 只在周五运行
if ((Get-Date).DayOfWeek -ne 'Friday') { exit 0 }
# 2. 只在 Obsidian 运行时运行
if (-not (Get-Process obsidian -ErrorAction SilentlyContinue)) { exit 0 }

New-Item -ItemType Directory -Force -Path $staging | Out-Null

try {
    # 3. 拉取 CC 仓库（首次自动克隆到 D:/CC/conversation-memories）
    if (-not (Test-Path "$ccRepo\.git")) {
        git clone --depth 1 https://github.com/gjj-star/conversation-memories.git $ccRepo 2>&1 | Out-Null
        Log '首次克隆 conversation-memories 仓库'
    } else {
        git -C $ccRepo pull --ff-only 2>&1 | Out-Null
    }

    # 4. 找出新笔记（排除系统文件）
    $known = @()
    if (Test-Path $manifest) { $known = @(Get-Content $manifest -Raw | ConvertFrom-Json) }
    $exclude = @('CLAUDE.md', 'AGENTS.md', 'MEMORY.md', 'conversation-log.md')
    $new = @(Get-ChildItem $ccRepo -Filter *.md -File | Where-Object {
        $_.Name -notin $known -and $_.Name -notin $exclude
    })

    # 5. 复制到暂存区（供 AI 整理）
    foreach ($f in $new) { Copy-Item $f.FullName "$staging\$($f.Name)" -Force }

    # 6. 更新清单
    ($known + @($new.Name)) | ConvertTo-Json | Set-Content $manifest -Encoding UTF8

    # 7. 提交并推送 MyObsidian
    if ($new.Count -gt 0) {
        git -C $vault add -A
        git -C $vault commit -m "weekly: 拉取对话记录新沉淀 $($new.Count) 条" --allow-empty
        git -C $vault push 2>&1 | Out-Null
        Log "同步完成：新沉淀 $($new.Count) 条 → Clippings/，已推送 GitHub"
    } else {
        Log '同步检查完成：无新笔记'
    }
} catch {
    Log "同步失败：$($_.Exception.Message)"
}
