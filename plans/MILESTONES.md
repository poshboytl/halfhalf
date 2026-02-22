# Milestones

## Overview

**核心目标**: OpenClaw 专属客户端，深度集成其独特能力

**总预估**: 8-10 周

## M0: Foundation (Week 1)

**目标**: 基础项目结构

### Tasks

- [ ] `rails new halfhalf --database=postgresql`
- [ ] 配置 Tailwind CSS
- [ ] User model + 认证
- [ ] Gateway Config model（存储 OpenClaw 连接）
- [ ] 基础 UI 框架（三栏布局）
- [ ] 部署到测试服务器

### 验收标准

- [ ] 能登录/注册
- [ ] 能配置 OpenClaw Gateway 连接
- [ ] 三栏布局显示正常

## M1: Sessions Integration (Week 2)

**目标**: 连接 OpenClaw，显示 sessions

### Tasks

- [ ] OpenClaw API client
- [ ] Sessions 列表获取
- [ ] Sessions 侧边栏 UI
- [ ] Session 切换
- [ ] 消息历史获取和显示

### 验收标准

- [ ] 显示 OpenClaw sessions 列表
- [ ] 点击切换 session
- [ ] 显示历史消息
- [ ] 连接状态指示

## M2: Chat & Streaming (Week 3-4)

**目标**: 发送消息，流式显示回复

### Tasks

- [ ] 消息发送
- [ ] SSE 流式接收
- [ ] Turbo Streams 实时更新
- [ ] 消息状态（pending/streaming/completed/failed）
- [ ] 基础 Markdown 渲染（DOMPurify）
- [ ] 取消/重试功能

### 验收标准

- [ ] 发送消息到 OpenClaw
- [ ] 流式显示 AI 回复
- [ ] 消息状态正确更新
- [ ] Markdown 渲染正确
- [ ] 能取消正在生成的消息

## M3: Sub-agents Panel (Week 5-6) ⭐

**目标**: Sub-agents 可视化 —— 核心差异化

### Tasks

- [ ] Sub-agents API 集成
- [ ] Sub-agents 侧边栏 UI
- [ ] 实时状态更新（spawned/progress/completed）
- [ ] 展开查看详细输出
- [ ] Steer（发送指令）功能
- [ ] Kill（终止）功能

### 验收标准

- [ ] 显示所有活跃 sub-agents
- [ ] 实时更新状态和进度
- [ ] 点击展开详细日志
- [ ] Steer 功能工作
- [ ] Kill 功能工作

## M4: Tool Calls Display (Week 7)

**目标**: 展示 agent 的 tool calls

### Tasks

- [ ] Tool call 事件解析
- [ ] Tool call UI 组件
- [ ] 折叠/展开输入输出
- [ ] 执行状态和耗时
- [ ] 代码块语法高亮

### 验收标准

- [ ] Tool call 开始时显示
- [ ] 显示 tool 名称和参数
- [ ] 完成后显示结果和耗时
- [ ] 可折叠/展开

## M5: Memory Viewer (Week 8)

**目标**: 查看和搜索 agent memory

### Tasks

- [ ] Memory search API 集成
- [ ] Memory files API 集成
- [ ] 搜索 UI
- [ ] 文件树展示
- [ ] 文件内容预览
- [ ] 搜索结果高亮

### 验收标准

- [ ] 搜索 memory 内容
- [ ] 显示文件列表
- [ ] 预览文件内容
- [ ] 高亮搜索关键词

## M6: TUI Client (Week 9-10)

**目标**: 终端客户端

### Tasks

- [ ] Go 项目初始化
- [ ] Bubble Tea 框架
- [ ] API client
- [ ] 三栏布局（sessions/chat/subagents）
- [ ] 消息显示（Glamour）
- [ ] 流式更新
- [ ] Sub-agent 状态显示
- [ ] 快捷键

### 验收标准

- [ ] 连接 OpenClaw Gateway
- [ ] 显示 sessions
- [ ] 发送消息
- [ ] 流式显示回复
- [ ] 显示 sub-agent 状态
- [ ] 基本快捷键工作

---

## Future (v1.1+)

| 功能 | 说明 |
|------|------|
| Cron jobs 管理 | 查看、触发、日志 |
| Skills 列表 | 已安装 skills |
| 分屏模式 | 两个 session 并排 |
| 跨 session 引用 | @session:xxx |
| Mermaid/KaTeX | 图表和公式 |
| 离线缓存 | 本地 SQLite |

---

## Dependencies

需要 OpenClaw Gateway 提供以下 API：

| API | 用途 | 状态 |
|-----|------|------|
| sessions_list | 列出 sessions | ✅ 已有 |
| sessions_history | 获取历史 | ✅ 已有 |
| sessions_send | 发送消息 | ✅ 已有 |
| subagents list | 列出 sub-agents | ✅ 已有 |
| subagents steer | 干预 sub-agent | ✅ 已有 |
| subagents kill | 终止 sub-agent | ✅ 已有 |
| memory_search | 搜索 memory | ✅ 已有 |
| memory_get | 获取文件 | ✅ 已有 |
| SSE stream | 实时事件 | ❓ 需确认格式 |

---

## Risk Assessment

| 风险 | 影响 | 缓解 |
|------|------|------|
| OpenClaw API 变化 | 高 | 抽象层、版本协商 |
| SSE 事件格式不清楚 | 中 | 早期验证 |
| Sub-agent 状态同步 | 中 | 定期轮询 + 事件推送 |
