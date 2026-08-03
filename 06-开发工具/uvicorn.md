---
name: uvicorn
description: Uvicorn 异步 Web 服务器、ASGI/WSGI 区别与生产部署模式
metadata:
  node_type: memory
  type: knowledge
---

## Uvicorn

Uvicorn 是基于 **ASGI 协议**的 Python 高性能异步 Web 服务器，FastAPI 官方推荐。

## 层次关系

服务器与框架是不同层：**FastAPI 写业务逻辑，Uvicorn 接 HTTP 请求**。

## ASGI vs WSGI

| | WSGI | ASGI |
|---|---|---|
| 同步/异步 | 同步 | 异步 |
| WebSocket | 不支持 | 支持 |
| 性能 | 标准 | 更高 |

性能来源：asyncio + uvloop + httptools。

## 部署模式

- 开发：`--reload` 热重载
- 生产：**Gunicorn + Uvicorn** 混合模式（Gunicorn 管进程，Uvicorn 跑 Worker）

> 📌 来源：CC 对话记录 conversation-log（2026-08-03）
