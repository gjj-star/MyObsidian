---
name: workflow-integration-mechanisms
description: 工作流对接业务系统的五种方式（REST API/Webhook/消息队列/代码节点/RPA）及一个审批节点的内部执行流程
metadata: 
  node_type: memory
  type: reference
  originSessionId: 62006bd2-df5d-4a68-bdc3-894ab7b3d9e3
  modified: 2026-07-21T07:14:27.585Z
---

## 工作流引擎的本质
引擎不碰业务数据——它只负责在正确的时间、以正确的顺序、调用正确的外部系统。它是一个调度器。

## 五种对接方式

### 1. REST API（80%+ 场景）
每个节点就是一个 HTTP 请求，同步等返回后走下一个节点。

### 2. Webhook（反向调用）
外部系统主动通知工作流。适合长等待场景（审批可能等三天），不轮询不占资源。

### 3. 数据库触发器 / 消息队列
监听数据变化（MySQL trigger / Kafka），适合系统间解耦，发布-订阅模式。

### 4. 代码节点（JS/Python 沙箱）
在流程内做数据变形/清洗/计算，避免为一个小格式化多部署一个微服务。

### 5. RPA 兜底
当系统没有 API 时，屏幕抓取/模拟点击。最不稳定但有时是唯一的路。

## 一个审批节点的内部执行
"主管审批"一个节点内部其实是 6 个子步骤：
1. 模板拼装通知内容
2. HTTP 发送通知（企微/钉钉）
3. Webhook 挂起等待
4. 收到审批回调
5. 代码节点判断通过/拒绝
6. HTTP 调 HR 系统扣减年假

## 现实对接问题
- REST vs SOAP → 格式转换
- 不同鉴权方式（OAuth2/API Key）
- 速率限制影响并行度
- API 文档不准 → 需实测反推
- 没有 API → RPA 或中间适配层

## 总结
API 是主干，webhook 是血管，代码节点是关节，RPA 是义肢。工作流引擎不创造业务能力，只把已有能力串成整体。

## 相关记忆
- [[agent-vs-workflow-comparison]] — Agent 和 Workflow 的对比
- [[sop-definition]] — SOP 定义，Workflow 是 SOP 的自动化实现
- [[rpa-basics]] — RPA 基础
