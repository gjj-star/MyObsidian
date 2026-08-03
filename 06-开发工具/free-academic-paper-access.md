---
name: free-academic-paper-access
description: 非中国大陆学术论文免费获取途径：arXiv、Semantic Scholar、Sci-Hub、Unpaywall、作者直索等渠道对比
metadata: 
  node_type: memory
  type: reference
  originSessionId: 141ef463-5bcf-4e10-9949-c9444bcf49f7
---

## 非中国大陆学术论文免费获取途径

### 完全免费合法渠道

| 渠道 | 覆盖范围 | 用法 |
|---|---|---|
| **arXiv** | STEM 预印本，月均2万篇 | arxiv.org 直接下载 |
| **Semantic Scholar** | 2亿+论文，`isOpenAccess` 字段 | s2-mcp-server 直接搜 |
| **PubMed Central** | 生物医学，NIH 资助论文必须开放 | ncbi.nlm.nih.gov/pmc |
| **Google Scholar** | 搜标题+PDF，找作者主页免费版 | scholar.google.com |
| **Unpaywall** | 浏览器插件，自动标绿免费版 | unpaywall.org |
| **DOAJ** | 1.8万+纯OA期刊 | doaj.org |
| **机构知识库** | 哈佛DASH、MIT DSpace等 | 各大学官网 |

### 灰色地带（免费但侵权）

- **Sci-Hub**: 8500万+论文，DOI直达PDF，域名常变（Wikipedia查最新）
- **Library Genesis**: 论文+书籍
- **Anna's Archive**: 三源聚合搜索

### 合法但需操作

- **直接找作者要**: 发邮件，成功率很高（作者不靠付费墙赚钱）
- **作者主页/Google Scholar页面**: 教授常自挂PDF
- **预印本版本**: 付费版是publisher's version，arXiv上有免费的preprint（内容一样）
- **Interlibrary Loan**: 大学图书馆互借扫描，免费但慢

### 实操优先级

① arXiv → ② s2-mcp-server查isOpenAccess → ③ Google Scholar搜标题+PDF → ④ Sci-Hub扔DOI → ⑤ 给作者发邮件

90%的论文在前四步能拿到。

### 与已有工具整合

已装的 `s2-mcp-server` 结果中 `isOpenAccess: true` 和 `openAccessPdf` 字段直接给免费PDF链接。配 Unpaywall 浏览器插件效果更好。

**Why:** 学术付费墙是研究效率的主要障碍，但这些免费渠道组合使用可覆盖绝大多数需求。关键是知道优先级顺序而非逐个尝试。

**How to apply:** 搜论文→先查arXiv→s2-mcp-server筛isOpenAccess→Scholar搜PDF→Sci-Hub兜底。装Unpaywall插件自动化前两步。
