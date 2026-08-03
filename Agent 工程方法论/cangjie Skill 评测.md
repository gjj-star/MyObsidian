---
name: cangjie Skill 评测
description: cangjie-skill 评测：RIA-TV++ 方法论、亮点、局限、与 CC/WorkBuddy 的平台适配性
metadata:
  node_type: memory
  type: reference
  originSessionId: 141ef463-5bcf-4e10-9949-c9444bcf49f7
aliases: [cangjie-skill-evaluation, cangjie-skill]
---

# cangjie Skill 评测

把书籍、长视频、播客、课程里的方法论蒸馏成可被 AI Agent 调用的原子化 skills 的元 skill（元地址：https://github.com/kangarooking/cangjie-skill）。

**英文**：Skill（AI Agent 可调用能力封装）；RIA-TV++（Reading–Interpretation–Appropriation + Triple Verification，读–解–用拆书法 + 三重验证）；Zettelkasten（卢曼卡片盒笔记法）；CC（Claude Code）

## 核心方法论：RIA-TV++

七阶段流水线：

1. **Adler 整书理解**（阿德勒《如何阅读一本书》式通读）
2. **5 并行提取**（框架 / 原则 / 案例 / 反例 / 术语）
3. **三重验证**（V1 跨域 / V2 预测力 / V3 独特性）
4. **RIA++ 构造**（赵周拆书法的增强版）
5. **Zettelkasten 链接**（卡片盒笔记法建立知识网络）
6. **压力测试**（darwin 兼容）
7. **交付**（DIGEST.md + 安装）

## 评分：8/10

**亮点**

- 方法论有学术根基（Adler / 赵周 RIA / Luhmann 卢曼）
- 三重验证是真正的质量分水岭（通过率 25–50%）
- 面向 agent 执行的设计（trigger / 判停 / 边界）
- 生态定位清晰：nuwa（蒸馏人）+ cangjie（蒸馏书）+ darwin（进化）
- 19+ 已产出 skill packs 验证

**问题**

- 重度依赖底层 AI 模型质量（弱模型会让三重验证形同虚设）
- 计算成本高（7 阶段全 agent 驱动）
- 不是独立工具（纯 SOP）
- 视频需先转录
- 只适合方法论密集型内容

## 平台适配

| 平台 | 产物（产出的 skills） | 元 skill（蒸馏流水线本身） |
|---|---|---|
| Claude Code | ✅ 原生格式 | ✅ Agent 工具并行提取 |
| WorkBuddy | ✅ SKILL.md 通用 | 🟡 需适配（并行 → Team Mode） |

## 推荐使用方案

**方案 A（推荐）**：在 Claude Code 里跑蒸馏 → 产出的 skills 同时装到 Claude Code 和 WorkBuddy。原因：三重验证依赖 Claude 的推理质量，混元 / DeepSeek 会降质。

**Why:** cangjie 是目前最成熟的"内容 → agent skill"蒸馏方案，方法论设计扎实。选型时的核心判断是"跑蒸馏的模型质量"而非"skill 安装的平台"。

**How to apply:** 首次用一本熟悉的短书（如《1000 个铁粉》）试点，Opus 跑全流程，验证产出 skill 的调用准确率后再规模化。
