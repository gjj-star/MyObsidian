---
name: agent-vs-workflow-comparison
description: Agent/Skill 与 Workflow（Dify）两种 AI 能力嵌入范式的定义、核心对比、各自硬伤、适用场景和混合编排策略
metadata: 
  node_type: memory
  type: reference
  originSessionId: 62006bd2-df5d-4a68-bdc3-894ab7b3d9e3
  modified: 2026-07-21T07:04:02.061Z
---

## 范式定义
- **Agent/Skill**：LLM 拿着工具集，自主决定每一步做什么。控制权在模型手里。
- **Workflow（Dify）**：人先画好流程图，节点类型预定义，模型只是图里的一个节点。控制权在人手里。

## 核心对比

| 维度 | Agent/Skill | Workflow（Dify） |
|---|---|---|
| 控制权 | 模型 | 人 |
| 可预测性 | 低——两次可能走不同路径 | 高——同一输入永远同一路径 |
| 异常处理 | 模型自己 try-catch | 人预先设计失败分支 |
| 调试难度 | 高——需追溯推理链 | 中低——每节点独立可查 |
| 适用场景 | 模糊/开放/需判断 | 结构化/重复/需合规 |
| 延迟 | 高——每步推理 | 低——节点间纯工程调度 |
| 审计合规 | 困难 | 容易 |
| 更新迭代 | 改 prompt 快但不保证行为不变 | 改图慢但影响范围可控 |
| 上线门槛 | prompt 写清楚即可 | 须理清完整业务流程 |

## 各自硬伤

**Agent 硬伤**：
1. 不可预测——同一个 prompt 两次结论可能不同
2. 无限循环——思考-行动之间打转，需 max_steps 一刀切
3. 安全审计——"谁决定删除这条数据？"难以回答

**Workflow 硬伤**：
1. 柔性不足——必须穷举所有分支，意料之外就卡死
2. 维护成本——业务一变，每个图都要改
3. 不能理解整体意图——LLM 只做点状任务，上下文不连续

## 适用场景矩阵
- **高确定性+结构化** → Workflow（审批流、数据清洗、SOP）
- **低确定性+开放性** → Agent（客服对话、研究分析、排障）
- **混合** → Agent 入口理解意图+规划，拆成子任务走 Workflow 执行

## 混合编排趋势
- Dify v1.0+ 在 Workflow 画布里加入 Agent Node，让某个节点可以"放手让模型自己判断"
- OMC executor 本质上是 Agent 生成的计划交给受控的执行单元去跑
- **一句话**：Workflow 是确定的系统里跑不确定的 AI，Agent 是不确定的 AI 带着确定的工具去探索

## 相关记忆
- [[agent-orchestrator-pattern]] — Agent 工作流编排模式（批次/状态机/检查点）
- [[oa-agent-integration]] — OA 中 Agent 集成五级成熟度模型
- [[sop-definition]] — SOP 定义，Workflow 最适合 SOP 化场景
