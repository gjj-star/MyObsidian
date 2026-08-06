---
name: 流处理 Apache Flink
node_type: memory
type: knowledge
description: Apache Flink 流处理引擎的核心概念与实时数仓典型链路
aliases:
  - flink
  - Apache Flink
tags: [开发工具, 编程与数据]
---

## Apache Flink 流处理

**英文**：Apache Flink 简称 Flink；Stream Processing（流处理）；Checkpoint（检查点）

Apache Flink 是开源的**分布式流处理引擎**（Distributed Stream Processing Engine），实时计算领域的事实标准。

### 核心概念

- **流处理 vs 批处理**：毫秒级延迟 vs 分钟级延迟（Flink 也支持批流一体，Batch-Stream Unification）
- **组件**：Source（数据源）→ Transformation（转换）→ Sink（输出）
- **窗口机制**：滚动窗口（Tumbling Window）/ 滑动窗口（Sliding Window）/ 会话窗口（Session Window）
- **状态管理 + Checkpoint（检查点）**：实现**精确一次（Exactly-once）**语义

### 生态与使用

- 阿里是最大贡献者（Blink 回馈开源）
- **Flink SQL** 大幅降低使用门槛
- 实时数仓典型链路：**Kafka → Flink → [[PostgreSQL 数据库|Hologres]] → 大屏**

### 应用

- 实时指标计算、风控、实时数仓等低延迟场景首选 Flink
- 使用门槛较低时优先采用 Flink SQL 而非 DataStream API

## 相关

- [[PostgreSQL 数据库]] — Flink 实时数仓链路的下游存储
- [[Docker 环境一致性]] — 集群部署环境一致性的典型场景

> 来源：CC 对话记录 conversation-log（2026-08-03）
