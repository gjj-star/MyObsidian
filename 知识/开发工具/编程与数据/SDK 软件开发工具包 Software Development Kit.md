---
name: SDK 软件开发工具包
node_type: memory
type: knowledge
description: SDK（软件开发工具包）的定义、组成、典型例子，以及与 API 的封装关系
modified: 2026-08-14T08:58:17.000Z
aliases: [SDK, Software Development Kit, 软件开发工具包, sdk]
tags: [开发工具, 编程与数据]
---

# SDK 软件开发工具包 Software Development Kit

**英文**：Software Development Kit（SDK，软件开发工具包）；API（Application Programming Interface，应用程序接口）

SDK 是某个平台或服务方提供给开发者的**"预制工具箱"**——把调用其能力所需的底层细节封装成现成的函数库、工具和文档，开发者直接 import 调用即可。

核心逻辑：**不用从零实现底层细节**（HTTP 请求、鉴权、加密、重试），一行调用搞定。

## 通常包含什么

| 组成 | 说明 |
|------|------|
| 函数库/API 封装 | 别人写好的代码，直接 import 调用 |
| 工具 | 命令行工具、调试器、模拟器等 |
| 文档 | 使用说明、API 参考 |
| 示例代码 | 拿来就能跑的 Demo |

## 典型例子

- **Anthropic SDK / OpenAI SDK**：调用大模型 API，如 `client.messages.create(...)` 一行发出请求，鉴权、重试、流式解析全被封装
- **微信 SDK**：第三方 App 接入微信登录、微信支付
- **Android SDK**：开发安卓 App 的基础工具包
- **Stripe SDK**：接入在线支付

## SDK 与 API 的关系

| 概念 | 角色 | 本质 |
|------|------|------|
| **API** | 规则说明书 | 规定"发什么格式的请求、返回什么数据"（HTTP 接口） |
| **SDK** | 做好的工具 | 把调用 API 的繁琐过程封装成现成的函数 |

**SDK 是 API 的便捷封装。** 没有 SDK 也能调用 API（自己发 HTTP 请求），有了 SDK 开发效率高得多。

## 相关

- [[SSE 流式解析]] — SDK 常把流式响应的解析封装成一行调用
- [[HTTP 状态码]] — 直接调 API 时需自行处理的状态码语义
