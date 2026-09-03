---
name: Jinja 模板引擎与 Chat Template
node_type: memory
type: knowledge
description: Jinja2 模板 DSL 的来历与约束，以及它如何成为 LLM Chat Template 事实标准——把结构化对话"编译"为模型训练时一致的 token 序列
modified: 2026-09-03T06:42:38.000Z
aliases:
  - Jinja
  - Jinja2
  - 聊天模板
  - Chat Template
  - chat template
tags: [开发工具, 编程与数据]
---

# Jinja 模板引擎与 Chat Template

**英文**：Jinja2（模板引擎 Template Engine）；Chat Template（聊天模板）；DSL（Domain-Specific Language，领域专用语言）；tokenizer（分词器）

Jinja（发音近"金加"，日语"神社"之意）是**模板引擎**，最早为 Python Web 框架（Flask）设计，核心问题：如何把结构化数据稳定、可控地填充进文本结构。`Hello, {{ name }}!` + `name="Alice"` → `Hello, Alice!`。

## 为什么是"受限的 DSL"

Jinja 支持变量替换之外的**受限控制结构**：`{% for %}`/`{% if %}` 循环条件、`| upper` 过滤器。但它不是通用编程语言——没有自由的 import、没有 I/O、没有任意副作用，可沙箱化。本质是"用于描述文本拼接规则的 DSL"。

- 模板看起来像代码，但只是**确定性编译文本**的规则
- 这一约束正是它后来被 LLM 工具链选中的关键

## 来历

- Armin Ronacher 约 2006 年开发，2008 年彻底重写并命名 **Jinja2**（早期版本弃用，现代所指皆 Jinja2）
- 设计受 Django 模板系统影响，但表达力与扩展性更强
- 前后端未分离时代用于服务端动态生成 HTML；React/Vue 兴起后淡出 Web 主流，作为成熟文本模板工具留在 Python 生态

## LLM 时代的角色：Chat Template

**问题**：多轮对话如何变成模型接受的 token？不同模型输入格式完全不同——LLaMA 用 `[INST]...[/INST]`、Mistral 加 `<s>`、ChatGLM 用 `[Round 1] 问/答`、ChatML 用 `<|im_start|>user...<|im_end|>`。根本原因：**推理输入格式必须与训练数据格式一致**，否则模型无法区分角色或输出粘连。

**Hugging Face 方案（2023 年正式引入）**：把"对话→输入文本"的规则写成 Jinja 模板，作为模型元数据随 tokenizer 一起发布（`tokenizer_config.json` 的 `chat_template` 字段）。使用方只需 `tokenizer.apply_chat_template(messages)` 即得该模型期望的输入文本。模型作者写一次模板，vLLM/TGI/FastChat 等推理框架全部自动适配——prompt 构造从代码里"外包"给可配置、可序列化的模板系统。

```django
{% for message in messages %}
{% if message.role == 'user' %}
[INST] {{ message.content }} [/INST]
{% elif message.role == 'assistant' %}
{{ message.content }}</s>
{% endif %}
{% endfor %}
```

类比：用户传来的 messages（JSON 角色区分）是结构化中间表示，Jinja chat template 是编译规则，渲染结果是模型实际接收的 token 流。**Jinja 不是在生成文本，而是在确定性地编译文本。**

## 为什么偏偏是 Jinja2

- Mako：模板几乎等同 Python，能力过强，安全边界难控制
- Django Template：表达力偏弱，心智负担重
- Mustache：无条件与循环，处理不了真实对话

Jinja 胜出：表达力刚好够用（for/if/filter）、默认无副作用易沙箱化、Python 生态成熟、模板本身是字符串可直接放进 JSON 配置。

## 相关

- [[声明式范式 Declarative Paradigm]] — 模板即声明式描述"文本如何拼接"，与命令式逐行拼接相对
- [[RAG 检索增强生成 Retrieval-Augmented Generation]] — prompt 侧工程生态的另一环（上下文组装）

> 来源：网页剪藏《Jinja 是什么？为什么大模型的聊天模板使用它？》（博客园，2026-09-02 入库；原文 2026-01-12）
