---
name: agent-skill-automation
description: 基于 LLM Agent 平台(workbuddy 等)的 Skill/智能助理式自动化，与经典 Agentic RPA(UI 模拟)的异同
metadata: 
  node_type: memory
  type: knowledge
  originSessionId: 1d96bcb2-b3c5-46cd-b222-e16e5ba9566b
---

实例：某财务"传真信息填写与保存"方案——企业微信机器人(入口) + workbuddy 助理(LLM Agent) + 导入 Skill(fax-form-filler：SKILL.md 提示词 + fill_fax_form.py 填表脚本 + docx 模板)。流程：接收传真文本/PDF → LLM 抽字段(企业名称/银行账号/开户行/费用) → 调 Python 脚本填表 → 存本地文件夹。

**归类**：属于 **Agentic 自动化**(AI 大脑驱动、自主规划)，但"手"是**平台自定义脚本工具**，而非模拟 GUI 的界面操作。是 Agentic RPA 大类中偏"Agent 直接干"的一支，不是经典"模拟人点击界面"的 RPA。

**vs 经典 Agentic RPA（LLM 大脑 + UI 模拟，如 UiPath+AI）**
- 本方案优势：上手快(导入 Skill+提示词)、非结构化理解强(LLM 抽字段)、入口自然(企微零培训)、工程化度量(TCR 任务完成率 / ATCC 平均积分消耗)。
- 本方案劣势：高风险字段靠 LLM 缺校验(银行账号/金额易错，需人在回路)；成本随用量(积分)增长；"手"仅限本地文件/表格，操作无 API 遗留系统不如 UI 模拟 RPA；依赖个人电脑常开+登录，非服务端稳定部署；一致性不如确定性脚本；未真正打通业务系统(半自动)；绑定厂商 workbuddy；企微入口吞吐低(不能合并转发)。
- 经典 Agentic RPA 反方向：胜在能操作任意界面系统、服务端稳定、可大规模；弱在搭建/维护成本高、UI 脆弱、非结构化理解不如纯 LLM Agent。

**结论**：本方案是"LLM Agent + 自定义脚本工具"式自动化，目前定位 AI 辅助半自动录入，非端到端全自动。
