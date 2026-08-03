---
name: PostgreSQL 数据库
description: PostgreSQL 的核心特点、与主流数据库对比及 Hologres 兼容性
metadata:
  node_type: memory
  type: knowledge
aliases:
  - postgresql
  - PostgreSQL
---

## PostgreSQL 数据库

**英文**：PostgreSQL = Postgres；RDBMS = Relational Database Management System（关系型数据库管理系统）；MVCC = Multi-Version Concurrency Control（多版本并发控制）；ACID = Atomicity, Consistency, Isolation, Durability（原子性、一致性、隔离性、持久性）；SQL = Structured Query Language（结构化查询语言）

PostgreSQL 是最流行的**开源关系型数据库**（RDBMS），以完整 SQL 标准支持、强大的扩展能力和宽松的开源协议著称。

### 核心特点

- **完整 SQL 标准 + ACID 事务**：事务保证原子性、一致性、隔离性、持久性
- **MVCC 并发控制**：Multi-Version Concurrency Control（多版本并发控制），读写互不阻塞
- **丰富类型**：JSONB、数组、几何等
- **扩展体系**：PostGIS（地理信息）、pgvector（向量检索）
- **BSD 协议**：Berkeley Software Distribution（伯克利软件发行版协议），完全免费可商用

### 与主流数据库对比

| | PostgreSQL | MySQL | SQL Server | Oracle |
|---|---|---|---|---|
| 开源 | ✅ BSD | ✅ GPL（GNU General Public License） | ❌ | ❌ |
| 复杂度 | 高功能 | 轻量 | 微软系 | 企业重型 |

### 相关生态

Hologres 兼容 PostgreSQL 协议——懂 PostgreSQL 就会写 Hologres 查询（见 [[Apache Flink 流处理]] 的实时数仓链路）。

### 应用

- 数据密集场景选用 PostgreSQL，充分利用 JSONB、向量检索等丰富类型
- 掌握 PostgreSQL 语法后即可平滑编写 Hologres 查询

> 📌 来源：CC 对话记录 conversation-log（2026-08-03）
