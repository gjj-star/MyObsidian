---
name: Agent 部署清单
description: AI Agent 落地部署清单 skill：前置条件三级分类、五阶段路线图、风险矩阵、TCR/ATCC 成本管理
metadata:
  node_type: memory
  type: reference
  originSessionId: 141ef463-5bcf-4e10-9949-c9444bcf49f7
aliases: [agent-deployment-checklist, Deployment Checklist]
---

# Agent 部署清单

从废弃工程文档蒸馏出的 Agent 部署清单，封装为 skill（名称：`agent-deployment-checklist`），覆盖从设计到生产上线的全过程，核心是弥合"脚本能跑 ≠ 生产可用"的差距。

**英文**：Skill（AI Agent 可调用能力封装）；TCR（Task Completion Rate，任务完成率）；ATCC（Average Token Cost per Completion，平均单次完成的 Token 成本）；HITL（Human-in-the-Loop，人在回路）

## 核心主张

- **前置条件三级分类** — 已就绪（可立即开始）/ 需配置（明确阻塞项）/ 待开发（依赖外部）
- **五阶段路线图** — 基础建设 → 核心 Skill → 外部集成 → 编排串联 → 条件迭代，每阶段有可交付成果
- **风险矩阵四维度** — 数据安全（敏感信息存储）/ 模板变更同步 / 外部系统变更降级 / 过度自动化
- **TCR/ATCC 双指标** — 不只衡量"能不能跑"，还衡量"跑得好不好"（TCR 任务完成率）与"花得多不多"（ATCC 平均 Token 成本）
- **关键业务约束硬编码** — 付款 12 点窗口、合同修改等两天、Skill zip 包不含 .eml，均写入代码强制，配置不可绕过

## 触发词

"部署清单" "deployment checklist" "上线检查" "agent落地" "workbuddy集成" "企微配置" "前置条件检查" "风险矩阵" "TCR ATCC" "积分成本" "实施路线图"

## 安装位置

`~/.claude/skills/agent-deployment-checklist/SKILL.md` | `~/.workbuddy/skills/agent-deployment-checklist/SKILL.md`

## 与其他 skill 的关系

- [[Agent 编排模式]] — 编排设计完，用部署清单上线
- [[SOP 转 Skill 方法论]] — 先拆分设计，再部署
- [[人在回路 HITL]] — 风险矩阵中"过度自动化"维度的理论基础

**Why:** 从真实 WorkBuddy（企业微信生态 AI 工作台）企业版部署经验中提炼，覆盖了"脚本能跑≠生产可用"的差距；五阶段顺序、三级前置条件分类、业务约束硬编码都是踩过的坑。

**How to apply:** 任何 Agent 项目上线前：按三级分类清点前置条件 → 按五阶段路线图排期 → 建立四维度风险矩阵 → 用 TCR/ATCC 设定基线并持续追踪。
