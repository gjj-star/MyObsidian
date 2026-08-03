---
name: rpa-basics
description: RPA 机器人流程自动化的定义、工作原理、典型场景、与 API/AI 的区别与局限
metadata: 
  node_type: memory
  type: knowledge
  originSessionId: 1d96bcb2-b3c5-46cd-b222-e16e5ba9566b
---

RPA（Robotic Process Automation，机器人流程自动化）：用软件"机器人"自动执行规则明确、重复性高的业务流程，方式是在现有软件界面上模拟人的操作（点击、录入、复制粘贴、跨系统搬运数据）。

**核心特征**：非侵入式（不改造/不依赖被操作系统的接口，直接在 UI 层操作，适合无 API 的老旧系统）；规则驱动（if-then 固定流程）；可 7x24 运行。

**典型场景**：财务对账、发票/报销处理、HR 入职离职流程、数据迁移与核对、客服工单流转、报表生成。

**与相近概念区别**
- vs API/传统集成：RPA 不需系统开放接口，绕过集成直接模拟 UI，适合封闭/遗留系统；代价是脆弱（UI 一变易崩）。
- vs 脚本/宏：RPA 更企业级，带可视化流程编排、集中治理、权限与审计。
- vs AI Agent/LLM：传统 RPA 是"死规则"，处理不了非结构化或异常；Agentic RPA（结合 LLM）能应对更灵活、需判断的任务。

**代表工具**：UiPath、Automation Anywhere、Blue Prism（海外）；影刀、来也、弘玑（国内）。

**局限**：系统 UI/布局变动即失效、维护成本高、只适合稳定且规则清晰的流程、异常需人工兜底。
