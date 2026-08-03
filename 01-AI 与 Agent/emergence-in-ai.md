---
name: emergence-in-ai
description: 涌现（Emergence）概念、在 LLM 中的表现、争议和关键论文
metadata: 
  node_type: memory
  type: reference
  originSessionId: ccaa9fff-80e5-4190-ab19-dc67c8a34ec5
---

## 涌现（Emergence）

涌现是指系统在规模增长到某个临界点后，突然表现出此前完全不具备的新能力——这些能力无法通过简单外推小规模时的表现来预测。量变引起质变，且质变是"跳"出来的。

## 经典类比

- 蚁群：单只蚂蚁行为简单，但群体能筑巢、寻路、分工——"智能"是群体属性
- 生物神经网络：860 亿神经元连在一起产生意识
- 交通流：简单跟车规则在宏观上形成逆向传播的拥堵波
- 雪花：水分子间只有氢键，却产生六角对称的复杂结构

## LLM 中的涌现能力

- 算术推理：小模型（<10B）乱猜，大模型（>100B）突然能一步步算对
- 多步推理：Chain-of-Thought 只在足够大的模型上才有效
- 代码理解：突然能从注释生成函数、理解跨文件调用
- 翻译：翻到一半的语言对突然变 fluent
- 理论心智：理解"小明不知道小红知道的事"这种嵌套意图
- 自我纠错：DeepSeek-R1 在 RL 训练中自发学会"等等，我再想想"

## 涌现的关键特征

1. 非渐进性（Phase Transition）：像水在 100°C 突然沸腾
2. 不可从小规模预测：Scaling Law 只能预测 loss，不能预测哪个能力在哪个规模出现
3. 普适性：同一规模的不同训练 run 都会出现类似能力

## 主要争议

Schaeffer 等人（2023）：涌现可能是度量方式的幻觉。用 accuracy 这种离散指标看是跳跃，用 log probability 这种连续指标看是平滑增长。争论未完全解决，但共识是：大模型确实能做小模型做不到的事。

## 关键论文

- Jason Wei et al. (2022): "Emergent Abilities of Large Language Models" — 首次系统描述涌现
- Schaeffer et al. (2023): "Are Emergent Abilities of Large Language Models a Mirage?" — 挑战涌现的真实性
