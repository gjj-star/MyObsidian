---
name: SaaS 系统架构
node_type: memory
type: knowledge
description: 生产级 SaaS 的七层架构分层、四个横切关注点与多租户隔离等特有架构挑战
modified: 2026-08-11T02:02:40.000Z
aliases: [SaaS Architecture, Software as a Service, 软件即服务]
tags: [企业数字化, 企业软件]
---

# SaaS 系统架构 SaaS Architecture

## 定义

**英文**：Software as a Service（SaaS，软件即服务）

**总结一句话**：生产级 SaaS = 微服务架构 + 多租户隔离 + K8s 弹性伸缩 + 全链路可观测性 + 按用量计费。

## 七层架构，各司其职

### 1. 用户层 / Client Layer

前端框架主流是 React / Vue 做 SPA（Single Page Application，单页应用），移动端 Flutter 或 React Native。SaaS 前端的核心挑战不是框架选型，而是**多租户 UI 定制**（白标 / 主题 / 域名隔离）。

### 2. 边缘层 / Edge & CDN

CDN 分发静态资源 + WAF（Web Application Firewall，Web 应用防火墙）拦截恶意请求 + DDoS（Distributed Denial of Service，分布式拒绝服务）防护。这层决定了 SaaS 在全球各地的访问速度和安全基线。大厂通常用 Cloudflare / 阿里云 CDN / 腾讯云 EdgeOne。

### 3. API 网关层 / API Gateway

整个 SaaS 的"统一入口"，承担：

- 路由分发（请求打到哪个微服务）
- 认证鉴权（OAuth2 / JWT token 校验）
- 限流熔断（保护后端不被打挂）
- 请求聚合（前端一个请求，网关拆成多个微服务调用）
- API 版本管理

常见选型：Kong / APISIX / Spring Cloud Gateway / AWS API Gateway。

### 4. 应用服务层 / Application Layer

核心层，生产级 SaaS 几乎都是微服务架构：

- 按业务域拆分服务（租户管理、订单、权限、计费、通知…）
- 每个服务独立部署、独立扩缩容
- 服务间通信用 gRPC（内网）或消息队列（异步解耦）
- 技术栈不强制统一——Go 写高并发服务、Java/Spring Boot 写业务逻辑、Python 做数据分析，各取所长

### 5. 中间件层 / Middleware

微服务架构的"润滑剂"：

- 消息队列：Kafka（高吞吐日志/事件）/ RabbitMQ（业务消息）/ RocketMQ（事务消息）
- 缓存：Redis 做热点数据缓存 + 分布式锁 + 会话存储
- 搜索：Elasticsearch 做全文检索和日志分析
- 配置中心：Nacos / Apollo，热更新配置不停机
- 服务网格：Istio / Linkerd，管流量路由、熔断、链路追踪（非必须但生产级常见）

### 6. 数据层 / Data Layer

SaaS 的数据层比传统系统复杂得多，因为要解决多租户隔离：

- 关系库 PostgreSQL / MySQL，通过分库分表应对数据增长
- NoSQL MongoDB 存非结构化数据
- 数据仓库（Snowflake / ClickHouse / BigQuery）做分析报表
- 对象存储 S3 / OSS 存文件、备份、日志归档

### 7. 基础设施层 / Infrastructure

Kubernetes 是事实标准：

- K8s 管容器编排、自动扩缩容、滚动发布
- CI/CD 用 GitLab CI / GitHub Actions / ArgoCD
- 监控 Prometheus + Grafana，日志 ELK / Loki
- 密钥管理 HashiCorp Vault / 云 KMS

## 四个横切关注点（每一层都要考虑）

| 关注点 | 关键设计 |
|---|---|
| **多租户隔离** | 三种模式：独立数据库（隔离最强，成本最高）→ 共享数据库独立 Schema → 共享 Schema + 租户 ID 字段（成本最低，隔离最弱）。生产级 SaaS 通常混合用：大客户独立库，小客户共享 |
| **可观测性** | 三支柱：Metrics（Prometheus）、Logs（ELK）、Traces（Jaeger/Zipkin）。出问题能快速定位是哪个服务、哪条链路 |
| **数据安全** | 传输加密 TLS、存储加密 AES-256、字段级加密（敏感字段单独加密）、审计日志、GDPR/等保合规 |
| **弹性伸缩** | K8s HPA（Horizontal Pod Autoscaler）按 CPU/内存自动扩缩，消息队列堆积时自动扩消费者，数据库读写分离 + 连接池 |

## SaaS 特有的架构挑战（传统系统不需要操心）

1. **多租户数据隔离** — 最核心的架构决策。选错了后期迁移成本极高。一般建议：从共享 Schema + 租户 ID 起步，预留迁移到独立库的能力
2. **按用量计费** — 需要埋点收集每个租户的 API 调用量、存储量、用户数，实时汇总到计费系统。这本身就是一个独立的微服务
3. **租户级配置** — 每个租户的自定义字段、工作流、权限模型都不一样。通常用元数据驱动（metadata-driven）架构，而不是硬编码
4. **零停机升级** — SaaS 不允许停机维护。需要蓝绿部署 / 金丝雀发布 / 数据库在线 DDL（gh-ost / pt-online-schema-change）
5. **租户间性能隔离** — 一个大租户跑批量任务不能影响其他租户。需要资源配额（K8s ResourceQuota）+ 限流 + 熔断

## 技术栈推荐（2026 年主流组合）

| 层 | 主流选型 |
|---|---|
| 前端 | React + TypeScript + Next.js / Vue 3 + Nuxt |
| 后端 | Go (gin/kratos) 或 Java (Spring Boot/Cloud) 或 Node.js (NestJS) |
| 数据库 | PostgreSQL（首选）/ MySQL + Redis 缓存 |
| 消息队列 | Kafka（大数据量）/ RabbitMQ（业务消息） |
| 容器编排 | Kubernetes + Helm |
| CI/CD | GitHub Actions / GitLab CI + ArgoCD |
| 监控 | Prometheus + Grafana + Loki |
| 云平台 | AWS / 阿里云 / 腾讯云 |

## 全景图

<svg viewBox="0 0 680 720" width="100%" role="img" xmlns="http://www.w3.org/2000/svg">
  <title>生产级 SaaS 系统架构全景</title>
  <desc>从用户层到基础设施层的完整 SaaS 架构分层示意图</desc>
  <defs>
    <marker id="arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
      <path d="M2 1L8 5L2 9" fill="none" stroke="context-stroke" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
    </marker>
    <style>
      .t { font-family: var(--font-sans, system-ui), sans-serif; font-size: 14px; fill: #D3D1C7; font-weight: 500; }
      .ts { font-family: var(--font-sans, system-ui), sans-serif; font-size: 12px; fill: #888780; }
      .tl { font-family: var(--font-sans, system-ui), sans-serif; font-size: 13px; fill: #B4B2A9; }
    </style>
  </defs>

  <!-- Layer 1: Users -->
  <rect x="40" y="30" width="600" height="56" rx="8" fill="#2C2C2A" stroke="#534AB7" stroke-width="0.5"/>
  <text class="t" x="340" y="50" text-anchor="middle" dominant-baseline="central">用户层 / Client Layer</text>
  <text class="ts" x="340" y="70" text-anchor="middle" dominant-baseline="central">Web (React/Vue) · Mobile (Flutter/RN) · API 调用方 · 第三方集成</text>

  <path d="M340 88 L340 104" stroke="#5F5E5A" stroke-width="1.5" fill="none" marker-end="url(#arrow)"/>

  <!-- Layer 2: Edge / CDN -->
  <rect x="40" y="106" width="600" height="56" rx="8" fill="#2C2C2A" stroke="#185FA5" stroke-width="0.5"/>
  <text class="t" x="340" y="126" text-anchor="middle" dominant-baseline="central">边缘层 / Edge &amp; CDN</text>
  <text class="ts" x="340" y="146" text-anchor="middle" dominant-baseline="central">CDN 静态资源 · WAF 防火墙 · DDoS 防护 · TLS 终结 · 负载均衡 (LB)</text>

  <path d="M340 164 L340 180" stroke="#5F5E5A" stroke-width="1.5" fill="none" marker-end="url(#arrow)"/>

  <!-- Layer 3: API Gateway -->
  <rect x="40" y="182" width="600" height="56" rx="8" fill="#2C2C2A" stroke="#0F6E56" stroke-width="0.5"/>
  <text class="t" x="340" y="202" text-anchor="middle" dominant-baseline="central">API 网关层 / API Gateway</text>
  <text class="ts" x="340" y="222" text-anchor="middle" dominant-baseline="central">路由 · 认证鉴权 (OAuth2/JWT) · 限流熔断 · 请求聚合 · 版本管理</text>

  <path d="M340 240 L340 256" stroke="#5F5E5A" stroke-width="1.5" fill="none" marker-end="url(#arrow)"/>

  <!-- Layer 4: Application / Microservices -->
  <rect x="40" y="258" width="600" height="100" rx="8" fill="#2C2C2A" stroke="#7F77DD" stroke-width="0.5"/>
  <text class="t" x="340" y="276" text-anchor="middle" dominant-baseline="central">应用服务层 / Application Layer（微服务架构）</text>

  <rect x="56" y="290" width="130" height="56" rx="6" fill="#3C3489" stroke="#7F77DD" stroke-width="0.5"/>
  <text class="tl" x="121" y="308" text-anchor="middle" dominant-baseline="central" fill="#CECBF6">租户管理服务</text>
  <text class="ts" x="121" y="328" text-anchor="middle" dominant-baseline="central" fill="#AFA9EC">多租户隔离</text>

  <rect x="196" y="290" width="130" height="56" rx="6" fill="#3C3489" stroke="#7F77DD" stroke-width="0.5"/>
  <text class="tl" x="261" y="308" text-anchor="middle" dominant-baseline="central" fill="#CECBF6">业务微服务</text>
  <text class="ts" x="261" y="328" text-anchor="middle" dominant-baseline="central" fill="#AFA9EC">核心业务逻辑</text>

  <rect x="336" y="290" width="130" height="56" rx="6" fill="#3C3489" stroke="#7F77DD" stroke-width="0.5"/>
  <text class="tl" x="401" y="308" text-anchor="middle" dominant-baseline="central" fill="#CECBF6">权限/计费服务</text>
  <text class="ts" x="401" y="328" text-anchor="middle" dominant-baseline="central" fill="#AFA9EC">RBAC · 用量计费</text>

  <rect x="476" y="290" width="130" height="56" rx="6" fill="#3C3489" stroke="#7F77DD" stroke-width="0.5"/>
  <text class="tl" x="541" y="308" text-anchor="middle" dominant-baseline="central" fill="#CECBF6">通知/文件服务</text>
  <text class="ts" x="541" y="328" text-anchor="middle" dominant-baseline="central" fill="#AFA9EC">邮件 · SMS · OSS</text>

  <path d="M340 360 L340 376" stroke="#5F5E5A" stroke-width="1.5" fill="none" marker-end="url(#arrow)"/>

  <!-- Layer 5: Middleware -->
  <rect x="40" y="378" width="600" height="56" rx="8" fill="#2C2C2A" stroke="#BA7517" stroke-width="0.5"/>
  <text class="t" x="340" y="398" text-anchor="middle" dominant-baseline="central">中间件层 / Middleware</text>
  <text class="ts" x="340" y="418" text-anchor="middle" dominant-baseline="central">消息队列 (Kafka/RabbitMQ) · 缓存 (Redis) · 搜索 (ES) · 配置中心 · 服务网格 (Istio)</text>

  <path d="M340 436 L340 452" stroke="#5F5E5A" stroke-width="1.5" fill="none" marker-end="url(#arrow)"/>

  <!-- Layer 6: Data -->
  <rect x="40" y="454" width="600" height="56" rx="8" fill="#2C2C2A" stroke="#D85A30" stroke-width="0.5"/>
  <text class="t" x="340" y="474" text-anchor="middle" dominant-baseline="central">数据层 / Data Layer</text>
  <text class="ts" x="340" y="494" text-anchor="middle" dominant-baseline="central">关系库 (PostgreSQL/MySQL 分库分表) · NoSQL (MongoDB) · 数据仓库 · 对象存储 (S3/OSS)</text>

  <path d="M340 512 L340 528" stroke="#5F5E5A" stroke-width="1.5" fill="none" marker-end="url(#arrow)"/>

  <!-- Layer 7: Infra -->
  <rect x="40" y="530" width="600" height="56" rx="8" fill="#2C2C2A" stroke="#888780" stroke-width="0.5"/>
  <text class="t" x="340" y="550" text-anchor="middle" dominant-baseline="central">基础设施层 / Infrastructure</text>
  <text class="ts" x="340" y="570" text-anchor="middle" dominant-baseline="central">K8s 容器编排 · CI/CD 流水线 · 监控告警 (Prometheus/Grafana) · 日志 (ELK) · 密钥管理</text>

  <!-- Side: Multi-tenancy -->
  <rect x="500" y="596" width="140" height="40" rx="6" fill="#04342C" stroke="#1D9E75" stroke-width="0.5"/>
  <text class="tl" x="570" y="616" text-anchor="middle" dominant-baseline="central" fill="#5DCAA5">多租户隔离贯穿全栈</text>

  <rect x="340" y="596" width="140" height="40" rx="6" fill="#042C53" stroke="#378ADD" stroke-width="0.5"/>
  <text class="tl" x="410" y="616" text-anchor="middle" dominant-baseline="central" fill="#85B7EB">可观测性贯穿全栈</text>

  <rect x="180" y="596" width="140" height="40" rx="6" fill="#4A1B0C" stroke="#D85A30" stroke-width="0.5"/>
  <text class="tl" x="250" y="616" text-anchor="middle" dominant-baseline="central" fill="#F0997B">数据安全贯穿全栈</text>

  <rect x="40" y="596" width="120" height="40" rx="6" fill="#412402" stroke="#EF9F27" stroke-width="0.5"/>
  <text class="tl" x="100" y="616" text-anchor="middle" dominant-baseline="central" fill="#FAC775">弹性伸缩</text>

  <text class="ts" x="340" y="666" text-anchor="middle" dominant-baseline="central">横切关注点 — 每一层都要考虑</text>
</svg>

## 应用

架构选型没有银弹，关键是根据**租户规模、性能要求、团队技术栈**权衡：小租户数起步用共享 Schema + 租户 ID，预留迁移独立库的能力；大客户用独立库。设计每一层时都过一遍四个横切关注点。

**How to apply:** 面试"你了解 SaaS 架构吗"用七层框架回答，重点讲多租户隔离三模式与混合策略；企业软件实施时用本卡判断客户系统的扩展边界（如 [[ERP CRM HRM 三者关系]] 中系统集成时是否要考虑多租户隔离）。

## 相关

- [[B 端与 C 端 B2B B2C]] — SaaS 是典型 B 端交付形态（订阅制 vs 买断制）
- [[ERP CRM HRM 三者关系]] — 传统企业软件正向 SaaS 形态演进
- [[PostgreSQL 数据库]] — 数据层首选关系库
- [[Docker 基础]] — K8s 容器编排的基础设施前置
