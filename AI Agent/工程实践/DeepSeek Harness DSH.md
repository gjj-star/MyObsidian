---
name: DeepSeek Harness DSH
node_type: memory
type: knowledge
description: DeepSeek Harness（DSH）插件优先 AI 工作台框架——宿主（Host）概念、Cordis 插件体系，以及"兼容协议不兼容插件"的行业标准之辨
modified: 2026-08-25T02:30:00.000Z
aliases: [DSH, DeepSeek Harness, 宿主 Host]
tags: [AI-Agent]
---

# DeepSeek Harness DSH

**英文**：DeepSeek Harness（DSH）；Host（宿主）；Plugin（插件）；Cordis（Node.js 依赖注入容器框架）；Cross-cutting Concerns（横切关注点）；MCP（Model Context Protocol，模型上下文协议）；Event Sourcing（事件溯源）

DeepSeek Harness 是 DeepSeek 开源的**插件优先（plugin-first）AI 工作台框架**（MIT 协议），宣传语 "Everything is a plugin"：模型、工具、绘画、沙箱乃至文件系统都是插件。

## 宿主（Host）是什么

DSH 里高频出现"宿主"，指 DSH 主程序本身——**承载并运行各类插件的运行时基础设施**：

- 宿主提供 ctx 上下文、webServer（仅监听 127.0.0.1 的浏览器 HTTP 载体）、前端静态服务、Electron 桌面壳中的 Host Cordis 插件树、确定性 Workspace Fingerprint 等能力
- 游戏、角色扮演包（如 dsh-dungeon-party 地下城派对、RP 角色扮演包）都是插件，依赖宿主能力运行，不能独立存在
- 类比：浏览器是宿主、扩展是插件；手机系统是宿主、App 是插件；生物体是宿主、寄生虫是寄居者（"宿主"一词的隐喻来源）
- 插件化架构下，每个插件都要声明"我运行在 DSH 宿主上"并调用宿主接口

## 架构机理（B 站老周 AgentBuilder 三天源码评审）

**工程优点**：Event Sourced 会话日志做唯一事实源、Go 状态机防并发、Hook 合并规则 deny > ask > allow、逐包注释精确到行号，代码质量接近学院派水准。

**"不会是行业标准"的四条理由**：

1. **横切关注点（Cross-cutting Concerns）死穴**：加一个跨插件功能（如"后台任务完成时推送到手机"）要魔改 jobs/session/通知等多个插件，各有接口契约、版本节奏、维护者；魔改即分叉，上游一发版就要重新合并，成本指数级上升
2. **进程本地限制**：任务注册表、子 Agent 收件箱都是进程内，崩溃即丢消息；无跨进程、无多机、无持久化后端、无调度器——这是全插件化"完整体验没有 owner、只有插件接缝"的必然结果
3. **生态治理的物理规律**：开放插件市场 = 上传零成本 + AI 让垃圾生产边际成本趋零 → 劣币驱逐良币（Skill Hub 两三个月变垃圾场的前车之鉴）；DSH 插件是注入宿主进程的 Node 模块，同进程同权限，无沙箱无权限边界，开放生态等于把供应链攻击面压缩进一份权限
4. **行业标准从来是边界协议，不是运行时插件接口**：TCP/IP、HTTP、LSP、MCP 皆如此；DSH 插件绑定 Cordis 依赖注入容器，兼容它等于在自己进程里嵌一个 Node 运行时——"把自己变成人家的宿主"

**结论（八个字）**：兼容协议、不兼容插件——MCP 这类边界格式可以对接，插件体系不建议接入。

## 相关

- [[Agent 编排模式]] — jobs/session hooks/工作流编排等宿主能力的基础设施视角
- [[多智能体架构 Multi-Agent Architecture]] — sub-agent 概念（DSH 的子 Agent 收件箱即进程内实现）
- [[SOP 转 Skill 方法论]] — 与 DSH 插件同属"能力封装"路线，但 Skill 是提示词+脚本，DSH 插件是进程内模块
- [[内网穿透 NAT Tunneling]] — 宿主 webServer 仅监听 127.0.0.1 的本地访问模式

> 来源：CC 对话记录 conversation-log（2026-08-25）+ B 站视频《DeepSeek Harness 不会是未来｜三天读完源码后的判断》（老周 AgentBuilder，2026-08-17 发布，2026-08-21 剪藏）
