---
name: Hologres 实时分析引擎
node_type: memory
type: knowledge
description: 阿里云自研的一站式实时交互式分析引擎（HSAP），完全兼容 PostgreSQL 协议
modified: 2026-08-07
aliases: [hologres, HSAP, 阿里云Hologres]
tags: [开发工具, 编程与数据]
rel_depends: "[[PostgreSQL 数据库]]"
---

Hologres 是阿里云自研的**一站式实时交互式分析引擎**（HSAP，Hybrid Serving/Analytical Processing 类产品），完全兼容 PostgreSQL 协议。

**英文**：Hologres（HSAP 实时交互式分析引擎）

## 核心特点

- **HSAP 统一架构**：实时写入 + 实时分析 + 在线服务一体
- **PG 协议兼容**：依赖 [[PostgreSQL 数据库]] 的协议，懂 PG 就会写 Hologres 查询
- **阿里生态融合**：与 Flink、MaxCompute、DataWorks 深度打通
- **存储计算分离**：弹性扩缩容

## 与同类对比

- **vs ClickHouse**：OLAP 强，但不擅长高并发点查
- **vs TiDB/TiFlash**：侧重不同，Hologres 主打实时数仓

> 一句话概括：PostgreSQL 协议 + ClickHouse 级 OLAP + Redis 级点查 + Flink 实时写入。典型链路见 [[流处理 Apache Flink]]（Kafka → Flink → Hologres → 大屏）。

> 来源：CC 对话记录 conversation-log（2026-08-03）
