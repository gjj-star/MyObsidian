# 每日沉淀同步脚本（每天 15:00 自动执行）
# 职责：拉取 CC 对话仓库 → 新笔记复制到 Clippings（原料区）→ 更新清单 → 提交推送 MyObsidian
# 触发：Windows 任务计划程序 "ObsidianDailySync"（每天 15:00 执行一次）
# 注意：清单为纯文本（每行一个文件名），不用 JSON（PS 5.1 的 ConvertTo/From-Json 数组处理有坑）
#       不用 $ErrorActionPreference='Stop'（git stderr 进度信息会误触发异常），改用 -ErrorAction Stop + $LASTEXITCODE

$vault    = 'C:\Users\EDY\Documents\Obsidian Vault'
$ccRepo   = 'D:\CC\conversation-memories'
$manifest = "$vault\Clippings\新沉淀清单.txt"
$staging  = "$vault\Clippings"
$logFile  = "$vault\Clippings\沉淀日志.md"

function Log($msg) {
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm')] $msg"
    Add-Content -Path $logFile -Value $line -Encoding UTF8
}

New-Item -ItemType Directory -Force -Path $staging | Out-Null

try {
    # 1. 拉取 CC 仓库（首次自动克隆到 D:/CC/conversation-memories）
    if (-not (Test-Path "$ccRepo\.git")) {
        git clone --depth 1 https://github.com/gjj-star/conversation-memories.git $ccRepo 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) { throw 'git clone 失败' }
        Log '首次克隆 conversation-memories 仓库'
    } else {
        git -C $ccRepo pull --ff-only 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) { throw 'git pull 失败' }
    }

    # 2. 找出新笔记（排除系统文件）
    $known = @()
    if (Test-Path $manifest) { $known = @(Get-Content $manifest | Where-Object { $_.Trim() }) }
    $exclude = @('CLAUDE.md', 'AGENTS.md', 'MEMORY.md', 'conversation-log.md')
    $new = @(Get-ChildItem $ccRepo -Filter *.md -File | Where-Object {
        $_.Name -notin $known -and $_.Name -notin $exclude
    })

    # 3. 复制到暂存区（供 AI 整理）
    foreach ($f in $new) { Copy-Item $f.FullName "$staging\$($f.Name)" -Force -ErrorAction Stop }

    # 4. 更新清单（纯文本，每行一个文件名）
    @($known + @($new.Name)) | Sort-Object -Unique | Set-Content $manifest -Encoding UTF8 -ErrorAction Stop

    # 5. 提交并推送 MyObsidian
    if ($new.Count -gt 0) {
        git -C $vault add -A
        git -C $vault commit -m "sync: 拉取对话记录新沉淀 $($new.Count) 条" --allow-empty
        if ($LASTEXITCODE -ne 0) { throw 'git commit 失败' }
        git -C $vault push 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) { throw 'git push 失败' }
        Log "同步完成：新沉淀 $($new.Count) 条 → Clippings/，已推送 GitHub"
    } else {
        Log '同步检查完成：无新笔记'
    }
} catch {
    Log "同步失败：$($_.Exception.Message)"
}
