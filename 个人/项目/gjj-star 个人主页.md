---
name: gjj-star 个人主页
node_type: note
type: user
description: 个人主页项目——复古终端/HUD 风格单文件站点（Vercel 托管），含 Steam 实时数据、健身记录展示与多主题切换
modified: 2026-09-22T02:51:22.000Z
aliases: [个人主页, ghostGJJ, 亦青]
tags: [个人, 项目]
---

# gjj-star（亦青 / ghostGJJ）

## 概述
个人主页 + GitHub Profile + Steam 展示 + 健身记录。

## 技术信息
- 路径：`G:/CloudeCoding/Workplace/gjj-star/`
- 前端：纯原生 HTML/CSS/JS（单文件 `index.html`，1178 行）
- 风格：复古终端/HUD 科幻风，4 种主题切换
- 托管：Vercel（前端 + Serverless API）

## 功能
- 个人介绍（亦青、ghostGJJ）
- 兴趣标签：4X 游戏、Roguelike、R&B 音乐、力量举、推理小说、硬科幻
- Steam 实时数据（个人资料、游戏库、完美通关成就、在线状态）
- 社交链接：Bilibili、GitHub、Steam、抖音、小程序

## 后端 API
- 生产环境：`api/steam.js`（Vercel Serverless Function）
- 备选：`steam-worker/server.js`（Railway 独立 Node 服务）
- 均使用 Steam Web API，无需第三方依赖

## 健身页
- `workouts.html`：89 天训练进度照片画廊
- 关联：健身每日记录（旧库笔记，未入库）
