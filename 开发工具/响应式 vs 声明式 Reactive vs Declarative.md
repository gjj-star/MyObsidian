---
name: 响应式 vs 声明式 Reactive vs Declarative
description: Vue 语境下响应式（reactive）与声明式（declarative）的定义、关系与异同
metadata: 
  node_type: memory
  type: knowledge
  originSessionId: 1d96bcb2-b3c5-46cd-b222-e16e5ba9566b
aliases: [reactivity-vs-declarative, Reactive vs Declarative, 响应式与声明式]
---

Vue 中两个容易混淆的概念，处于不同层面。

**英文**：Declarative（声明式）；Reactive（响应式）

## 要点：声明式 declarative（写法范式）

描述 UI（User Interface）应该是什么样（目标状态），由框架负责更新 DOM（Document Object Model）。Vue 模板中的 `{{ x }}`、`v-if`、`v-for`、`@click` 都是声明式。反例：命令式写法 `el.textContent = x`。

## 要点：响应式 reactive（底层机制）

数据变化时，依赖它的视图/计算自动更新，由依赖追踪（Proxy）+ effect 实现。Vue 中的 `ref()`、`reactive()`、`computed`、`watch` 都是响应式。

## 关系：声明式是意图，响应式是引擎

Vue 用响应式支撑声明式，让"只描述界面、不手动同步"成为可能。

- 声明式不一定靠响应式：React 是声明式的，但靠整体重渲染 + diff（差异比较），并非细粒度响应式。
- 响应式不一定用于 UI：Pinia / 纯响应式状态管理可脱离模板使用。

## 对比：异同

**相同点**：都让人脱离手动操作细节、降低心智负担；共同构成"数据驱动视图"。

**不同点**：
- 抽象层级不同：范式 vs 机制
- 关注点不同：UI 怎么写 vs 数据怎么传播
- 范围不同：视图表达 vs 数据层/计算/watch 全链路
- 可分离性：静态模板可以声明式但无响应式；响应式可脱离 UI 独立使用

## 示例

`{{ doubled }}` 是声明式；`const doubled = computed(() => count.value * 2)` 是响应式（自动追踪 count 依赖）。
