---
name: docker-environment-consistency
description: "Docker 环境一致性的原理、解决\"在我机器上能跑\"、三层保障与局限"
metadata: 
  node_type: memory
  type: knowledge
  originSessionId: 1d96bcb2-b3c5-46cd-b222-e16e5ba9566b
---

环境一致性是 Docker 核心价值，解决经典问题"在我机器上能跑"。

**不一致来源**：操作系统、运行时版本、系统级依赖库（libssl/glibc）、环境变量/配置、隐式全局安装、时区/locale/编码。

**三层保障**
1. 镜像 = 环境快照（只读完整文件系统，含 OS 基础层、运行时、依赖、代码、配置）。
2. 容器 = 镜像原样运行（容器内世界由镜像决定，不受宿主机装了什么影响）。
3. Dockerfile = 声明式定义（环境写成代码，可版本控制、可复现，如 `FROM python:3.11` 锁版本、`ENV TZ` 锁时区）。

**连锁好处**：新人快速上手、CI/CD 可信（测试通过≈上线能跑）、回滚确定、跨平台交付。

**局限（不保证）**：数据一致性（需迁移脚本/种子数据）、外部依赖一致性（需配置管理）、内核相关行为（容器共享宿主机内核）。
