---
name: 人在回路 HITL
node_type: memory
type: reference
description: AI Agent 人在回路设计模式：控制级别、LangGraph 实现、审批与升级模式、Web 异步 HITL 生产实践
originSessionId: 141ef463-5bcf-4e10-9949-c9444bcf49f7
aliases: [human-in-the-loop, HITL, Human-in-the-Loop, 人在环路]
tags: [AI-Agent]
---

# 人在回路 HITL

人在回路（HITL）是一种 AI Agent 设计模式：Agent 在执行关键步骤前暂停，等待人类批准/修改/拒绝后再继续。

**英文**：Human-in-the-Loop（HITL）

## 控制的三级别

| 模式 | 全称 | 人类角色 | 典型场景 |
|---|---|---|---|
| **HITL** | Human-in-the-Loop（人在回路） | 每步关键决策必须确认 | 自动转账、敏感邮件 |
| **HOTL** | Human-on-the-Loop（人在环上） | Agent 自主运行，人可紧急停止 | 自动驾驶 |
| **HOOTL** | Human-out-of-the-Loop（人在环外） | 人只看结果 | 推荐系统 |

## LangGraph 核心实现

```python
app = workflow.compile(
    checkpointer=MemorySaver(),
    interrupt_before=["action"]  # 进入 action 节点前暂停
)
```

- **恢复执行**：`app.stream(None, config)` — None = 不改状态继续跑
- **修改后恢复**：`app.update_state(thread_config, new_state, as_node="agent")` 然后 stream
- **interrupt_before vs interrupt_after**：before = 审批（执行前确认），after = 验收（执行后检查结果）

## 两种设计模式

| 模式 | 场景 | 机制 |
|---|---|---|
| **审批（Approval）** | 高风险操作（金钱、数据删除） | interrupt_before 暂停 → 人批准/修改/拒绝 |
| **升级（Escalation）** | 低置信度、无法处理的异常 | Agent 主动调用 ask_human 工具求助 |

## Web 服务中的异步 HITL（生产环境）

不能用 `input()` 阻塞。正确做法：

1. `app.stream()` → 遇断点暂停 → 保存 Checkpoint（检查点） → 返回 `202 Accepted` + `thread_id`
2. 用户前端点击"批准" → POST 请求带 thread_id + resume → `app.stream(None)` 恢复
3. 需设置 TTL（Time-to-Live，生存时间）清理过期 Checkpoint（MemorySaver 重启即丢，SqliteSaver/PostgresSaver 持久化）

## 与已有工具链的对应

- cangjie-skill 的"两个用户确认点"（阶段 0 骨架确认 + 阶段 1.5 入选名单确认）= HITL 审批模式
- WorkBuddy 的 Plan 模式 = HOTL（先列计划，用户确认再执行）
- cangjie-skill 的 PIPELINE_STATE.md = Checkpoint 持久化的简化版

## 应用

**Why:** HITL 是 Agent 安全性的基石设计模式，Claude Code 的技能流水线中多次实际运用。理解三级别控制和异步恢复机制有助于设计更可靠的 agent 工作流。

**How to apply:** 设计高风险 agent 操作时，默认加 interrupt_before 断点；跨 session（会话）的长任务用持久化 Checkpoint + TTL；置信度低时用升级模式而非静默失败。

## 相关

- [[Agent 编排模式]] — 编排中嵌入 HITL 检查点
- [[Agent Skill 自动化]] — 高风险字段校验需人在回路

> 来源：北方的郎《AI 智能体》第 14 章，2025-12-02
