---
name: agent-deployment-checklist
description: AI Agent 落地部署清单 skill：前置条件三级分类、五阶段路线图、风险矩阵、TCR/ATCC 成本管理
metadata: 
  node_type: memory
  type: reference
  originSessionId: 141ef463-5bcf-4e10-9949-c9444bcf49f7
---

## agent-deployment-checklist

从废弃工程文档蒸馏出的 Agent 部署清单。名称: `agent-deployment-checklist`

### 核心主张
- **前置条件三级分类** — 已就绪(可立即开始) / 需配置(明确阻塞项) / 待开发(依赖外部)
- **五阶段路线图** — 基础建设 → 核心Skill → 外部集成 → 编排串联 → 条件迭代，每阶段有可交付成果
- **风险矩阵四维度** — 数据安全(敏感信息存储) / 模板变更同步 / 外部系统变更降级 / 过度自动化
- **TCR/ATCC 双指标** — 不只是"能不能跑"，还要衡量"跑得好不好、花得多不多"
- **关键业务约束硬编码** — 付款12点窗口、合同修改等两天、Skill zip包不含.eml

### 触发词
"部署清单" "deployment checklist" "上线检查" "agent落地" "workbuddy集成" "企微配置" "前置条件检查" "风险矩阵" "TCR ATCC" "积分成本" "实施路线图"

### 安装位置
`~/.claude/skills/agent-deployment-checklist/SKILL.md` | `~/.workbuddy/skills/agent-deployment-checklist/SKILL.md`

### 与其他 skill 的关系
- [[agent-orchestrator-pattern]] — 编排设计完用部署清单上线
- [[sop-to-skill-methodology]] — 先拆分设计再部署
- [[human-in-the-loop]] — 风险矩阵中过度自动化维度的理论基础

**Why:** 从真实的 WorkBuddy 企业版部署经验中提炼，覆盖了"脚本能跑≠生产可用"的差距。五阶段顺序、三级前置条件分类、业务约束硬编码都是踩过的坑。

**How to apply:** 任何 Agent 项目上线前，按三级分类清点前置条件，按五阶段路线图排期，建立四维度风险矩阵，用 TCR/ATCC 设定基线并持续追踪。
