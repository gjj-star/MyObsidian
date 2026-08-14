---
name: SSE 流式解析
node_type: memory
type: knowledge
description: HTTP 之上的服务端单向推送技术（Server-Sent Events），及流式解析的跨 chunk 截断与缓冲区管理
modified: 2026-08-07
aliases: [sse-stream-parsing, SSE, Server-Sent Events, 服务端事件推送]
tags: [开发工具, 编程与数据]
---

SSE（Server-Sent Events）是 **HTTP 之上的服务端单向推送技术**，数据格式为 `event:` / `id:` / `data:` 文本行 + 双换行分隔。

**英文**：Server-Sent Events（SSE）

## 要点

- **单向推送**：服务端 → 客户端，基于普通 HTTP，无需 WebSocket 的握手与双向通道
- **消息边界**：双换行 `\n\n` 分隔事件，`data:` 帧为负载
- **流式解析核心挑战**：跨 chunk 截断——不完整行、不完整消息，需要缓冲区管理（累积缓冲，按边界切分）
- **LLM 场景**：实现"打字机效果"的主流方式，每个 token 通过 `data:` 帧推送 JSON，最后一帧为 `data: [DONE]`

> 来源：CC 对话记录 conversation-log（2026-08-07）
