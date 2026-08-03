# 知识库工作约定（Obsidian 知识库专用）

## 定位
- 本库是**知识库**：沉淀、整理与连接。CC 对话仓库（github.com/gjj-star/conversation-memories）负责留档，本库负责提炼。

## 每周沉淀流程（周五）
1. 每周五用户打开 Obsidian 后，`weekly-sync.ps1`（Windows 任务计划程序 "ObsidianWeeklySync" 触发）自动完成：
   拉取 CC 仓库 → 新 .md 复制到 `收集箱/新沉淀/` → 更新 `收集箱/新沉淀清单.json` → 提交并推送 MyObsidian
2. 会话启动时若发现 `收集箱/新沉淀/` 有文件，**主动执行知识整理**：
   - 逐篇提炼为知识卡：中文标题、补全英文术语（全称+简写）、按主题归入对应文件夹
   - 整理完成后清空暂存区，`git add -A && git commit && git push`
3. 每次沉淀后向用户汇报：新沉淀 N 条 → 整理为 M 篇知识卡，分布情况

## 笔记规范
- 标题用中文（概念可加英文副题），概念卡包含「**英文**：Full Name（ABBR）」术语行
- 保留 frontmatter（name/description/metadata + aliases）
- 链接用 [[中文标题]] 双链，不产生断链
