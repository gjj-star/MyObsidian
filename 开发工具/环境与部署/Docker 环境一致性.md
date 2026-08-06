---
name: Docker 环境一致性
node_type: memory
type: knowledge
description: Docker 环境一致性的原理、解决"在我机器上能跑"问题的三层保障与局限
originSessionId: 1d96bcb2-b3c5-46cd-b222-e16e5ba9566b
aliases: [docker-environment-consistency, 环境一致性, Environment Consistency]
tags: [开发工具, 环境与部署]
---

环境一致性是 Docker 的核心价值，用于解决经典问题——"在我机器上能跑"（Works on My Machine）。

**英文**：Environment Consistency（环境一致性）

## 要点：不一致的来源

操作系统（OS, Operating System）、运行时版本、系统级依赖库（如 libssl、glibc）、环境变量/配置、隐式全局安装、时区/locale/编码差异。

## 要点：三层保障

1. **镜像 = 环境快照**：只读的完整文件系统，包含 OS 基础层、运行时、依赖、代码与配置。
2. **容器 = 镜像原样运行**：容器内世界由镜像决定，不受宿主机装了什么影响。
3. **Dockerfile = 声明式定义**：环境写成代码，可版本控制、可复现。如 `FROM python:3.11` 锁定版本、`ENV TZ` 锁定时区。

## 应用：连锁好处

- 新人快速上手
- CI/CD 可信（持续集成/持续交付，Continuous Integration / Continuous Delivery）：测试通过 ≈ 上线能跑
- 回滚确定
- 跨平台交付

## 局限（不保证的部分）

- **数据一致性**：需迁移脚本（Migration）/ 种子数据（Seed Data）
- **外部依赖一致性**：需配置管理
- **内核相关行为**：容器共享宿主机内核，无法隔离内核差异

## 相关

- [[Docker 基础]] — 容器化平台的基础概念
- [[声明式范式 Declarative Paradigm]] — Dockerfile 即"环境写成代码"的声明式定义
