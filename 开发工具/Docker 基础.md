---
name: Docker 基础
description: Docker 容器化平台的定义、容器与虚拟机对比、镜像/容器/Dockerfile 三要素与构建流水线
metadata: 
  node_type: memory
  type: knowledge
  originSessionId: 1d96bcb2-b3c5-46cd-b222-e16e5ba9566b
aliases: [docker-basics, Docker, Docker Basics, 容器化]
---

Docker 是容器化平台（Containerization Platform）：将应用及其依赖（代码、库、配置、环境变量）打包成标准化容器，使其在任何环境一致运行。

**英文**：Docker

## 对比：容器 vs 虚拟机

| 维度 | 虚拟机 VM（Virtual Machine） | 容器（Container） |
|---|---|---|
| 隔离层级 | 虚拟整台硬件 + 完整操作系统（OS, Operating System） | 共享宿主机内核，仅打包应用及所需库 |
| 体积 | GB 级 | MB 级 |
| 启动速度 | 分钟级 | 秒级 |

## 要点：三要素

- **镜像（Image）**：只读模板，容器的"安装包"
- **容器（Container）**：镜像运行起来的实例，即正在运行的进程
- **Dockerfile**：描述如何构建镜像的脚本

## 案例：构建流水线

关系链：Dockerfile → 镜像 → 容器。最小示例：

```dockerfile
FROM node:18
WORKDIR /app
COPY . .
RUN npm install
CMD ["node", "server.js"]
```

## 应用

开发、测试、生产环境的一致部署，微服务架构，CI/CD 流水线（持续集成/持续交付，Continuous Integration / Continuous Delivery）与本地开发环境的快速搭建。

## 相关

- [[Docker 环境一致性]] — 容器化带来的核心价值
- [[Uvicorn 异步服务器]] — 典型部署场景：容器里跑 Web 服务
- [[Ollama 概览]] — 本地模型也可容器化一键部署
