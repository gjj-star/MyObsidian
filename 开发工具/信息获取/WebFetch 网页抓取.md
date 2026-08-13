---
name: WebFetch 网页抓取
node_type: memory
type: reference
description: Claude Code 内置 WebFetch 工具的核心参数、工作流程、关键限制（SPA/登录墙/缓存）与权限配置，及配合 WebSearch 的信息获取玩法
modified: 2026-08-13T02:30:07.000Z
aliases: [WebFetch]
tags: [开发工具, 信息获取]
---

# WebFetch 网页抓取

**英文**：WebFetch（网页抓取）；WebSearch（网页搜索）；SSR（Server-Side Rendering，服务端渲染）；SPA（Single Page Application，单页应用）

WebFetch 是 Claude Code 内置的网络内容获取工具，通过 HTTP 下载网页 → 转 Markdown → 返回给模型阅读。本质是一个**服务端 HTTP 客户端 + HTML→Markdown 转换器**。

## 核心参数

| 参数 | 必填 | 说明 |
|------|------|------|
| `url` | ✓ | 要抓取的网页地址 |
| `prompt` | 否 | 对抓取内容的提取/分析指令（如"提取所有 API 方法名"） |
| `start_line` | 否 | 从第几行开始返回（截取行范围） |
| `end_line` | 否 | 返回到第几行为止 |

## 工作流程

```
用户指定 URL → HTTP GET 请求获取原始 HTML → HTML 转 Markdown（保留标题、列表、代码块等结构）→ 默认上限约 5000 行（超出截断）→ 注入上下文供模型阅读/分析/回答
```

## 关键限制

| 限制 | 说明 |
|------|------|
| **不执行 JavaScript** | SPA（React/Vue 等）纯客户端渲染的页面抓不到内容，只拿到空壳 HTML |
| **需登录的页面失败** | 无法穿过登录墙（除非配置 Cookie，默认不支持） |
| **跨域重定向不自动跟随** | 需手动处理跳转后的 URL |
| **robots.txt 限制** | 遵循网站 robots.txt 规则 |
| **15 分钟缓存** | 同一 URL 15 分钟内重复请求返回缓存结果 |
| **大小限制** | 约 5000 行上限，超长页面会被截断 |

## 权限控制

在 `settings.json` 中配置白名单/黑名单：

```json
{
  "permissions": {
    "allow": ["WebFetch(https://docs.python.org/**)"],
    "deny": ["WebFetch(https://internal.company.com/**)"]
  }
}
```

支持通配符 `**` 匹配路径。

## 典型使用场景

1. **查官方文档**：直接读 docs.python.org、nodejs.org 等的最新文档
2. **配合 WebSearch**：先搜网址再读内容——WebSearch 找页面 URL → WebFetch 把页面内容拉下来细读
3. **读 GitHub README / Release Notes**：拿项目的最新说明
4. **抓 API 文档**：读接口定义、参数说明

## 相关

- [[AI 文献检索能力]] — 与 WebSearch 配合完成检索闭环
- [[学术文献获取渠道]] — 文献获取的渠道体系
- [[BOSS 直聘爬虫搭建]] — 网页抓取的实践案例
