---
name: 哈希与哈希不一致 Hash
node_type: memory
type: knowledge
description: 哈希（Hash）作为数据"指纹"的原理、哈希不一致的四大排查场景，以及与一致性哈希的概念区分
modified: 2026-08-25T02:30:00.000Z
aliases: [Hash, 哈希, 哈希校验, integrity check]
tags: [开发工具, 编程与数据]
---

# 哈希与哈希不一致 Hash

**英文**：Hash（哈希）；MD5（Message-Digest Algorithm 5，消息摘要算法 5）；SHA-256（Secure Hash Algorithm 256，安全哈希算法 256）；Integrity Check（完整性校验）；Consistent Hashing（一致性哈希）

哈希是数据的**"指纹"**：MD5、SHA-256 等算法把任意长度的数据压缩为固定长度的字符串。同一数据 + 同一算法 → 结果必然相同；结果不一致，说明数据被篡改、损坏，或对比对象本身不同。

## 哈希不一致的四个常见场景

| 场景 | 表现 |
|---|---|
| 文件下载校验 | 比对官方公布的校验和（checksum），不一致说明文件下载损坏或被篡改 |
| 包管理器安装报错 | npm/pnpm 报 `integrity check failed`：lockfile 记录的哈希与 registry 实际内容不符，常见于缓存损坏 |
| Git 对象哈希校验 | 仓库损坏时 Git 校验对象哈希失败 |
| CDN 缓存校验 | ETag 基于内容哈希，用于判断缓存是否过期（配合 [[HTTP 状态码]] 的 304/412 语义） |

## 易混概念

- **哈希不一致 ≠ 一致性哈希**：一致性哈希（Consistent Hashing）是分布式系统中数据分布与节点路由的算法，与数据校验无关。

## 相关

- [[GitHub 代码审查 GitHub Code Review]] — Git 提交对象依赖同一套哈希机制
- [[HTTP 状态码]] — ETag 缓存校验与 304/412 状态码的关系

> 来源：CC 对话记录 conversation-log（2026-08-24）
