---
name: 生命周期 Lifecycle
node_type: memory
type: reference
description: 生命周期的定义、多领域实例、三个共性特征、与工作流和 B 端系统的关系
originSessionId: 62006bd2-df5d-4a68-bdc3-894ab7b3d9e3
modified: 2026-07-21T10:51:40.703Z
aliases: [lifecycle-concept, Lifecycle, Life Cycle]
tags: [AI-Agent]
---

# 生命周期 Lifecycle

生命周期（Lifecycle）是一个事物从诞生到消亡所经历的完整阶段序列，每阶段有明确边界、状态和任务。

**英文**：Life Cycle（LC）

## 多领域实例

| 领域 | 阶段 |
|---|---|
| 软件工程（SDLC，Software Development Life Cycle，软件开发生命周期） | 需求→设计→开发→测试→部署→运维→退役 |
| 产品管理 | 导入期→增长期→成熟期→衰退期 |
| 数据 | 创建→存储→使用→共享→归档→销毁 |
| 用户/客户 | 获客→激活→留存→变现→流失 |
| 工作流实例 | 触发→执行中→等待回调→完成/失败→归档 |
| Agent 任务 | 创建→规划→执行→观测→决策→结束 |
| 员工（HR，Human Resources，人力资源） | 入职→在职→晋升/转岗→离职 |
| 合同 | 起草→审批→签署→履行→到期/续签 |
| 订单 | 下单→支付→发货→签收→售后→完结 |

## 三个共性特征

1. **状态有先后，不可逆** — 每阶段有入口条件和出口条件
2. **每阶段做的事不同** — 不同阶段不同目标、不同能力模型
3. **管理生命周期的是管理手** — 知道处于哪个阶段就知道：当前该关注什么、下一步是什么、哪里会出问题（阶段切换点最容易掉链子）

## 与工作流的关系

- 工作流引擎就是驱动对象沿生命周期移动的工具
- 每个节点 = 一个生命周期阶段，每条边 = 一个合法状态转移
- Dify 本质上是生命周期管理工具
- 大多数 B 端系统（OA/ERP/CRM/HRM）本质上都在管理某个对象的生命周期

术语：OA（Office Automation，办公自动化）、ERP（Enterprise Resource Planning，企业资源计划）、CRM（Customer Relationship Management，客户关系管理）、HRM（Human Resource Management，人力资源管理）。

## 应用

- **工作流设计**：先识别对象的生命周期阶段与合法状态转移，再映射为工作流的节点与边
- **系统排查**：B 端系统掉链子通常发生在阶段切换点（边界条件），重点检查各阶段的入口/出口条件

## 相关记忆

- [[工作流对接机制]] — 工作流对接机制
- [[Agent 与 Workflow 对比]] — Agent vs Workflow 对比
- [[B 端与 C 端 B2B B2C]] — B 端产品
