---
name: 拉取上游模型
node_type: memory
type: reference
description: 查询 API 请求地址背后的上游模型清单与实际模型：OpenAI 兼容端点、Anthropic 原生端点差异，及中转/代理场景的溯源技巧
modified: 2026-08-14T08:58:17.000Z
aliases: [Fetch Upstream Model, 上游模型查询, 模型清单拉取, fetch-upstream-model]
tags: [开发工具, 环境与部署]
---

# 拉取上游模型 Fetch Upstream Model

**英文**：Upstream Model（上游模型）；ANTHROPIC_BASE_URL（API 端点配置）；OpenAI 兼容接口（OpenAI-Compatible API）；LiteLLM / CC Switch（模型中转站）

"请求地址"指 Claude Code 里配置的 API 端点——`~/.claude/settings.json` 的 env 块中 `ANTHROPIC_BASE_URL`。"上游模型"指这个地址背后实际提供服务的模型。拉取上游模型 = 向该地址发请求，问它"你能提供哪些模型 / 你实际用的是哪个模型"。

## 方法一：拉取模型清单

### OpenAI 兼容接口（实测可用）

```bash
curl -s "https://api.deepseek.com/v1/models" \
  -H "Authorization: Bearer $ANTHROPIC_AUTH_TOKEN"
```

实测返回：

```json
{"object":"list","data":[
  {"id":"deepseek-v4-flash","object":"model","owned_by":"deepseek"},
  {"id":"deepseek-v4-pro","object":"model","owned_by":"deepseek"}
]}
```

注意：DeepSeek 的 `/models`（不带 /v1）同样可用；OpenAI 官方地址则是 `https://api.openai.com/v1/models`。

### Anthropic 原生接口（兼容转接常不支持）

```bash
curl -s "https://api.deepseek.com/anthropic/v1/models" \
  -H "x-api-key: $ANTHROPIC_AUTH_TOKEN" \
  -H "anthropic-version: 2023-06-01"
```

实测返回 **HTTP 404**——DeepSeek 的 Anthropic 兼容接口没实现模型清单端点（Anthropic 官方 `https://api.anthropic.com/v1/models` 是支持的）。结论：**转接兼容接口时，模型清单优先走 OpenAI 兼容路径**。

## 方法二：查当前实际使用的上游模型

1. **Claude Code 内**：`/status` 查看当前会话模型；`/model` 切换模型
2. **配置溯源**：`~/.claude/settings.json` 的 `ANTHROPIC_MODEL`（当前为 `deepseek-v4-pro[1M]`）；OMC 层级别名映射 `ANTHROPIC_DEFAULT_SONNET_MODEL` 等（本机 sonnet/opus/fable → deepseek-v4-pro[1M]，haiku → deepseek-v4-flash）
3. **响应回显**：OpenAI 兼容格式的响应体里 `model` 字段会回显实际使用的模型 ID

## 中转/代理场景溯源技巧

走 LiteLLM、CC Switch 等中转站时，本地配置只能看到中转地址，真实上游藏在：

- **响应头**：`x-litellm-model-api-base`（真实上游地址）、`x-litellm-model-id`（真实模型 ID）
- **中转站配置文件**：LiteLLM 的 `config.yaml` 里 `model_list` 定义了"暴露名 → 真实模型"的映射

## 相关

- [[Ollama 概览]] — 本地模型服务的端点与模型管理
