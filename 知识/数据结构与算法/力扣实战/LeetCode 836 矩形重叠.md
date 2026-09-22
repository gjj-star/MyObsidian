---
name: 矩形重叠 Rectangle Overlap
node_type: memory
type: knowledge
type_note: 降维
description: LeetCode 836 矩形重叠笔记——二维相交降维成一维区间相交，max(左端点) < min(右端点)；含官方两种解法对比与踩坑记录（下标顺序、and 与 &）
modified: 2026-09-14T08:35:00.000Z
aliases: [LeetCode 836, Rectangle Overlap, 矩形重叠, 区间相交]
tags: [数据结构与算法, 力扣实战]
---

# LeetCode 836：矩形重叠

## 题目核心

给定两个矩形 `rec1 = [x1, y1, x2, y2]`、`rec2 = [a1, b1, a2, b2]`，判断它们是否有**重叠面积**（边贴边不算）。

关键：题目给的坐标顺序是 `[x1, y1, x2, y2]`，即 **(左下 x, 左下 y, 右上 x, 右上 y)**。

---

## 我的思路：二维降一维

一开始想到的是：两个矩形是否重叠，可以拆成 **x 方向和 y 方向分别判断**。

```
矩形 [x1, y1, x2, y2]
  → 投影到 x 轴：(x1, x2)
  → 投影到 y 轴：(y1, y2)

两个矩形重叠  ⟺  x 方向有交集 AND y 方向有交集
```

**怎么判断两个区间有没有交集？**

设两个区间 `(x1, x2)` 和 `(a1, a2)`：

- 交集的左边界 = 两个左端点里**更大**的那个 → `left = max(x1, a1)`
- 交集的右边界 = 两个右端点里**更小**的那个 → `right = min(x2, a2)`
- 如果 `left < right`，说明中间还有一段真实的区间 → x 方向存在重叠

y 方向同理：

```
below = max(y1, b1)
above = min(y2, b2)
below < above  →  y 方向存在重叠
```

最终判断：

```python
left < right and below < above
```

⚠️ **必须是 `<` 不能是 `<=`**。两个矩形刚好边贴边时 `right == left`，虽然碰到了，但重叠面积为 0，题目认为不算重叠。

---

## 我踩的坑

### 坑 1：数组下标的顺序记错了

一开始把下标想成：

```
[x1, x2, y1, y2]   ❌
```

题目实际给的是：

```
[x1, y1, x2, y2]   ✅

rec[0] → x1（左下 x）
rec[1] → y1（左下 y）
rec[2] → x2（右上 x）
rec[3] → y2（右上 y）
```

**记忆法：x 和 y 交替出现，先 x 后 y。** 这个顺序也决定了为什么 `rec[0]/rec[2]` 是 x 方向、`rec[1]/rec[3]` 是 y 方向。

### 坑 2：`and` 写成了 `&`

正确的：

```python
return left < right and below < above
```

错误的：

```python
return left < right & below < above   # ❌
```

原因不只是"and 才是逻辑与"，还有**优先级**问题：`&` 的优先级**高于**比较运算符，上面那行实际会被解析成：

```python
left < (right & below) < above
```

先算了 `right & below` 的按位与，结果完全跑偏（而且 Python 里这种链式比较会静默给出错误结果，不报错，更难查）。

---

## 代码

### Python

```python
from typing import List

class Solution:
    def isRectangleOverlap(self, rec1: List[int], rec2: List[int]) -> bool:
        # x 方向交集的左右边界
        left = max(rec1[0], rec2[0])
        right = min(rec1[2], rec2[2])

        # y 方向交集的上下边界
        below = max(rec1[1], rec2[1])
        above = min(rec1[3], rec2[3])

        # x、y 两个方向都必须存在长度大于 0 的交集
        return left < right and below < above
```

### TypeScript

```typescript
function isRectangleOverlap(rec1: number[], rec2: number[]): boolean {
    const left = Math.max(rec1[0], rec2[0]);
    const right = Math.min(rec1[2], rec2[2]);
    const below = Math.max(rec1[1], rec2[1]);
    const above = Math.min(rec1[3], rec2[3]);
    return left < right && below < above;
}
```

### 更紧凑的写法（官方方法二的风格）

```python
class Solution:
    def isRectangleOverlap(self, rec1: List[int], rec2: List[int]) -> bool:
        return (
            min(rec1[2], rec2[2]) > max(rec1[0], rec2[0]) and
            min(rec1[3], rec2[3]) > max(rec1[1], rec2[1])
        )
```

---

## 官方题解方法一：检查位置（反向排除）

### 思路

反过来分析：什么情况下两个矩形**不重叠**？

- 如果任一矩形面积为 0，一定不重叠；
- 面积都大于 0 时，不重叠意味着 `rec1` 落在 `rec2` 的 **四周**之一：**左侧 / 右侧 / 上方 / 下方**。

（"左侧"的定义：存在一条竖直的直线，把两个矩形分在两侧；其余三个同理。）

### 算法

先判面积是否为 0：

- `rec1` 面积为 0 ⟺ `rec1[0] == rec1[2]` 或 `rec1[1] == rec1[3]`
- `rec2` 面积为 0 ⟺ `rec2[0] == rec2[2]` 或 `rec2[1] == rec2[3]`

再把四种"不重叠位置"翻译成代码：

```
左侧：rec1[2] <= rec2[0]
右侧：rec1[0] >= rec2[2]
上方：rec1[1] >= rec2[3]
下方：rec1[3] <= rec2[1]
```

四种命中任一 → 不重叠。

### 代码

```python
class Solution:
    def isRectangleOverlap(self, rec1: List[int], rec2: List[int]) -> bool:
        if rec1[0] == rec1[2] or rec1[1] == rec1[3] or rec2[0] == rec2[2] or rec2[1] == rec2[3]:
            # 至少一个矩形面积为 0，一定不重叠
            return False
        return not (rec1[2] <= rec2[0] or   # left
                    rec1[3] <= rec2[1] or   # bottom
                    rec1[0] >= rec2[2] or   # right
                    rec1[1] >= rec2[3])     # top
```

---

## 三种解法对比

| | 思路方向 | 是否需要单独判面积 0 | 可读性 |
|---|---|---|---|
| **我的写法** | 正向：投影区间取交集 | 不需要（贴边/退化自然被 `<` 挡掉） | 高，变量名自解释 |
| **官方方法二** | 正向：投影区间取交集 | 不需要 | 高，一行搞定 |
| **官方方法一** | 反向：排除四种不重叠位置 | **需要**，否则退化矩形会误判 | 中，四个条件容易记混 |

我的写法和官方方法二本质是同一个（数学上都是 `min(右) > max(左)`），区别只是我把中间量命名成了 `left / right / below / above`，可读性好一点；官方版更短。

---

## 复杂度

只做了固定次数的 `max` / `min` / 比较，与输入规模无关。

- 时间复杂度：**O(1)**
- 空间复杂度：**O(1)**

---

## 最后我的理解

这道题其实是把一个**二维矩形相交问题，降维成两个一维区间相交问题**：

```
矩形重叠
  ↓
x 轴投影有交集 AND y 轴投影有交集
  ↓
max(左端点) < min(右端点)
```

**一句话记忆**：交集 = 左端点取大、右端点取小，剩下的还有长度就算相交。

> 我觉得这比直接背「左、右、上、下四种不重叠情况」更容易理解，因为是从"交集"这个概念直接推出来的。
