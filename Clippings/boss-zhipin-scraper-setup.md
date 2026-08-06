---
name: boss-zhipin-scraper-setup
description: BOSS直聘 FDE 岗位爬虫环境搭建、IPv6 兼容修复、首次抓取结果
metadata: 
  node_type: memory
  type: project
  originSessionId: 21246bc1-5f35-4147-ab92-1badbfdc6fb6
---

## 环境搭建

- **Python**: 3.12.10, 安装在 `C:\Users\EDY\AppData\Local\Programs\Python\Python312\`
- **工具**: [boss-zhipin-scraper](https://github.com/eatmoreduck/boss-zhipin-scraper) 克隆到 `D:/CC/boss-zhipin-scraper/`
- **Chrome CDP**: Chrome 150, 端口 9222, 隔离 profile 在 `C:\Users\EDY\.boss-zhipin-scraper\chrome-profile\`

## 关键修复

脚本 `boss_cdp_raw.py` 中 3 处 `127.0.0.1` 硬编码改为 `[::1]`（IPv6），因为本机 Chrome CDP 只绑定 IPv6 localhost。分别在第 272、1673、1756 行。

## Windows Python 注意

Windows Store 的 Python 占位符（`C:\Users\EDY\AppData\Local\Microsoft\WindowsApps\python.exe`）优先级高于真实 Python。**不要用裸 `python` 命令**，要用完整路径：
```
C:\Users\EDY\AppData\Local\Programs\Python\Python312\python.exe
```
或禁用 Windows 设置中的"应用执行别名"（Manage App Execution Aliases）。

每次运行前需要 `export PYTHONIOENCODING=utf-8` 否则 GBK 编码会炸 emoji。

## 首次抓取结果（2026-07-16）

- **关键词**: FDE, 城市: 101280100（广州）
- **结果**: 58 条岗位，10 页只抓到了前 2 页有数据（3-10 页无结果）
- **薪资范围**: 5K-90K，中位约 15-25K
- **大厂岗位**: 字节跳动 30-50K·15薪（唯一大厂直招）
- **文件**: `C:\Users\EDY\.boss-zhipin-scraper\job-result\boss_jobs_20260716_1822.json` + `.csv`
- **状态**: ✅ 全部完成 — 列表 58 条 + 详情 JD 57/58（1 条加载失败）
- **详情文件**: `boss_details_20260716_1822.json`（182KB）+ `boss_details_20260716_1822.csv`（165KB）
- **字节跳动 FDE 专家 JD**: 飞书 AI 落地+商业转化角色，30-50K·15薪，要求 AI Agent 实操+ToB SaaS 3年+跨团队推动力
- **Top 5 薪资**: AgentOS负责人 70-90K / 罗盘文化 FDE 30-60K / 云合智聘驻外岗 40-55K·13薪 / 斯伯特 25-50K / 字节 30-50K·15薪
- **注意**: stdout 有 print 缓冲问题，下次运行加 `python -u` 实时看进度；真实进度应看 `boss_details_*.json` 而非终端输出

## 后续抓取命令模板

```bash
export PYTHONIOENCODING=utf-8
# 确保 Chrome 已用 CDP 模式启动:
# taskkill //F //IM chrome.exe
# "/c/Program Files/Google/Chrome/Application/chrome.exe" --remote-debugging-port=9222 --remote-allow-origins=* --user-data-dir="C:/Users/EDY/.boss-zhipin-scraper/chrome-profile" "https://www.zhipin.com" &
# 然后在 Chrome 窗口登录 BOSS直聘

# 抓取命令:
"/c/Users/EDY/AppData/Local/Programs/Python/Python312/python.exe" D:/CC/boss-zhipin-scraper/scripts/boss_cdp_raw.py --keyword "关键词" --city 城市代码 --pages 10 --format csv --analysis
```

**Why:** 为郭锦佳的 FDE 岗位市场调研提供实时数据来源，了解广州 FDE 岗位的薪资分布、JD 要求和企业需求。

**How to apply:** 每次需要抓取最新岗位时按上述模板操作；不同城市只需改 `--city` 参数（城市代码见 BOSS直聘 URL）；详情 JD 完成后分析技能词频指导技术补课方向。关联 [[guojinjia-fde-plan]] [[fde-learning-roadmap]]
