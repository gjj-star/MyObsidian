---
name: declarative-paradigm
description: 声明式编程范式——Dockerfile 与 Vue 的声明式对比、优点与命令式反例
metadata: 
  node_type: memory
  type: knowledge
  originSessionId: 1d96bcb2-b3c5-46cd-b222-e16e5ba9566b
---

声明式 = 只描述目标状态（what），把达成过程（how）交给工具。

**两个层面（精神相通但不同）**
- Dockerfile：声明环境的目标状态，由 Docker 引擎在**构建期**执行成镜像（IaC / 配置层）。
- Vue 模板：声明 UI 的目标状态，由框架在**运行期**响应式保持同步（UI 编程范式层）。

**优点**：心智负担低、可读可维护、状态与表现自动同步。

**命令式反例**：手动操作 DOM（`document.getElementById` 改 `textContent`）、手动一步步装环境。

**注意**：不是同一机制——Docker 是一次性构建产物，Vue 是持续响应式的运行时。声明式是通用思想，亦见于 SQL、函数式编程。
