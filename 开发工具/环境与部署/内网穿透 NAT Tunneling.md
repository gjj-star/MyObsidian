---
name: 内网穿透 NAT Tunneling
node_type: memory
type: knowledge
description: 内网穿透（NAT 穿透）的原理、常用工具与安全注意事项
aliases: [nat-traversal, nat-tunneling, NAT Tunneling, 内网穿透, NAT 穿透]
tags: [开发工具, 环境与部署]
---

内网穿透（NAT 穿透）是让**外网设备能访问内网服务**的技术。

**英文**：NAT（Network Address Translation，网络地址转换）

## 要点：核心原理

通过中转服务器建立隧道：内网机器**主动连接**中转服务器（绕开 NAT 限制），外网请求经中转服务器转发到内网服务。关键点：连接由内网发起，所以防火墙/NAT 拦不住。

## 对比：常用工具

| 工具 | 特点 |
|---|---|
| frp | 自托管、功能全（基于 Go 实现，见 [[Go 语言 Golang]]） |
| ngrok | 即开即用、免费额度 |
| Cloudflare Tunnel | 依托 Cloudflare 全球网络，免公网 IP |

## 应用与安全注意

隧道会把内网服务暴露到公网，务必加认证、限 IP、及时关停。

## 相关

- [[Uvicorn 异步服务器]] — 本地 Web 服务暴露公网的典型场景
- [[HTTP 状态码]] — 经网关转发时的 502/504 错误排查

> 来源：CC 对话记录 conversation-log（2026-07-27）
