---
name: fde-learning-roadmap
description: FDE（前线部署工程师）从零开始的学习路线、技术栈、实操项目、模拟方法和岗位入口
metadata: 
  node_type: memory
  type: reference
  originSessionId: 6434b0ca-7bb1-4a64-85ca-7e2874794df9
---

# FDE 从零学习路线

## 什么是 FDE
让产品在客户真实环境里跑起来的人。一半工程师 + 一半现场顾问。代表公司：Palantir。
核心能力：写代码 + 读代码 + 调试生产环境 + 搞定客户。

> 详见 [[pm-vs-fde-comparison]] 中的定义与对比。

## 技术栈学习路线（按顺序）

### 阶段 0：计算机基础（3-4 周）
- **操作系统基础**：Linux 是 FDE 默认工作环境
- **网络基础**：TCP/IP、DNS、HTTP/HTTPS、端口、防火墙——客户集成问题 80% 是网络
- **命令行**：`ssh` `curl` `grep` `awk` `sed` `systemctl` `journalctl`
- **Git**：客户站点定制代码的版本管理、patch、cherry-pick

### 阶段 1：后端语言 Python（8-12 周）
- **为什么首选 Python**：FDE 日常工作 70% 是脚本——数据迁移、API 对接、日志分析。Python 写这些最快。Java/Go 是第二阶段
- 基础语法 → 文件 I/O（CSV/JSON/XML/Parquet）→ 数据库操作（SQL + DB-API/SQLAlchemy）
- API 调用：`requests`/`httpx`，处理认证（API Key / OAuth / JWT）、分页、错误重试
- 脚本自动化：数据清洗、批量处理、定时任务
- 测试：`pytest`，至少能写集成测试

### 阶段 2：Linux + 网络实操（4-6 周）
- Linux 基础：用户/权限、进程管理、systemd、cron
- 网络诊断：`ping` `traceroute` `nslookup` `tcpdump` `netstat -tlnp` `ss` `curl -v`
- Shell 脚本：bash 写部署脚本、健康检查、日志轮转
- SSH 隧道：端口转发、跳板机——客户环境经常在内网
- 日志管理：`journalctl` `tail -f` `grep`、ELK 基础概念

### 阶段 3：容器 + 基础设施（6-8 周）
- Docker：Dockerfile、docker-compose、多阶段构建、卷挂载、网络模式
- Kubernetes 基础：Pod/Service/Deployment/ConfigMap/Secret、kubectl 常用操作
- 云服务基础：AWS/Azure/GCP 三选一，学 VM、网络、存储、IAM
- CI/CD 概念：GitHub Actions 配一个简单流水线

### 阶段 4：企业集成技术（4-6 周）
- SSO / OAuth 2.0 / SAML：客户集成第一关就是单点登录
- API 网关：Nginx / Kong 基础、反向代理、限流、认证
- 数据库：PostgreSQL 增删改查 + 导入导出 + 备份恢复（pg_dump/pg_restore/WAL）
- 数据格式：CSV / JSON / XML / Parquet / Avro——不同客户给不同格式
- 加密基础：TLS 证书、SSH Key、PGP——客户安全审核必备

### 阶段 5：软技能（持续培养）
- 需求捕捉：客户说"我想要个报表"→ 追问数据源、频率、受众、权限
- 技术演示：能给 5 个 CTO 现场 Demo 不翻车
- 冲突管理：客户环境炸了，一个人在机房，对面是焦虑的技术总监
- 文档写作：部署手册、故障报告、知识转移文档
- 英语：FDE 客户经常跨国，文档和邮件基本英文

## 实操项目（按难度递进）

### 入门级
1. **数据迁移脚本**：Excel/CSV → 清洗 → PostgreSQL，练 Python + pandas + SQL 写入 + 幂等性
2. **服务器健康检查脚本**：SSH → 检查 CPU/内存/磁盘/服务状态 → 输出报告，练 bash + Linux 系统命令
3. **API 集成适配器**：A 系统 REST API → 数据转换 → B 系统 REST API，练 requests + 认证 + 错误重试 + 定时调度

### 进阶级
4. **Docker 化部署方案**：开源应用 + 数据库 + Nginx 的 docker-compose 编排，练 Dockerfile + 卷持久化 + 网络配置
5. **SSO 集成 Demo**：Web 应用 + OAuth 2.0（Google/GitHub/Keycloak），理解授权码流程、token 刷新、SAML 基础
6. **日志聚合+告警**：Filebeat → Elasticsearch → Kibana + 阈值告警，练 ELK 栈 + 日志格式规范

### 项目级
7. **完整客户部署方案**：部署架构图 + 网络拓扑 + Docker Compose/K8s YAML + 安装文档 + 运维手册 + 故障排查指南
8. **K8s 多租户部署**：Namespace 隔离 + ConfigMap/Secret + Ingress + 资源限制 + 水平扩缩 + Helm Chart
9. **客户数据集成平台（微型）**：多数据源连接器 + 错误隔离 + 重试 + 状态监控
10. **灾备+恢复演练**：数据库故障 → 备份恢复 → 数据完整性验证 → 复盘报告

## 没有客户环境怎么模拟
| 模拟方式 | 练什么 |
|----------|--------|
| 在本地 VM 里把网络配错再修复 | 网络排错直觉 |
| 用 VirtualBox/Proxmox 搭"客户内网" | 内网环境、跳板机、代理、防火墙 |
| 找开源项目提 Issue 帮修 Bug | 读陌生人代码 + 调试 |
| 参加 Hackathon 做集成类项目 | 限时压力 + 不熟悉的技术栈 |
| 找小公司免费帮做技术集成 | 真实需求 + 沟通历练 |

## 找工作切入点（国内 FDE 相关岗位）
| 岗位 | 匹配度 | 说明 |
|------|--------|------|
| 解决方案工程师/SA | ⭐⭐⭐⭐⭐ | 技术+沟通，FDE 最接近的国内岗位 |
| 交付工程师 | ⭐⭐⭐⭐ | 数据迁移+环境部署，直接对应 |
| 客户成功工程师/CSE | ⭐⭐⭐⭐ | 偏持续运营，技术要求稍低 |
| 技术顾问（实施方向） | ⭐⭐⭐ | 业财/SaaS 领域直接对口 |
| TAM | ⭐⭐⭐ | 偏关系维护+技术协调，沟通要求高 |
| DevRel/Developer Advocate | ⭐⭐ | 偏社区，外向型工程师 |

目标公司类型：B2B 企业软件公司（数据库厂商、安全厂商、云厂商专业服务部门、Palantir 类公司）。

## 与 PM 的核心区别
| | FDE | PM |
|---|---|---|
| 核心产出 | 跑在客户环境里的系统 | PRD/路线图 |
| 技术深度 | **必须能写** | 能听懂就行 |
| 节奏 | 客户节奏（不定时） | 迭代节奏（定周期） |
| 供需 | **严重稀缺** | 供给过剩 |
| 出差 | 多 | 少 |
