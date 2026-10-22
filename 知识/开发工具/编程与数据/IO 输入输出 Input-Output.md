---
name: I/O 输入输出 Input-Output
node_type: memory
type: knowledge
description: I/O（输入/输出）基础——从键盘屏幕到磁盘/网络/数据库/设备四类 I/O，为什么程序关注 I/O（等待远比计算慢）、I/O 密集 vs CPU 密集、同步/异步与阻塞/非阻塞，以及"I/O 相对系统边界"的视角
modified: 2026-10-22T08:00:00.000Z
aliases: [I/O, 输入输出, Input-Output, IO]
tags: [开发工具, 编程与数据]
---

# I/O 输入输出

I/O = Input / Output，即输入 / 输出。

它是计算机领域最基础的概念之一。

简单来说：只要数据从一个地方进入另一个地方，就可能涉及 I/O。

## 1. 举个最简单的例子

假设你写了一段 Python 程序：

```python
name = input("请输入你的名字：")
print(f"你好，{name}")
```

这里发生了两次 I/O：
- Input（输入）：通过键盘输入名字，数据进入程序。
- Output（输出）：程序把文字输出到终端。

可以理解为：

```mermaid
%%{init: {"theme":"base","themeVariables":{"background":"#000000","edgeLabelBackground":"#000000","fontFamily":"Microsoft YaHei, Arial, sans-serif"},"flowchart":{"curve":"linear","nodeSpacing":45,"rankSpacing":85}}}%%

flowchart LR
    A["`键盘
    输入数据`"]
    B["`程序
    处理数据`"]
    C["`屏幕
    输出结果`"]

    A -->|Input| B
    B -->|Output| C

    style A fill:#0d0f12,stroke:#94a3b8,stroke-width:2px,color:#ffffff,font-size:20px
    style B fill:#071327,stroke:#3b82f6,stroke-width:2px,color:#ffffff,font-size:20px
    style C fill:#0d0f12,stroke:#94a3b8,stroke-width:2px,color:#ffffff,font-size:20px

    linkStyle 0 stroke:#16a34a,stroke-width:3px,color:#16a34a
    linkStyle 1 stroke:#2563eb,stroke-width:3px,color:#2563eb
```

## 2. I/O 不只是键盘和屏幕

在实际的软件开发中，I/O 的含义要广泛得多。

| I/O 类型 | 举例 |
| --- | --- |
| 磁盘 I/O | 读取文件、写入日志 |
| 网络 I/O | HTTP 请求、下载文件 |
| 数据库 I/O | 查询、读取、写入数据 |
| 设备 I/O | 键盘、鼠标、摄像头 |

需要注意：数据库 I/O 往往涉及磁盘 I/O 和网络 I/O，它们不是完全独立的分类。

## 3. 为什么程序员特别关注 I/O？

因为 I/O 往往比 CPU 在内存中计算慢得多。

例如，你的网站需要从数据库读取一篇文章：

1. 程序发送数据库查询请求。
2. 等待数据库返回数据。
3. 程序收到数据。
4. 把文章返回给浏览器。

假设查询耗时 100ms，而程序处理数据只需要 1ms。

那么程序花费的绝大部分时间都在等待 I/O，而不是计算。

这就引出了几个特别重要的概念：

- **I/O 密集型**：程序主要时间花在等待数据读写，例如爬虫、文件上传、数据库访问。
- **CPU 密集型**：程序主要时间花在计算，例如视频编码、复杂数学运算。
- **同步 / 异步 I/O**：程序如何组织 I/O 操作，以及如何获取操作完成的结果。
- **阻塞 / 非阻塞 I/O**：发起操作后，调用线程是否必须等待。

其中，同步不一定等于阻塞，异步也不简单等于多线程。

还有一个特别值得理解的地方：**I/O 是相对于某个系统边界而言的。**

例如，从磁盘读取文件，对于 CPU 上运行的程序来说是输入；而向网络发送文件，则是输出。同一份数据，在不同系统、不同方向上可以扮演不同角色。
