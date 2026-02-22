# Half & Half 🫖

**OpenClaw 专属客户端** —— 让 agent 输出更易读、并行任务更直观。

## Why?

OpenClaw 很强大，但现有的 surface（Telegram、Slack）不够用：

- ❌ 看不到 sub-agent 在干什么
- ❌ Tool calls 在后台，不知道发生了什么
- ❌ Markdown 表格/代码渲染差
- ❌ Memory 是文件，不方便查看

Half & Half 深度集成 OpenClaw：

- ✅ **Sub-agents 可视化** — 实时看到并行任务状态
- ✅ **Tool calls 展示** — 显示调用了什么、结果是什么
- ✅ **Memory 查看器** — 搜索、浏览 agent memory
- ✅ **更好的渲染** — Markdown、代码高亮、表格

## Features

### 🔄 Sub-agents Panel

实时显示所有并行任务：

```
┌─ Sub-agents ────────────┐
│ ● PR Review             │
│   Running 2m            │
│   "checking tests..."   │
│                         │
│ ● Code Refactor         │
│   Running 1m            │
│                         │
│ ✓ Documentation         │
│   Completed             │
│   [View Result]         │
└─────────────────────────┘
```

### 🔧 Tool Calls

看到 agent 在调用什么工具：

```
┌─ Tool Call ─────────────────────────┐
│ 🔧 web_fetch                        │
│ URL: https://api.example.com/data   │
│ Status: ✓ completed (234ms)         │
│ [Show Response]                     │
└─────────────────────────────────────┘
```

### 🧠 Memory Viewer

搜索和浏览 agent 的 memory 文件。

### 📊 Rich Rendering

- GitHub Flavored Markdown
- 语法高亮代码块
- 表格正确显示

## Clients

### 🌐 Web

Hotwire 驱动，实时更新。

### 💻 TUI

终端界面，Go + Bubble Tea。

## Requirements

- 运行中的 **OpenClaw Gateway**
- Half & Half 服务器（自托管）

## Quick Start

```bash
git clone https://github.com/poshboytl/halfhalf.git
cd halfhalf
bin/setup
bin/dev

# 然后在 UI 中配置你的 OpenClaw Gateway
```

## Self-Hosting

```bash
docker compose up -d
```

## Documentation

- [Overview](plans/OVERVIEW.md) - 项目愿景
- [Architecture](plans/ARCHITECTURE.md) - 技术架构
- [Tech Stack](plans/TECH_STACK.md) - 技术选型
- [Milestones](plans/MILESTONES.md) - 开发计划

## Status

🚧 **开发中**

## License

MIT
