---
name: flink
description: Apache Flink 流处理引擎的核心概念与实时数仓典型链路
metadata:
  node_type: memory
  type: knowledge
---

## Apache Flink

Apache Flink 是开源的**分布式流处理引擎**，实时计算领域的事实标准。

## 核心概念

- **流处理 vs 批处理**：毫秒级延迟 vs 分钟级（Flink 也支持批流一体）
- **组件**：Source（数据源）→ Transformation（转换）→ Sink（输出）
- **窗口机制**：滚动窗口 / 滑动窗口 / 会话窗口
- **状态管理 + Checkpoint**：实现**精确一次（Exactly-once）**语义

## 生态与使用

- 阿里是最大贡献者（Blink 回馈）
- **Flink SQL** 大幅降低使用门槛
- 实时数仓典型链路：**Kafka → Flink → [[postgresql|Hologres]] → 大屏**

> 📌 来源：CC 对话记录 conversation-log（2026-08-03）
