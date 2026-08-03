---
name: agentic-rpa
description: Agentic RPA 的定义、相对传统 RPA 的能力升级、架构、场景、与纯 Agent 区别及挑战
metadata: 
  node_type: memory
  type: knowledge
  originSessionId: 1d96bcb2-b3c5-46cd-b222-e16e5ba9566b
---

Agentic RPA = AI Agent/LLM（脑） + 传统 RPA（手）：把大模型推理能力接入 RPA，让机器人从"按死脚本执行"升级到"能理解、判断、处理异常"。

**动机（传统 RPA 痛点）**：死规则、只处理结构化固定格式；UI 一变即崩（脆弱性，维护成本>建设成本）；遇异常只能停下靠人工兜底。

**能力升级（vs 传统 RPA）**
- 理解非结构化数据：OCR+LLM 读合同/发票/自由邮件，抽取字段（而非固定模板）。
- 动态决策：按上下文实时推理选路径，而非写死 if-else。
- 异常处理与自愈：遇陌生弹窗/格式尝试理解绕过，或总结交人。
- 自然语言下达任务 + 自我规划（Planning）：给定目标，拆解子任务、调用工具完成。

**技术架构**：RPA 执行层（手）+ LLM 推理核心 + 工具调用(Tool Use/Function Calling，把 RPA 动作当工具) + 记忆 + 多 Agent 编排（规划/执行/审核）+ 常结合 OCR、RAG(向量库)、流程挖掘。

**vs 纯 AI Agent**：纯 Agent 难操作真实 GUI；Agentic RPA 让 Agent 能"动手"操作无 API 的企业系统，是落地关键。三者关系：Agentic RPA ≈ Agent(脑) + RPA(手) + 企业系统连接。

**挑战**：LLM 幻觉/误判（高风险场景需 [[human-in-the-loop]] 人在回路审核）；推理成本高于脚本；决策路径不如固定脚本透明（合规/审计）；权限管控；仍依赖 RPA 脆弱的 UI 层底座。

**趋势/产品**：UiPath Agentic Automation/Autopilot、Microsoft Copilot+Power Automate、影刀/来也接大模型；从"录制回放"走向"目标驱动"，从 RPA 演进到 APA(Agentic Process Automation)。
