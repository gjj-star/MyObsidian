# Gem Tycoon（宝石大亨）

## 概述
老虎机 × Roguelike × 卡组构筑 单页网页游戏。

## 技术信息
- 路径：`G:/CloudeCoding/Workplace/Gem Tycoon/GemTycoon-Demo/`
- 入口：`Gem Tycoon：Demo.html`（单文件，98KB）
- 技术栈：React 18 + Tailwind CSS + Lucide Icons + Web Audio API
- 无需构建，浏览器直接打开

## 游戏系统
- **10 种卡牌**（蓝宝石、祖母绿、红宝石、金刚石、塔菲石、紫水晶、彩虹石、托帕石、金币卡、原石）
- **30 种神器**（6 类被动道具，5 个槽位限制）
- **17 种魔法物品**（一次性消耗品）
- **6 种排列类型**（3x3 网格上的连线组合）
- 计分公式：`总分 = 筹码总和 × 倍率总和`（再叠加乘算因子）

## 强化学习 AI
- 环境：`rl-training/game/gem_env.py`（Gymnasium，451 行，像素级复刻游戏逻辑）
- 算法：Maskable PPO（来自 sb3-contrib）
- 训练范围：100 万步
- 特色：动作屏蔽、奖励塑造（对数分数 + 删牌 + 利息）、流派偏差（原石流/金币流/宝石流）

## 文档
- `游戏百科.md`：完整卡牌/神器/魔法/排列/计分数据
- `README.md`：项目说明和快速入门
- `rl-training/宝石大亨 AI (Gem Tycoon RL Agent).md`：AI 训练文档
