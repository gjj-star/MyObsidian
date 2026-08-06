---
name: Uvicorn 异步服务器
node_type: memory
type: knowledge
description: Uvicorn 异步 Web 服务器、ASGI/WSGI 的区别与生产部署模式
aliases: [uvicorn, Uvicorn, ASGI Server]
tags: [开发工具, 编程与数据]
---

Uvicorn 是基于 **ASGI 协议**的 Python 高性能异步 Web 服务器，FastAPI 官方推荐。

**英文**：Uvicorn；ASGI（Asynchronous Server Gateway Interface，异步服务器网关接口）；WSGI（Web Server Gateway Interface，Web 服务器网关接口）

## 要点：层次关系

服务器与框架是不同层：**FastAPI 写业务逻辑，Uvicorn 接 HTTP（HyperText Transfer Protocol，超文本传输协议）请求**。

## 对比：ASGI vs WSGI

| 维度 | WSGI | ASGI |
|---|---|---|
| 同步/异步 | 同步 | 异步 |
| WebSocket | 不支持 | 支持 |
| 性能 | 标准 | 更高 |

性能来源：asyncio + uvloop + httptools。

## 应用：部署模式

- 开发：`--reload` 热重载
- 生产：**Gunicorn + Uvicorn** 混合模式（Gunicorn 管进程，Uvicorn 跑 Worker）

## 相关

- [[Docker 基础]] — 生产部署常见容器化方案
- [[HTTP 状态码]] — 处理 HTTP 请求时返回的状态码语义
- [[内网穿透 NAT Tunneling]] — 本地服务暴露公网供外部调用的典型场景

> 来源：CC 对话记录 conversation-log（2026-08-03）
