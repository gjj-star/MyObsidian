---
name: 软件环境划分 Environment Tiers
node_type: memory
type: knowledge
description: 软件交付链路的环境划分——DEV/Test/SIT/UAT/Staging/Prod/DR 各环境职责、部署内容与注意事项，及预生产到生产的切换策略
modified: 2026-09-09T03:30:00.000Z
aliases: [DEV, SIT, UAT, Staging, Prod, DR, 环境划分, 开发测试环境, Disaster Recovery]
tags: [开发工具, 环境与部署]
---

# 软件环境划分 Environment Tiers

**英文**：DEV（Development Environment，开发环境）；SIT（System Integration Test，系统集成测试环境）；UAT（User Acceptance Test，用户可接受性测试环境）；Staging（预生产环境）；Prod（Production，生产环境）；DR（Disaster Recovery，灾备环境）；Dry Run（预演）

软件从代码到上线的完整链路按阶段划分为多个环境，每个环境部署带版本组件并跑对应层级的验证。越往后越接近生产、越不能出错。

## 环境链路

| 环境 | 职责 | 验证内容/注意事项 |
| --- | --- | --- |
| DEV（开发环境） | 开发自测 | 源代码编译打包；单元测试 + 服务 API 自动化测试 + 服务 UI 自动化测试 |
| Test（测试环境） | 版本级测试 | 部署带版本组件；API 与 UI 自动化测试 |
| SIT（系统集成测试） | 多系统联调 | 在 Test 基础上加**多系统集成 API 与 UI 测试**——验证系统间接口契约 |
| UAT（用户验收测试） | 客户验收 | 用户（客户方）按需求/功能文档直接参与验收；按合同可能需出具功能性/安全/性能测试报告 |
| Staging（预生产） | 上线前最后验证 | 基本健康测试（自动/手工）；常用**生产真实数据 Dry Run**（在正常生产的配置与网络条件下预演），通过后切换或直接上线 |
| Prod（生产） | 正式对外 | 稳定优先，变更走发布流程 |
| DR（灾备） | 灾难恢复 | 对可用性/连续性有特别要求的系统（如国计民生类）需异地灾备 |

## 从 Staging 切到 Prod 的常用策略

预生产到生产的集群切换方法：**蓝绿部署**（Blue-Green）、**A/B 测试**、**金丝雀部署**（Canary，灰度发布）——环境演练通过后把流量逐步/整体切到生产集群。

## 相关

- [[CI-CD 持续集成与交付]] — 流水线各阶段自动部署到对应环境（部署到 test 命名空间、灰度发布等）
- [[灰度发布 Canary Release]] — Staging → Prod 的切换策略之一
- [[Docker 环境一致性]] — 环境一致性的实现基础（"在我电脑上能跑"问题的解法）

> 来源：网页剪藏《Dev，SIT，UAT， Staging， Prod，DR环境分别是意思？》（CSDN 大象无形，大音希声，2022-09-20；2026-09-04 入库）
