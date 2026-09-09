---
name: 两数之和 Two Sum
node_type: memory
type: knowledge
description: LeetCode 1 两数之和三种解法笔记——暴力枚举/排序+双指针/哈希表，坑点（先查后记、返回下标、TS 排序比较函数）与"空间换时间"思维演进
modified: 2026-09-09T03:12:33.000Z
aliases: [Two Sum, LeetCode 1, LeetCode 第一题]
tags: [算法, 实战]
---

# LeetCode 1：两数之和（Two Sum）

## 题目核心

给定一个整数数组 `nums` 和目标值 `target`，找到数组中两个数，使它们之和等于 `target`，并返回这两个数在**原数组中的下标**。

例如：

```text
nums = [2, 7, 11, 15]
target = 9

因为：
2 + 7 = 9

所以返回：
[0, 1]
```

---

# 一、暴力枚举

## 思路

最直接的想法：

遍历数组中的每一个数，然后让它与它后面的每一个数相加。

例如：

```text
nums = [2, 7, 11, 15]
```

检查顺序：

```text
2 + 7
2 + 11
2 + 15

7 + 11
7 + 15

11 + 15
```

只要找到：

```text
nums[i] + nums[j] == target
```

就返回：

```text
[i, j]
```

---

## 伪代码

```text
遍历数组中的每一个位置 i

    遍历 i 后面的每一个位置 j

        如果 nums[i] + nums[j] == target
            返回 [i, j]
```

---

## Python

```python
def two_sum(nums, target):
    for i in range(len(nums)):
        for j in range(i + 1, len(nums)):
            if nums[i] + nums[j] == target:
                return [i, j]

    return []
```

---

## TypeScript

```typescript
function twoSum(nums: number[], target: number): number[] {
    for (let i = 0; i < nums.length; i++) {
        for (let j = i + 1; j < nums.length; j++) {
            if (nums[i] + nums[j] === target) {
                return [i, j];
            }
        }
    }

    return [];
}
```

---

## 时间复杂度

第一层循环大约执行：

```text
n 次
```

第二层循环也可能执行：

```text
n 次
```

所以：

```text
O(n²)
```

空间复杂度：

```text
O(1)
```

因为没有额外创建随着数组变大的数据结构。

---

## 坑点

### 1. `j` 应该从 `i + 1` 开始

错误：

```python
for j in range(len(nums)):
```

这样会产生：

```text
2 + 2
7 + 2
7 + 7
```

不仅重复，还可能让同一个元素和自己配对。

正确：

```python
for j in range(i + 1, len(nums)):
```

含义就是：

> 当前这个数，只和它后面的数字比较。

---

### 2. 返回的是下标，不是数字

错误：

```python
return [nums[i], nums[j]]
```

例如会返回：

```text
[2, 7]
```

题目真正要求的是：

```text
[0, 1]
```

所以应该：

```python
return [i, j]
```

---

# 二、排序 + 双指针

## 思路

如果数组是**从小到大有序的**，可以分别从最左边和最右边开始。

定义：

```text
i = 最左边
j = 最右边
```

计算：

```text
nums[i] + nums[j]
```

如果：

```text
nums[i] + nums[j] == target
```

找到答案。

如果：

```text
nums[i] + nums[j] < target
```

说明当前和太小。

因为数组有序，所以左边的数是较小的数。

因此让：

```text
i += 1
```

也就是让左指针向右移动。

如果：

```text
nums[i] + nums[j] > target
```

说明当前和太大。

右边是较大的数，因此：

```text
j -= 1
```

让右指针向左移动。

---

## 例子

```text
nums = [2, 7, 11, 15]
target = 18
```

开始：

```text
[2, 7, 11, 15]
 ↑          ↑
 i          j
```

计算：

```text
2 + 15 = 17
```

因为：

```text
17 < 18
```

所以左边太小：

```text
i += 1
```

变成：

```text
[2, 7, 11, 15]
    ↑       ↑
    i       j
```

计算：

```text
7 + 15 = 22
```

因为：

```text
22 > 18
```

所以右边太大：

```text
j -= 1
```

变成：

```text
[2, 7, 11, 15]
    ↑   ↑
    i   j
```

计算：

```text
7 + 11 = 18
```

找到答案。

---

# 问题：LeetCode 第一题的数组默认无序

例如：

```text
nums = [3, 2, 4]
target = 6
```

不能直接使用双指针。

因为：

```text
3 + 4 = 7
```

大于 `6`。

如果让右指针左移：

```text
3 + 2 = 5
```

又小于 `6`。

最终会错过真正的答案：

```text
2 + 4 = 6
```

原因是：

> 双指针中“和太大就移动右边、和太小就移动左边”的逻辑，依赖数组已经有序。

所以必须：

```text
先保存原始下标
↓
排序
↓
双指针
↓
找到答案
↓
返回原始下标
```

---

## 伪代码

```text
创建一个新数组

其中每个元素保存：
    数值
    原始下标

例如：

nums = [3, 2, 4]

变成：

[
    (3, 0),
    (2, 1),
    (4, 2)
]

按照数值排序

得到：

[
    (2, 1),
    (3, 0),
    (4, 2)
]

设置：

i = 0
j = 最后一个位置

当 i < j：

    current_sum = 左边数字 + 右边数字

    如果 current_sum == target：
        返回左右两个数字的原始下标

    如果 current_sum < target：
        i += 1

    如果 current_sum > target：
        j -= 1
```

---

## Python

```python
def two_sum(nums, target):
    indexed_nums = [(num, i) for i, num in enumerate(nums)]

    indexed_nums.sort(key=lambda x: x[0])

    left = 0
    right = len(indexed_nums) - 1

    while left < right:
        left_num = indexed_nums[left][0]
        right_num = indexed_nums[right][0]

        current_sum = left_num + right_num

        if current_sum == target:
            return [
                indexed_nums[left][1],
                indexed_nums[right][1]
            ]

        elif current_sum < target:
            left += 1

        else:
            right -= 1

    return []
```

---

## TypeScript

```typescript
function twoSum(nums: number[], target: number): number[] {
    const indexedNums = nums.map((num, index) => {
        return {
            num,
            index
        };
    });

    indexedNums.sort((a, b) => a.num - b.num);

    let left = 0;
    let right = indexedNums.length - 1;

    while (left < right) {
        const currentSum =
            indexedNums[left].num + indexedNums[right].num;

        if (currentSum === target) {
            return [
                indexedNums[left].index,
                indexedNums[right].index
            ];
        }

        if (currentSum < target) {
            left++;
        } else {
            right--;
        }
    }

    return [];
}
```

---

## 时间复杂度

建立新数组：

```text
O(n)
```

排序：

```text
O(n log n)
```

双指针：

```text
O(n)
```

总时间：

```text
O(n) + O(n log n) + O(n)
```

取最高阶：

```text
O(n log n)
```

空间复杂度：

```text
O(n)
```

因为需要保存：

```text
数字 + 原始下标
```

---

## 坑点

### 1. 数组无序时不能直接双指针

双指针的关键不是：

> 一左一右放两个指针。

真正关键是：

> 数组的有序性允许我们排除不可能的答案。

---

### 2. 排序之后下标发生变化

例如：

```text
原数组：

[3, 2, 4]
```

下标：

```text
3 → 0
2 → 1
4 → 2
```

排序：

```text
[2, 3, 4]
```

现在排序后的位置变成：

```text
2 → 0
3 → 1
4 → 2
```

但题目要求的是：

```text
原始下标
```

所以必须提前保存：

```text
数字 → 原始下标
```

---

### 3. TypeScript 排序一定要写比较函数

错误：

```typescript
nums.sort();
```

JavaScript / TypeScript 默认可能按照字符串方式排序。

例如：

```text
[2, 10, 3]
```

可能会按照：

```text
10
2
3
```

这样的字符串顺序处理。

数字排序应该：

```typescript
nums.sort((a, b) => a - b);
```

---

### 4. `while` 条件应该是 `left < right`

不能写：

```text
left <= right
```

否则两个指针可能指向同一个元素。

题目要求：

> 使用两个不同位置的数字。

---

# 三、哈希表

## 核心思路

以前的暴力方法是：

```text
看到 2

然后去后面逐个找：

2 + 7
2 + 11
2 + 15
```

但其实，当看到：

```text
nums[i]
```

时，我们真正需要的是：

```text
need = target - nums[i]
```

例如：

```text
target = 9

当前 nums[i] = 7
```

那么：

```text
need = 9 - 7
     = 2
```

所以问题可以从：

```text
我要去后面一个一个尝试吗？
```

变成：

```text
我以前有没有见过数字 2？
```

为了快速知道以前见过哪些数字，可以建立一个“小本本”。

记录：

```text
数字 → 下标
```

例如：

```text
{
    2: 0
}
```

代表：

```text
数字 2
曾经在下标 0 出现过
```

---

## 执行过程

```text
nums = [2, 7, 11, 15]
target = 9
```

初始：

```text
seen = {}
```

### 第一轮

```text
i = 0
nums[i] = 2

need = 9 - 2
     = 7
```

检查：

```text
seen 中有 7 吗？
```

没有。

所以记录：

```text
seen = {
    2: 0
}
```

### 第二轮

```text
i = 1
nums[i] = 7

need = 9 - 7
     = 2
```

检查：

```text
seen 中有 2 吗？
```

有：

```text
2 → 0
```

当前：

```text
i = 1
```

所以：

```text
return [0, 1]
```

---

## 伪代码

```text
创建一个哈希表 seen

遍历数组：

    need = target - nums[i]

    如果 need 已经存在于 seen：

        返回：
        [seen[need], i]

    否则：

        记录：
        seen[nums[i]] = i
```

---

## Python

```python
def two_sum(nums, target):
    seen = {}

    for i in range(len(nums)):
        need = target - nums[i]

        if need in seen:
            return [seen[need], i]

        seen[nums[i]] = i

    return []
```

也可以使用：

```python
def two_sum(nums, target):
    seen = {}

    for i, num in enumerate(nums):
        need = target - num

        if need in seen:
            return [seen[need], i]

        seen[num] = i

    return []
```

---

## TypeScript

```typescript
function twoSum(nums: number[], target: number): number[] {
    const seen = new Map<number, number>();

    for (let i = 0; i < nums.length; i++) {
        const need = target - nums[i];

        if (seen.has(need)) {
            return [seen.get(need)!, i];
        }

        seen.set(nums[i], i);
    }

    return [];
}
```

---

## 时间复杂度

只需要遍历一次数组：

```text
O(n)
```

哈希表：

```text
查找一个数
平均 O(1)

插入一个数
平均 O(1)
```

所以：

```text
n × O(1)

= O(n)
```

空间复杂度：

```text
O(n)
```

因为最坏情况下，需要把数组里的很多数字都保存到哈希表。

---

# 什么叫“空间换时间”？

暴力方法：

```text
不额外保存东西

但是每看到一个数字
都要继续搜索后面的数字
```

所以：

```text
时间：O(n²)
空间：O(1)
```

哈希表：

```text
把以前见过的数字存起来

以后直接查询：
“这个数字以前出现过吗？”
```

因此：

```text
时间：O(n)
空间：O(n)
```

也就是：

> 多使用一些内存，换取更少的搜索时间。

---

# 哈希表解法的坑点

## 1. 必须先查 `need`，再存当前数字

这是非常重要的一点。

可以把整个过程记成“相亲角”：

> **我去相亲角相亲，按顺序入场，每个人进来之后可以查本子里有没有喜欢的类型，没有的话就把自己是什么类型记到本子里（先查后记）。**

也就是说：

```text
一个人入场
↓
先算自己喜欢什么类型
↓
查本子里之前有没有这个类型
↓
有 → 配对成功
没有 → 把自己的类型和位置登记进本子
```

为什么不能“先记后查”？

因为可能把**自己当成自己要找的人**。

我的反例原话：

> **“我喜欢我自己这样式儿的，我先把我喜欢的人记到本里，然后在本里查，有一个我这样式儿的！我喜欢！诶我去，竟然是我自己！”**

例如：

```text
nums = [3, 3]
target = 6
```

当前：

```text
i = 0
nums[i] = 3
```

它喜欢的类型：

```text
need = target - nums[i]
     = 6 - 3
     = 3
```

如果先把自己登记：

```text
seen = {
    3: 0
}
```

再去查询：

```text
我要找 3
```

结果本子里真的有：

```text
3 → 0
```

于是可能返回：

```text
[0, 0]
```

相当于：

```text
nums[0] + nums[0]
3 + 3 = 6
```

虽然数学上成立，但实际上：

```text
我相中的人就是刚刚登记进去的我自己。
```

题目要求的是两个不同位置的元素，所以这是错误的。

正确顺序：

```text
先查
↓
查不到
↓
再登记自己
```

例如第一个 `3`：

```text
我喜欢 3

查本子：
没有 3

于是把自己登记：
3 → 0
```

第二个 `3` 进来：

```text
我也喜欢 3

查本子：
有 3！

而且：
3 → 0

当前自己：
i = 1
```

于是：

```text
return [0, 1]
```

成功找到两个不同的人。

### 一句话记忆

> **我去相亲角相亲，按顺序入场，每个人进来之后可以查本子里有没有喜欢的类型，没有的话就把自己是什么类型记到本子里（先查后记）。如果先记后查就会出现以下情况：我喜欢我自己这样式儿的，我先把我喜欢的人记到本里，然后在本里查，有一个我这样式儿的！我喜欢！诶我去，竟然是我自己！**

---

## 2. 哈希表保存的是“数字 → 下标”

不是：

```text
下标 → 数字
```

我们真正需要解决的问题是：

```text
need 这个数字有没有出现过？
```

所以应该：

```text
key = 数字
value = 下标
```

即：

```text
seen[数字] = 下标
```

例如：

```text
seen = {
    2: 0,
    7: 1
}
```

---

## 3. Python 的字典查询

Python：

```python
if need in seen:
```

判断的是：

```text
need 是否存在于 key 中
```

非常适合这题。

---

## 4. TypeScript 推荐使用 `Map`

可以写：

```typescript
const seen = new Map<number, number>();
```

存：

```typescript
seen.set(nums[i], i);
```

判断：

```typescript
seen.has(need);
```

获取：

```typescript
seen.get(need);
```

---

## 5. TypeScript 中为什么有 `!`

这里：

```typescript
seen.get(need)!
```

`Map.get()` 的返回类型是：

```typescript
number | undefined
```

因为 TypeScript 认为：

> 万一这个 key 不存在呢？

但前面已经：

```typescript
if (seen.has(need))
```

确认它存在了。

所以：

```typescript
!
```

意思是告诉 TypeScript：

> 我确定这里不是 `undefined`。

---

# 三种方法对比

| 方法 | 时间复杂度 | 空间复杂度 | 核心思想 |
|---|---:|---:|---|
| 暴力枚举 | `O(n²)` | `O(1)` | 枚举所有两数组合 |
| 排序 + 双指针 | `O(n log n)` | `O(n)` | 排序后利用大小关系缩小范围 |
| 哈希表 | `O(n)` | `O(n)` | 保存历史信息，快速查询 |

---

# 思维演进

可以把这道题的三个解法理解成一个逐步优化过程。

## 第一阶段：暴力枚举

```text
我不知道答案在哪。

那我就把所有可能的两个数字都试一遍。
```

得到：

```text
O(n²)
```

---

## 第二阶段：双指针

开始思考：

```text
有没有办法一次排除很多不可能的情况？
```

如果数组有序：

```text
和太小
→ 左边变大

和太大
→ 右边变小
```

于是不用检查所有组合。

得到：

```text
O(n log n)
```

排序占据主要时间。

---

## 第三阶段：哈希表

进一步思考：

```text
看到 nums[i] 时

其实我不需要知道所有其他数字。

我只需要知道：

target - nums[i]

以前有没有出现过。
```

于是建立：

```text
数字 → 下标
```

的记录。

每次直接查询。

得到：

```text
O(n)
```

---

# 最后总结

Two Sum 的三种主要思路：

```text
① 暴力枚举

每个数
去找后面的每个数

O(n²)
```

```text
② 排序 + 双指针

排序
↓
左右指针
↓
和太小 → left++
和太大 → right--

O(n log n)
```

```text
③ 哈希表

need = target - 当前数字

查询：
need 以前出现过吗？

出现过：
返回 [以前的下标, 当前下标]

没出现：
记录 当前数字 → 当前下标

O(n)
```

真正值得记住的不是三段代码，而是三个问题：

```text
第一层：
能不能把所有可能都试一遍？

第二层：
能不能利用某种规律，一次排除一些可能？

第三层：
能不能把以前的信息保存下来，避免重复搜索？
```

这三个问题会在很多算法题里反复出现。