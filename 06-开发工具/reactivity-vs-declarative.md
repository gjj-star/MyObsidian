---
name: reactivity-vs-declarative
description: Vue 语境下响应式(reactive)与声明式(declarative)的定义、关系与异同
metadata: 
  node_type: memory
  type: knowledge
  originSessionId: 1d96bcb2-b3c5-46cd-b222-e16e5ba9566b
---

Vue 中两个易混概念，处于不同层面：

**声明式 declarative（写法范式）**：描述 UI 应该是什么样（目标状态），框架负责更新 DOM。Vue 模板 `{{ x }}`、`v-if`、`v-for`、`@click` 都是声明式。反例：命令式 `el.textContent = x`。

**响应式 reactive（底层机制）**：数据变化时，依赖它的视图/计算自动更新，由依赖追踪（Proxy）+ effect 实现。Vue 中 `ref()`、`reactive()`、`computed`、`watch` 都是响应式。

**关系（声明式是意图，响应式是引擎）**：Vue 用响应式支撑声明式，让"只描述界面、不手动同步"成为可能。
- 声明式不一定靠响应式：React 声明式但靠整体重渲染 + diff，非细粒度响应式。
- 响应式不一定用于 UI：Pinia / 纯响应式状态管理可脱离模板。

**异同**
- 同：都让人脱离手动操作细节、降低心智负担；共同构成"数据驱动视图"。
- 异：抽象层级不同（范式 vs 机制）；关注点不同（UI 怎么写 vs 数据怎么传播）；范围不同（视图表达 vs 数据层/计算/watch 全链路）；可分离（静态模板可声明式无响应式；响应式可脱离 UI）。

**示例**：`{{ doubled }}` 是声明式；`const doubled = computed(() => count.value * 2)` 是响应式（自动追踪 count 依赖）。
