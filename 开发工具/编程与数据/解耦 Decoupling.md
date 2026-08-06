---
name: 解耦 Decoupling
node_type: memory
type: knowledge
description: 解耦（降低模块间依赖关系）的含义、常见手段与好处
aliases: [decoupling, Decoupling, 解耦]
tags: [开发工具]
---

"解耦"是降低系统模块间**依赖关系**的软件工程概念。类比电脑硬件的模块化：CPU、内存、硬盘独立更换互不影响。

**英文**：Decoupling（解耦）

## 要点：常见手段

- **接口抽象**：依赖接口而非具体实现
- **依赖注入**（DI, Dependency Injection）：运行时注入依赖，模块间不直接 new
- **消息队列**（MQ, Message Queue）：异步通信，生产/消费方互不感知

## 应用：好处

紧耦合 → 松耦合后：模块可独立开发/测试/替换，故障隔离，系统更易扩展。

## 相关

- [[工作流对接机制]] — 消息队列是系统对接中解耦的典型手段

> 来源：CC 对话记录 conversation-log（2026-07-27）
