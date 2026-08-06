---
name: sop-to-skill-methodology
description: SOP→Skill 拆分方法论 skill：三维取舍矩阵、设计规范、中央数据枢纽、HITL 分级
metadata: 
  node_type: memory
  type: reference
  originSessionId: 141ef463-5bcf-4e10-9949-c9444bcf49f7
---

## sop-to-skill-methodology

从废弃工程文档蒸馏出的 SOP 拆分方法论。名称: `sop-to-skill-methodology`

### 核心主张
- **三维取舍矩阵** — 不是所有 SOP 都值得做 Skill。按可自动化程度 + 工作量大小 + 外部依赖就绪度打分
- **Skill 统一设计规范** — name/description(含触发词+中英双语)/适用场景/工作流/输入输出/依赖/边界/文件层级
- **中央数据枢纽三角色** — Bitable 承担归一化(统一格式)、追溯(谁改了什么)、解耦(Skill间不直接通信)
- **HITL 精确到具体动作** — 不是笼统的"有人参与"，而是"审核解析结果"、"打印拿签名"、"确认邮件发送后点击"
- **触发词双模式** — 精确匹配(防误触发) + 语义匹配(覆盖变体)，skill description 含中英双语提高跨语言触发率

### 触发词
"SOP拆分" "sop to skill" "skill设计" "触发词设计" "HITL分级" "数据枢纽" "skill template" "哪些SOP值得做" "自动化可行性评估"

### 安装位置
`~/.claude/skills/sop-to-skill-methodology/SKILL.md` | `~/.workbuddy/skills/sop-to-skill-methodology/SKILL.md`

### 与其他 skill 的关系
- [[agent-orchestrator-pattern]] — 拆分完需要编排
- [[agent-deployment-checklist]] — 设计完需要部署
- [[cangjie-skill-evaluation]] — cangjie-skill 的 RIA-TV++ 是通用蒸馏，这个专属 SOP 拆分场景

**Why:** 从 8 个真实 SOP 的取舍决策（为什么 SOP 二"无需 AI"、为什么 SOP 五/六"待条件满足"）中提炼的判断框架，比纯理论更有实操参考价值。

**How to apply:** 拿到新业务 SOP 链时，先用三维矩阵逐条打分，淘汰低于阈值的，剩余的按统一设计规范模板化，再建中央数据枢纽表结构。
