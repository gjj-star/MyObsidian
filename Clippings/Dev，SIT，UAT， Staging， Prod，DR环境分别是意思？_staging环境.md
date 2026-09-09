---
title: "Dev，SIT，UAT， Staging， Prod，DR环境分别是意思？_staging环境"
source: "https://blog.csdn.net/chancein007/article/details/126951697"
author:
  - "[[大象无形，大音希声]]"
published: 2022-09-20
created: 2026-09-04
description: "文章浏览阅读3.1w次，点赞11次，收藏55次。本文详细介绍了软件开发过程中的不同环境，包括开发环境、测试环境、系统集成环境、用户可接受性测试环境、预生产环境、生产环境及灾备环境，并解释了每个阶段的特点与注意事项。"
tags:
  - "clippings"
---
在日常的开发测试运维中，我们经常听到大家说起DEV，Test， SIT，UAT， Staging， Prod，DR环境等；那么这些名词分别代表什么以及在各个阶段的时候有什么注意事项呢？笔者用如下的一张图进行了总结。  
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/21805fd4eb63024aa5dbdb6cc459afcf.png#pic_center)  
具体的说明如下：

##### 持续集成 开发环境（DEV: Development Environment）

直接通过源代码编译打包，其会跑单元测试，服务API自动化测试，服务UI自动化测试

##### 测试环境 （Test: Test Environment）

部署带版本的组件，服务API自动化测试，服务UI自动化测试

##### 系统集成环境（SIT, System Integration Test Environment）

部署带版本的组件，服务API自动化测试，服务UI自动化测试，多系统集成API测试，多系统集成UI自动化测试。

##### 用户可接受性测试环境（UAT, User acceptance Test Environment）

部署带版本的组件，此环境主要用来进行软件产品的验收，用户（客户方）会直接参与，用户根据需求 功能文档 进行验收，当然在用户验收前可以可以跑API自动化测试和UI自动化测试。此外根据客户项目合同要求，可能需要出具可接受性测试报告：包括但不限于，功能性测试报告，安全测试报告，性能测试报告等

##### 预生产环境（STAGING, Staging Environment）

部署带版本的组件，一般在直接上生产环境之前，会进行一些基本健康测试\[自动或者手工\]，有的时候还会进行模拟生产环境的真实数据进行Dry Run，其Dry Run很多时候都是在正常生产环境的配置和网络条件下进行的，Dry Run之后，没有问题了，就会把预生产环境切换回来，或者直接上生产环境； 从预生产环境集群切换到生产环境集群的方法有： 蓝绿部署，A/B测试，金丝雀部署【灰度发布】等方法。

##### 生产环境（Prod: Production Environment）

部署带版本的组件，正式生产环境。

##### 灾备环境（DR: Disaster Recovery Environment）

部署带版本的组件，对于一些服务可用性，可连续性有特别要求，比如关系到国计民生的系统，需要进行灾备。