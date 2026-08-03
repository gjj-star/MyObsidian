---
name: cangjie-skill-evaluation
description: cangjie-skill 评测：RIA-TV++ 方法论、亮点、局限、与 CC/WorkBuddy 的适配性
metadata: 
  node_type: memory
  type: reference
  originSessionId: 141ef463-5bcf-4e10-9949-c9444bcf49f7
---

## cangjie-skill 评测

把书籍、长视频、播客、课程里的方法论蒸馏成可被 AI agent 调用的原子化 skills。元 skill 地址: https://github.com/kangarooking/cangjie-skill

### 核心方法论: RIA-TV++

七阶段流水线：Adler 整书理解 → 5 并行提取（框架/原则/案例/反例/术语）→ 三重验证(V1跨域/V2预测力/V3独特性) → RIA++ 构造 → Zettelkasten 链接 → 压力测试(darwin 兼容) → 交付(DIGEST.md + 安装)

### 评分: 8/10

**亮点**: 方法论有学术根基(Adler/赵周RIA/Luhmann)、三重验证是真正的质量分水岭(通过率25-50%)、面向agent执行的设计(trigger/判停/边界)、生态定位清晰(nuwa蒸馏人+cangjie蒸馏书+darwin进化)、19+已产出skill packs验证

**问题**: 重度依赖底层AI模型质量(弱模型会让三重验证形同虚设)、计算成本高(7阶段全agent驱动)、不是独立工具(纯SOP)、视频需先转录、只适合方法论密集型内容

### 平台适配

| 平台 | 产物(产出的skills) | 元skill(蒸馏流水线本身) |
|---|---|---|
| Claude Code | ✅ 原生格式 | ✅ Agent工具并行提取 |
| WorkBuddy | ✅ SKILL.md通用 | 🟡 需适配(并行→Team Mode) |

### 推荐使用方案

**方案A(推荐)**: CC里跑蒸馏 → 产出的skills同时装到CC和WorkBuddy。原因: 三重验证依赖Claude推理质量,混元/DeepSeek会降质。

**Why:** cangjie是目前最成熟的"内容→agent skill"蒸馏方案，方法论设计扎实。选型时核心判断是"跑蒸馏的模型质量"而非"skill安装的平台"。

**How to apply:** 首次用一本熟悉的短书(如《1000个铁粉》)试点，Opus跑全流程，验证产出skill的调用准确率后再规模化。
