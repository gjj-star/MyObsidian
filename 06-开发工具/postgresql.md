---
name: postgresql
description: PostgreSQL 的核心特点、与主流数据库的对比及 Hologres 兼容性
metadata:
  node_type: memory
  type: knowledge
---

## PostgreSQL

PostgreSQL 是最流行的**开源关系型数据库**（RDBMS）。

## 核心特点

- 完整 SQL 标准 + **ACID 事务**
- **MVCC 并发控制**：读写互不阻塞
- 丰富类型：JSONB、数组、几何等
- 扩展体系：PostGIS（地理）、pgvector（向量检索）
- **BSD 协议**：完全免费可商用

## 与主流数据库对比

| | PostgreSQL | MySQL | SQL Server | Oracle |
|---|---|---|---|---|
| 开源 | ✅ BSD | ✅ GPL | ❌ | ❌ |
| 复杂度 | 高功能 | 轻量 | 微软系 | 企业重型 |

## 相关生态

Hologres 兼容 PG 协议——懂 PostgreSQL 就会写 Hologres 查询（见 [[flink]] 的实时数仓链路）。

> 📌 来源：CC 对话记录 conversation-log（2026-08-03）
