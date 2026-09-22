---
name: 回文数 Palindrome Number
node_type: memory
type: knowledge
type_note: 数学
description: LeetCode 9 回文数笔记——从字符串对折比较到纯数学取余取整反转，再到只反转一半（偶数位 x == reverse、奇数位去掉中间位）与末尾 0 边界坑的完整推演
modified: 2026-09-17T07:31:08.000Z
aliases: [LeetCode 9, 回文数, Palindrome Number]
tags: [数据结构与算法, 力扣实战, 数学]
---

# LeetCode 9 回文数

> [!info] 题目原文（LeetCode 9 回文数）
> 给你一个整数 `x` ，如果 `x` 是一个回文整数，返回 `true` ；否则，返回 `false` 。
>
> 回文数是指正序（从左向右）和倒序（从右向左）读都是一样的整数。
>
> - 例如，`121` 是回文，而 `123` 不是。
>
> **示例 1：**
>
> - 输入：`x = 121`
> - 输出：`true`
>
> **示例 2：**
>
> - 输入：`x = -121`
> - 输出：`false`
> - 解释：从左向右读，为 `-121` 。从右向左读，为 `121-` 。因此它不是一个回文数。
>
> **示例 3：**
>
> - 输入：`x = 10`
> - 输出：`false`
> - 解释：从右向左读，为 `01` 。因此它不是一个回文数。
>
> **提示：**
>
> - `-2^31 <= x <= 2^31 - 1`
>
> **进阶：** 你能不将整数转为字符串来解决这个问题吗？

## 一、最开始的思路：转成字符串，左右对比

首先想到把数字转化为字符串或者列表，通过下标的对比，对于前半序列的数进行遍历判断：

```python
for i in range(len(a) // 2):
    if a[i] != a[len(a) - i - 1]:
        return False
```

核心就是比较左右对称位置：

```text
下标：  0  1  2  3  4
        ↑  ↑     ↑  ↑
        └───────────┘
           └─────┘
```

长度为 `5` 时：

```text
0 -> 5 - 0 - 1 = 4
1 -> 5 - 1 - 1 = 3
```

中间的元素不用比较，因为肯定等于自己，所以只需要遍历：

```python
range(len(a) // 2)
```

代码：

```python
class Solution:
    def isPalindrome(self, x: int) -> bool:
        a = str(x)

        for i in range(len(a) // 2):
            if a[i] != a[len(a) - i - 1]:
                return False

        return True
```

时间复杂度：`O(n)`。

空间复杂度：`O(n)`，因为创建了字符串。

---

# 二、不转换成字符串：用数学方法拆每一位

题目的进阶要求是不把整数转成字符串。

我想到：

> 对一个数一直用 10 取余和取整就可以拿到每一位数字了！

比如：

```text
123 % 10 = 3
123 // 10 = 12

12 % 10 = 2
12 // 10 = 1

1 % 10 = 1
1 // 10 = 0
```

所以：

```python
x % 10
```

可以拿到**最右边的一位**。

而：

```python
x // 10
```

可以**删除最右边的一位**。

可以写成：

```python
while x > 0:
    digit = x % 10
    x //= 10
```

有意思的是，取出来的顺序天然就是反过来的：

```text
原数字：123

取出：
3 -> 2 -> 1
```

---

# 三、把取出来的数字重新拼起来

如果现在：

```text
reverse = 12
digit = 3
```

我想到：

```text
12 * 10 + 3 = 123
```

所以公式就是：

```python
reverse = reverse * 10 + digit
```

例如反转 `123`：

```text
reverse = 0

取到 3：
reverse = 0 * 10 + 3
        = 3

取到 2：
reverse = 3 * 10 + 2
        = 32

取到 1：
reverse = 32 * 10 + 1
        = 321
```

于是可以把整个数字反转，再和原数字比较。

---

# 四、第一版纯数学解法：完整反转数字

因为循环过程中 `x` 会不断变化：

```python
x //= 10
```

最后会变成 `0`，所以要先保存原始值：

```python
original = x
```

另外：

> 如果原始数是负数直接判断不是回文数就好了。

所以：

```python
if x < 0:
    return False
```

完整代码：

```python
class Solution:
    def isPalindrome(self, x: int) -> bool:
        if x < 0:
            return False

        original = x
        reverse = 0

        while x > 0:
            digit = x % 10
            reverse = reverse * 10 + digit
            x //= 10

        return reverse == original
```

例如 `121`：

```text
original = 121
reverse = 0

第一次：
digit = 1
reverse = 1
x = 12

第二次：
digit = 2
reverse = 12
x = 1

第三次：
digit = 1
reverse = 121
x = 0

reverse == original
121 == 121
```

所以返回 `True`。

`0` 也不用特殊处理：

```text
original = 0
reverse = 0

while 不进入

reverse == original
0 == 0
```

同样返回 `True`。

---

# 五、继续优化：其实只需要反转一半

完整反转其实做了多余的工作。

因为判断回文，本质上只需要：

```text
左半边 == 右半边反转
```

所以根本没必要反转整个数字。

## 偶数位

例如：

```text
1221
```

开始：

```text
x = 1221
reverse = 0
```

第一次：

```text
reverse = 1
x = 122
```

第二次：

```text
reverse = 12
x = 12
```

此时：

```text
x == reverse
12 == 12
```

说明左右两半刚好相同。

所以我一开始想到：

> `x = reverse` 的时候就可以判断了。

对于偶数位确实成立。

---

# 六、奇数位的情况

例如：

```text
121
```

过程：

```text
x = 121
reverse = 0
```

第一次：

```text
x = 12
reverse = 1
```

还没有到一半。

再进行一次：

```text
x = 1
reverse = 12
```

现在：

```text
x = 1
reverse = 12
```

`reverse` 比 `x` 多了中间那个数字。

原数字：

```text
1 2 1
  ↑
中间这一位不需要比较
```

只需要把 `reverse` 最后一位去掉：

```python
reverse // 10
```

于是：

```text
12 // 10 = 1
```

然后：

```text
x == reverse // 10
1 == 1
```

成立。

所以最后有两种情况：

```python
x == reverse
```

对应偶数位：

```text
1221
12 == 12
```

或者：

```python
x == reverse // 10
```

对应奇数位：

```text
121
1 == 12 // 10
```

最终判断：

```python
return x == reverse or x == reverse // 10
```

---

# 七、循环什么时候停止？

观察两个例子。

`1221`：

```text
x = 1221    reverse = 0
x = 122     reverse = 1
x = 12      reverse = 12
```

`121`：

```text
x = 121     reverse = 0
x = 12      reverse = 1
x = 1       reverse = 12
```

可以发现：

在右半边还没有追上左半边的时候：

```text
x > reverse
```

一旦：

```text
reverse >= x
```

就说明已经走到数字中间了。

所以循环条件可以写成：

```python
while x > reverse:
```

这也是这个优化最关键的地方：

> 不需要提前知道数字有多少位，而是让 `x` 从右边不断缩短，让 `reverse` 从右边不断增长，直到两边相遇。

---

# 八、一个很重要的坑：末尾是 0

例如：

```text
10
```

如果直接执行：

```python
while x > reverse:
```

过程：

```text
x = 10
reverse = 0
```

第一次：

```text
digit = 0

reverse = 0
x = 1
```

第二次：

```text
digit = 1

reverse = 1
x = 0
```

最后：

```python
x == reverse
0 == 1
False
```

但是：

```python
x == reverse // 10
0 == 1 // 10
0 == 0
True
```

于是会错误地认为 `10` 是回文数。

为什么？

因为：

```text
10
```

倒过来实际上是：

```text
01
```

但整数不存在前导 `0`。

所以只要一个**非 0 数字末尾是 0**，它就一定不可能是回文数。

因为如果最后一位是：

```text
0
```

第一位也必须是：

```text
0
```

而整数第一位不可能是 `0`。

因此提前判断：

```python
if x < 0 or (x % 10 == 0 and x != 0):
    return False
```

这里必须保留：

```python
x != 0
```

因为：

```text
0
```

本身就是回文数。

---

# 九、最终优化代码

## Python

```python
class Solution:
    def isPalindrome(self, x: int) -> bool:
        # 负数一定不是回文数
        # 非 0 且末尾为 0，也一定不是回文数
        if x < 0 or (x % 10 == 0 and x != 0):
            return False

        reverse = 0

        # 只反转数字的一半
        while x > reverse:
            reverse = reverse * 10 + x % 10
            x //= 10

        # 偶数位：x == reverse
        # 奇数位：去掉 reverse 的中间一位
        return x == reverse or x == reverse // 10
```

## TypeScript

```typescript
function isPalindrome(x: number): boolean {
    if (x < 0 || (x % 10 === 0 && x !== 0)) {
        return false;
    }

    let reverse = 0;

    while (x > reverse) {
        reverse = reverse * 10 + x % 10;
        x = Math.floor(x / 10);
    }

    return x === reverse || x === Math.floor(reverse / 10);
}
```

---

# 十、复杂度

设数字一共有 `n` 位。

完整反转需要处理全部 `n` 位：

```text
时间复杂度：O(n)
空间复杂度：O(1)
```

只反转一半大约只处理 `n / 2` 位：

```text
时间复杂度：O(n)
空间复杂度：O(1)
```

虽然大 O 还是 `O(n)`，但是实际循环次数减少了一半。

---

# 十一、这道题我的思路变化

最开始：

> 转化为字符数或者列表，通过下标的对比对于前半序列的数进行遍历判断。

然后想到：

> 对一个数一直用 10 取余和取整就可以拿到每一位数字了！

得到：

```text
% 10  → 取最右边一位
// 10 → 删除最右边一位
```

接着想到怎么重新拼数字：

> `12 * 10 + 3`

于是得到：

```python
reverse = reverse * 10 + digit
```

先完成了：

```text
完整反转数字
↓
和原数字比较
```

然后继续发现：

> 判断回文根本不需要完整反转，只要反转右半边，再和剩下的左半边比较。

偶数位：

```python
x == reverse
```

奇数位：

```python
x == reverse // 10
```

最后再处理一个特殊坑：

```python
x % 10 == 0 and x != 0
```

因为非 `0` 数字如果末尾是 `0`，一定不可能是回文数。

---

## 最后的核心理解

这题真正有意思的地方不是“怎么反转整数”，而是：

```text
回文数：

左半边 | 右半边

只要：

左半边 == 反转后的右半边

就已经足够判断了。
```

因此我们让：

```text
x
```

不断删掉最右边数字，让：

```text
reverse
```

不断接收这些数字：

```text
x 越来越短
reverse 越来越长
```

直到：

```python
x <= reverse
```

也就是两边在数字中间相遇。
