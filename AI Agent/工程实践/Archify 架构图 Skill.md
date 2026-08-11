---
name: Archify 架构图 Skill
node_type: memory
type: reference
description: Archify Agent Skill——把代码库或系统描述转化为可验证、可交互、可分享的架构图（自包含 HTML，支持五种图类型）
modified: 2026-08-11T10:20:00.000Z
aliases: [Archify, archify skill, 架构图生成 Skill]
tags: [AI-Agent]
---

# Archify 架构图 Skill

**英文**：Archify（Agent Skill）；JSON IR（Intermediate Representation，中间表示）；Delta Review（差异评审）；Share Card（分享卡片）

Archify 是一个 Agent Skill：给一个系统描述或代码仓库，直接在对话里生成**可验证、可交互、可分享**的技术地图（自包含 HTML 文件），支持 Raven / Cursor / Claude Code / Codex CLI / OpenCode。当前稳定版本 v2.13，MIT 协议。

## 五种图类型

| 类型 | 用途 | Prompt 里要写什么 |
|---|---|---|
| Architecture（架构图） | 组件、服务、存储、边界 | 范围、核心组件、主路径 |
| Workflow（流程图） | CI/CD、审批、工具调用、Runbook | 参与者、顺序、分支、异常 |
| Sequence（时序图） | API 调用、缓存回退、鉴权、异步追踪 | 调用方、被调方、返回、时序 |
| Data Flow（数据流图） | 管道、血缘、PII、消费者 | 来源、转换、存储、边界 |
| Lifecycle（生命周期图） | 状态、重试、等待、终态 | 状态、事件、重试与取消路径 |

## 核心机制

- **Typed JSON IR**：Agent 先生成有 schema 的 JSON 中间表示，再渲染成图——来源可复现、可迭代
- **原子化验证后交付**：schema、布局、HTML/SVG、路由、标签避让全部通过校验才替换旧图；失败时返回机器可读的规则码与精确修复建议（`validate --json` / `deliver --json`），而非裸报错
- **如实交互**：focus、上下游 reach、精确路由、角色对比都基于已记录的节点与关系，不发明拓扑；证据型节点可打开 Git 校验过的源文件与行区间
- **Delta 评审**：`compare architecture base.json head.json` 对比 Before / Delta / After 三个快照，精确列出新增、删除、改动、移动、重路由的事实，用于合并前架构评审
- **一次交付**：单文件 HTML，导出 PNG / SVG / WebM / 1200x630 分享卡片；有限动效可选（尊重 prefers-reduced-motion），可进入演示模式

## 使用

```bash
# 安装（Claude Code 装到 ~/.claude/skills/ 或 .claude/skills/）
npx skills add tt-a1i/archify -g

# 然后直接对 Agent 说：
# "Use archify to map this repository's runtime architecture."
# "Show 8-12 core components, one primary path, external dependencies, and trust boundaries."
```

- 先要一个**有界视图**（8-12 个核心组件、一条主路径），再在对话里增量细化（`add Redis`、`move auth to the left`）
- 明确不在范围内：自动 Mermaid 解析、通用自动布局、托管分享、所见即所得编辑
- 项目主页与交互式示例：github.com/tt-a1i/archify（Proof Lab 含 11 个已校验场景）

## 应用

适合：代码库架构盘点与文档化、合并前的架构变更评审、向非技术方演示系统拓扑。与知识库已有 Skill 类卡片互补——它是"画架构图"的专用 Skill，[[SOP 转 Skill 方法论]] 讲的是把流程固化为 Skill 的方法，[[引导型与工程型 Skill]] 讲 Skill 的形态分类。

## 相关

- [[SOP 转 Skill 方法论]] — 如何把流程沉淀为可复用 Skill
- [[引导型与工程型 Skill]] — Skill 的形态分类框架
- [[多智能体协同的四种架构模式]] — 画架构图前先想清楚系统是哪种协作形态
- [[生命周期 Lifecycle]] — Lifecycle 图类型对应的生命周期概念卡

> 来源：GitHub tt-a1i/archify 项目 README（2026-08-10 剪藏）
