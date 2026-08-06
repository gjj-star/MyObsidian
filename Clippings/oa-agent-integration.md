---
name: oa-agent-integration
description: OA 系统中 Agent/AI 集成的五级成熟度模型、当前产品动态、与 Agentic RPA 的关联
metadata: 
  node_type: memory
  type: knowledge
  originSessionId: 869361d7-7af4-48e8-8223-8601d67447a6
  modified: 2026-07-20T08:39:47.102Z
---

# OA 中的 Agent/AI 集成

> 关联：[[oa-system-overview|OA 系统概述]]、[[agent-skill-automation|Agentic 自动化 vs Agent/Skill 自动化]]、[[agentic-rpa|Agentic RPA]]

## 五级成熟度模型

| 层级 | 场景 | 技术方案 |
|------|------|---------|
| **L1: RPA 替人点** | AutoIT/UiPath 自动登录 OA、填写报销单、点击提交 | 经典 RPA（基于元素选择器） |
| **L2: Agent 替人判断** | LLM 读取审批附件（合同 PDF/发票图片），自动提取关键字段填入表单 | LLM + OCR + 脚本，类似之前讨论的财务传真方案 |
| **L3: Agent 嵌入流程** | 审批流中插入 AI 节点——合同条款合规检查、发票真伪核验、报销金额合理性异常检测 | OA 流程引擎调用 AI API，返回通过/驳回/标记 |
| **L4: Agent 自主审批** | 低风险标准事项（如 500 元以内办公用品采购）由 Agent 直接审批，无需人类干预 | LLM Agent + 规则引擎 + HITL 兜底 |
| **L5: 跨系统 Agent 编排** | Agent 判断"付款申请 OA 通过了→ERP 生成凭证→发邮件通知供应商" | 多 Agent 协作 + API 集成 |

## 产品侧动态（2025-2026）

- **钉钉/飞书/企微** 已内置 AI 助手：智能填单、审批摘要、会议纪要自动生成
- **泛微/致远互联** 推出 AI 流程顾问——自然语言描述需求，自动生成审批流
- **低代码 OA（明道云/简道云）** 集成 AI 字段——表单里"智能分类""智能评分"字段直接调用 LLM

## 对郭锦佳的实操意义

AIBP 业财实习里，如果能发现并推动一个"OA 流程 + AI 辅助"的场景（比如发票信息自动提取填充），这将成为极具辨识度的 FDE 项目叙事。技术上并不复杂——调一个 LLM API + Python 脚本即可。

**Why:** OA 正经历 AI 化浪潮，理解 Agent 如何在 OA 中落地（而非停留在 "ChatGPT 套壳" 层面）是 FDE 在 2025-2026 年的核心差异化能力。L2-L3 级落地门槛低但价值感知强，非常适合实习期间做边角项目。

**How to apply:** 在 AIBP 实习中识别 L1-L3 场景；面试时用五级模型框架结构化地讨论 OA+AI 话题；技术上参考 [[agent-skill-automation|财务传真方案]] 的架构模式（LLM Agent + 自定义脚本工具）。
