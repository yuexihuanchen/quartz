# 我的数字花园

基于 [Quartz v4](https://github.com/jackyzha0/quartz/tree/v4) 搭建的个人知识库 / 数字花园。

- 🌐 线上站点：https://my-site-pink-iota.vercel.app
- ✍️ 内容来源：Obsidian 公开笔记目录（`0.数字花园`），通过 `sync-notes.ps1` 一键同步、构建、推送并部署
- 🔁 自动同步：Windows 计划任务每周运行一次（`scripts/register-sync-task.ps1` 注册）

## 用法

```powershell
.\sync-notes.ps1   # Obsidian → content/notes → build → commit → push → vercel deploy
```

## 致谢

本站点由开源项目 [Quartz v4](https://quartz.jzhao.xyz/)（[jackyzha0/quartz](https://github.com/jackyzha0/quartz)）驱动，感谢原作者。本仓库仅用于个人内容发布，不替代上游项目。
