---
name: 在 D 天内送达包裹的能力 Capacity to Ship Packages
node_type: memory
type: knowledge
description: LeetCode 1011 二分答案经典题笔记——暴力枚举到 check(容量) 模拟运输、发现单调性再到二分搜索最小可行容量，Python/TypeScript 双实现
modified: 2026-09-09T07:50:00.000Z
aliases: [LeetCode 1011, Capacity to Ship Packages Within D Days, 二分答案, 二分查找]
tags: [数据结构与算法, 力扣实战]
---

# LeetCode 1011：在 D 天内送达包裹的能力

## 题目核心

给定包裹重量数组 `weights` 和规定天数 `days`，求船的**最小运载能力**，使得所有包裹能在 `days` 天内送达。

> 关键约束：包裹必须按数组顺序运输，**不能重新排序**。

示例：`weights = [1,2,3,4,5,6,7,8,9,10], days = 5` → 答案 15。

---

## 我的解题历程（五步）

> 这一节按真实思考顺序记录，重点是第 3 步踩的坑。

### 第 1 步：定答案的边界

题目没说每天重量有序，所以没法在数组上做文章，转而思考"答案（船容量）本身落在什么范围"：

- **下界** `left = max(weights)`：船再小也得装得下最重的包裹，否则那个包裹永远运不走；
- **上界** `right = sum(weights)`：容量够大时一次全装走，再大没有意义。

答案一定在 `[max(weights), sum(weights)]` 里。

### 第 2 步：暴力直觉

以 `weights = [1..10]` 为例，容量范围 `[10, 55]`。最直观的想法：把每个容量都试一遍，算出各自需要的天数，找满足条件的最小容量。

——这就是暴力枚举答案，能跑，但范围是 S（总和）级别的，太慢。

### 第 3 步：踩坑 —— 判断条件不是"天数恰好等于 days"，而是"不超过 days"

最初写的条件是"天数**刚好等于** days 的最小容量"，这是错的。

自己举的例子 `1..10` 是等差数列，碰巧掩盖了这个问题。实际上**天数不是容量的连续函数**：相邻容量可能需要完全相同的天数，"恰好等于 days"的容量可能根本不存在。

修正为 `check(capacity) <= days`，问题就从"找精确命中"变成"找最左可行解"——这才是二分能处理的形式。

### 第 4 步：发现单调性，上二分

关键观察：**容量越大 → 每天装得越多 → 需要的天数越少**（单调不增）。

```text
容量:  10 11 12 13 14 15 16
天数:   8  7  7  6  5  5  4

要求 days = 5:
       ×  ×  ×  ×  √  √  √
                 ↑ 第一个可行位置就是答案
```

有了单调性，"mid 可行"就意味着"比 mid 大的全都可行"，可以放心砍掉一半范围。

### 第 5 步：补全 check —— 给定容量怎么算天数

顺序固定时，装船策略是**确定**的，没有规划空间：

- 当前船还装得下 → 继续装；
- 装不下 → 换一天，当前包裹作为新一天的第一件。

遍历一遍即可算出天数。

---

## 思路定型：二分答案

**核心转变**：这题不是"怎么安排包裹最优"，而是"**给定容量，运输结果是否唯一确定**"——是。所以：

```text
给容量 → 模拟运输 → 判断可行性 → 在答案范围上二分
```

**二分流程**：

```python
left, right = max(weights), sum(weights)
while left <= right:
    mid = (left + right) // 2
    if check(mid) <= days:   # mid 可行 → 答案 ≤ mid，往左缩
        right = mid - 1
    else:                    # mid 不可行 → 答案 > mid，往右缩
        left = mid + 1
return left                  # 循环结束时 left = 最小可行容量
```

**check 函数**：

```text
check(capacity):
    day = 1, current_weight = 0
    for weight in weights:
        if current_weight + weight <= capacity:
            current_weight += weight      # 能装就装
        else:
            day += 1                      # 装不下换一天
            current_weight = weight
    return day
```

check 示例：`weights = [1,2,3,4,5,6], capacity = 6` → 第一天 1+2+3=6，之后 4、5、6 各占一天 → `check(6) = 4`。

---

## 为什么不是动态规划？

问题长得像"把包裹分成 D 组使每组最大重量最小"，容易想到 `dp[i][j]`（前 i 个包裹分 j 天）。

但**顺序固定**这个约束让 check 变得免费：给定容量后每天怎么装已经没有选择，"能装就装"就是最优（也是唯一）策略。所以根本不需要 DP 做决策，直接模拟 + 二分即可。

> 反过来说：如果题目允许重排包裹，check 就不再唯一，这题会从二分答案升级为 NP 难的装箱问题。

---

## 复杂度

- `check`：遍历一次数组 → **O(n)**
- 二分次数：答案范围约 S（总和）→ **O(log S)**
- **总时间：O(n log S)**，**空间：O(1)**

---

## Python 代码

```python
from typing import List

class Solution:
    def shipWithinDays(self, weights: List[int], days: int) -> int:
        # 判断容量 capacity 是否能在 days 天内运完
        def check(capacity):
            day = 1
            current_weight = 0
            for weight in weights:
                if current_weight + weight <= capacity:
                    current_weight += weight   # 能装就装
                else:
                    day += 1                   # 装不下，换一天
                    current_weight = weight
            return day

        # 答案边界：至少装下最重包裹，至多一次全装走
        left = max(weights)
        right = sum(weights)

        # 二分找最小可行容量
        while left <= right:
            mid = (left + right) // 2
            if check(mid) <= days:
                right = mid - 1              # 可行，尝试更小
            else:
                left = mid + 1               # 不可行，增大容量
        return left
```

---

## TypeScript 代码

```typescript
function shipWithinDays(weights: number[], days: number): number {
    function check(capacity: number): number {
        let day = 1;
        let currentWeight = 0;
        for (const weight of weights) {
            if (currentWeight + weight <= capacity) {
                currentWeight += weight;
            } else {
                day++;
                currentWeight = weight;
            }
        }
        return day;
    }

    let left = Math.max(...weights);
    let right = weights.reduce((sum, weight) => sum + weight, 0);

    while (left <= right) {
        const mid = Math.floor((left + right) / 2);
        if (check(mid) <= days) {
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return left;
}
```

---

## 二分答案通用模板

看到"**求最小的 X，使某条件成立**"且"X 越大越容易满足条件"（单调性），就可以套：

```text
定答案范围 [left, right]
    ↓
取 mid，check(mid)
    ↓
可行   → right = mid - 1（往左找更小）
不可行 → left  = mid + 1（往右找可行）
```

同族题目：

- **875** 爱吃香蕉的珂珂（最小速度）
- **410** 分割数组的最大值（本题换皮）
- **1482** 制作 m 束花所需的最少天数

---

## 一句话记忆

> 二分不只能"在有序数组里找数"，它适用于一切**答案具有单调性**的问题——数组本身不需要有序。
