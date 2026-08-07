# 知识库工作约定（Obsidian 知识库专用）

## 定位
- 本库是**知识库**：沉淀、整理与连接。CC 对话仓库（github.com/gjj-star/conversation-memories）负责留档，本库负责提炼。

## 原料区与每日沉淀流程
- **Clippings/ 是唯一原料区**：网页剪藏（Obsidian Web Clipper 自动写入）入库；CC 对话新沉淀（weekly-sync.ps1 每天 15:00 自动拉取并记入清单，原始文件留在 CC 仓库不复制入库）；无单独收集箱
- 提炼后**原剪藏/原笔记保留在 Clippings/ 作档案**，不删除（用户可能在网页端继续添加，后续还会有更多）
1. 每天 15:00，`weekly-sync.ps1`（Windows 任务计划程序 "ObsidianDailySync" 触发）自动完成：
   拉取 CC 仓库 → 新沉淀记入 `Clippings/新沉淀清单.txt`（原始文件不复制入库，避免污染关系图谱）→ 提交并推送 MyObsidian
2. 会话启动时若发现 `Clippings/` 有未整理文件（CC 新沉淀或网页剪藏），**主动执行知识整理**：
   - 逐篇提炼为知识卡：中文标题、补全英文术语（全称+简写）、按主题归入对应文件夹
   - 区分来源：CC 新沉淀文件名与清单对照，原始文件从 `D:/CC/conversation-memories` 读取；网页剪藏带 `tags: clippings` 的 frontmatter
   - 整理完成后 `git add -A && git commit && git push`
3. 每次沉淀后向用户汇报：新沉淀 N 条 → 整理为 M 篇知识卡，分布情况

## 笔记规范
- 标题用中文（概念可加英文副题），概念卡包含「**英文**：Full Name（ABBR）」术语行
- 知识卡 frontmatter 用**扁平顶层字段**（Bases 与属性面板可直接读取，不用嵌套 metadata）：`name`（中文名）/ `node_type: memory` / `type`（reference、knowledge、user）/ `description`（一句话摘要）/ `originSessionId`（来源 CC 会话）/ `modified`（更新时间）/ `aliases`（英文+中文别名）/ `tags`（主题标签：AI-Agent、企业数字化、自动化与集成、开发工具、认知研究、自我认知；**子主题标签与图谱颜色组一一对应**，按子目录补：企业软件、业财与经营、编程与数据、环境与部署、信息获取、六爻、方法论、职业、自我；日记用 日记）
- 蒸馏 CC 新沉淀时按上述格式生成 frontmatter；网页剪藏保持原样，仅加 `tags: clippings`
- 链接用 [[中文标题]] 双链，不产生断链
- **关系标注**：图谱连线表达"相关"（默认语义，不标字段）；特殊关系在 frontmatter 用扁平字段显式声明（正文链接处同步加前缀：`上位：`/`子类：`/`对比：`/`依赖：`）：
  - `rel_parent` 上位/所属（子卡标注，如 财务BP → BP 业务伙伴）
  - `rel_child` 下位/子类/成员（父卡标注，与 rel_parent 对称配对）
  - `rel_contrast` 对比（双方对称标注，如 Electron ↔ uni-app）
  - `rel_depends` 依赖/基于（依赖方标注，如 Hologres → PostgreSQL）
- **禁止使用 Emoji 与图形符号**（勾、叉、星、图钉等图案一律不用）；星级用 `n/5` 表示（如 5/5），勾叉用文本符号 `✓` `✗`，箭头用 `→` `←` `↔` 等文本箭头
