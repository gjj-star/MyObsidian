---
name: GitHub 代码审查
node_type: memory
type: reference
description: GitHub 代码审查（Code Review）保姆级流程：从收到邀请到提交结论的完整操作路径、审查 checklist、评论礼仪与常见坑
modified: 2026-08-17T10:09:15.000Z
aliases: [GitHub Code Review, Code Review, 代码审查, github-code-review-tutorial]
tags: [开发工具, 编程与数据]
---

# GitHub 代码审查 GitHub Code Review

**英文**：Code Review（代码审查）；PR（Pull Request，拉取请求）；Reviewer（审查者）；Approve（通过）；Request Changes（要求修改）；Suggested Change（修改建议）；Dismiss Review（撤销审查）；nit（Nitpick，吹毛求疵级小意见）

## 完整操作流程

### 第 0 步：找到要审的 PR

三个入口：
1. **右上角铃铛**：被列为 Reviewer 后有通知（邮件同步）
2. **仓库页面 → Pull requests → Review requests 筛选**：点名要审的清单
3. 直接打开 PR 页面，顶部显示 "xxx requested your review"

### 第 1 步：先看 Conversation，不急着看代码

PR 页面顶部 4 个标签：**Conversation / Commits / Files changed / Checks**。先在 Conversation 搞清三件事：
- **标题 + 描述**：这 PR 要解决什么问题？关联哪个 issue？
- **CI 状态**：底部绿色 ✓ 还是红色 ✗（红了说明测试挂了，但代码逻辑照样可以先审）
- **已有讨论**：别人提过什么？别重复提相同问题

### 第 2 步：Files changed —— 审查主战场

- 绿色行 = 新增，红色行 = 删除；文件多时用左侧目录树跳转
- 点文件栏右上角齿轮 → **Hide whitespace**：过滤纯缩进/空白改动（大合并时救命）
- 看完一个文件点 **Viewed** 复选框标记，之后进来自动折叠

### 第 3 步：逐行评论

1. 悬停某行，行号左侧出现蓝色 **+**，点它写评论；拖选多行可对整段评论
2. 写完出现两个按钮——新手最重要的分叉口：
   - **Add single comment**：立即单独发出（通知作者一次）
   - **Start a review**：进入"审查批次"模式，评论先攒着，最后连同结论一次性提交

> **正式审查请选 Start a review**：提 10 条意见，作者只收到一条汇总通知，而不是被刷屏 10 次。

### 第 4 步：提修改建议（Suggested change）

知道该怎么改时，别只写"这里改成 xxx"：
1. 评论框工具栏点 **± 图标**（Insert a suggestion）
2. 自动生成 ` ```suggestion ` 代码块，把建议代码写进去
3. 作者那边出现 **Commit suggestion** 按钮，一键采纳——最受作者欢迎的审查方式

### 第 5 步：给出最终结论

右上角 **Review changes** → 弹窗三个选项：

| 选项 | 含义 | 什么时候用 |
|---|---|---|
| **Comment** | 只留言，不表态 | 早期讨论、先提意见不定性 |
| **Approve** | 通过 | 代码没问题，可以合并 |
| **Request changes** | 要求修改 | 有必须改的问题，改之前不该合并 |

下面的大文本框写总结（如"整体没问题，3 条小建议已标出"），然后点 **Submit review**。

> **最经典的翻车点**：点了 Start a review 攒了一堆评论，却忘了最后点 Review changes → Submit review。评论一直躺在草稿里，作者一个字都看不到！

### 第 6 步：审查之后

- 作者修改后推新 commit，回来只挑提过意见的文件重看
- 满意了：再走一遍 Review changes → **Approve**
- 想推翻自己的结论：审查旁边 **⋯ → Dismiss review**（Approve 后发现严重 bug 果断撤回）

## 怎么做"好"审查（比会点按钮重要十倍）

**审查 checklist：**
1. **正确性**：逻辑对吗？边界情况（空值、并发、异常、越界）处理了吗？
2. **测试**：改了逻辑有没有对应测试？有没有把测试偷偷删了？
3. **安全**：密钥、密码、token 有没有被提交进来？用户输入有没有校验？
4. **意外改动**：有没有顺手改了无关文件？调试代码（console.log 之类）删了吗？
5. **可读性**：命名清楚吗？有没有大段重复代码？

**评论礼仪：**
- 对事不对人：说"这个函数遇到空数组会崩"，而不是"你这写的有问题"
- 提问式好过命令式："如果这里 list 为空会怎样？" 比 "这里要判空" 更能引发思考
- 区分级别：致命问题才用 Request changes；纯风格偏好加 `nit:` 前缀（"不改也行"）
- 不懂就直说：请作者补注释或描述，比装懂后瞎 Approve 强
- 及时响应：作者在等 review 才能继续，拖两天很伤人

## 常见坑汇总

1. **评论攒着没提交** → 作者以为你消失了，你也以为审完了
2. **Approve 之后作者又推了新 commit** → Approve 默认仍然有效！除非团队开了 "Dismiss stale reviews" 保护，否则要自己回去重看
3. **Files changed 写了半截评论切走页面** → 草稿可能丢失
4. **把主观口味当阻塞问题** → 空格、命名偏好之类 Request changes，纯属内耗
5. **只看 diff 断章取义** → diff 只显示改动的那几行，点文件标题旁的行号展开上下文再看，很多"bug"其实是误判
6. **硬啃几千行的巨型 PR** → 请作者拆分 PR，或分批审并留言说明"我先审了 A 部分，B 部分明天看"

**一句话总结：先懂 PR 要解决什么 → Files changed 逐行看 → 能改就给 suggestion → 攒完评论统一给结论 → 忘了提交等于没审。**

## 相关

- [[冒烟测试 Smoke Testing]] — PR 的 CI 检查即自动冒烟，审查第一步先看它
