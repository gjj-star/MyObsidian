---
name: FDE 职业知识卡
description: FDE（前线部署工程师）岗位知识卡：定义、技术栈六阶段、国内岗位切入点与实习练兵法
metadata:
  node_type: memory
  type: reference
aliases:
  - fde-career-knowledge
  - FDE
  - Field Deployment Engineer
---

# FDE 职业知识卡

**英文**：Field Deployment Engineer（FDE，前线部署工程师）

> 本文提取自 CC 对话记录中的两份计划笔记（fde-learning-roadmap / guojinjia-fde-plan），原计划已移出知识库，保留在 conversation-memories 仓库。

## FDE 是什么

让产品在**客户真实环境**里跑起来的人——一半工程师 + 一半现场顾问。代表公司：Palantir。

核心能力：**写代码 + 读代码 + 调试生产环境 + 搞定客户**。详细对比见 [[PM 与 FDE 对比]]。

## 技术栈六阶段

| 阶段 | 内容 | 周期 |
|---|---|---|
| 0 计算机基础 | Linux、TCP/IP 网络、命令行、Git | 3-4 周 |
| 1 后端语言 | Python（脚本、API 对接、pytest） | 8-12 周 |
| 2 Linux+网络实操 | 网络诊断、Shell、SSH（Secure Shell，安全外壳协议）隧道、日志 | 4-6 周 |
| 3 容器+基础设施 | Docker、K8s（Kubernetes）、云服务、CI/CD（持续集成/持续交付） | 6-8 周 |
| 4 企业集成 | SSO（Single Sign-On，单点登录）/OAuth/SAML、API 网关、PG（PostgreSQL）、数据格式、TLS（Transport Layer Security，传输层安全协议） | 4-6 周 |
| 5 软技能 | 需求捕捉、Demo、冲突管理、文档、英语 | 持续 |

客户集成问题 80% 是网络问题；FDE 日常 70% 是 Python 脚本。

## 国内岗位切入点

| 岗位 | 匹配度 | 说明 |
|---|---|---|
| 解决方案工程师/SA（Solutions Architect） | 5/5 | 技术+沟通，最接近 |
| 交付工程师 | 4/5 | 数据迁移+环境部署 |
| 客户成功工程师/CSE（Customer Success Engineer） | 4/5 | 偏持续运营 |
| 技术顾问（实施方向） | 3/5 | 业财/SaaS 对口 |
| TAM（Technical Account Manager，技术客户经理） | 3/5 | 偏关系维护 |
| DevRel（Developer Relations，开发者关系） | 2/5 | 偏社区 |

目标公司：B2B 企业软件公司（数据库/安全/云厂商专业服务、Palantir 类）。

## 实习即训练场（AIBP 业财 = FDE 练兵场）

| 实习场景 | 练到的 FDE 技能 |
|---|---|
| 客户数据导入/清洗 | Python 自动化、数据格式转换、幂等性 |
| 看同事部署/配置系统 | Linux 实操、环境配置 |
| 旁听客户需求会议 | 需求捕捉、方案翻译 |
| 跟排查系统报错 | 读日志、调试、根因分析 |
| 写部署文档/操作手册 | 技术文档写作 |
| 对接客户 SSO | OAuth/OIDC（OpenID Connect）/SAML |
| 客户环境数据库操作 | SQL 实战、备份恢复 |

> **原则：脏活累活（数据迁移、环境部署、问题排查）主动举手——这就是 FDE 的本职工作。**

## 竞争力差异（个人视角）

技术（Linux/Docker/后端）可快速补齐；**产品思维 + 客户沟通 + AI 落地经验**三合一很难得。个人背景见 [[个人画像]]；OA 项目是黄金练兵场，见 [[OA 与 FDE 岗位的关系]]。
