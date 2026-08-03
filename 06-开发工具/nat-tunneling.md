---
name: nat-tunneling
description: 内网穿透（NAT 穿透）的原理、常用工具与安全注意事项
metadata:
  node_type: memory
  type: knowledge
---

## 内网穿透

内网穿透（NAT 穿透）是让**外网设备能访问内网服务**的技术。

## 核心原理

通过中转服务器建立隧道：内网机器**主动连接**中转服务器（绕开 NAT 限制），外网请求经中转服务器转发到内网服务。关键点：连接由内网发起，所以防火墙/NAT 拦不住。

## 常用工具

| 工具 | 特点 |
|---|---|
| frp | 自托管、功能全（基于 Go 实现，见 [[golang]]） |
| ngrok | 即开即用、免费额度 |
| Cloudflare Tunnel | 依托 Cloudflare 全球网络，免公网 IP |

## 安全注意

隧道会把内网服务暴露到公网，务必加认证、限 IP、及时关停。

> 📌 来源：CC 对话记录 conversation-log（2026-07-27）
