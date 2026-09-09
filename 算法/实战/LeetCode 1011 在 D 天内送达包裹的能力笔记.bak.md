---
name: 在 D 天内送达包裹的能力 Capacity to Ship Packages
node_type: memory
type: knowledge
description: LeetCode 1011 二分答案经典题笔记——暴力枚举到 check(容量) 模拟运输、发现单调性再到二分搜索最小可行容量，Python/TypeScript 双实现
modified: 2026-09-09T03:20:00.000Z
aliases: [LeetCode 1011, Capacity to Ship Packages Within D Days, 二分答案, 二分查找]
tags: [算法, 实战]
---

# LeetCode 1011：在 D 天内送达包裹的能力

## 题目核心

给定：

- `weights`：包裹重量数组
- `days`：规定天数

要求：

找到船的**最小运载能力**，使得所有包裹能在 `days` 天内按顺序送达。

注意：

> 包裹必须按照数组顺序运输，不能重新排序。

例如：

```text
weights = [1,2,3,4,5,6,7,8,9,10]
days = 5
```

需要找到最小船容量。

---

# 第一反应：暴力枚举答案

## 思路

船的容量一定在：

```text
[max(weights), sum(weights)]
```

之间。

原因：

## 最小容量

必须至少装下最重的包裹。

例如：

```text
weights = [3,7,2]
```

船容量不能小于：

```text
7
```

否则重量为 7 的包裹永远无法运输。

所以：

```text
left = max(weights)
```

---

## 最大容量

最大情况：

一次把所有包裹全部装走。

所以：

```text
right = sum(weights)
```

---

因此答案范围：

```text
[max(weights), sum(weights)]
```

---

## 暴力思路

例如：

```text
weights = [1,2,3,...,10]

范围：

[10,55]
```

那么：

尝试：

```text
capacity = 10
capacity = 11
capacity = 12
...
capacity = 55
```

对于每个容量：

计算它需要多少天。

找到：

```text
需要天数 <= days
```

中的最小容量。

---

## 关键问题

如何计算：

> 给定容量 capacity，需要几天？

这就是 check 函数。

---

# check(capacity)：模拟运输

## 思路

如果知道船容量：

```text
capacity = 15
```

那么每天怎么装其实是确定的。

规则：

- 能装就继续装
- 装不下就换一天

不需要考虑其他方案。

---

## 伪代码

```text
check(capacity):

    day = 1
    当前重量 current_weight = 0


    遍历每个包裹 weight:

        如果当前重量 + weight <= capacity:

            当前船继续装
            current_weight += weight


        否则:

            船装不下
            换一天

            day += 1

            当前包裹放到新的一天
            current_weight = weight


    返回 day
```

---

## 示例

```text
weights = [1,2,3,4,5,6]
capacity = 6
```

过程：

第一天：

```text
1+2+3=6
```

第二天：

```text
4
```

第三天：

```text
5
```

第四天：

```text
6
```

所以：

```text
check(6)=4
```

---

# 发现单调性

关键观察：

船容量越大：

- 每天能装更多
- 需要的天数越少

所以：

```text
容量增加
↓
运输天数减少
```

例如：

```text
capacity:

10 11 12 13 14 15 16

天数:

8  7  7  6  5  5  4
```

如果要求：

```text
days = 5
```

那么：

```text
10 11 12 13 14 15 16
×  ×  ×  ×  √  √  √
```

答案就是：

> 第一个满足条件的位置。

---

# 二分答案

## 核心思想

不是在数组里找数字。

而是在答案范围里找：

> 最小的可行容量。

条件：

```text
capacity 是否能在 days 天内完成运输？
```

---

## 二分流程

范围：

```text
left = max(weights)

right = sum(weights)
```

计算：

```python
mid = (left + right) // 2
```

检查：

```text
check(mid)
```

---

## 情况1：mid 可行

如果：

```text
check(mid) <= days
```

说明：

```text
mid 足够大
```

但是可能还能更小。

所以：

```text
答案在左边
```

移动：

```python
right = mid - 1
```

---

## 情况2：mid 不可行

如果：

```text
check(mid) > days
```

说明：

```text
mid 太小
```

容量不够。

所以：

```text
答案在右边
```

移动：

```python
left = mid + 1
```

---

# Python代码

```python
class Solution:
    def shipWithinDays(self, weights: List[int], days: int) -> int:

        def check(capacity):

            day = 1
            current_weight = 0

            for weight in weights:

                if current_weight + weight <= capacity:
                    current_weight += weight

                else:
                    day += 1
                    current_weight = weight

            return day


        left = max(weights)
        right = sum(weights)


        while left <= right:

            mid = (left + right) // 2

            if check(mid) <= days:

                # 容量够，可以尝试更小
                right = mid - 1

            else:

                # 容量不够，需要增大
                left = mid + 1


        return left
```

---

# TypeScript代码

```typescript
function shipWithinDays(
    weights: number[],
    days: number
): number {


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

    let right = weights.reduce(
        (sum, weight) => sum + weight,
        0
    );


    while (left <= right) {

        const mid = Math.floor(
            (left + right) / 2
        );


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

# 复杂度分析

设：

- `n = weights长度`
- `S = sum(weights)`

---

## check函数

每次遍历一次数组：

```text
O(n)
```

---

## 二分次数

答案范围：

```text
[max(weights), sum(weights)]
```

大小约为：

```text
S
```

所以：

```text
O(logS)
```

---

总复杂度：

```text
O(n logS)
```

空间：

```text
O(1)
```

---

# 为什么很多人想到动态规划？

因为这个问题看起来像：

> 把包裹分成 D 组，使每组最大重量最小。

这确实类似 DP。

例如：

状态可能：

```text
dp[i][j]
```

表示：

```text
前 i 个包裹分成 j 天的最优答案
```

---

但是这题有一个关键条件：

## 包裹顺序固定

不能：

```text
[1,5,2,8]
```

重新排列。

所以：

给定一个容量：

```text
capacity
```

每天怎么装已经没有选择。

只能：

```text
能装就装
不能装换天
```

因此：

```text
capacity
↓
唯一确定
↓
需要多少天
```

于是可以：

```text
二分容量
+
check判断
```

---

# 二分答案模板

以后看到：

> 求最小的 X，使某个条件成立

可以考虑：

```text
答案范围
    ↓
取mid
    ↓
check(mid)
    ↓

可行：
    往左缩小范围

不可行：
    往右缩小范围
```

---

# 本题思维演进

## 第一阶段：暴力

尝试所有容量：

```text
10
11
12
...
55
```

复杂度高。

---

## 第二阶段：发现规律

容量越大：

```text
需要天数越少
```

出现单调性。

---

## 第三阶段：二分答案

寻找：

```text
第一个满足条件的容量
```

得到：

```text
O(n logS)
```

---

# 最终记忆

这题不是：

> 怎么安排包裹最优？

而是：

> 如果我规定船容量是多少，运输结果是不是已经确定？

答案：

是。

所以：

```text
给容量
↓
模拟运输
↓
判断可行性
↓
二分寻找最小容量
```

这就是「二分答案」。