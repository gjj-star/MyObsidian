---
name: ai-literature-search-capabilities
description: AI 文献查找能力现状：能做和不能做的、学术 skills 推荐、MCP 配置、WorkBuddy+Zotero 方案
metadata: 
  node_type: memory
  type: reference
  originSessionId: 141ef463-5bcf-4e10-9949-c9444bcf49f7
---

## AI 文献查找能力评估

### 能力现状

| 能做好的 | 弱项 |
|---|---|
| 按主题找经典文献 | 2024年后增量论文盲区 |
| 已知论文摘要提取 | 灰色文献几乎不可见(预印本v1/中文期刊) |
| 跨领域关联联想 | "找不到"≠"不存在"(非穷举搜索) |
| 自然语言→检索式 | 引用网络分析弱(不如Connected Papers) |
| 多源交叉验证 | 幻觉文献(中文比英文严重得多) |
| — | 权威性判断粗糙 |

### 推荐 Skills

| 场景 | 推荐 | 亮点 |
|---|---|---|
| 通用文献全流程 | `literature-research` (biocheming) | 11模块: 发现→阅读→筛选→评估→综合→比较→可视化→趋势→空白→书目, 质量评分78.3 |
| 已有本地PDF综述 | `efficient-literature-survey` (namooubn) | 30篇500万字符→3万token, 节省99.4% |
| 中文文献(知网/万方) | `academic-research-skills` (YuanyuanMa03) | 58技能覆盖8平台 |
| 引文追溯 | `semantic-scholar-skills` (TyTodd) | expand-references/trace-citations/paper-triage |

### 推荐 MCP

**s2-mcp-server** (smaniches): 14工具, 一行配置 `uvx s2-mcp-server`, 免费API key 100req/s

### 推荐组合

```
检索引擎: s2-mcp-server (MCP)       ← Semantic Scholar API
综述工作流: literature-research      ← 筛选/评估/综合/输出
中文补充:   academic-research-skills ← 知网/万方
文献管理:   Zotero MCP              ← WorkBuddy直连(WB独有优势)
```

### WorkBuddy 配置要点

- Skills路径: `~/.workbuddy/skills/`
- MCP配置: `~/.workbuddy/mcp.json`
- Zotero: 设置→高级→勾选"允许此计算机上的应用程序与Zotero通讯"

**Why:** AI文献检索能力有明确边界，知道"不能做什么"比知道"能做什么"更重要。正确的姿势是AI生成候选+人工验证+AI做关联分析，而不是让AI直接推荐论文列表。

**How to apply:** 文献综述时用 s2-mcp-server 做初筛 → 人工验证 → literature-research 做筛选评估 → Zotero 管理 → 输出结构化综述。
