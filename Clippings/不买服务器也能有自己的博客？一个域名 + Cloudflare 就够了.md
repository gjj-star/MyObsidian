---
title: "不买服务器也能有自己的博客？一个域名 + Cloudflare 就够了"
source: "https://www.bilibili.com/video/BV1iQHr6NEcC/?spm_id_from=333.337.search-card.all.click&vd_source=cef0fce7e5fbce2135907be0a04cc3d7"
author:
  - "[[冷静的阿旷]]"
published: 2026-10-04
created: 2026-10-09
description: "GitHub：https://github.com/du2333/flare-stack-blog部署文档：https://github.com/du2333/flare-stack-blog/blob/main/docs/deployment.md配音：IndexTTS2 合成（派蒙形象及音色 © 米哈游）BGM：South Waves - Eugenio Mininni（Mixkit）/"
tags:
  - "clippings"
---
<iframe width="560" height="315" src="https://player.bilibili.com/player.html?bvid=BV1iQHr6NEcC&amp;page=1&amp;high_quality=1&amp;danmaku=0" title="Bilibili video player" frameborder="0" allowfullscreen=""></iframe>

GitHub：https://github.com/du2333/flare-stack-blog  
部署文档：https://github.com/du2333/flare-stack-blog/blob/main/docs/deployment.md  
配音：IndexTTS2 合成（派蒙形象及音色 © 米哈游）  
BGM：South Waves - Eugenio Mininni（Mixkit）/ Foggy Headed - HoliznaCC0（CC0）  
音效：Mixkit / Kenney（CC0）

## Transcript

**0:00** · 不买服务器不做数据库一年只花一个域名的钱就能拥有一个大后台的全站播客大家好这里是派蒙今天给大家安利一个开源博客项目 Flair stack block 他整个跑在被大家叫做赛博大善人的 cloud flair上存在第一数据库图片放进R缓存交给KV通知走Q4队列

**0:29** · 没有服务器要维护也不用操心扩容服务器派蒙早就把它扔掉了那到底要花多少钱呢来看作者的真实账单一整年下来只有一笔域名费 10.46美元博客最忙的一天也才用掉免费额度的3% 真要火到免费额度不够用啦每个月五美元升级就行

**0:57** · 先来看看前台首页清爽好看置顶封面标签一应俱全文章页带目录代码高亮和数学公式读起来很舒服按下CTRL加K就能全文搜索中文也搜得准深色模式中英双语RSS订阅和评论区也都安排上了后台也很好用编辑器所见即所得写着写着就自动保存

**1:27** · 改坏了还能从历史版本一键恢复图片拖进来就会上传到R媒体库里还能看到每张图被哪篇文章用到想换个风格拖一下主题色滑块整个站点立刻跟着变色最后是派蒙最喜欢的功能博客自带HTTPAPI和agent skill 让AI帮你把笔记整理成文章存成草稿后台里马上就能看到

**1:58** · 心动了吧接下来派蒙手把手教你部署跟着做就行开始之前先准备好三样东西一个GITHUP账号一个cloud flare账号绑定好付款方式并开通R2 只要不超出免费额度就不会扣钱还有一个已经托管在cloud flair上的域名第一步打开项目的GITHUB页面点右上角的fork

**2:27** · 勾选只复制main分支然后创建第二步准备两份变量清单一份是构建使用的告诉部署程序用哪个域名哪些资源另一份是运行使用的放登录相关的配置先把walker名字和域名填上其他的边做边补登录密钥那一下填一串32位以上的随机字符就行

**2:56** · 第三步创建一个github o s s app 让你和读者能用GITHUB登录博客主页地址填你的域名回调地址照着画面里的格式填结尾那一串别改注册之后复制client id 再生成一个client secret 记得马上复制离开页面就看不到了第四步在cloud flair控制台创建四个资源

**3:24** · 第一数据库存文章和用户复制它的id R2存储桶存图片记下名字 Q队列处理通知记下名字 KV命名空间做缓存复制id4个都填进构建清单就齐活了第五步是可选的在images里给域名开启图片转换

**3:50** · 博客的图片就会自动压缩成合适的尺寸第六步创建worker 在workers和pages里选择用GITHUB导入授权之后选中你fork的仓库项目名和清单里的worker名字保持一致构建命令填帮run build 部署命令填帮run deploy展开高级设置把构建清单里的六个变量填进去然后点deploy

**4:22** · 数据库迁移资源绑定域名绑定部署程序全都会自动完成等几分钟就好部署成功之后打开这个worker的设置添加运行时变量可以把整份运行时清单直接粘贴进去注意每一项都要勾选secret 再点保存并部署第七步打开你的博客用GITHUB登录数据库里

**4:51** · 第一个注册的用户会自动成为管理员点开头像菜单就能进入后台啦部署完成撒花以后项目有更新只要在你的folk里点一下sink fork club flair 就会自动重新部署数据库迁移也会顺手做好嗯 flair stack blog完全开源 GITHUB地址和部署文档都在简介里觉得有用的话给项目点个star

**5:21** · 再给派蒙来个一键三连吧我们下次见