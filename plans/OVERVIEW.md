# Project Overview

## Vision

Half & Half 是 **OpenClaw 的专属客户端**——让 agent 输出更易读、并行任务更直观、OpenClaw 特性更好用。

名字 "Half & Half" 代表对话的两半：人类和 AI agent，协作完成任务。

## Problem Statement

### OpenClaw 用户的痛点

1. **现有 surface 不够用**
   - Telegram/Slack 不渲染 Markdown 表格
   - 代码块没有语法高亮
   - 看不到 sub-agent 在干什么

2. **OpenClaw 特性无法可视化**
   - Sub-agents 并行执行，但只能看最终结果
   - Tool calls 在后台，用户不知道发生了什么
   - Memory 是文件，不方便查看

3. **并行任务难以管理**
   - 多个 sub-agent 同时跑，状态不清晰
   - 无法一眼看到所有进行中的任务

## Solution

一个深度集成 OpenClaw 的专属客户端：

### 1. OpenClaw 特性可视化

- **Sub-agents 面板**: 实时看到所有并行任务的状态和进度
- **Tool calls 展示**: 显示 agent 正在调用什么工具、输入输出
- **Memory 查看器**: 搜索、浏览 agent 的 memory 内容
- **Sessions 管理**: 列表、切换、历史记录

### 2. 更好的输出渲染

- 完整 Markdown 支持 (GFM)
- 语法高亮的代码块
- 表格正确显示

### 3. 并行任务管理

- 多标签页对应多个 session
- Sub-agent 状态实时更新
- 一眼看到所有进行中的任务

### 4. 多客户端

- Web 界面（完整功能）
- TUI 终端界面（开发者友好）

## Differentiation

**这不是又一个 AI 聊天工具。**

竞品（Open WebUI、TypingMind）是通用 AI 客户端。
Half & Half 是 **OpenClaw 专属**——深度集成 OpenClaw 的独特能力。

| 通用 AI 客户端 | Half & Half |
|----------------|-------------|
| 多 provider 支持 | OpenClaw 专属 |
| 只有聊天 | Sub-agents 可视化 |
| 看不到过程 | Tool calls 展示 |
| 无 memory 概念 | Memory 查看器 |

## Target Users

**OpenClaw 用户**，特别是：

1. **Power users**
   - 运行自己的 OpenClaw
   - 经常用 sub-agents 做并行任务
   - 想要更好的可视化

2. **开发者**
   - 调试 agent 行为
   - 需要看 tool calls
   - 喜欢 TUI

## Non-Goals (v1)

- 其他 AI provider 支持（低优先级）
- 群聊
- 语音/视频
- 移动原生 App

## Success Metrics

- Sub-agent 状态实时更新
- Tool calls 正确展示
- Markdown 表格/代码渲染正确
- TUI 基本功能可用
