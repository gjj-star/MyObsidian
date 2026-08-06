---
name: 声明式范式 Declarative Paradigm
node_type: memory
type: knowledge
description: 声明式编程范式的定义、Dockerfile 与 Vue 模板两个层面的对比、优点与命令式反例
originSessionId: 1d96bcb2-b3c5-46cd-b222-e16e5ba9566b
aliases: [declarative-paradigm, Declarative Paradigm, 声明式编程]
tags: [开发工具]
---

声明式（Declarative）范式 = 只描述目标状态（What），把达成过程（How）交给工具。

**英文**：Declarative Paradigm（声明式范式）

## 要点：两个层面（精神相通但机制不同）

- **Dockerfile**：声明环境的目标状态，由 Docker 引擎在**构建期**执行成镜像——属于基础设施即代码（IaC, Infrastructure as Code）/ 配置层。
- **Vue 模板**：声明 UI（User Interface）的目标状态，由框架在**运行期**响应式保持同步——属于 UI 编程范式层。

## 优点

- 心智负担低
- 可读、可维护
- 状态与表现自动同步

## 对比：命令式反例

- 手动操作 DOM（Document Object Model）：`document.getElementById(...)` 改 `textContent`
- 手动一步步安装环境

## 注意与扩展

两个层面不是同一机制：Docker 是一次性构建产物，Vue 是持续响应式的运行时。声明式是通用思想，亦见于 SQL（Structured Query Language，结构化查询语言）、函数式编程（Functional Programming）。

## 相关

- [[响应式 vs 声明式 Reactive vs Declarative]] — Vue 语境下声明式与响应式的对比
- [[Docker 环境一致性]] — Dockerfile 声明式定义环境的实践
