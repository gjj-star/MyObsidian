# 知识库工作约定（Obsidian 知识库专用）

## 定位
- 本库是**知识库**：沉淀、整理与连接。CC 对话仓库（github.com/gjj-star/conversation-memories）负责留档，本库负责提炼。

## 原料区与每日沉淀流程
- **Clippings/ 是唯一原料区**：网页剪藏（Obsidian Web Clipper 自动写入）+ CC 对话新沉淀（weekly-sync.ps1 每天 15:00 自动写入）汇合于此；无单独收集箱
- 提炼后**原剪藏/原笔记保留在 Clippings/ 作档案**，不删除（用户可能在网页端继续添加，后续还会有更多）
1. 每天 15:00，`weekly-sync.ps1`（Windows 任务计划程序 "ObsidianDailySync" 触发）自动完成：
   拉取 CC 仓库 → 新 .md 复制到 `Clippings/` → 更新 `Clippings/新沉淀清单.txt` → 提交并推送 MyObsidian
2. 会话启动时若发现 `Clippings/` 有未整理文件（CC 新沉淀或网页剪藏），**主动执行知识整理**：
   - 逐篇提炼为知识卡：中文标题、补全英文术语（全称+简写）、按主题归入对应文件夹
   - 区分来源：CC 新沉淀文件名与清单对照；网页剪藏带 `tags: clippings` 的 frontmatter
   - 整理完成后 `git add -A && git commit && git push`
3. 每次沉淀后向用户汇报：新沉淀 N 条 → 整理为 M 篇知识卡，分布情况

## 笔记规范
- 标题用中文（概念可加英文副题），概念卡包含「**英文**：Full Name（ABBR）」术语行
- 保留 frontmatter（name/description/metadata + aliases）
- 链接用 [[中文标题]] 双链，不产生断链
- **禁止使用 Emoji 与图形符号**（勾、叉、星、图钉等图案一律不用）；星级用 `n/5` 表示（如 5/5），勾叉用文本符号 `✓` `✗`，箭头用 `→` `←` `↔` 等文本箭头
