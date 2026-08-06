---
name: ollama-overview
description: Ollama 是什么、优势和劣势、适用场景
metadata: 
  node_type: memory
  type: reference
  originSessionId: ccaa9fff-80e5-4190-ab19-dc67c8a34ec5
---

Ollama 是一个在本地电脑上运行大语言模型（LLM）的工具。

## 核心特点

- 本地运行 — 模型下载到本地，数据不出机器，无需联网
- 一键启动 — 类似 Docker 的体验，`ollama run llama3` 即可在本地跑起模型
- 开源免费 — 完全开源，模型量化后能在消费级硬件（甚至笔记本）上运行
- API 兼容 — 提供与 OpenAI API 兼容的接口，方便开发时切换
- 支持模型多 — Llama、Mistral、Gemma、Qwen、DeepSeek 等主流开源模型均可一键拉取运行

## 优势

- 数据隐私：所有数据在本地处理，不上传云端
- 零成本推理：除电费和硬件外，无 API 调用费用
- 离线使用：不依赖网络
- 低延迟：无网络往返
- 生态兼容：兼容 OpenAI API，代码稍改 endpoint 即可切换
- 可控性强：自由切换模型版本、调参数，不受服务商限流/下架影响

## 劣势

- 硬件门槛：70B 模型需要高端 GPU
- 能力差距：开源模型在复杂推理和代码生成上不如 Claude 4 / GPT-4
- 显存/内存常驻：不像云端用完即释放
- 维护成本：需自己管理模型更新、版本兼容、量化选择
- 量化精度损失：4bit/8bit 量化会降低精度
- 缺少开箱即用的高级特性：如 Agent 编排、Artifacts 等

## 适用场景

适合：隐私优先、高频调用、预算敏感、实验/学习
不适合：追求最强推理能力、复杂代码生成、不想折腾硬件
