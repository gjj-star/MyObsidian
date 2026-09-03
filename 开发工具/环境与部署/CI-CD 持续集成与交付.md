---
name: CI/CD 持续集成与交付
node_type: memory
type: knowledge
description: CI/CD 自动化交付体系——CI（持续集成）/持续交付/持续部署三层含义、六阶段流水线、工具链选型与实施避坑
modified: 2026-09-03T06:42:38.000Z
aliases:
  - CI/CD
  - Continuous Integration
  - Continuous Delivery
  - Continuous Deployment
  - 流水线 Pipeline
tags: [开发工具, 环境与部署]
---

# CI/CD 持续集成与交付

**英文**：Continuous Integration（CI，持续集成）；Continuous Delivery（CD，持续交付）；Continuous Deployment（CD，持续部署）；Pipeline（流水线）；Webhook（网络钩子）

CI/CD 不是单一工具，而是把"代码提交→构建→测试→部署"全流程自动串联的**交付方法论**，目标是缩短从开发到生产的周期，同时保证质量——调和"快速迭代"与"质量稳定"的矛盾。

## 三个层次：CI 与两个 CD

| 概念 | 英文 | 解决什么 | 关键动作 |
| --- | --- | --- | --- |
| 持续集成 | Continuous Integration | 代码能随时合在一起跑（合并冲突、集成期 bug） | 频繁提交共享仓库 → 自动构建 → 单测/集测 → 反馈 |
| 持续交付 | Continuous Delivery | 随时能安全发布 | CI 通过后自动部署预生产，生产部署一键手动触发 |
| 持续部署 | Continuous Deployment | 自动安全发布 | 交付的进阶版：全自动部署生产，无需人工确认 |

一句话：CI 解决"代码能合在一起跑"；持续交付解决"随时能安全发布"；持续部署解决"自动安全发布"。

## 六阶段流水线

1. **代码提交（触发点）**：Git 推送目标分支，经仓库 Webhook（如 GitHub Actions 的 `on: push`）自动触发；pre-commit 钩子做格式/lint 校验减少无效提交
2. **自动构建**：拉代码后按项目类型执行构建（Maven `mvn package`、`npm build`），生成可执行中间产物
3. **自动化测试（质量门禁）**：单元测试（JUnit/pytest）+ 集成测试 + UI 测试（Selenium/Cypress）+ 代码质量扫描（SonarQube）；失败即终止流水线
4. **构建镜像（标准化交付物）**：产物打包为容器镜像推送镜像仓库（Harbor/Docker Hub/ACR）；**标签用 Git Commit ID**，不用 latest
5. **部署测试环境**：拉镜像部署到 test 命名空间，执行冒烟测试验证"类生产环境"兼容性
6. **部署生产环境**：交付=手动批准，部署=自动执行；部署策略有滚动更新（Rolling Update）、蓝绿部署（Blue-Green）、金丝雀发布（Canary），配套 `kubectl rollout undo` 快速回滚

## 工具链

- **CI 工具**：Jenkins（插件丰富、复杂流水线）、GitLab CI（与仓库深度集成）、GitHub Actions（YAML 简洁、云原生）、CircleCI（云原生开箱即用）
- **CD 工具**：ArgoCD（K8s 声明式 + GitOps）、Spinnaker（多环境、内置蓝绿/金丝雀）、Flux CD（轻量 GitOps）、Jenkins X（K8s 专用）
- **组合建议**：中小团队 = GitHub Actions + ArgoCD + Docker + K8s；企业级 = GitLab CI + Spinnaker + Harbor + SonarQube；传统项目 = Jenkins + Ansible + Nexus

## 实施原则与避坑

- 核心原则：高频提交（每天至少一次，避免大爆炸式集成）、自动化优先（手动步骤是出错主源）、快速反馈（失败立即通知）、环境一致性（容器化）
- 常见坑：只做单元测试不做集成测试 → 覆盖"单元+集成+冒烟"多层；滥用 latest 标签 → 用 Commit ID/版本号；CI 工具权限过高 → 最小权限（仅能部署指定命名空间）；流水线 10+ 步骤过复杂 → 拆分为独立流水线用依赖关联

CI/CD 不是银弹，而是现代软件开发的基础设施：自动化消除重复劳动、高频集成暴露问题、标准化交付物保证环境一致。

## 相关

- [[Docker 环境一致性]] — 环境一致的实现载体（容器镜像即标准化交付物）
- [[Docker 基础]] — 镜像构建/仓库/标签的基础
- [[冒烟测试 Smoke Testing]] — 部署测试环境后的验证环节
- [[灰度发布 Canary Release]] — 生产部署策略之一（金丝雀发布）
- [[GitHub 代码审查 GitHub Code Review]] — 与 CI 同属"提交后自动反馈"的工程实践

> 来源：网页剪藏《CI/CD 全流程指南：从概念到落地的持续交付实践》（技术栈，2026-08-28）
