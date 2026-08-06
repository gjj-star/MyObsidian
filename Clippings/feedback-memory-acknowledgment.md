---
name: feedback-memory-acknowledgment
description: 用户要求每次创建/更新知识记录后明确告知
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 21246bc1-5f35-4147-ab92-1badbfdc6fb6
---

每次在记忆中保存新知识后，必须在对话回复末尾明确加上一句"已创建/添加 XXX 知识记录"（或"已更新 XXX 记忆"），让用户无需主动询问就知道记忆已落盘。

**Why:** 用户不想每次都追问"你记了没"，显式确认能减少摩擦。

**How to apply:** 每次调用 Write/Edit 写入或更新记忆文件后，在回复最后一行加上确认语句。
