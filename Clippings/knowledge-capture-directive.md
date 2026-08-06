---
name: knowledge-capture-directive
description: 用户要求把其不懂、经解释的技术知识写入知识库，而非仅当一次性对话
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 1d96bcb2-b3c5-46cd-b222-e16e5ba9566b
---

当用户主动询问、且经解释后属于"用户原本不懂的技术概念 / 名词定义 / 原理"时，应将其提炼为精炼的知识条目写入知识库（memory `type: knowledge`），而非仅当作一次性对话丢弃。

**Why:** 用户希望积累可复习的个人知识库。通用技术知识（如 Docker 定义、容器概念）对文档是噪音，但对正在学习的用户是待掌握的新知，值得持久化以便日后检索与复习。这修正了此前"仅记 user/feedback/project/reference 四类、通用知识不记"的默认策略——该策略未考虑"知识对用户的陌生度"。

**How to apply:** 每次解释完用户明显不懂的技术知识后，提炼成知识条目（聚焦定义、原理、对比，精简可复习），保存并在回复末尾按 [[feedback-memory-acknowledgment]] 设定显式告知"已添加 XXX 知识记录"。知识条目使用 `type: knowledge`。
