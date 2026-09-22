---
name: RAG 检索增强生成
node_type: memory
type: knowledge
description: 检索增强生成（RAG）的原理、三代演进、Embedding/Rerank/LLM 模型选型、效果评测体系与 Graph RAG、Agentic RAG 等前沿方向
modified: 2026-08-11T10:20:00.000Z
aliases: [embedding-rerank-llm-comparison, Retrieval-Augmented Generation, RAG, 检索增强生成]
tags: [开发工具, 编程与数据]
---

# RAG 检索增强生成 Retrieval-Augmented Generation

**英文**：Retrieval-Augmented Generation（RAG，检索增强生成）；Embedding（嵌入）；Rerank（重排序）；Top-K（取相似度前 K 个）；Chunk（文本块）；Vector Database（向量数据库）；Hallucination（幻觉）

RAG 的基本思路：在让大模型生成回答之前，先从外部知识库中检索与问题相关的信息，把检索结果连同用户问题一起交给模型，让模型基于真实资料作答。解决企业落地的四个现实问题：**时效性**（读取最新文档，无需重训）、**专业性**（垂直领域基于权威资料）、**幻觉**（机制上减少无依据编造）、**可解释可审计**（回答可回溯到具体条款）。

## 为什么不能只靠长上下文

"能给出一个回答"和"在真实业务中持续、稳定、可控地给出正确答案"是两回事。盲目把文档全塞进上下文有三类问题：

1. **成本与效率**：推理成本与上下文长度强正相关；绝大多数任务只需极少相关信息，全量塞入浪费计算资源
2. **注意力与聚焦**：上下文过长时模型出现注意力衰减（偏向末尾）和信息干扰（被无关内容带偏）
3. **知识更新与可控性**：重训/微调投入高周期长；回答依据难以追溯，合规审计困难

## 工作流程

1. **索引阶段**：文档清洗 → 切分为语义完整的 chunks → Embedding 模型转高维向量 → 存入向量数据库（Pinecone / Weaviate / FAISS / Milvus）
2. **检索阶段**：用户问题向量化 → 计算余弦相似度 → Top-K 召回最相关片段（可设最低相似度阈值，无关查询直接空召回）
3. **生成阶段**：把「系统指令 + 检索片段 + 用户问题」拼成结构化 prompt 发给 LLM，要求严格基于参考信息作答、注明依据

> 注：**Top-N 与 Top-K**——概念上等价（都是"按分数排序后取前几个"），K 是检索论文的标准写法，N 常见于工程文档；在 RAG 流水线里两者同时出现时代表两个阶段：向量库召回取 **Top-N**（粗排，量大，如 50-100，保覆盖率），Rerank 精排后取 **Top-K**（最终上下文，量小，如 3-5，保精度），N > K。

## 三代演进

| 代际 | 核心 | 局限 |
|---|---|---|
| **Naive RAG** | 固定长度切块 → 向量相似度检索 → 简单拼接生成 | 切块粗糙截断语义、检索信号单一、噪音直接进上下文 |
| **Advanced RAG** | 检索前优化：语义感知分块 + 元数据、查询重写（Query Rewrite）、多路查询（Multi-Query）、子问题分解（Sub-Query）、Step-back Prompting；检索后优化：Rerank 重排、筛选去重压缩 | 工业界主流范式 |
| **Modular RAG** | 可插拔功能模块按需编排：查询理解与路由、多源检索与融合、记忆与个性化、任务适配与治理；生成中发现信息不足可主动触发多轮检索 | 从中枢式知识编排层迈向 Agent |

## 三类核心模型选型

**技术架构对比**：

| 维度 | Embedding | Rerank | LLM |
|------|-----------|--------|-----|
| 架构 | 双塔（Bi-Encoder）：Query 和 Doc 各一个塔，独立编码后余弦相似度匹配 | 单塔（Cross-Encoder）：Query + Doc 拼接后一起输入 | Decoder-only（GPT 式）：自回归逐 token 生成 |
| 推理速度 | 极快（向量检索，ANN 索引） | 中等（每条候选都要过一遍模型） | 慢（逐 token 生成） |
| 典型大小 | 0.1B-1B 参数 | 0.3B-3B 参数 | 7B-2000B+ 参数 |
| 输入长度 | 短文本为主（512 token） | 中等（512-8K token） | 长文本（128K-1M token） |
| 输出 | 固定维度向量 | 相关性分数 | 自然语言文本 |

Pipeline 协作：① Embedding 在向量库中召回 Top-50~100 候选 → ② Rerank 精排筛选 Top-5~10 → ③ LLM 拼接 Prompt 生成回答。**为什么不能只用一步**：只用 Embedding 粗召回精度不够（Top-1 可能不相关）；只用 Rerank 无法在海量数据上逐一跑（太慢太贵）；只用 LLM 无法塞入所有知识。三者是分工协作的 Pipeline，不是竞争关系。

1. **Embedding**（决定召回质量）：看 MTEB 基准（8 类任务 56 个数据集）；核心参数是**维度**（越高语义刻画越细，成本越高）与**上下文长度**（短文本 512-1024 token 够用，长文档要 2048+）。常用：text-embedding-3-large、bge-m3（混合检索）、Qwen2-Embedding 系列
2. **Rerank**（精排，修正召回排序）：参考 Agentset Reranker Leaderboard（ELO / nDCG@10 / 延迟）。常用：BGE Reranker v2 M3、Cohere Rerank、Voyage Rerank 2.5
3. **LLM**（生成）：私有化部署（Qwen / Llama / GLM 系列，7B-14B 即不错）或云端 API；选型参考 LMArena（盲测对战），最终用 20-30 个典型业务问题做端到端 A/B 测试，可大小模型搭配降本

## 效果评测

- **检索指标**：Recall@K / Precision@K / F1（覆盖与准确）；MRR / NDCG@K / MAP（排序质量）。工程组合：Recall@K + MRR@K
- **生成指标**：EM（精确匹配，答案唯一场景）；ROUGE / BLEU / METEOR（词面重叠）；BertScore / 向量相似度（语义）；**Hallucination / Faithfulness**（逐句核查答案能否在检索文档中找到依据）
- **LLM-as-a-Judge**：用更强模型从相关性、完整性、忠实性、正确性四维评分
- **框架**：RAGAS（综合性）、ARES（分类器辅助）、RGB（生成阶段细分维度）、MultiHop-RAG（多跳推理）；领域基准：MedRAG（医疗）、LegalBench-RAG（法律）
- **落地要点**：评测数据要代表真实业务（分层采样 + 专家标注 + 线上反馈持续补充）；"评测 → 发现问题 → 调整 → 再评测"循环迭代

## 前沿方向

- **Graph RAG**：用 LLM 从文本抽取实体与关系构建知识网络，先定位局部结构再沿连接扩展——擅长需要联系多份文档的推理问题，与向量检索互补。相关研究见 arxiv 2404.16130（Microsoft GraphRAG）
- **Multimodal RAG**：跨模态语义对齐（ViT/CLIP 编图像、Whisper 编音频、OCR/ASR/版面分析抽取），统一多模态索引，图片/视频/音频均可作为检索与回答依据
- **Late Chunking**："先编后切"——用长上下文嵌入模型先编码整篇文档生成全局感知的 token 向量，再分块池化；解决指代词跨块失联（相似度 0.71 → 0.83），已在 Jina Embeddings v3 落地
- **Agentic RAG**：RAG 从被动检索工具变为 Agent 的**长期记忆系统**——结构化索引 + 智能遗忘 + 知识巩固（沉淀为知识图谱）；支持多跳检索与迭代反思（见 [[多智能体架构 Multi-Agent Architecture]] 的认知架构延伸）

## 相关

- [[知识图谱 Knowledge Graph]] — Graph RAG 的底层结构
- [[多智能体架构 Multi-Agent Architecture]] — Agentic RAG 与 Agent 长期记忆
- [[Ollama 概览]] — 私有化部署开源 LLM 的本地方案
- [[SSE 流式解析]] — RAG 生成的流式输出对接

> 来源：Datawhale Easy-Vibe 教程《什么是RAG以及它如何工作》（2026-08-11 剪藏）
