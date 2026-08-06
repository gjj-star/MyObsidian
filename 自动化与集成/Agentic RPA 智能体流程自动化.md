---
name: Agentic RPA 智能体流程自动化
node_type: memory
type: knowledge
description: Agentic RPA 的定义、相对传统 RPA 的能力升级、技术架构、与纯 AI Agent 的对比及落地挑战
originSessionId: 1d96bcb2-b3c5-46cd-b222-e16e5ba9566b
aliases:
  - agentic-rpa
  - Agentic RPA
  - APA
tags: [自动化与集成]
---

# Agentic RPA 智能体流程自动化

**英文**：Agentic Robotic Process Automation（Agentic RPA，智能体流程自动化）

## 定义

Agentic RPA = AI Agent/LLM（大脑）+ 传统 RPA（双手）：把大模型推理能力接入 RPA，让机器人从"按死脚本执行"升级为"能理解、判断、处理异常"。

## 动机：传统 RPA 的痛点

- 死规则，只处理结构化、固定格式的任务
- UI 一变即崩——脆弱性导致维护成本高于建设成本
- 遇异常只能停下，靠人工兜底

## 能力升级（vs 传统 RPA）

| 维度 | 传统 RPA | Agentic RPA |
|---|---|---|
| 数据理解 | 固定模板 | OCR + LLM 读合同/发票/自由邮件，抽取字段（而非固定模板） |
| 决策方式 | 写死 if-else | 按上下文实时推理选择路径 |
| 异常处理 | 停下等人工 | 理解陌生弹窗/格式并尝试绕过，或总结后交人 |
| 任务下达 | 录制/脚本 | 自然语言下达任务 + 自我规划（Planning）：给定目标，拆解子任务、调用工具完成 |

## 技术架构

RPA 执行层（手）+ LLM 推理核心 + 工具调用（Tool Use / Function Calling，把 RPA 动作当工具）+ 记忆 + 多 Agent 编排（规划/执行/审核）+ 常结合 OCR、RAG（Retrieval-Augmented Generation，检索增强生成；向量库）、流程挖掘。

## 与纯 AI Agent 的区别

纯 Agent 难以操作真实 GUI；Agentic RPA 让 Agent 能"动手"操作无 API 的企业系统，是落地关键。三者关系：

**Agentic RPA ≈ Agent（脑）+ RPA（手）+ 企业系统连接**

## 挑战

- LLM 幻觉/误判——高风险场景需 [[人在回路 HITL|人在回路]] 审核
- 推理成本高于脚本
- 决策路径不如固定脚本透明（合规/审计困难）
- 权限管控复杂
- 仍依赖 RPA 脆弱的 UI 层底座

## 趋势与产品

- UiPath Agentic Automation / Autopilot、Microsoft Copilot + Power Automate、影刀/来也接入大模型
- 从"录制回放"走向"目标驱动"，从 RPA 演进到 APA（Agentic Process Automation，智能体流程自动化）

## 相关

- [[RPA 基础]] — 传统 RPA 的痛点即 Agentic RPA 的动机
- [[Agent Skill 自动化]] — 同族对比：Agent 直接干 vs UI 模拟
- [[工作流对接机制]] — 无 API 系统的最后兜底手段
