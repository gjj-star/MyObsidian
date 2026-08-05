---
name: HTTP 状态码
description: HTTP 状态码五大类全景、日常最常用的 14 个及非标准码（代理/云厂商）
metadata:
  node_type: memory
  type: knowledge
aliases:
  - http-status-codes
  - HTTP Status Codes
---

## HTTP 状态码

**英文**：HTTP = HyperText Transfer Protocol（超文本传输协议）

HTTP 状态码（HTTP Status Code）是服务器在处理客户端请求后返回的三位数字代码，用于告知请求的处理结果。首位数字决定类别归属，共分五大类，从信息响应到服务端错误。

### 五类全景

| 类别 | 英文 | 含义 | 常见码 |
|---|---|---|---|
| 1xx | Informational | 信息响应 | 100-103 |
| 2xx | Success | 成功 | 200 / 201 / 204 / 206 |
| 3xx | Redirection | 重定向 | 301 / 302 / 304 / 307 / 308 |
| 4xx | Client Error | 客户端错误 | 400-451 |
| 5xx | Server Error | 服务端错误 | 500-504 |

### 日常最常用 14 个

**2xx 成功**

- **200 OK** 成功；**201 Created** 已创建；**204 No Content** 无内容；**206 Partial Content** 部分内容（分块下载）

**3xx 重定向**

- **301 Moved Permanently** 永久重定向 vs **302 Found** 临时重定向（缓存差异是经典坑）；**304 Not Modified** 未修改（缓存命中）；**307 Temporary Redirect / 308 Permanent Redirect** 保留请求方法的重定向

**4xx 客户端错误**

- **400 Bad Request** 请求错误；**401 Unauthorized** 未认证 vs **403 Forbidden** 无权限（易混）；**404 Not Found** 不存在；**405 Method Not Allowed** 方法不允许；**422 Unprocessable Entity** 参数校验失败；**429 Too Many Requests** 限流

**5xx 服务端错误**

- **500 Internal Server Error** 服务器内部错误；**502 Bad Gateway** 网关错误；**503 Service Unavailable** 服务不可用；**504 Gateway Timeout** 网关超时

### 非标准码（代理/云厂商）

- Cloudflare 52x：520-530（**524** = 源站响应超时）
- Nginx **499**（客户端断开）；AWS ELB 460/463；IIS 440/449

### 应用

- 排查接口问题时先按首位数字定位类别，再对照具体码值
- 缓存相关优先检查 304 与缓存头配置；重定向注意 301/302 的缓存语义差异
- 网关层出现 502/503/504 时，结合 524 等非标准码判断是源站超时还是服务不可用

## 相关

- [[BOSS 直聘爬虫搭建]] — 爬虫需处理 403/429 等反爬状态码
- [[Uvicorn 异步服务器]] — Web 服务返回状态码的现场
- [[内网穿透 NAT Tunneling]] — 502/504 等网关错误的典型来源

> 来源：CC 对话记录 conversation-log（2026-07-29）
