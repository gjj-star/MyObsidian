---
name: Obsidian 智能体插件教程
node_type: memory
type: reference
description: Obsidian 智能体插件完整教程——Copilot V4 / Claudian / Agent Client 三方定位对比、使用方法与工作流差异，原文收录
modified: 2026-09-04T06:00:00.000Z
aliases: [Claudian, Copilot V4, Agent Client, Obsidian 智能体插件对比]
tags: [AI-Agent]
---

## 一、Copilot、Claudian 与 Agent Client 对比

### 综合对比

| 对比项              | Copilot V4                                                                                                                          | Claudian                                                                                                    | Agent Client                                                                                                               |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| 核心定位             | ✅ **把一个长期积累的 Obsidian Vault 当作 AI 工作空间使用。** 例如让 Agent 从几百篇笔记中找旧资料、围绕某个研究主题建立长期 Project、固定加载一批资料和规则，再用 Claude/Codex/OpenCode 完成整理、研究和写作 | ✅ **已经在终端里长期使用 Claude Code 或 Codex，希望几乎原样搬进 Obsidian。** 例如继续使用原来的 MCP、Skills、子智能体、模型和权限设置，同时直接修改当前笔记、查看 Diff | ✅ **同时使用很多不同 Agent，希望用 Obsidian 统一管理它们。** 例如左边 Claude、右边 Codex，再开 Hermes/Gemini，对同一个任务分别执行；也可以让 Agent 直接工作在 Vault 之外的代码项目目录 |
| 核心思想             | Agent + Project + 语义检索 + Skills + Obsidian 工作流                                                                                      | 尽量保留各 Agent 原本的模型、权限、MCP、Skill、子智能体等能力                                                                      | 通过 ACP 统一连接各种 Agent，插件尽量少干预 Agent 本身                                                                                       |
| 底层实现             | 建立统一会话层；不同 Agent 使用 SDK 或 ACP 接入                                                                                                    | 针对不同 Agent 分别适配，使用 SDK、ACP、RPC 等不同方式                                                                        | 以 **ACP（智能体客户端协议）** 为核心，统一管理各种 Agent                                                                                       |
| Obsidian 知识管理能力  | ✅ **最强**：Project、Miyo、语义检索、Quick Ask、Commands 等                                                                                     | ⚠️ 主要依赖 Agent 自己读取和搜索 Vault                                                                                 | ⚠️ 主要负责把 Obsidian 笔记提供给 Agent                                                                                              |
| 语义检索 / RAG       | ✅ **Miyo，本地语义知识检索是核心优势**                                                                                                            | ❌ 没有独立语义知识库，主要靠 Agent 搜文件                                                                                   | ❌ 没有独立语义知识库，主要靠 Agent 搜文件                                                                                                  |
| Agent 原生能力保留     | ⚠️ 做了一层统一封装，更强调一致体验                                                                                                                 | ✅ **最强**：模型、权限、MCP、Skill、插件、子智能体等暴露更完整                                                                      | ✅ Agent 原来的 MCP、Skill、命令等基本继续使用                                                                                            |
| 支持 Agent 的广度     | ⚠️ 目前重点支持 Claude Code、Codex、OpenCode                                                                                                | ✅ Claude Code、Codex、Grok、OpenCode、Pi                                                                        | ✅ **最广**：支持多种 ACP Agent，并允许添加自定义 ACP Agent                                                                                 |
| 跨 Agent 多智能体     | ✅ **Claude / Codex / OpenCode 并行执行，并自动生成汇总**                                                                                        | ⚠️ 主要使用 Claude/Codex 自己的子智能体机制                                                                              | ⚠️ 可以让多个不同 Agent 并行运行和接收同一任务，但不自动汇总                                                                                        |
| 跨 Agent Skill 管理 | ✅ **一份 Skill 可同时提供给多个 Agent**                                                                                                       | ⚠️ 更偏向使用各 Agent 自己的 Skill 目录                                                                                | ⚠️ 主要直接继承 Agent 已有 Skill                                                                                                   |
| 局部笔记编辑           | ✅ Quick Ask 等编辑工作流                                                                                                                  | ✅ **Inline Edit 很突出，可直接查看逐词修改差异**                                                                           | ✅ 可以显示 Agent 对笔记产生的修改差异                                                                                                    |
| 外部目录 / 代码项目      | ⚠️ 主要围绕当前 Vault 工作                                                                                                                  | ✅ 可以引用 Vault 外文件和目录                                                                                         | ✅ **最强，可直接把任意目录作为 Agent 工作目录**                                                                                             |
| 多人协作             | ❌                                                                                                                                   | ✅ **Collab：基于 Git + 局域网的人类协作功能，目前仍偏实验性**                                                                    | ❌                                                                                                                          |
| 本地模型             | ✅ 可通过 OpenCode、BYOK 等方式使用                                                                                                           | ✅ 取决于底层 Agent / Provider                                                                                    | ✅ 取决于底层 Agent                                                                                                              |
| 移动端              | ✅ Quick Chat 等传统 AI 功能可用；Agent 主要是桌面端                                                                                               | ❌ 桌面端                                                                                                       | ❌ 桌面端                                                                                                                      |
| 上手难度             | ✅ **最低，更适合普通 Obsidian 用户**                                                                                                          | ⚠️ 设置较多，更适合已经熟悉 Claude Code / Codex 的用户                                                                     | ⚠️ 需要理解 ACP、Agent 安装和认证                                                                                                    |
| 商业模式             | ⚠️ 插件开源；基础 Agent 可使用自己的账户/API，本身另有 Lite、Plus、Supporter 等付费服务                                                                        | ✅ 插件本身免费开源；模型/API 费用由底层服务产生                                                                                 | ✅ 插件本身免费开源；模型/API 费用由底层服务产生                                                                                                |
| 更适合谁             | **知识管理、研究、写作、自媒体、希望一站式使用 Agent 的用户**                                                                                                | **已经深度使用 Claude Code / Codex，希望保留原生 Agent 工作流的用户**                                                          | **同时使用很多 Agent，希望 Obsidian 只是统一操作界面的用户**                                                                                   |

#### Copilot
主要解决“怎么让 Agent 更好地利用我的 Obsidian 知识库”。
如果你的核心需求是**让 AI 长期使用和检索 Obsidian 里的大量知识资料**，用 Copilot。

#### Claudian
主要解决“怎么把我原来的 Claude Code/Codex 完整搬进 Obsidian”。
如果你已经有成熟的 **Claude Code / Codex 工作流，希望原来的 MCP、Skill、子智能体和权限配置继续使用**，用 Claudian。

#### Agent Client
主要解决“怎么在 Obsidian 里统一运行很多不同的 Agent”。
如果你经常同时使用 **Claude、Codex、Gemini、Hermes 等多种 Agent，希望 Obsidian 只是一个统一操作界面**，用 Agent Client。

### Agent 的连接方式

在看表格前，需要先理解三种常见方式：

- **ACP（Agent Client Protocol，智能体客户端协议）**：**给「编辑器 / 客户端」和「AI Agent」之间制定一套统一的通信标准。** 插件只要实现一次 ACP 客户端，就可以连接各种兼容 ACP 的 Agent。优势是统一、容易扩展。

```
                    ┌─ Claude
Obsidian ─┐         ├─ Codex
Zed ──────┼─ ACP ───┼─ Gemini CLI
JetBrains ┤         ├─ OpenCode
VS Code ──┘         └─ Hermes
```

- **Agent SDK（智能体开发工具包）**：由 Agent 厂商直接提供程序接口。例如 Claude Agent SDK 可以直接在插件内部驱动 Claude Agent。通常与特定 Agent 结合更深，但不能通用到其他 Agent。
- **专用接口 / RPC**：有些 Agent 提供自己的控制接口。Claudian 会针对不同 Agent 使用不同连接方式，以尽可能保留它们的原生功能。

因此，**ACP 的优势是通用，SDK / 专用接口的优势是可以针对某个 Agent 做得更深**，不存在绝对谁更先进。

| Agent | Copilot V4 | Claudian | Agent Client |
|---|---|---|---|
| **Claude Code** | ✅ 支持；通过 **Claude Agent SDK** 直接连接 | ✅ 支持；通过 **Claude Agent SDK** 连接 | ✅ 支持；安装 `claude-agent-acp` 后通过 **ACP** 连接 |
| **Codex** | ✅ 支持；通过 `codex-acp` 转换为 **ACP** 连接 | ✅ 支持；通过 Codex `app-server` 的 **JSON-RPC（程序通信接口）** 连接 | ✅ 支持；安装 `codex-acp` 后通过 **ACP** 连接 |
| **OpenCode** | ✅ 支持；通过 **ACP** 连接 | ✅ 支持；使用 OpenCode 专用适配层 | ✅ 支持；通过 **ACP** 连接 |
| **Grok Build** | ❌ 不支持 | ✅ 支持；通过 **ACP** 连接 | ❌ 当前没有内置预设 |
| **Pi** | ❌ 不支持 | ✅ 支持；通过 **Pi RPC（Pi 自己的程序接口）** 连接 | ❌ 当前没有内置预设 |
| **Gemini CLI** | ❌ 不支持 | ❌ 不支持 | ✅ 支持；通过 **ACP** 连接 |
| **Hermes Agent** | ❌ 不支持 | ❌ 不支持 | ✅ 支持；通过 **ACP** 连接 |
| **Mistral Vibe** | ❌ 不支持 | ❌ 不支持 | ✅ 支持；通过 **ACP** 连接 |
| **Kiro** | ❌ 不支持 | ❌ 不支持 | ✅ 支持；通过 **ACP** 连接 |
| **其他 ACP Agent** | ❌ 目前不能随意添加 | ⚠️ 主要支持插件已经专门适配的 Agent | ✅ **可以作为 Custom Agent（自定义智能体）添加，扩展性最强** |

从连接架构来看：

- **Copilot**：只重点支持少数 Agent，但在它们之上建立自己的 Project、Skills、Miyo 和 Multi-Agent 工作层。
- **Claudian**：不追求统一协议，而是为不同 Agent 选择最合适的接口，重点是**完整保留原生能力**。
- **Agent Client**：几乎完全围绕 ACP 设计，因此**Agent 数量和未来扩展性最好**。

### Copilot 的核心优势

| 核心功能                    | 作用                                                             | 相比其他插件的优势                                   |
| ----------------------- | -------------------------------------------------------------- | ------------------------------------------- |
| **Project**             | 在同一个 Vault 中建立多个长期任务空间，每个 Project 保存自己的规则、固定资料和聊天历史            | Claudian/Agent Client 没有同等完整的“知识工作 Project” |
| **Miyo 语义检索**           | 根据内容含义而不只是关键词搜索整个知识库                                           | 三款中只有 Copilot 有完整独立的语义知识检索层                 |
| **跨 Agent Multi-Agent** | Claude、Codex、OpenCode 并行回答同一个问题，再由当前主 Agent 汇总                 | 最适合多模型研究、Review、第二意见                        |
| **跨 Agent Skills**      | 一份 Skill 可以同时提供给 Claude、Codex、OpenCode                         | 不需要分别维护三套 Skill                             |
| **Agent + 传统 AI 工作流共存** | Agent Chat 负责复杂任务；Quick Chat、Quick Ask、Commands 负责问答、翻译、润色等轻任务 | 对普通 Obsidian 用户更完整                          |
| **模型来源完整**              | 可以使用已有 Claude/Codex 订阅、BYOK（自带 API Key）、本地模型或 Copilot 托管模型     | 非技术用户和高级用户都能找到合适路径                          |

### Claudian 的核心优势

| 核心功能 | 作用 | 相比其他插件的优势 |
|---|---|---|
| **深度复用 Agent 原生能力** | Claude/Codex 的模型、权限、MCP、Skill、子智能体等直接进入 Obsidian | 比 Copilot 更接近直接使用 Claude Code/Codex |
| **Inline Edit（行内编辑）** | 选中笔记文字 → Agent 修改 → 显示逐词差异 → 接受/拒绝 | 编辑 Markdown 的交互非常直接 |
| **Claude Code Plugins** | 直接发现和使用 Claude Code 插件 | Copilot/Agent Client 没有同等级的专门管理界面 |
| **子智能体管理** | 直接管理 Claude/Codex 的子智能体，并通过 `@` 调用 | 适合已经建立复杂 Agent 工作流的用户 |
| **丰富的 Provider 设置** | Codex 推理强度、推理摘要、沙箱，Claude 权限与用户设置等都能单独控制 | 高级 Agent 用户可控程度更高 |
| **外部文件/目录引用** | `@` 不只可以引用 Vault 笔记，也可以引用外部文件和目录 | 更适合知识库 + 代码项目混合场景 |
| **Collab** | 基于 Git 和局域网进行多人协作、Review、Diff、冲突处理 | Copilot/Agent Client 没有对应的人类协作系统 |

## 二、Copilot 与 Claudian 核心设置

### Copilot 设置

| 设置 | 含义 | 如何设置 |
|---|---|---|
| **Copilot License** | 解锁当前账户拥有的付费/终身权益 | 没有付费 License 可留空；已有 License 粘贴后 Apply |
| **Default backend** | 新 Agent Chat 默认启动哪个 Agent | 常用 Claude 就选 Claude，常用 Codex/OpenCode 同理 |
| **OpenCode** | 使用 OpenCode 作为 Agent | 可以让 Copilot 自动安装，也可以指定已有 OpenCode |
| **Claude** | 使用本机 Claude Code | 一般自动检测；使用 Claude Code 自己的登录和模型 |
| **Codex** | 使用 Codex | Copilot 当前需要 `codex-acp` 适配器，按 Configure 页面安装和登录 |
| **Copilot folder** | Copilot 保存 Project、Skills、Commands 等数据的根目录 | 默认 `copilot` 即可，一般不修改 |
| **Custom vault instructions** | 整个 Vault 的长期 Agent 规则 | 实际保存到 Vault 根目录 `AGENTS.md`，只写长期稳定规则 |
| **Autosave Chat as Markdown** | 是否把每次聊天额外保存为 Markdown 笔记 | 不想让聊天记录污染 Vault 可以关闭；Session History 仍然保留 |
| **BYOK** | 给 Quick Chat/OpenCode 配置自己的云模型或本地模型 | 根据服务填写 API Key、Base URL、模型；LM Studio/Ollama 可填本地兼容接口 |
| **Miyo → Connect** | 连接本机 Miyo 知识检索服务 | 先安装并运行 Miyo，再添加当前 Vault，回 Copilot 点击 Connect |
| **Miyo → Semantic Search** | 开启按含义搜索笔记 | 成功连接 Miyo 后建议开启 |
| **Miyo → Search Scope** | 搜当前 Vault，还是 Miyo 管理的所有资料 | 一般选 `Current vault` |
| **Miyo → Search Chat** | 搜索 Miyo 索引的 ChatGPT/Claude 历史会话 | 有需要再在 Miyo 中添加聊天数据源 |
| **Document Processor** | PDF、EPUB 等文档由谁解析 | 隐私优先选本地 Miyo；使用 Copilot 云端服务可选 Plus |
| **Skills** | 管理 Agent 可复用的专业能力 | 对每个 Skill 分别开启 Claude、Codex、OpenCode |
| **Commands** | 保存 `/xxx` 形式的固定 Prompt | 适合翻译、摘要、润色等重复任务 |
| **Self-Host（自托管）** | 优先使用自己控制的模型、搜索服务和基础设施 | 只有明确需要自己管理模型/搜索服务时再开启 |
| **Legacy Vault Index** | Copilot V3 遗留的旧向量索引 | Miyo 是 V4 推荐方向；成功使用 Miyo 后不需要继续围绕旧索引搭工作流 |
| **API Key Storage** | API Key 保存位置 | 保持 Obsidian Keychain，无需手动设置 |
| **Agent Activity Log / Debug** | 保存 Agent 后台通信信息用于排错 | 只在排错时开启，正常使用建议关闭 |

需要特别区分：Copilot 的 **BYOK 模型不会自动进入 Claude Code/Codex**。Claude、Codex 使用各自 CLI/账户的模型；BYOK 主要供 Quick Chat、OpenCode 等路径使用。

### Claudian 设置

| 设置 | 含义 | 如何设置 |
|---|---|---|
| **Language** | 插件界面语言 | 选择简体中文即可 |
| **双栏模式 / 打开位置 / 恢复标签页** | Claudian 聊天界面布局 | 按个人使用习惯设置，不影响 Agent 能力 |
| **Custom System Prompt** | 给所有 Claudian 会话追加统一规则 | 只放 Claudian 专属规则，避免与 Vault 的 `AGENTS.md` 大量重复 |
| **Excluded Tags** | 指定哪些标签的笔记不要自动加入上下文 | 每行一个标签，如 `private`、`draft` |
| **Media Folder** | 聊天附件保存目录 | 默认 `Attachments` 或自己的附件目录 |
| **Shared Environment** | 所有 Agent 共用的环境变量 | 适合放 `PATH`、代理等；Agent 专属变量放各 Provider 页面 |
| **Collab** | 开启多人局域网/Git 协作 | 单人使用关闭 |
| **Collab Project Folder** | Collab 工作副本目录 | 默认 `workspace` 即可，只在 Collab 开启时生效 |
| **Native Git Path** | Collab 调用的 Git | 一般留空自动检测 |
| **Claude → CLI Path** | 本机 Claude Code 路径 | 优先留空自动检测；失败再填写 `which claude` 的结果 |
| **Claude → Models** | Claude 可用模型及默认模型 | 一般使用自动发现的模型；中转 API/特殊模型才手动添加 |
| **Claude → Safe Mode** | Claude 的执行权限 | 普通使用建议 `default`；`acceptEdits` 会减少文件修改确认 |
| **Load user Claude settings** | 是否加载 `~/.claude` 中已有配置 | 已经长期使用 Claude Code 建议开启 |
| **Claude → Commands & Skills** | 使用 `.claude/commands/` 和 `.claude/skills/` | 可以直接复用原有 Claude Code 配置 |
| **Claude → Subagents** | 管理 `.claude/agents/` 中的子智能体 | 有角色化/并行任务需求时创建 |
| **Claude → MCP** | 使用 Claude Code 原来的 MCP | 继续通过 Claude CLI 管理，Claudian 直接使用 |
| **Claude Code Plugins** | 加载 Claude Code 已安装插件 | 已有插件可直接启用 |
| **Claude Environment** | Claude 专属 API/模型环境变量 | 正常 Anthropic 登录无需填写；API 中转才填写 `ANTHROPIC_*` |
| **Codex → CLI Path** | 本机 Codex CLI 路径 | 留空自动检测；失败填写 `which codex` 结果 |
| **Codex → Discover Models** | 从 Codex 获取当前真正可用模型 | Codex 已登录/配置后点击 Discover |
| **Codex → Ultra 推理强度** | 显示支持 Ultra 的最高推理档位 | 只有需要最高推理强度时开启 |
| **Codex → Reasoning Summary** | 控制是否显示推理过程摘要 | 调查 Agent 行为可选详细；日常可用简洁/自动 |
| **Codex → Safe Mode** | 控制 Codex 对工作目录的权限 | 只读任务选 `read-only`；允许编辑 Vault 可选 `workspace-write` |
| **Codex → Skills** | 管理 `.agents/skills/` 中的共享 Skill | 与 Copilot 同时安装时要特别注意目录冲突 |
| **Hidden Skills** | 不在 Claudian 菜单显示指定 Skill | 每行一个 Skill 名称，不带 `$` |
| **Codex → Subagents** | 管理 `.codex/agents/*.toml` | 需要 Codex 子智能体时创建 |
| **Codex → MCP** | 使用 Codex CLI 已配置的 MCP | 继续通过 `codex mcp` 管理 |
| **Codex Environment** | Codex 专属运行环境 | 正常 ChatGPT/Codex 登录无需填写；API 中转才设置 `OPENAI_*` |
| **Grok → CLI / Models** | 接入 Grok Build | 安装并登录 Grok，CLI 通常自动检测，再点 Discover |
| **OpenCode → CLI / Models** | 接入 OpenCode 及其模型 Provider | CLI 通常自动检测；模型来自 OpenCode 自己已经配置的 Provider |
| **Pi → CLI / Models** | 接入 Pi | 安装 Pi 后自动检测或填绝对路径，再点 Discover |

Claudian 的核心思路是：**模型、MCP、Skill、子智能体和权限尽量继续由底层 Agent 自己管理，Claudian 负责把这些能力呈现在 Obsidian 中。**

## 三、核心功能与实现机制

### Copilot：Project、Miyo 与跨 Agent 能力

#### Project：Vault 内的长期任务空间

**Project 用来把长期工作的聊天、文件、项目说明集中起来，并反复继续工作**。**Vault → 多个 Project → 每个 Project 再有多个 Chat**
非常类似 ChatGPT 的 Project。和 NotebookLM 有少许类似，但还是高度相似于 ChatGPT Project。
```text
ChatGPT Project
├── Project Instructions
├── Project Files
└── Chats

Copilot Project
├── Project AGENTS.md
├── Project Context
└── Project Chats
```

例如同一个 Vault 可以同时存在【Agent Memory 研究】【AI提示词】【Python学习】三个 Project，而不需要建立三个 Vault。

每个 Project 默认位于：`copilot/projects/<project>/`

其中：

- `project.md`：保存 Project 描述以及需要长期加载的 Context；
- `AGENTS.md`：保存这个 Project 专属的 Agent 规则；
- Project Chat：只显示这个 Project 的聊天历史。

Project Context 可以长期保存文件、文件夹、标签、属性、URL、YouTube 等资料。Vault 根目录 `AGENTS.md` 仍然生效，但 Project `AGENTS.md` 更具体，冲突时 Project 规则优先。


#### RAG 实现：Legacy Vault Index 与 Miyo

都属于知识检索层，都可以参与 RAG（检索增强生成），但并不等于完整 RAG。

**Legacy Vault Index** 是 Copilot V3 内置的旧向量索引；**Miyo** 是 V4 推荐的新方案，是独立运行的本地知识服务。

|                  | Legacy Vault Index                        | Miyo                                   |
| ---------------- | ----------------------------------------- | -------------------------------------- |
| 向量数据库/索引         | **Orama，本地**                              | **Qdrant，本地**                          |
| Embedding 模型     | 用户自己选择                                    | 当前 Miyo 使用 **`nomic-embed-text-v1.5`** |
| Embedding 在哪里运行  | ⚠️ **取决于模型 Provider**                     | ✅ **本地 llama-server**                  |
| 可以使用云端 Embedding | ✅ OpenAI、Google、OpenRouter、Copilot Plus 等 | ❌ 本地 Miyo 正常路径不需要                      |
| 可以使用本地 Embedding | ✅ Ollama、LM Studio 等                      | ✅ 默认就是本地                               |
| 关键词搜索            | ✅ 有                                       | ✅ **BM25**                             |
| 向量搜索             | ✅                                         | ✅                                      |
| 混合搜索             | 有旧 Copilot 自己的混合检索逻辑                      | ✅ **Dense Vector + BM25 → RRF 融合**     |
| 文件监听/增量索引        | Copilot 插件管理                              | **Miyo 自己管理**                          |
| 索引属于谁            | Copilot Plugin                            | **独立 Miyo Service**                    |
| V4 定位            | ⚠️ 旧版本V3用的                                | ✅ V4主推                                 |


##### Miyo 能做什么

| 功能 | 作用 |
|---|---|
| **Vault 语义检索** | 根据内容含义搜索笔记，而不只是匹配关键词 |
| **为 Agent 提供知识上下文** | Claude、Codex、OpenCode 可以通过 Miyo Skill 搜索 Vault，再把结果用于回答 |
| **本地知识索引** | 索引和检索主要在自己控制的 Miyo 服务中完成，不需要把知识库长期存入 Copilot 插件自己的云端知识库 |
| **PDF / EPUB 处理** | 可以在本地解析 PDF、EPUB，供 Agent 使用 |
| **聊天记录搜索** | 可以配置并索引部分 ChatGPT、Claude 历史会话，与 Vault 搜索分开管理 |
| **统一知识服务** | Miyo 不只为 Copilot 服务，还可以把已经注册的本地资料提供给其他支持的 AI 工具 |
| **多目录管理** | 一个 Miyo 可以管理多个本地目录或 Vault，Copilot 可以限制只搜索当前 Vault |

##### 安装与连接

1. 前往 **[Miyo 官网](https://www.miyo.md/)** 下载对应系统的桌面版，支持 macOS、Windows、Linux。
2. 安装并启动 Miyo。
3. 在 Miyo 中把自己的 **Obsidian Vault 注册为知识目录**。
4. 打开 `Obsidian → Copilot → Settings → Miyo`。
5. 点击 **Connect**。
6. Copilot 会自动寻找本机正在运行的 Miyo；连接成功后会显示类似 `Connected · local`。
7. 开启 **Semantic Search（语义搜索）**。
8. `Search Scope` 一般选择 **Current vault**，避免 Copilot 默认搜索 Miyo 管理的其他目录。


#### 跨 Agent Skills

Copilot 建立一个统一 Skill 仓库，再把 Skill 链接到不同 Agent 的原生目录：

| Agent | 原生 Skill 目录 |
|---|---|
| Claude | `.claude/skills/` |
| Codex | `.agents/skills/` |
| OpenCode | `.opencode/skills/` |

因此同一个 `obsidian-markdown`、`json-canvas` 等 Skill 可以同时提供给多个 Agent，而不需要人工维护三份。

#### Multi-Agent

同一个问题分别交给 Claude/Codex/OpenCode → 得到多个答案 → **当前主 Agent 负责汇总**
比如：当前使用 Claude Code，你可以在对话框中 @Codex @OpenCode，分别执行任务，最后把结果交给Claude Code汇总。

```markdown
在Claude Code对话框中输入：@Codex @OpenCode 帮我评审这个方案

然后：

问题
 │
 ├→ Codex 临时会话 → 答案 A
 │
 └→ OpenCode 临时会话 → 答案 B

最后会汇总给 Claude，做最终评估。
```
这里 Codex 和 OpenCode 是**平级的独立 Agent**，不是 Claude Code 的 Subagent。

### Claudian：尽量完整保留 Agent 原生能力

Claudian 重点解决一个问题：**在 Obsidian 中尽量完整地运行原本的 Claude Code、Codex、OpenCode 等 Agent。**

#### Inline Edit（行内编辑）

选中笔记中的文字后调用 Claudian，Agent 可以直接修改当前内容，并显示逐词 Diff（修改差异）。

工作流是：选中文字 → 提出修改要求 → Agent 编辑 → 查看 Diff → 接受或拒绝。

对于写文章、技术笔记、润色和局部重构，这比进入聊天窗口再复制结果更直接。

#### Skills、MCP、Plugins 与子智能体

Claudian 尽量复用 Agent 原来的配置：

- Claude：`.claude/skills/`、`.claude/agents/`、Claude MCP、Claude Code Plugins；
- Codex：`.agents/skills/`、`.codex/agents/`、Codex MCP；
- OpenCode、Grok、Pi：继续使用各自 Provider 已有的模型和运行环境。

因此已经拥有成熟 Claude Code/Codex 配置的用户，迁移到 Claudian 的成本较低。

#### Collab

Collab 是**多个人类用户协作同一个项目**。

它通过 Git 和局域网完成 Project 同步、Diff、Review、冲突处理等，目前仍属于实验功能。个人用户通常不需要开启。

## 四、注意事项

- **Copilot 与 Claudian 的 Skill 管理存在冲突。** Copilot 会把共享 Skill 通过符号链接放入 `.agents/skills/` 等目录，而当前 Claudian 会把部分符号链接识别为 `Managed resource must not be a symlink`。同时安装时不要让两个插件同时接管同一批 Skill，也不要看到报错后直接删除目录。
- **Miyo 需要本地服务保持可用。** 本地模式不需要 API Key，但 Copilot 需要能够连接正在运行的 Miyo。

> **专注 AI 与个人知识管理**
> 本文属于 [杰森的效率工坊](https://jasonai.me)原创。未经允许禁止商用。
> 
> **订阅杰森的频道：**
> [YouTube](https://www.youtube.com/@JasonEfficiencyLab) · [Twitter(X)](https://x.com/JasonEffiLab) · [小红书](https://www.xiaohongshu.com/user/profile/60935957000000000101fbf7) · [B站](https://space.bilibili.com/3546884870244925)