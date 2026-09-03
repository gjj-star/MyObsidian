---
title: "CI/CD 全流程指南：从概念到落地的持续交付实践 - 技术栈"
source: "https://jishuzhan.net/article/1989235506262114306"
author:
published:
created: 2026-08-28
description: "在软件开发中，“快速迭代”与“质量稳定”似乎是一对矛盾——频繁发布可能引入bug，严格测试又会拖慢节奏。而CI/CD（持续集成/持续交付） 正是解决这一矛盾的核心方法论：通过自动化工具链将“代码提交→构建→测试→部署”全流程串联，实现“高频次、高质量、低风险”的软件交付。本文从“核心概念→流程拆解→工具选型→实战案例”展开，帮你彻底搞懂CI/CD的落地逻辑。"
tags:
  - "clippings"
---
在 [软件开发](#) 中，"快速迭代"与"质量稳定"似乎是一对矛盾------频繁发布可能引入bug，严格测试又会拖慢节奏。而CI/CD（持续集成/持续交付） 正是解决这一矛盾的核心方法论：通过自动化工具链将"代码提交→构建→测试→部署"全流程串联，实现"高频次、高质量、低风险"的软件交付。本文从"核心概念→流程拆解→工具选型→实战案例"展开，帮你彻底搞懂CI/CD的落地逻辑。

一、先搞懂：CI/CD 到底是什么？

CI/CD 不是单一工具，而是一套自动化流程体系，核心目标是"缩短从代码开发到生产部署的周期，同时保证软件质量"。其核心由三个阶段组成：

1. CI（Continuous Integration，持续集成）
- 定义：开发人员频繁将代码提交到共享仓库（如Git），触发自动构建、编译和测试，快速发现代码集成问题。
- 核心目标：解决"代码合并冲突"和"集成阶段bug"，确保团队开发的代码能随时合并成一个可运行的整体。
- 关键动作：代码提交触发自动构建→运行单元测试/集成测试→生成构建产物（如Jar包、Docker镜像）→反馈结果（成功/失败）。
2. CD（Continuous Delivery，持续交付）
- 定义：在CI的基础上，将通过测试的构建产物自动部署到预生产环境（如测试环境、灰度环境），随时准备手动触发生产部署。
- 核心目标：确保软件"可随时发布"，将部署从"复杂手动操作"转化为"一键触发"，减少人为错误。
- 关键动作：CI成功后自动部署到测试环境→运行验收测试→手动确认后部署到生产环境（或等待定时触发）。
3. CD（Continuous [Deployment](#) ，持续部署）
- 定义：持续交付的"进阶版"------无需手动干预，通过测试的构建产物自动部署到生产环境，实现"代码提交后全自动发布"。
- 核心目标：极致缩短发布周期，适合对迭代速度要求极高的业务（如互联网产品）。
- 关键区别：与持续交付的唯一差异是"生产部署是否自动化"（交付需手动确认，部署全自动化）。

一句话总结：

- CI 解决"代码能合在一起跑"；
- 持续交付解决"随时能安全发布"；
- 持续部署解决"自动安全发布"。

二、CI/CD 核心流程：从代码到生产的全链路拆解

一个完整的CI/CD流程通常包含6个关键阶段，每个阶段通过自动化工具衔接，形成"流水线"（Pipeline）。以" [Java](#) 应用+Docker+K8s"为例，流程如下：

代码提交 → 自动构建 → 自动化测试 → 构建镜像 → 部署到测试环境 → 部署到生产环境

学习实用编程语言与开发课程

1. 代码提交（触发点）
- 动作：开发人员通过Git将代码提交到远程仓库（如GitHub、GitLab），并推送至指定分支（如\`dev\`、\`main\`）。
- 触发机制：通过仓库的"WebHook"配置，当代码推送到目标分支时，自动触发CI/CD流水线（如GitHub Actions的\`on: push\`事件）。
- 关键目标：确保代码提交规范（如通过\`pre-commit\`钩子检查代码格式、执行lint校验），减少无效提交。
2. 自动构建（编译与依赖管理）
- 动作：CI工具拉取代码，根据项目类型执行构建命令（如Maven的\`mvn package\`、Node.js的\`npm build\`），解决依赖并生成可执行产物（如Jar包、静态资源）。
- 核心工具：Maven、Gradle（Java）、npm/yarn（前端）、Go Modules（Go）。
- 关键目标：验证代码可编译，依赖无冲突，生成"可执行的中间产物"。
3. 自动化测试（质量门禁）
- 动作：构建成功后，自动运行多层级测试，确保代码质量：
- 单元测试：测试独立函数/类（如JUnit、pytest），验证逻辑正确性；
- 集成测试：测试模块间交互（如Spring Boot Test），验证接口兼容性；
- UI测试：前端项目通过Selenium、Cypress测试页面交互；
- 代码质量检查：通过SonarQube检测代码异味（如重复代码、未覆盖测试）。
- 关键目标：若测试失败或质量不达标（如测试覆盖率＜80%），流水线立即终止，反馈开发者修复。
4. 构建镜像（标准化交付物）
- 动作：将通过测试的构建产物打包为容器镜像（如Docker镜像），并推送到镜像仓库（如Docker Hub、Harbor、阿里云ACR）。
- 镜像标签策略：建议使用"Git Commit ID"作为标签（如\`app:abc123\`），避免"latest"标签导致版本混乱。
- 关键目标：生成"可移植、环境一致"的交付物，确保在任何支持容器的环境中都能运行。
5. 部署到测试环境（验证环境兼容性）
- 动作：从镜像仓库拉取镜像，自动部署到测试环境（如K8s的\`test\`命名空间），并执行冒烟测试（验证服务是否启动、核心接口是否可用）。
- 部署工具：Kubectl（K8s）、Helm（包管理）、Ansible（传统服务器）。
- 关键目标：验证镜像在"类生产环境"中的运行状态，发现环境依赖问题（如配置错误、网络不通）。
6. 部署到生产环境（最终交付）
- 动作：测试环境验证通过后，按策略部署到生产环境：
- 持续交付：手动点击"批准"按钮触发部署；
	升级工厂自动化控制系统
- 持续部署：自动执行部署（需通过更严格的生产前测试，如性能测试、安全扫描）。
- 部署策略：
- 滚动更新（Rolling Update）：逐步替换旧版本，避免服务中断；
- 蓝绿部署（Blue-Green）：部署到全新集群，验证后切换流量；
- 金丝雀发布（Canary）：先部署少量实例，观察无问题后全量发布。
- 关键目标：确保生产环境稳定，即使出现问题能快速回滚（如K8s的\`kubectl rollout undo\`）。

三、CI/CD 工具链：从选择到组合

CI/CD 工具分为"全功能平台"和"专项工具"，需根据团队规模、 [技术](#) 栈选择合适组合。

1. 核心CI工具（自动化构建与测试）

| 工具 | 特点 | 适用场景 |

| Jenkins | 开源、插件丰富（支持所有语言/工具）、可自定义程度高 | 复杂流水线、多技术栈混合团队 |

| GitLab CI | 与GitLab仓库深度集成（无需额外配置WebHook）、配置简单 | 已使用GitLab的团队、中小型项目 |

| GitHub Actions| 与GitHub无缝集成、YAML配置简洁、支持云原生环境 | 开源项目、使用GitHub的团队 |

| CircleCI | 云原生、开箱即用、支持并行测试 | 快速迭代的互联网项目 |

2. 核心CD工具（自动化部署与环境管理）

| 工具 | 特点 | 适用场景 |

| ArgoCD | 基于K8s的声明式CD工具、支持GitOps（配置即代码） | K8s集群部署、需要版本控制的场景 |

| Spinnaker | 支持多环境部署、内置蓝绿/金丝雀策略、企业级功能 | 大规模集群、多团队协作的生产环境 |

| Flux CD | 轻量、与GitOps无缝集成、适合云原生环境 | 小型K8s集群、简化版CD流程 |

| Jenkins X | 基于Jenkins，专为K8s设计，内置CI/CD流水线 | 熟悉Jenkins且使用K8s的团队 |

3. 辅助工具（测试、镜像、配置管理）
- 代码管理：Git（GitHub/GitLab/Gitee）；
- 测试工具：JUnit（ [Java](#) ）、pytest（Python）、Jest（前端）、Selenium（UI）；
- 代码质量：SonarQube（代码扫描）、JaCoCo（测试覆盖率）；
	探索软件高效开发工具
- 镜像仓库：Harbor（私有仓库）、Docker Hub（公共仓库）；
- 配置管理：Kustomize（K8s配置）、Vault（密钥管理）。
4. 工具组合推荐
- 中小团队/初创公司：GitHub Actions（CI） + ArgoCD（CD） + Docker + K8s（简单易维护，云原生友好）；
- 企业级团队：GitLab CI（CI） + Spinnaker（CD） + Harbor（镜像） + SonarQube（质量）（支持复杂流程和多环境）；
- 传统项目：Jenkins（CI/CD一体化） + Ansible（部署） + Nexus（仓库）（兼容非容器化应用）。

四、实战案例：基于GitHub Actions + K8s的CI/CD流水线

以"Spring Boot应用部署到K8s"为例，完整流水线配置如下，可直接复用：

1. 项目结构

spring-boot-app/

├──.github/workflows/ci-cd.yml # GitHub Actions配置

├── src/ # 源代码

├── Dockerfile # 镜像构建文件

├── k8s/ # K8s部署配置

│ └── [deployment](#).yaml

└── pom.xml # Maven依赖

2. CI/CD流水线配置（ci-cd.yml）

## 触发条件：推送到main分支时触发

on:

branches: $"main"$

jobs:

## 阶段1：构建与测试

build-test:

runs-on: ubuntu-latest

steps:

- name: 拉取代码

uses: actions/checkout@v4

- name: 配置JDK 17

uses: actions/setup-java@v4

with:

java-version: '17'

distribution: 'temurin'

cache: maven

- name: 构建与单元测试

run: mvn -B package --file pom.xml

- name: 代码质量检查（SonarQube）

run: mvn sonar:sonar -Dsonar.host.url= ${{ secrets.SONAR_URL }} -Dsonar.login=$ {{ secrets.SONAR\_TOKEN }}

## 阶段2：构建并推送Docker镜像

build-push-image:

needs: build-test # 依赖build-test阶段成功

runs-on: ubuntu-latest

steps:

- name: 拉取代码

uses: actions/checkout@v4

- name: 配置Docker

uses: docker/setup-buildx-action@v3

- name: 登录Docker仓库

uses: docker/login-action@v3

with:

registry: ${{ secrets.DOCKER\_REGISTRY }} # [如registry.cn-hangzhou.aliyuncs.com](http://xn--registry-jo1o.cn-hangzhou.aliyuncs.com/)

username: ${{ secrets.DOCKER\_USERNAME }}

password: ${{ secrets.DOCKER\_PASSWORD }}

- name: 构建并推送镜像

uses: docker/build-push-action@v5

with:

context:.

push: true

tags: ${{ secrets.DOCKER_REGISTRY }}/myapp:${{ github.sha }} # 用Commit ID做标签

## 阶段3：部署到K8s测试环境

deploy-test:

needs: build-push-image # 依赖镜像构建成功

runs-on: ubuntu-latest

steps:

- name: 拉取代码

uses: actions/checkout@v4

- name: 配置kubectl

uses: azure/setup-kubectl@v3

- name: 连接K8s集群

run: |

echo "${{ secrets.KUBE\_CONFIG }}" > ~/.kube/config # 从密钥获取K8s配置

- name: 替换镜像标签并部署

run: |

## 替换k8s配置中的镜像标签为当前Commit ID

sed -i "s|IMAGE\_TAG|${{ github.sha }}|g" k8s/deployment.yaml

## 部署到test命名空间

kubectl apply -f k8s/deployment.yaml -n test

- name: 验证部署

run: |

## 等待Pod就绪（最多等待30秒）

kubectl wait --for=condition=ready pod -l app=myapp -n test --timeout=30s

## 检查服务状态

kubectl get pods -n test

3. 流程说明
4. 触发：开发人员推代码到\`main\`分支，GitHub Actions自动启动流水线；
5. 构建测试：编译代码、运行单元测试、SonarQube检查代码质量，失败则终止；
6. 构建镜像：通过Dockerfile构建镜像，推送到私有仓库（标签为Git Commit ID）；
7. 部署测试：用kubectl连接K8s集群，替换部署文件中的镜像标签，部署到\`test\`命名空间，验证Pod就绪。

五、CI/CD 实施的核心原则与避坑指南

1. 核心原则
- 高频提交：开发人员每天至少提交1次代码，避免"大爆炸式集成"（大量代码一次性合并，冲突难以解决）；
- 自动化优先：测试、部署等步骤尽量自动化，减少手动操作（手动步骤是出错的主要来源）；
- 快速反馈：流水线失败后立即通知开发者（如Slack、邮件），确保问题尽早修复；
- 环境一致性：开发、测试、生产环境尽量一致（通过容器化实现），避免"在我电脑上能跑"的问题。
2. 避坑指南
- 测试用例不全：只做单元测试不做集成测试，导致线上出现接口兼容问题------解决方案：覆盖"单元+集成+冒烟"多层测试；
- 镜像标签混乱：滥用\`latest\`标签，导致部署版本不可控------解决方案：用Git Commit ID、版本号作为标签；
- 权限管理松散：CI/CD工具拥有过高权限（如K8s集群管理员权限），存在安全风险------解决方案：遵循最小权限原则（如给流水线分配仅能部署到指定命名空间的权限）；
- 流水线过于复杂：一个流水线包含10+步骤，维护困难------解决方案：拆分流水线（如拆分为"构建测试""部署测试""部署生产"独立流水线，通过依赖关联）。

总结：CI/CD 的核心价值

CI/CD 不是"银弹"，但它是\*\*现代软件开发的基础设施\*\*------通过自动化消除重复劳动，通过高频集成暴露问题，通过标准化交付物保证环境一致，最终实现"更快的迭代速度+更稳定的软件质量"。

对于团队而言，实施CI/CD的关键不是"选最复杂的工具"，而是"从简单流程起步，逐步迭代优化"：先实现"代码提交→自动测试→构建镜像"的CI流程，再扩展到"自动部署测试环境"的持续交付，最后根据业务需求决定是否启用持续部署。