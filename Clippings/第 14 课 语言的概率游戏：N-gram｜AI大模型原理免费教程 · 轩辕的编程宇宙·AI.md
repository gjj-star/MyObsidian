---
title: "第 14 课 语言的概率游戏：N-gram｜AI大模型原理免费教程 · 轩辕的编程宇宙·AI"
source: "https://www.xuanyuancode.com/ai-llm/lessons/nlp-01-ngram"
author:
published:
created: 2026-09-23
description: "AI大模型原理免费教程·第 14 课《语言的概率游戏：N-gram》，从向量到 Transformer，适合新手小白零基础入门。本课从一个问题出发：不懂语法、不懂语义，光靠「数数」能不能接出下一个词？"
tags:
  - "clippings"
---
第 1 站

## 手机怎么猜下一个字

你用手机打字，输入「今天天气」，键盘弹出三个候选词： **「真好」「不错」「怎么样」** 。 它是怎么猜出来的？

手机没有读懂「天气」这个概念，没有联网查天气预报，也没有问过你今天心情好不好。 它做的事情极其简单： **翻历史记录，数数** 。

想象手机偷偷读过几千万条中文消息。每次看到「今天天气」这四个字后面跟着什么，就记一笔：

<svg viewBox="0 0 560 180" role="img" aria-label="「今天天气」之后的词频统计"><text x="30" y="28" font-family="Noto Sans SC, sans-serif" font-size="13" font-weight="700" fill="#232F3B">在几千万条消息里，「今天天气」后面跟着……</text> <g><text x="80" y="58" text-anchor="end" font-family="Noto Serif SC, serif" font-size="13" fill="#232F3B">真好</text> <rect x="88" y="43" width="311.2888888888889" height="18" rx="3" fill="#3E6B8F" opacity="0.6"></rect><text x="407.2888888888889" y="57" font-family="JetBrains Mono, monospace" font-size="11" fill="#3E6B8F">4,120 次</text></g> <g><text x="80" y="84" text-anchor="end" font-family="Noto Serif SC, serif" font-size="13" fill="#232F3B">不错</text> <rect x="88" y="69" width="293.9111111111111" height="18" rx="3" fill="#3E6B8F" opacity="0.6"></rect><text x="389.9111111111111" y="83" font-family="JetBrains Mono, monospace" font-size="11" fill="#3E6B8F">3,890 次</text></g> <g><text x="80" y="110" text-anchor="end" font-family="Noto Serif SC, serif" font-size="13" fill="#232F3B">怎么样</text> <rect x="88" y="95" width="191.9111111111111" height="18" rx="3" fill="#5C6B79" opacity="0.6"></rect><text x="287.9111111111111" y="109" font-family="JetBrains Mono, monospace" font-size="11" fill="#5C6B79">2,540 次</text></g> <g><text x="80" y="136" text-anchor="end" font-family="Noto Serif SC, serif" font-size="13" fill="#232F3B">好热</text> <rect x="88" y="121" width="141.2888888888889" height="18" rx="3" fill="#5C6B79" opacity="0.6"></rect><text x="237.2888888888889" y="135" font-family="JetBrains Mono, monospace" font-size="11" fill="#5C6B79">1,870 次</text></g> <g><text x="80" y="162" text-anchor="end" font-family="Noto Serif SC, serif" font-size="13" fill="#232F3B">太差了</text> <rect x="88" y="147" width="74.04444444444444" height="18" rx="3" fill="#93A0AC" opacity="0.6"></rect><text x="170.04444444444442" y="161" font-family="JetBrains Mono, monospace" font-size="11" fill="#93A0AC">980 次</text></g></svg>

图 14-1「今天天气」后面出现频率最高的词。手机只需按频率排序，就能给出三个候选。

下次你输入「今天天气」，手机就把出现最多的几个词推给你。 **这就是手机输入法的基本原理——纯粹的数数，和「理解语言」毫无关系。**

手机是不是真的「懂」你在说什么？如果你前面刚写了「最近身体不太好」， 它还会推荐「今天天气真好」吗？

第 2 站

## 让方法更通用：看最近 N 个词

上面的方法每次都看整段「今天天气」这个固定短语—— 如果用户输入的是「今天的天气」，历史记录就完全对不上号了，方法失效。

更实用的做法：不管前面说了多少， **只看最近的几个词** ，用它们来预测下一个词。 看最近 1 个词，叫「一元模型」；看最近 2 个词，叫「二元模型」； 看最近 N 个词，就叫 **N-gram** （N 元语言模型）。

<svg viewBox="0 0 560 160" role="img" aria-label="N-gram 预测示意：看最近 N 个词预测下一个"><text x="280" y="22" text-anchor="middle" font-family="Noto Sans SC, sans-serif" font-size="13" fill="#5C6B79">句子：「我 昨天 买 了 一 只 猫」，预测下一个词</text> <g><rect x="20" y="40" width="58" height="40" rx="5" fill="#F5F0E8" stroke="#DCD2BF" stroke-width="1"></rect><text x="49" y="66" text-anchor="middle" font-family="Noto Serif SC, serif" font-size="15" font-weight="700" fill="#93A0AC">我</text></g> <g><rect x="85" y="40" width="58" height="40" rx="5" fill="#F5F0E8" stroke="#DCD2BF" stroke-width="1"></rect><text x="114" y="66" text-anchor="middle" font-family="Noto Serif SC, serif" font-size="15" font-weight="700" fill="#93A0AC">昨天</text></g> <g><rect x="150" y="40" width="58" height="40" rx="5" fill="#F5F0E8" stroke="#DCD2BF" stroke-width="1"></rect><text x="179" y="66" text-anchor="middle" font-family="Noto Serif SC, serif" font-size="15" font-weight="700" fill="#93A0AC">买</text></g> <g><rect x="215" y="40" width="58" height="40" rx="5" fill="#F5F0E8" stroke="#DCD2BF" stroke-width="1"></rect><text x="244" y="66" text-anchor="middle" font-family="Noto Serif SC, serif" font-size="15" font-weight="700" fill="#93A0AC">了</text></g> <g><rect x="280" y="40" width="58" height="40" rx="5" fill="#F5F0E8" stroke="#DCD2BF" stroke-width="1"></rect><text x="309" y="66" text-anchor="middle" font-family="Noto Serif SC, serif" font-size="15" font-weight="700" fill="#93A0AC">一</text></g> <g><rect x="345" y="40" width="58" height="40" rx="5" fill="#EBF2F8" stroke="#3E6B8F" stroke-width="2"></rect><text x="374" y="66" text-anchor="middle" font-family="Noto Serif SC, serif" font-size="15" font-weight="700" fill="#3E6B8F">只</text></g> <g><rect x="410" y="40" width="58" height="40" rx="5" fill="#EBF2F8" stroke="#3E6B8F" stroke-width="2"></rect><text x="439" y="66" text-anchor="middle" font-family="Noto Serif SC, serif" font-size="15" font-weight="700" fill="#3E6B8F">猫</text></g> <g><rect x="475" y="40" width="58" height="40" rx="5" fill="#FDF6EC" stroke="#C0481E" stroke-width="2"></rect><text x="504" y="66" text-anchor="middle" font-family="Noto Serif SC, serif" font-size="15" font-weight="700" fill="#C0481E">？</text></g> <path d="M 350 90 L 350 110 L 473 110 L 473 90" fill="none" stroke="#3E6B8F" stroke-width="1.5"></path><text x="411" y="130" text-anchor="middle" font-family="Noto Sans SC, sans-serif" font-size="11" fill="#3E6B8F">N=2：看「只」「猫」</text> <text x="411" y="145" text-anchor="middle" font-family="Noto Sans SC, sans-serif" font-size="11" fill="#3E6B8F">→ 预测「咪」「叫」「跑」？</text></svg>

图 14-2N-gram 只看最近 N 个词（蓝色部分），忽略更早的内容。N=2 时，无论前面说了什么，都只用「只」和「猫」来预测下一个词。

实际上，大部分手机输入法和早期语音助手都在用 N=2 或 N=3 的版本。 这个方法简单、快速，而且训练方式也很简单： 爬下大量文本，把每一段连续的 N 个词都数一遍，统计频率，存成一张巨大的表格就完成了。 **不需要理解语言，不需要语法规则，只需要数数。**

这张表长什么样、又怎么「查」？以二元模型（N=2）为例：想预测「天气」后面接什么，就翻到 **前文 =「天气」** 这一块， 数一数语料里它后面各个词分别出现过多少次，再除以「天气」的总出现次数，就得到每个候选词的概率：

前文 =「天气」　·　语料中 count(「天气」) = 10,000

| 下一个词 w | 共现次数 count(「天气」, w) | 概率 P(w │「天气」) = 次数 ÷ 10,000 |
| --- | --- | --- |
| 真好 | 2,300 | 23.0% |
| 不错 | 2,100 | 21.0% |
| 预报 | 1,800 | 18.0% |
| 怎么样 | 1,500 | 15.0% |
| 好热 | 1,000 | 10.0% |
| 香蕉 | 3 | 0.03% |
| （其余几千个词合计） | 1,297 | 13.0% |

图 14-3N-gram 的「查表」长这样（二元模型，前文 =「天气」）。预测时就找到当前前文那一行区块，按概率挑下一个词。注意「香蕉」只共现 3 次、概率几乎为零——语料里没怎么数到的组合，N-gram 就只能给个近乎 0 的概率。整本表里， **每一个可能的前文都对应这样一行区块** 。

换个角度看，这张频率表其实就是 **条件概率** ：给定前面 N 个词，下一个词出现的可能性有多大。 第 6 课说过，一个语言模型的本质，就是给「下一个词」分配一张概率分布表—— 「今天天气」之后，「真好」占 23%、「不错」占 21%、「香蕉」占 0.001%…… N-gram 就是这个想法 **最朴素的实现** ：直接拿历史频率当概率，能数则数，数不到就抓瞎。 后面几课要做的事，都是在换更聪明的方式去估计这同一张概率表。

第 3 站

## 局限：记性只有两三个词

试着用 N=2 的模型来补完这句话：

「那只从小在胡同里长大、非常怕生人的小猫，今天第一次\_\_」

真正要填的词，应该和「小猫」「怕生人」「第一次」都有关—— 也许是「出门」「见生人」「叫出声来」。 但 N=2 的模型只看最后两个词： **「第一次」\_\_** 。 「第一次」后面最常见的搭配是什么？大概是「听说」「尝试」「见到」…… 完全不知道前面在说一只猫的事。

加大 N 也救不了

你可能想说：N 调大一点不就好了？把 N 从 2 改成 5，看最近 5 个词。 问题是：训练数据里，见过「怕生人的小猫，今天第一次」这整个组合的概率几乎为零。 N 越大，每个具体组合出现的次数越少，大量组合根本从未出现过。

打个比方：你统计了 100 亿条对话，但「非常怕生人的小猫今天第一次出门」这整句话， 一次也没出现过。N-gram 对「没见过的组合」完全束手无策，只能乱猜或者返回「不知道」。 N 越大，「没见过的组合」就越多——两难困境。

N-gram 还有一个更根本的毛病。即使见过「猫」后面接「出门」，也没法推断「小猫」后面能接「出门」。为什么？

第 4 站

## N-gram 能做什么，不能做什么

尽管有这些局限，N-gram 在几十年间一直是语言技术的支柱：

- 手机输入法的候选词推荐
- 早期语音识别（把声音转成文字时，用 N-gram 过滤掉"听起来像但文法奇怪"的结果）
- 垃圾邮件过滤（某些词组合在一起高度可疑）
- 机器翻译的初级版本

它之所以有用，是因为 **语言里大量的短距离搭配是非常固定的** 。 「天气」后面接「预报」的概率，远高于接「香蕉」的概率。 这些规律靠数数就能捕捉到，不需要任何深层理解。

但它做不到的事情同样明显：长句子、跨句子的理解、词义的灵活性—— 这些都需要一个能「理解词的含义」而不只是「认识词的形状」的工具。 下一课解决「词」本身的问题。

第 5 站

## 总结

本课核心 · TAKEAWAY

N-gram 是语言预测的「数数法」： 看最近 N 个词，查历史统计，找最常见的下一个词。 不需要理解语言，只需要一张巨大的频率表。 但它的记性只有 N 个词——超出这个范围的上下文，完全看不到。

### 这一课你亲手推导了

- **N-gram 的思路** ：看最近 N 个词 → 查频率表 → 预测下一个词。
- **训练方式** ：爬大量文本，统计每段连续词组出现的频率，存成表格。
- **局限①** ：只有 N 个词的记性，无法处理长距离依赖。
- **局限②** ：把词当成符号，「猫」和「小猫」是两个毫不相关的符号。

小测验

## 学习小测验

做完这一课，来检测一下核心知识点。选出你的答案后点击「提交」，即可看到正确选项与讲解。

Q1N-gram 语言模型预测下一个词时，用的是什么思路？

Q2N-gram 模型最致命的问题之一是「稀疏性」，它指的是什么？


<iframe sandbox="allow-forms allow-popups allow-popups-to-escape-sandbox allow-same-origin allow-scripts allow-top-navigation-by-user-activation" frameborder="0" src="https://googleads.g.doubleclick.net/pagead/ads?client=ca-pub-5639745717417263&amp;output=html&amp;adk=1812271804&amp;adf=3025194257&amp;abgtt=6&amp;lmt=1790132767&amp;plaf=1%3A2%2C2%3A2%2C7%3A2&amp;plat=1%3A128%2C2%3A128%2C3%3A128%2C4%3A128%2C8%3A128%2C9%3A32768%2C16%3A8388608%2C17%3A32%2C24%3A32%2C25%3A32%2C30%3A1081344%2C32%3A32%2C41%3A32%2C42%3A32%2C43%3A32%2C44%3A32&amp;format=0x0&amp;url=https%3A%2F%2Fwww.xuanyuancode.com%2Fai-llm&amp;pra=5&amp;aiof=11&amp;asro=0&amp;aimartd=4&amp;aieuf=1&amp;aicrs=1&amp;uach=WyJXaW5kb3dzIiwiMTkuMC4wIiwieDg2IiwiIiwiMTUzLjAuNDIzNC40OCIsbnVsbCwwLG51bGwsIjY0IixbWyJNaWNyb3NvZnQgRWRnZSIsIjE1My4wLjQyMzQuNDgiXSxbIk5vdF9BIEJyYW5kIiwiOC4wLjAuMCJdLFsiQ2hyb21pdW0iLCIxNTMuMC44MDEwLjUzIl1dLDBd&amp;dt=1790132767348&amp;bpp=1&amp;bdt=440&amp;idt=25&amp;shv=r20260922&amp;mjsv=m202609170101&amp;ptt=9&amp;saldr=aa&amp;abxe=1&amp;cookie_enabled=1&amp;eoidce=1&amp;nras=1&amp;correlator=940671808965&amp;frm=20&amp;pv=2&amp;u_tz=480&amp;u_his=1&amp;u_h=1440&amp;u_w=2560&amp;u_ah=1440&amp;u_aw=2560&amp;u_cd=24&amp;u_sd=1&amp;dmc=32&amp;adx=-12245933&amp;ady=-12245933&amp;biw=1255&amp;bih=1355&amp;scr_x=0&amp;scr_y=0&amp;eid=95403099&amp;oid=2&amp;pvsid=2629324270473200&amp;tmod=18369963&amp;uas=0&amp;nvt=7&amp;fsapi=1&amp;fc=1920&amp;brdim=-7%2C0%2C-7%2C0%2C2560%2C0%2C1294%2C1447%2C1270%2C1355&amp;vis=1&amp;rsz=%7C%7Cs%7C&amp;abl=NS&amp;fu=32768&amp;bc=31&amp;bz=1.02&amp;pgls=CAk.&amp;ifi=1&amp;uci=a!1&amp;fsb=1&amp;dtd=31" title="Advertisement" aria-label="Advertisement"></iframe>