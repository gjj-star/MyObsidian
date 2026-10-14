---
name: Agent 核心概念与设计模式面试题（2026 修订版）
node_type: source
type: reference
description: 八章面试资料——Agent 核心概念/设计模式/Prompt 进阶/MCP 与 A2A 协议/可靠性工程/成本控制/评估监控 + 18 道高频面试题，含勘误索引与核对资料（2026 修订版）
modified: 2026-10-14T08:33:15.000Z
aliases: [Agent 面试题, Agent 设计模式, AI Agent 面试]
tags: [AI-Agent]
---

# Agent 核心概念与设计模式面试题（2026 修订版）

> **修订日期：**2026-10-14  
> **整理原则：**沿用原笔记的八章顺序、二级/三级标题、表格、示例代码与 18 道面试问答的组织形式；内容为重新编写的勘误与更新版，非原文逐字转载。  
> **修订标记：**`【纠错】`＝原说法存在技术错误；`【更新】`＝实现或协议已有变化；`【辨析】`＝原观点不应被当作普遍定律；`【补充】`＝补足现代 Agent 工程的重要部分。  
> **阅读提示：**本文中的代码以**架构示意/伪代码**为主；凡未提供 SDK 定义的 `model`、`runtime`、`sandbox` 等均为抽象接口，不应误认为复制即可运行。

---

## 一、Agent 核心概念

### 什么是 AI Agent？

AI Agent 是能够围绕目标，结合模型判断、外部工具和环境反馈，**动态决定后续操作并推动任务完成**的系统。是否必须显式写一个很长的计划、是否必须调用多个模型，并不是判断 Agent 的标准。

- **单次 LLM 调用：**给出输入后，通常直接得到文本或结构化结果。
- **固定工作流（Workflow）：**开发者规定主要步骤，模型可能参与分类、提取、总结等环节。
- **Agent：**系统将部分流程选择权交给模型，使模型能够根据工具结果决定下一步如何行动。

**【辨析】**原先将“传统 LLM 应用”等同于“无状态、单次调用”过于绝对。传统 LLM 应用也可以跨会话、使用工具和存储状态；Agent 与 Workflow 是理解**控制流归属**的有用区分，但真实应用通常混合两者。

### Agent 四大核心能力

1. **感知（Perception）：**获取用户意图、工具反馈、文件、网页和环境状态。
2. **推理与决策（Reasoning/Decision）：**在约束条件下选择下一步动作，不要求开发者能看见模型的完整内部思维链。
3. **规划（Planning）：**按需拆分任务、排序步骤或修订方案；可以显式规划，也可以逐步决策。
4. **行动（Action）：**调用工具、修改文件、执行程序、请求审批或输出最终结果。

**【补充】**能力不等于可靠性。实际产品还需要由执行框架（Harness/Runtime）处理**状态、权限、上下文、超时、恢复、审计和验收**，这些不必由模型自己“想出来”。

### Agent Loop（感知-推理-行动-反思循环）

Agent Loop 是一种典型的模型—工具交互循环：

```text
用户目标 → 构建上下文 → 模型决策
                          ├─ 输出最终结果 → 检查/结束
                          └─ 请求工具调用
                                  ↓
                          权限与参数校验
                                  ↓
                             执行工具
                                  ↓
                          记录结果与状态
                                  └────→ 再次模型决策
```

**【更新】**每一轮都单独调用一次“反思模型”并不是必要步骤。模型可以在下一轮根据观察结果继续判断；是否增加显式 Critic/Reflection，应由评测证明收益。

**伪代码：**

```python
def agent_loop(task, runtime, max_steps=20):
    state = runtime.create_state(task)

    for _ in range(max_steps):
        if runtime.expired(state) or runtime.over_budget(state):
            return runtime.stop_with_reason(state, "超时或预算用尽")

        context = runtime.build_context(state)  # 按需选择历史、文件与工具结果
        decision = runtime.model_decide(context)

        if decision.is_final:
            return runtime.verify_and_finish(state, decision.answer)

        for call in decision.tool_calls:
            runtime.validate_schema(call)
            runtime.check_permission(call, state)  # 必要时暂停等人批准
            result = runtime.execute_tool(call)
            runtime.persist_observation(state, call, result)

    return runtime.stop_with_reason(state, "达到最大循环次数")
```

**关键设计考量：**

- **终止：**设置步数、费用、时间、操作次数上限，并允许用户取消。
- **上下文：**并非历史越全越好；根据任务调入有用片段，保留关键事实和文件引用。
- **安全：**工具返回和网页属于不可信输入；模型建议的动作必须经由代码层校验。
- **恢复：**持久化进度，重启后继续；对有副作用的操作使用幂等键或明确的补偿机制。
- **验收：**“模型说已完成”不等于实际完成，应该尽量检查文件、测试、API 状态或用户可验证的结果。

---

### 记忆系统

#### 记忆分类与实现

下表是**理解记忆用途的概念分类**，不是必须采用的固定五层架构。类别间可能重叠。

| 记忆类型 | 关注的问题 | 常见生命周期 | 可选实现 |
|---|---|---|---|
| 短期/对话记忆 | 本轮对话已发生什么 | 当前会话或任务 | 消息历史、上下文窗口、摘要 |
| 工作记忆 | 当前操作进展到哪里 | 单个任务，必要时跨重启 | State、Checkpoint、任务数据库、Scratchpad |
| 长期记忆 | 哪些事实或偏好未来仍有用 | 跨会话，按保留策略管理 | SQL/文档库/Markdown/向量索引 |
| 情景记忆 | 过去做过什么，得到什么结果 | 跨任务 | 执行轨迹、案例库、成功/失败复盘 |
| 语义记忆 | 已知概念、定义、实体及关系 | 长期维护、可修订 | 文档、结构化数据库、知识图谱、RAG |

**【纠错】**长期记忆不是“默认把一切写入向量数据库”。**向量数据库是检索手段，不是权威事实存储的同义词。**是否长期保留取决于产品策略、用户授权与数据生命周期，而不是“永久”二字。

#### 具体实现方案

**短期记忆 — Context Window 管理：**

- 把用户当前问题、必要历史、相关工具结果组成这一轮的模型输入。
- 对话过长时，可通过摘要/裁剪/按需检索减小上下文，但摘要可能丢失细节。
- 对代码修改、交易指令、明确纠错等关键记录，优先保留原文或可追溯引用。

**长期记忆 — 结构化存储 + 检索索引（按需选配向量检索）：**

```python
# 示例：事实先落到权威存储，再为它建立检索索引
record = db.upsert_fact(
    key="wiki:scratchpad:definition",
    value="已由用户确认的术语解释",
    source="notes/agents.md",
    version=3,
)
search_index.upsert(record.id, text=record.value)

# 读取时返回内容和可追溯的 ID/来源，而不是只返回相似文本
hits = search_index.search(query="什么是 Scratchpad", limit=5)
facts = [db.get(hit.id) for hit in hits]
```

**【辨析】**这里 `db` 和 `search_index` 是抽象接口。存储层可以是本地 Markdown、SQLite、Postgres 或云数据库；只有规模和召回需求确实需要时，才考虑向量索引（如 Chroma/Qdrant 等）。具体选型应评估数据量、离线需求、成本和维护难度。

**长期记忆 — 文件系统方案：**

- Markdown/JSON 便于用户阅读、修订、同步与版本管理，尤其适用于本地优先应用。
- 文件不等于“无法检索”：可配合全文检索、倒排索引、数据库索引或向量搜索。
- 核心区分：**文件或数据库保存真实知识；索引帮助找到知识**。

**工作记忆 — 持久状态方案：**

- 任务的当前阶段、工具结果摘要、待办项、审批状态应落在明确的 State/Checkpoint 中。
- 内存对象适合短生命周期任务；希望断点续跑时，应使用 SQLite/Postgres/持久化队列等存储。
- Redis 可以作为缓存或共享协调组件，但不能假设它天然解决并发冲突、持久化和一致性。

#### 记忆检索策略

1. **精准查询：**针对唯一 ID、路径、用户确认过的值，先查权威数据源。
2. **关键词/全文：**查术语、标题、函数名、精确短语。
3. **向量语义检索：**找表达不同但含义接近的内容。
4. **混合与重排：**结合关键词、语义匹配和 Reranker，并保留来源与版本信息。
5. **时间和重要性：**是否加入衰减、加多大权重，应根据真实检索集测试，不能照搬通用公式。

**【辨析】**例如用户去年确认的定义不会仅因“时间旧”就失效；时间衰减不适合所有知识类型。

#### 记忆衰减和清理

- 按类型区分：临时工具缓存可以过期；用户明确保存的知识不应因低频访问而静默删除。
- 维护版本与来源：事实更新时同步更新索引，避免旧结论重新冒出来。
- 去重、合并、归档应优先可回退，并保留用户可查看或恢复的记录。
- 隐私相关信息要有明确的保存、修订和删除规则。

---

### 工具使用（Tool Use）

#### Function Calling vs Tool Use 的区别

| 对比项 | Function Calling | Tool Use |
|---|---|---|
| 定义 | 多家模型提供的结构化函数调用能力 | Agent 使用外部能力的总体概念 |
| 作用 | 让模型表达“调用哪个函数、传哪些参数” | 完成查询、计算、写文件、浏览等具体操作 |
| 实现 | API 工具调用结构 / 参数 Schema 等 | 可基于函数调用、代码执行、协议接入等实现 |
| 谁来执行 | 通常由宿主应用或服务端工具运行时执行 | 取决于系统架构与工具种类 |
| 与 MCP 的关系 | 模型侧选工具/给参数的一种机制 | MCP 可为应用侧提供标准化工具和资源接入 |

**【纠错】**Function Calling 不是 OpenAI 独有的概念；也不能把 MCP 当作与 Function Calling 互斥的替代技术。模型可能通过 Function Calling 请求一个由 MCP Server 暴露的工具，真正的执行仍由授权的运行时承担。

#### 工具描述的最佳实践

```python
# 示例：与具体供应商 API 无关的“工具定义”示意
web_search = {
    "name": "web_search",
    "description": (
        "查询需要外部最新资料的信息。"
        "输入应为具体检索问题；不要用来做本地数学计算。"
    ),
    "parameters": {
        "type": "object",
        "properties": {
            "query": {"type": "string", "description": "具体搜索内容"}
        },
        "required": ["query"],
        "additionalProperties": False,
    },
}
```

**原则：**

1. 名称清楚，职责单一，写明适用和不适用场景。
2. 参数给出 Schema、必填项、枚举和格式要求，返回结果也应有清晰结构。
3. 工具调用前进行授权与参数校验；工具结果要保留来源、错误状态和必要上下文。
4. **【辨析】**不存在“工具必须控制在 10～20 个以内”的通用最佳值。候选工具过多可能影响选择质量，但也可借助检索、按需暴露、命名空间、权限过滤和评测来管理更大的工具集。
5. 对写操作设置明确权限和幂等约束，不能依赖一段提示词保证安全。

#### 多工具编排策略

1. **顺序：**前一步的结果供下一步使用。
2. **并行：**互不依赖的调用可以同时开展，注意速率限制及结果合并。
3. **条件：**根据运行状态选择执行分支。
4. **迭代：**按反馈继续探索，同时设置退出规则。
5. **组合：**将稳定的多步能力封装为一个工具或子流程，减少重复编排成本。

---

## 二、Agent 设计模式

### 1. ReAct（Reasoning + Acting）

ReAct 是“通过推理指导行动，并利用行动结果修正后续判断”的经典思想。原始论文通常用 Thought、Action、Observation 描述这个交替过程。

**工作流程：**

1. 模型根据任务和环境选择下一步行动。
2. 如需工具，给出结构化的工具名与参数。
3. 运行时执行工具并返回 Observation。
4. 模型继续决策，直到完成、失败或触发停止条件。

**【更新】**早期代码常从模型文本里解析 `Thought:` / `Action:`，现代系统更适合用原生 Tool Calling 获得结构化调用；ReAct 的**决策思想**与底层工具调用格式是两回事。

**伪代码：**

```python
def react_agent(question, model, runtime, max_iters=10):
    messages = [{"role": "user", "content": question}]

    for _ in range(max_iters):
        result = model.generate(messages, tools=runtime.available_tools())
        if result.final_answer is not None:
            return result.final_answer
        if not result.tool_calls:
            return "模型未给出有效的下一步操作"

        messages.append(result.assistant_message)  # 保留调用记录
        for call in result.tool_calls:
            output = runtime.call_tool_with_checks(call)
            messages.append(runtime.format_tool_result(call.id, output))

    return "超出最大尝试次数"
```

**适用场景：**探索式查询、多步检索、工具反馈会影响后续动作的任务。

**不适用场景：**完全确定、单步可完成的任务，或需要严格确定性控制的交易/审批流程；不意味着 ReAct **不能**与规划或并行工具调用组合。

**优缺点：**

| 优点 | 局限 |
|---|---|
| 能利用环境反馈动态调整动作 | 可能循环、重复调用或偏离目标 |
| 简化不确定步骤的调度 | 需要管理不断增长的上下文 |
| 工具执行过程可追踪 | **工具轨迹可观察 ≠ 内部 Thought 完全可见或可解释** |

---

### 2. Plan-and-Execute

规划与执行分开：先得到可修订的行动计划，再一项项执行和验收；规划不一定一次性覆盖所有细节。

**工作流程：**

1. Planner 给出任务分解与验收条件。
2. Executor 执行当前步骤，记录结果和失败原因。
3. 必要时 Replanner 根据**已经完成的真实状态**修改剩余计划。
4. 验证最终产出是否达到目标，而不只是“所有步骤都跑过”。

**伪代码：**

```python
def plan_and_execute(task, planner, executor, replanner, max_steps=20):
    remaining = planner.make_plan(task)
    completed = []

    for _ in range(max_steps):
        if not remaining:
            break
        step = remaining.pop(0)
        result = executor.run(step, context=completed)
        completed.append({"step": step, "result": result})

        # 返回的是“新的剩余计划”，而不是修改 for 循环的旧列表
        remaining = replanner.revise_remaining(
            task=task, completed=completed, remaining=remaining
        )
        if result.is_blocked and not remaining:
            return {"status": "blocked", "completed": completed}

    if remaining:
        return {"status": "incomplete", "remaining": remaining}
    return {"status": "ready_for_verification", "completed": completed}
```

**【纠错】**原例在 `for i, step in enumerate(steps)` 中重赋值 `steps`，不会改变这个循环已经持有的迭代器，后续可能仍执行旧步骤；这里改为管理 `remaining` 队列。

**适用场景：**多阶段交付、可拆分的研究或软件开发任务、需要进度汇报与断点续跑的任务。

**不适用场景：**单步确定性任务；早期环境信息不足且固定规划反而造成额外成本的场景（但可采用滚动规划）。

**优缺点：**

| 优点 | 局限 |
|---|---|
| 目标与阶段进度清楚 | 初始计划可能很快失效 |
| 支持验收与状态持久化 | 重新规划会带来开销 |
| 可分层使用不同模型或确定性程序 | 必须处理计划/执行状态不一致的问题 |

---

### 3. Reflection / Self-Critique

Reflection 指在获得结果后，利用评价信号改进输出或策略。**自我批评是候选办法，不等于事实验证。**

**工作流程：**

1. 生成候选结果。
2. 优先运行外部可验证检查（测试、schema、事实引用、约束检查）。
3. 如果检查失败，提供明确失败证据后修改。
4. 无自动检查时，可增加独立审查，但不能把审查模型“说没问题”当成正确性证明。
5. 设置修改次数、费用和回退机制。

**伪代码：**

```python
def reflection_agent(task, generator, verifier, max_rounds=3):
    candidate = generator.create(task)
    for _ in range(max_rounds):
        report = verifier.check(task, candidate)  # 优先使用可执行/外部检查
        if report.passed:
            return {"status": "verified", "output": candidate}
        candidate = generator.revise(task, candidate, evidence=report.failures)
    return {"status": "unverified", "output": candidate}
```

**【纠错】**“法律文书/数学证明等高风险场景很适合仅靠自评提高正确性”是不恰当的推论；需要可靠来源、专门验证器或人工复核。

**适用场景：**代码测试修复、格式约束修复、具有明确验收标准的稿件改进。

**不适用场景：**无可靠评估标准而且自评容易循环的任务；高延迟要求的简易问题。

**优缺点：**

| 优点 | 局限 |
|---|---|
| 有明确反馈时可提高成功率 | 同一模型可能重复同样的误判 |
| 容易形成“生成—检查—修改”的闭环 | 增加成本，甚至越改越差 |
| 可用测试与外部证据增强可信度 | 自评结论不能取代真实验收 |

---

### 4. Tool-Use Pattern

模型选择工具只是第一步；完整 Tool-Use Pattern 还涉及工具注册、权限过滤、参数验证、执行、观察、停止与审计。

**工作流程：**

1. 展示与当前用户权限相符的候选工具。
2. 模型选择工具并生成参数。
3. 运行时验证 schema、身份、授权、危险操作的审批要求。
4. 工具执行并返回带状态的结果；记录调用 ID 和错误。
5. 模型基于结果继续，或者系统按规则终止。

**适用场景：**检索、读写文件、调用 API、运行代码等需外部能力的任务。  
**关键挑战：**安全边界、工具描述歧义、非幂等操作、错误恢复、结果污染与评估。

---

### 5. Multi-Agent Patterns

#### Supervisor 模式

由一个协调者把子任务交给其他 Agent 或确定性工具，统一跟踪结果。**子 Agent 不一定是不同模型，也不一定需要彼此聊天。**

**伪代码：**

```python
def supervisor_agent(task, workers, coordinator):
    jobs = coordinator.decompose(task)
    results = {}
    for job in jobs:
        worker = coordinator.select_worker(job, workers)
        results[job.id] = worker.run(job, allowed_context=results)
    return coordinator.merge_and_verify(task, results)
```

#### Debate 模式

多个独立推理路径相互质询，可能暴露盲点；**不能保证“辩论越多越接近真相”**，尤其当模型共享相同偏见、证据不足或相互迎合时。应结合外部事实和明确裁判标准。

#### Pipeline 模式

按阶段串接处理者，如研究→起草→校对。阶段固定时使用普通 Workflow 往往比强行拆成多个“独立 Agent”更简单。

#### Peer-to-Peer 模式

多个 Agent 通过消息或共享任务资源协调。适用于确有自治节点、异步协作需求的系统，代价是竞态、冲突处理、死锁和故障恢复更加复杂。

**多 Agent 系统的关键设计问题：**

1. 子任务是否真的需要独立上下文、并行探索或不同权限。
2. 共享状态写入是否具备锁、版本号、冲突解决和事件日志。
3. 委托链如何设置权限边界与任务预算。
4. 验收由谁负责，如何处理互相矛盾的子 Agent 结论。
5. **【辨析】**“多 Agent 更聪明”不是工程定律；先做单 Agent + 多工具基线，通过 Benchmark 决定是否增加协作者。

---

### 6. Human-in-the-loop

Human-in-the-loop（HITL）是在人类必须保留最终决定权或 Agent 缺少授权时，将运行中的任务暂停、交给人工确认后再恢复。

**实现方式：**

1. **审批门：**例如对外发消息、转账、删除大量文件、修改生产环境之前确认。
2. **人工纠错：**用户能修改待执行参数或驳回提议。
3. **升级机制：**出现权限不足、重大歧义或无法验证的风险时转人工。
4. **状态持久化：**保存审批对象、操作摘要、执行前后状态和请求 ID，恢复时核验是否仍被授权。

**【辨析】**模型自行估计的置信度不一定校准；不要仅以“置信度 < 某个固定阈值”作为高风险操作的安全保障。

**适用场景：**不可逆/高风险副作用、涉及用户资产或第三方权益的操作、合规审查和异常升级。

---

### 7. CodeAct 模式

CodeAct 让模型用代码表达操作，并通过代码执行环境获得结果。**它可以通过工具调用启动代码执行器，并不与 Function Calling 互斥。**

**核心思想：**

- 模型根据任务生成代码或脚本，并在受限环境中运行。
- 宿主严格管理可访问文件、网络、凭证、依赖包与执行时间。
- 环境反馈（标准输出、错误日志、测试）用于修正下一步动作。

**工作流程：**生成代码 → 静态/策略检查 → 沙箱执行 → 收集输出 → 再次决策/结束。

**伪代码：**

```python
def codeact_agent(task, model, sandbox, max_steps=10):
    history = [{"role": "user", "content": task}]
    for _ in range(max_steps):
        decision = model.next_action(history)
        if decision.is_final:
            return decision.answer
        if decision.action != "run_code":
            return "不支持的操作"
        sandbox.enforce_policy(decision.code)
        output = sandbox.run(decision.code, timeout_seconds=20)
        history.append({"role": "tool", "content": output.summary})
    return "达到最大执行步数"
```

**优点：**适合逻辑组合、数据操作、自动化和测试驱动任务。  
**缺点：**代码执行可能有副作用；文本代码扫描无法替代容器隔离、权限控制和资源限制。  
**适用：**数据分析、编码、受控文件操作。  
**不适用：**不允许代码执行或无法提供可信隔离的敏感场景。

---

## 三、Prompt Engineering 进阶

### Chain-of-Thought (CoT)

- CoT 是研究/描述推理步骤的一类方法，具有重要的历史与学术价值。
- **【更新】**对许多现代推理模型，不应默认添加“Let's think step by step”之类提示；模型本来就可能进行内部推理，额外提示不一定改善效果。
- **Zero-shot / Few-shot CoT：**经典提示技术，是否有效需按模型与任务测量。
- **ToT / GoT：**探索和组织多条推理路径的方法，不代表今天每个 Agent 都应该显式构建搜索树/图。
- **【纠错】**模型实际内部推理不等同于它展示给用户的推理说明；不可把一段生成出来的 Thought 当作完整、可信的内部决策日志。

### 上下文工程（Context Engineering）

上下文工程不只是修改提示词，而是为**每一次模型调用**选择和组织对任务最有价值的信息。

- **输入来源：**系统/开发者约束、用户请求、工具定义、检索结果、历史消息、工作状态、文件、记忆。
- **信息组织：**按需检索与渐进加载，避免全量塞入；维护来源、版本和重要性。
- **生命周期：**长任务按需要压缩、摘要或从文件重新读取，确保关键状态不因窗口替换而丢失。
- **可信边界：**网页、仓库、PDF、工具输出等都可能包含提示注入，不能提升为系统指令。
- **验收：**用任务成功率、成本、时延和失败案例验证上下文策略，而非盲目追求更长上下文。

### 结构化输出

- **JSON Mode：**一般用于限制输出为合法 JSON（具体保证依接口不同）。
- **Schema-constrained Structured Output：**尝试约束输出符合指定结构，仍需在业务侧校验语义和权限。
- **Function/Tool Calling：**表达工具调用意图；不是与普通结构化数据输出同一件事。
- **【补充】**遵循 Schema 仅意味着结构可能有效，不能保证字段值真实、工具调用合理或者业务操作安全。

---

## 四、MCP / A2A 等新兴协议

### MCP（Model Context Protocol）

- MCP 是连接 AI 应用与外部工具、资源、提示模板的开放协议，属于**宿主/客户端与工具服务端的通信层**。
- 常见角色：**Host**（承载应用与权限策略）、**Client**（与 Server 交互的协议客户端）、**Server**（暴露 Tools / Resources / Prompts）。
- 标准传输：**stdio**（本地子进程）与 **Streamable HTTP**（网络通信）。旧版 **HTTP+SSE** 已弃用，新系统不应以它作为首选架构。
- **【重要更新｜2026-07-28 规范】**相比 2025-11-25 版，协议核心转向无状态设计：取消旧版 `initialize`/`notifications/initialized` 初始化握手，版本和客户端能力随请求提供；新版 Streamable HTTP 移除独立 GET 订阅与协议级 Session ID。旧版客户端/服务端需要进行版本兼容处理。
- **【辨析】**“一次写好 MCP Server，所有 Agent 无需改动即可用”过于理想化。兼容性还取决于协议版本、工具能力、认证授权、客户端支持和部署环境。
- **安全：**校验调用者身份、最小权限、敏感工具审批、输入验证以及审计；使用协议不自动意味着接入安全。

### A2A（Agent-to-Agent）

- A2A 是面向**独立 Agent 系统间的互操作**的开放协议，最初由 Google 推动。
- Agent Card 描述能力、接口与认证要求；任务与消息用于委托、协作和状态跟踪。
- **【更新】**A2A 在 2026 年已有 1.0.0 版本；应按选用的协议版本阅读规范，不建议照搬早期 Agent Card URL、字段或任务接口。
- 与 MCP 的主要区别：MCP 更偏向应用接入**工具/资源**；A2A 更偏向不同自治 Agent 之间交互，两者可以组合。

### ANP（Agent Network Protocol）

- ANP 是探索 Agent 身份、发现、协商与安全互联的开放协议项目。
- 与 MCP/A2A 不完全同层次、也不应简单写成行业统一标准。
- **【辨析】**协议愿景与实际落地程度不同；开发前应先确认生态采用、实现成熟度、权限模型和必要性。

---

## 五、Agent 可靠性工程

### 重试机制

重试适用于**可恢复的暂时性失败**，例如部分限流、网络闪断；参数错误、权限拒绝、业务冲突通常不应无条件重试。

```python
import random
import time

def reliable_read_tool(tool, args, max_attempts=3):
    """仅示意无副作用的只读调用。写操作需要幂等键和去重。"""
    for attempt in range(max_attempts):
        try:
            return tool.execute(args)
        except (TimeoutError, ConnectionError):
            if attempt == max_attempts - 1:
                raise
            delay = min(8, 2 ** attempt) + random.uniform(0, 0.3)
            time.sleep(delay)
```

**【补充】**对于发邮件、下单、删除数据等有副作用的调用，网络超时不代表操作未成功。重试前必须查询执行状态，或使用幂等键/事务日志，防止重复执行。

### 回退策略（Fallback）

1. **工具回退：**可靠来源不可用时换备用来源，注意结果语义是否一致。
2. **模型回退：**能力足够且权限符合要求时切换模型；不要默默降级到不能满足任务的模型。
3. **流程回退：**失败时切回受限工作流，或者让用户确认继续方式。
4. **状态回退：**可恢复环境使用快照、版本控制或补偿操作；不是所有外部副作用都能撤销。

### 超时控制

- 单次工具调用与模型调用各有独立超时。
- 整个任务设置时间、token、货币成本和最大操作次数上限。
- 长任务可以进入持久化的暂停/恢复状态，而非只靠不断延长超时时间。

### 循环检测

```python
def no_progress(history, window=5):
    """示意：根据外部进度衡量，而非仅靠动作种类。"""
    recent = history[-window:]
    if len(recent) < window:
        return False
    return all(item.progress_delta == 0 for item in recent)
```

**【纠错】**“最近五步只有一两种操作”不代表死循环：分页检索、批量测试、逐文件处理都可能重复调用同一种工具。更好的信号是状态是否推进、是否重复相同参数与结果、是否触发预算上限。

---

## 六、Agent 成本控制

### Token 预算管理

除了 token 数，还要评估**按模型实际价格计算的费用**、工具/API 费用、重试次数与整体时延。

```python
class RunBudget:
    def __init__(self, max_tokens, max_cost_usd):
        self.max_tokens = max_tokens
        self.max_cost_usd = max_cost_usd
        self.used_tokens = 0
        self.used_cost_usd = 0.0

    def record(self, usage):
        # usage 为服务端实测的 token 与费用统计，不是凭空估算
        self.used_tokens += usage.total_tokens
        self.used_cost_usd += usage.cost_usd

    def exceeded(self):
        return (self.used_tokens >= self.max_tokens
                or self.used_cost_usd >= self.max_cost_usd)
```

**【补充】**需要在调用前做预算预留，并在返回后据实扣账；上下文 token、输出 token、缓存命中、工具调用费用和模型计费方式可能不同。

### 模型路由（Model Routing）

根据任务能力需求和真实 Benchmark 分配模型：

- **结构化提取/简单分类：**可先测成本较低的模型或确定性程序。
- **复杂规划/代码修复/困难推理：**考虑能力较强且经过任务验证的模型。
- **不确定任务：**先做轻量判别，必要时升级模型或增加检索/验证。

```python
def route_model(task, policy, eval_scores):
    candidates = policy.allowed_models(task.data_classification)
    eligible = [m for m in candidates
                if eval_scores[m][task.kind].success_rate >= policy.min_quality]
    if not eligible:
        return policy.safe_fallback  # 人工处理或保守失败
    return min(eligible, key=lambda m: eval_scores[m][task.kind].expected_cost)
```

**【更新】**不要把 GPT-4o/o1 等旧例及历史单价当作 2026 年的选型指南；具体版本、价格和可用区域会变化，应参照当日模型目录与实测结果。

### 其他成本控制策略

1. **提示缓存/结果缓存：**避免重复请求，但注意实时性、权限差异和缓存失效。
2. **提早完成：**基于外部验收条件结束，而不是只凭模型“很自信”。
3. **上下文裁剪：**按需提供相关文件和历史，保留关键信息。
4. **批处理：**只在服务支持、任务可批量且不损害响应体验时采用。
5. **减少无收益的模式叠加：**多一个 Critic/Planner/Agent 未必能换来更高成功率。

---

## 七、评估与监控

### Agent 评估维度

1. **任务成功率：**验证真实结果，区分模型声称完成与独立验收通过。
2. **可靠性：**首次通过率、恢复成功率、重复副作用率、权限违规率。
3. **工具质量：**工具选择、参数生成、调用成功及错误恢复。
4. **证据质量：**引用来源是否支持结论、事实是否可溯源。
5. **效率：**任务总耗时、关键路径、步数及可并行程度。
6. **成本：**实际 token、模型与工具费用、重试损耗。
7. **安全与用户体验：**越权率、恶意输入处理、人工接管体验。

**【辨析】**“步数越少越好”与“幻觉率可以用单个分数准确衡量”都不成立。成功与正确性通常比少几步更重要；应明确不同指标的判分方法。

### 评测框架

- **RAGAS / RAG 专项评测：**适用于检索、引用和回答质量等特定维度。
- **LangSmith / Phoenix / OpenTelemetry：**用于运行轨迹追踪、调试与评测工作流（能力因版本/配置而异）。
- **SWE-bench / GAIA / AgentBench：**分别覆盖软件修复和通用 Agent 相关任务，但不同数据集版本、污染风险和评分机制可能影响结论。
- **自建任务集：**优先覆盖自己的真实使用场景、失败案例、权限攻击与中断恢复。
- **LLM-as-Judge：**可辅助评估开放式答案，但应校准评审模型和人工一致性，不能替代所有客观验证。

**【补充】**推荐记录 Trace：模型调用、工具参数与结果、状态转移、审批、错误与最终可验证产物；注意对个人信息和密钥脱敏。

---

## 八、高频面试题

### 基础概念

**1. AI Agent 和传统 LLM 应用的本质区别是什么？**

**参考答案：**主要看下一步流程由谁决定。固定 Workflow 由开发者指定路径；Agent 会在允许的范围内依据反馈选择动作。两者可以混合：安全检查和审批由代码固定，探索过程可由模型决策。多轮或有状态并不是 Agent 独有特点。

---

**2. Agent 的记忆系统如何设计？长短期记忆各怎么实现？**

**参考答案：**先明确“要记什么、谁能改、何时失效”。短期上下文用于当前推理，任务工作状态用 Checkpoint 保存，长期事实交由文件/数据库持久化；全文、向量或图检索则帮助找到相关信息。不同记忆类型不是必须一一对应不同数据库。用户确认事实应有来源、版本与编辑权限，不能因相似度低或时间久就自动删除。

---

**3. 什么是 Tool Use / Function Calling？Agent 如何决定用哪个工具？**

**参考答案：**Tool Use 是访问外部能力；Function Calling 是多家模型支持的一种结构化工具请求机制。模型参考任务、工具描述和参数 Schema 选择工具；宿主负责授权、校验、执行、返回结果。工具数量没有统一最佳上限，应通过候选筛选、按需暴露和工具选择 Benchmark 测试。

---

**4. 解释 ReAct 模式的工作原理。**

**参考答案：**ReAct 把决策和执行交错进行：观察当前状态、选择动作、执行并获取反馈，然后继续。今天常用结构化 Tool Calling 而不是解析 `Thought/Action` 文本；可观察的是工具轨迹，而不是模型完整的隐藏推理。可以与显式规划和并行调用组合。

---

**5. 单 Agent vs 多 Agent 系统，如何选择？**

**参考答案：**先用单 Agent + 多工具建基线。只有发现需要独立上下文、专业化权限、并行探索或职责隔离时才拆分多 Agent，并使用任务完成率、成本、时延、错误率来评价收益。多 Agent 可能提升部分任务表现，也可能因沟通和状态同步降低可靠性。

---

### 设计与架构

**6. 如何设计一个 Agent 来完成「自动调研+写报告」的任务？**

**参考答案：**可以采用“提纲—检索—来源核验—写作—验收”的 Workflow，开放式检索环节使用 Agent Loop。报告必须附来源与引用，区分事实和推测；为每个研究子题设置完成条件与预算。只有调研并行化能被评测证明有效时才加入多个 Agent，不能默认必须上 Supervisor+Researcher+Writer 三件套。

---

**7. 多 Agent 系统中如何处理 Agent 间的通信和状态共享？**

**参考答案：**可通过子 Agent 工具调用、消息队列或共享状态协调。需要定义消息 Schema、任务 ID、状态所有者、版本与冲突处理策略；隔离不同 Agent 的最小上下文。多方写入同一数据时，必须使用事务、乐观锁、事件日志或适合的合并规则，而不能指望“共享内存”自然解决一致性。

---

**8. 如何实现 Human-in-the-loop？什么场景需要它？**

**参考答案：**敏感操作执行前保存任务状态并中断，向用户展示操作对象、参数、风险和影响范围；得到明确授权后恢复并再次校验。适用于对外沟通、资金、删除、生产环境变更及合规场景。不要只依赖模型的主观置信度触发审批；应有固定的权限和风险策略。

---

**9. Agent 的错误处理和容错机制如何设计？**

**参考答案：**按模型、工具、状态、业务副作用四层处理。短暂性故障可限次重试，永久错误要立即停止或更正输入；有副作用的操作使用幂等键。长任务记录 Checkpoint，配合时间/费用/步数上限与异常升级。成功必须经过外部验收，而非单靠模型自报。

---

**10. 如何控制 Agent 的成本（Token 消耗、API 调用）？**

**参考答案：**先设质量门槛与预算，再优化。核心手段是按任务选模型、缩减不相关上下文、缓存可重复结果、减少低收益的 Agent/Reflection 层和不必要的工具调用。统计应涵盖输入/输出/缓存 token、工具费用、失败重试和时延。不要使用过期模型报价或把“多 Agent 成本＝单 Agent×数量”当作精确公式。

---

### 工程实践

**11. Agent 在生产环境中有哪些常见问题？**

**参考答案：**常见问题包括上下文失真、工具参数错、循环无进展、不可恢复的副作用、权限越界、提示注入、成本和时延波动。对应措施是最小权限、沙箱、调用审计、持久状态、独立结果验证、预算上限与回归评测。仅降低 temperature 或在提示词中写“不要幻觉”远远不够。

---

**12. 如何调试一个复杂的 Agent 工作流？**

**参考答案：**记录 Trace 的每一轮输入摘要、工具调用、权限判断、返回、任务状态变化和成本，复现最小失败案例。区分工具 bug、检索缺失、模型决策、状态机问题与外部服务故障。某些推理模型的隐藏内部思维链不可取得，因此不应该以“记录完整 Thought”作为调试前提；观察可用的行为轨迹和执行证据即可。

---

**13. 如何评估 Agent 的性能？用什么指标？**

**参考答案：**首要是**独立验证的任务成功率**。再记录首次成功率、恢复成功率、工具与参数准确率、成本、端到端延迟、权限违规、人工接管率和结果质量。测试集应包含常规案例、历史失败、边界条件和恶意输入。开放式任务可辅以 LLM Judge，但客观测试和人工抽检不可缺少。

---

**14. Prompt Engineering vs Context Engineering，区别是什么？**

**参考答案：**Prompt Engineering 关注怎样准确表达指令；Context Engineering 关注每次推理时模型实际看到什么，包括哪些文件、检索片段、工具结果、历史和任务状态。后者是持续的选择、整理、压缩与更新过程，重点是信号质量、来源可信度和信息时效性，不是尽可能把窗口填满。

---

**15. MCP 协议是什么？它解决什么问题？**

**参考答案：**MCP 规范 AI 应用与工具服务的通信方式，通过 Host/Client/Server 和 Tools、Resources、Prompts 降低集成成本。标准传输是 stdio 和 Streamable HTTP。2026-07-28 版进一步改成无状态协议核心，取消旧初始化流程和协议级 Session；实际实现要明确版本兼容、认证授权与权限控制。它不等于模型的 Function Calling，也不自动保证所有客户端无差异支持。

---

### 场景设计

**16. 设计一个客服 Agent 系统。**

**要求：**多轮会话、知识库检索、工单创建、转人工。

**参考答案：**以单 Agent + 受控工具/工作流起步。知识库回答必须带来源；订单查询需要身份校验；创建工单要有去重键；退款或账户修改走明确审批。转人工条件包含用户明确请求、政策或权限要求、连续未解决以及无法核验事实。监测自主解决率、错误处理率、首次解决时间、投诉率与用户满意度。**【纠错】**不建议直接照搬“置信度 0.6”“连续三轮”的固定阈值，必须以真实数据校准。

---

**17. 设计一个代码审查 Agent。**

**要求：**读取 PR、分析代码、给出可执行建议。

**参考答案：**先获取 PR diff 与受影响文件上下文，再按风险优先级调用类型检查、测试、静态分析等工具。审查结论标出文件/行号、潜在故障路径、验证方式与置信依据。默认只读，发起修改或提交评论前检查权限；用历史 PR 的误报率、有效发现率以及独立验证结果评估，而不是仅依赖 Reflection 让模型“自查一遍”。

---

**18. 如何构建一个能自主学习和改进的 Agent？**

**参考答案：**先区分三层：①**记忆更新**，积累有来源的经验和知识；②**系统改进**，通过离线分析、提示词/工具/路由策略调整、Skill 更新和版本发布改善行为；③**模型参数训练**，通过专门的训练管线更新权重。前两种并不意味着模型自动改变参数，也不应一概称为 in-context learning。上线前应有可复现的 Benchmark、安全测试、版本控制、人工审批和回滚；用户反馈需要评估质量与隐私授权，不能未经检查就写进训练数据或权威记忆。

---

## 附录 A：主要勘误索引（原笔记位置 → 修订要点）

| 原位置 | 需要纠正或限定的地方 | 本修订版处理 |
|---|---|---|
| 一 / Agent 概念 | “传统应用必然单次、无状态” | 改为控制流与自主程度的区别 |
| 一 / 记忆 | 向量库作为长期记忆默认方案 | 区分权威存储和检索索引 |
| 一 / 工具 | Function Calling 说成 OpenAI 特有 | 改成跨厂商结构化工具调用能力 |
| 一 / 工具 | 固定 10～20 个工具上限 | 按任务检索候选、权限过滤、Benchmark |
| 二 / ReAct | 文本解析 Thought/Action；Thought 完全可解释 | 原生工具调用；隐藏推理不等于可观察轨迹 |
| 二 / Plan-and-Execute | `for enumerate(steps)` 内修改 `steps` | 使用可变 `remaining` 队列，保留重新规划逻辑 |
| 二 / Reflection | 自我评估等同于正确性提升 | 以测试、引用和外部验收优先 |
| 二 / Multi-Agent | 辩论与多角色被暗示为天然更强 | 先建单 Agent 基线，再按评测拆分 |
| 二 / CodeAct | 与 Function Calling 对立 | 代码执行也可作为一种工具 |
| 三 / CoT | “Let's think step by step”视为普适好方法 | 区分经典 CoT 与推理模型的提示实践 |
| 四 / MCP | 远程传输只写 SSE+HTTP | 更新到 2026-07-28，增加无状态与兼容说明 |
| 五 / 可靠性 | 不区分可重试与不可重试写操作 | 补幂等键、进度、恢复与验收 |
| 五 / 循环检测 | 少量动作类型即死循环 | 改成重复输入和“没有进度”检测 |
| 六 / 成本 | 旧模型价格作示范、忽略实际收费 | 使用实时选型、真实账单及质量门槛 |
| 八 / 第 16 题 | 固定置信度 0.6 自动转人工 | 按风险规则、实际校准与用户请求处理 |
| 八 / 第 18 题 | 自主学习都归入 in-context learning | 区分记忆、系统演进和参数训练 |

## 附录 B：核对资料（以官方文档为主）

- 原笔记源文件：<https://github.com/Zchary1106/agent-interview-hub/blob/main/通用知识/Agent核心概念与设计模式.md>
- Anthropic — Building effective agents：<https://www.anthropic.com/engineering/building-effective-agents>
- Anthropic — Effective context engineering for AI agents：<https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents>
- OpenAI — Agents SDK：<https://developers.openai.com/api/docs/guides/agents/sdk>
- OpenAI — Reasoning best practices：<https://developers.openai.com/api/docs/guides/reasoning-best-practices>
- MCP 官方 2026-07-28 发布：<https://blog.modelcontextprotocol.io/posts/2026-07-28/>
- MCP 2026-07-28 规范传输：<https://modelcontextprotocol.io/specification/2026-07-28/basic/transports>
- A2A 官方项目规范：<https://github.com/a2aproject/A2A/blob/main/docs/specification.md>

> **最后复盘：**经典模式仍可作为理解 Agent 的抽象。工程上不要为了“使用 ReAct/Plan/Reflection/Multi-Agent”而搭建模式；从可靠执行、明确权限、上下文质量和可验证结果出发，让 Benchmark 决定复杂度是否值得。
