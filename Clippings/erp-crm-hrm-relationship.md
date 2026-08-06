---
name: erp-crm-hrm-relationship
description: ERP、CRM、HRM 三者的定义、核心区别、联动场景、现实架构模式
metadata: 
  node_type: memory
  type: knowledge
  originSessionId: 869361d7-7af4-48e8-8223-8601d67447a6
  modified: 2026-07-20T08:51:42.790Z
---

# ERP vs CRM vs HRM 三者关系

## 一句话区分

| 系统 | 管什么 | 面向谁 | 核心问题 |
|------|--------|--------|---------|
| **ERP**（Enterprise Resource Planning） | 企业**内部资源**（钱、物、产能） | 财务/采购/生产/仓库 | "钱花哪了？货在哪？产能够不够？" |
| **CRM**（Customer Relationship Management） | 企业**外部关系**（客户、商机） | 销售/市场/客服 | "谁可能买？跟到哪步了？签了之后有没有流失风险？" |
| **HRM**（Human Resource Management） | 企业**人力资源**（人、能力） | HR/管理者/员工 | "多少人？花了多少工资？绩效好不好？关键岗位有没有备胎？" |

## 权限

```
         ┌──────┐
         │ CRM  │  ← 外部：管"谁给我钱"
         └──┬───┘
            │ 签了单 → 生成销售订单
            ▼
  ┌─────────────────────┐
  │        ERP          │  ← 内核：管"怎么花这些钱变成东西又变成更多钱"
  │  财务 │ 供应链 │ 制造 │
  └──┬──────────────────┘
     │ 要招人 ←→ 要发工资
     ▼
  ┌──────┐
  │ HRM  │  ← 内部：管"谁来做这些事"
  └──────┘
```

## 关键联动场景

1. **CRM → ERP**：销售签单后，CRM 的销售订单直接同步 ERP，触发生产排程/库存分配/财务记账，无需人工重复录入
2. **ERP → HRM**：ERP 里的组织架构、成本中心决定了 HRM 里人员的编制归属和薪酬分摊；项目收入（ERP）影响项目奖金包（HRM）
3. **HRM → ERP**：HRM 的薪资计算结果传回 ERP 总账模块，自动生成工资费用凭证

## 现实中的模糊地带

- **大 ERP（SAP、Oracle EBS）自带 HR 和 CRM 模块**——理论上三合一，但 HR 模块体验通常不如专业 HRM（北森/Workday），CRM 不如 Salesforce
- **中型企业典型架构**：用友/金蝶 ERP + 独立 HRM + 独立 CRM（或直接用钉钉/飞书的轻量 HR+CRM）
- **HRM 和 OA 考勤模块有重叠**：OA 管审批流（请假申请），HRM 管余额计算（还剩几天年假）和薪资关联（扣多少钱）——两者通过接口同步。详见 [[hrm-overview|HRM 概述]]

## 在企业数字化全景图的位置

延续 [[oa-system-overview|OA 概述]] 中的五层架构：

```
业务层（ERP / CRM / HRM）
    ↕ 集成/数据搬运
流程层（OA 系统）
    ↕
自动化层（Agent / RPA）
    ↕
记录层（单据 + 台账）
```

FDE 的核心工作就是打通这四层之间的数据流。

**Why:** 郭锦佳在 AIBP 业财实习中接触的就是 ERP 财务模块，理解 ERP↔CRM↔HRM↔OA 的全局关系是 FDE 的基础素养——客户问"这个系统能不能跟我们的 X 对接"，要知道 X 是什么、数据流向哪。

**How to apply:** 面试中遇到"你了解企业软件吗"用三句话框架回答；实施时用联动场景判断集成边界；与 [[oa-system-overview]]、[[hrm-overview]]、[[guojinjia-fde-plan]] 配合使用。
