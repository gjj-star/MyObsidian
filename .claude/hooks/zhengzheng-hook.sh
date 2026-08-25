#!/usr/bin/env bash
# 「!?整整?!」全量整理习惯触发钩子（UserPromptSubmit）
# 检测用户输入中的触发词，命中时注入 5 步工作流提醒（additionalContext）
input=$(cat)
if printf '%s' "$input" | grep -q '整整'; then
  printf '%s' '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"用户触发了「!?整整?!」全量整理习惯，按 CLAUDE.md 中 5 步执行：1. git -C D:/CC/conversation-memories pull 并对照新沉淀清单与 conversation-log 蒸馏知识卡；2. 整理 Clippings/ 未沉淀网页剪藏；3. 全库断链/孤儿/首页计数检查并更新关系图谱；4. git add -A && commit && push（MyObsidian）；5. 允许使用 /team。完成后汇报：新沉淀 N 条 → M 篇知识卡及分布。"}}'
fi
exit 0
