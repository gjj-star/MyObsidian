---
name: guided-vs-procedural-skills
description: 引导型 skill vs 工程型 skill 的概念分化、市场需求分析、构建方法论
metadata: 
  node_type: memory
  type: project
  related: "[[ollama-overview]] [[emergence-in-ai]]"
  originSessionId: ccaa9fff-80e5-4190-ab19-dc67c8a34ec5
---

## 引导型（Guided）vs 工程型（Procedural）Skill

工程型 skill 解决"怎么做"（How），引导型 skill 解决"要什么"（What）。

用户输入"帮我做一份高级感 PPT"时存在 articulation gap——脑子里有模糊想法但无法翻译成可执行规格。工程型 skill 直接生成（猜），导致返工；引导型 skill 先通过结构化提问澄清需求再执行。

## 市场需求分析

- Prompt 高手（能写完整 brief）：<5%，不需要引导型
- 会用但不会写 prompt（核心客群）：~70%
- 完全不用 AI 的：~25%，引导型可能是入门桥梁

## 为什么市面上做得少

1. 商业激励反着走：按 token 计费奖励"直接生成 + 返工"路径，引导型的提问 token 是前置成本
2. 构建成本不对称：引导型需要领域专家 + AI skill 作者的双重身份，交集很小
3. 质量无法自动化验证：引导型 skill 的品质只能靠真实用户反馈，无法写测试
4. 用户预期错位：用户把 AI 当执行者而非需要理解需求的专家

## 构建方法论（四步，可复用）

1. 专家知识提取：让 AI 扮演领域专家，提取所有决策点
2. 依赖压缩：找出可推断的问题，精简到最少必要集
3. 默认值设计：每个问题给推荐默认值 + 简短解释
4. 实现 + 审查 + 反馈迭代

## 学术/工业界前沿

- MAC（Amazon, NeurIPS 2025）：多 Agent 协作澄清，成功率 +7.8%
- ECLAIR（Adobe, AAAI 2025）：企业场景多 Agent 澄清框架
- HumanEvalComm（UBC, 2025）：>60% LLM 在需求模糊时仍直接生成代码而非提问
- Open Agent Skills 标准（agentskills.io）：25+ 产品兼容的 SKILL.md 格式
