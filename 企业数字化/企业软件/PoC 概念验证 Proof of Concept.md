---
name: PoC 概念验证
node_type: memory
type: knowledge
description: PoC（Proof of Concept）概念验证的最小验证逻辑、与原型/MVP 的区别、典型场景与核心原则
modified: 2026-08-13T02:30:07.000Z
aliases: [poc-proof-of-concept, PoC, Proof of Concept, 概念验证]
tags: [企业数字化, 企业软件]
---

# PoC 概念验证 Proof of Concept

**英文**：Proof of Concept（PoC，概念验证）；Prototype（原型）；MVP（Minimum Viable Product，最小可行产品）；Fake Door（假门实验）

PoC 是在正式投入资源开发之前，用一个最小化的原型验证某个想法、技术方案或产品方向是否**技术上可行、业务上有价值**。

核心逻辑：**花最小的代价，回答最关键的未知问题。** PoC 不是做一个"简陋版产品"，而是做一个"只验证核心假设的试验"。

## PoC vs 原型 vs MVP

| 维度 | PoC | 原型 Prototype | MVP |
|---|---|---|---|
| 目标 | 验证技术/业务可行性 | 展示交互与设计效果 | 找到付费用户 |
| 产出 | 一段代码 / 实验报告 | 可点击的交互稿 | 可用的最小产品 |
| 回答的问题 | "能做出来吗？" | "好用吗？" | "有人买吗？" |
| 是否交付 | ✗ 通常丢弃 | ✗ 通常丢弃 | ✓ 投入生产 |

## 典型场景

1. **技术选型**：新框架/数据库能不能扛住预期负载？→ 搭个 PoC 压测
2. **算法验证**：AI 方案在真实数据上准确率够不够？→ 小批量数据跑通
3. **集成验证**：第三方 API 能不能满足场景？→ 最小集成试一下
4. **业务假设**：用户真的需要这个功能吗？→ Fake Door 实验

## 核心原则

- **只测关键假设**——其他一切从简
- **允许失败**——证明"做不了"也是成功的 PoC，省了后续投入
- **设终止条件**——测哪些指标、达标线是多少，做之前先定好

## 相关

- [[B 端与 C 端 B2B B2C]] — B 端交付中 PoC 是售前与立项的常见环节
- [[北极星指标 North Star Metric]] — MVP 阶段"有人买吗"指向的增长指标
- [[SaaS 系统架构 SaaS Architecture]] — PoC 验证可行后进入正式架构与发布
- [[灰度发布 Canary Release]] — 验证后的安全上线路径
