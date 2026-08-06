---
name: docker-basics
description: Docker 容器化平台的核心定义、容器与虚拟机的区别、镜像/容器/Dockerfile 三要素
metadata: 
  node_type: memory
  type: knowledge
  originSessionId: 1d96bcb2-b3c5-46cd-b222-e16e5ba9566b
---

Docker 是容器化平台，将应用及其依赖（代码、库、配置、环境变量）打包成标准化容器，使其在任何环境一致运行。

**容器 vs 虚拟机**
- 虚拟机：虚拟整台硬件 + 完整 OS，GB 级，分钟级启动。
- 容器：共享宿主机内核，仅打包应用及所需库，MB 级，秒级启动。

**三要素**
- 镜像 Image：只读模板（容器的"安装包"）。
- 容器 Container：镜像运行起来的实例（正在跑的进程）。
- Dockerfile：描述如何构建镜像的脚本。

关系：Dockerfile → 镜像 → 容器。最小示例：
```dockerfile
FROM node:18
WORKDIR /app
COPY . .
RUN npm install
CMD ["node", "server.js"]
```
