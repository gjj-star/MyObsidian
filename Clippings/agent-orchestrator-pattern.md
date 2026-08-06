---
name: agent-orchestrator-pattern
description: Agent 工作流编排模式 skill：批次划分、状态机、硬编码检查点、双路径上下文传递
metadata: 
  node_type: memory
  type: reference
  originSessionId: 141ef463-5bcf-4e10-9949-c9444bcf49f7
---

## agent-orchestrator-pattern

从废弃工程文档蒸馏出的 Agent 编排设计模式。名称: `agent-orchestrator-pattern`

### 核心主张
- **批内自动、批间硬编码人工检查点** — 批次边界 = 不可控时间间隔 + 不可省略物理动作
- **中央数据枢纽解耦 Skill** — 所有 Skill 只从上游读、向 Bitable 写回，避免直接耦合
- **失败暂停而非跳过** — 批次内任一 Skill 失败立即冻结，支持从失败点重试
- **安全检查点必须硬编码** — 涉及金额、银行账号的环节，代码层面强制执行，配置文件不可绕过
- **条件触发≠自动执行** — 检测到外部条件满足时，主动建议但需人工确认后才执行

### 触发词
"编排工作流" "batch orchestration" "HITL checkpoint" "agent workflow" "多skill编排" "批次划分" "checkpoint设计"

### 安装位置
`~/.claude/skills/agent-orchestrator-pattern/SKILL.md` | `~/.workbuddy/skills/agent-orchestrator-pattern/SKILL.md`

### 与其他 skill 的关系
- [[sop-to-skill-methodology]] — 先有拆分再有编排
- [[agent-deployment-checklist]] — 编排设计完需要部署清单落地
- [[human-in-the-loop]] — HITL 的理论基础

**Why:** 这是从真实的 WorkBuddy 生产项目（8 SOP → 7 Skill + Orchestrator）中提炼的可迁移架构模式。核心价值在于"批内自动、批间人工"的实践经验，而非理论推演。

**How to apply:** 面对多步骤业务链时，先用批次边界双维度（时间间隔+物理动作）做第一刀切分，再设计状态表做单一真相源，最后硬编码所有检查点。
