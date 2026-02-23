# Half & Half 开发计划

> OpenClaw 专属客户端 —— 一半给人，一半给 AI

## 🎯 目标

让 Half & Half 成为 OpenClaw 的一等公民，拥有：
- 完整的 session 记忆
- Workspace 访问（读写 MEMORY.md）
- Tools 可视化
- 多线程并行对话

---

## 📐 架构

```
┌─────────────────────────────────────────────────────────┐
│                    Half & Half (Rails)                   │
├─────────────────────────────────────────────────────────┤
│  Browser ←──HTTP/Turbo──→ Rails ←──WebSocket──→ Gateway │
└─────────────────────────────────────────────────────────┘
                                          ↓
                                    OpenClaw Agent
                                    (workspace access)
```

---

## 📊 数据模型

```ruby
User
  └── Project        # 项目（关联 workspace/repo）
        └── Thread   # 对话线程（= OpenClaw session）
              └── Message   # 消息
              └── ToolCall  # 工具调用记录
```

---

## 🚀 开发阶段

### Phase 1: 数据模型重构 (Day 1-2)

- [ ] 创建 Project 模型
  - name, workspace_path, repo_url, description
- [ ] 创建 Thread 模型  
  - title, session_key, project_id, status (active/archived)
- [ ] 重构 Message 模型
  - thread_id, role, content, status
- [ ] 创建 ToolCall 模型
  - thread_id, message_id, tool_name, input, output, status
- [ ] 迁移现有 GatewayConfig 数据

### Phase 2: 侧边栏 UI (Day 2-3)

- [ ] 左侧边栏布局
  - New Thread 按钮
  - Projects 树形列表
  - Threads 列表（按项目分组）
  - Settings 入口
- [ ] 项目 CRUD
- [ ] Thread CRUD
- [ ] 当前 Thread 高亮
- [ ] 快捷键支持 (Cmd+N 新建 Thread)

### Phase 3: Gateway WebSocket 集成 (Day 3-5)

- [ ] WebSocket 客户端封装
  ```ruby
  class GatewayConnection
    def connect
    def send_message(session_key, content)
    def on_event(&block)
  end
  ```
- [ ] Gateway 协议实现
  - connect 握手
  - 认证 (device identity)
  - session 管理
- [ ] 事件处理
  - chat.message (streaming)
  - tool.call.start / tool.call.end
  - subagent.spawn / subagent.complete
- [ ] 断线重连机制
- [ ] 心跳保活

### Phase 4: 多 Session 管理 (Day 5-6)

- [ ] Session 创建/复用逻辑
- [ ] 每个 Thread 绑定一个 sessionKey
- [ ] Session 列表查询 (sessions_list)
- [ ] Session 历史加载 (sessions_history)
- [ ] Tab 切换时的 session 订阅/取消订阅

### Phase 5: Tool Calls 可视化 (Day 6-7)

- [ ] Tool Call 卡片组件
  ```
  ┌─────────────────────────────┐
  │ 🔧 write                    │
  │ path: MEMORY.md             │
  │ status: ✅ completed        │
  │ [展开详情]                   │
  └─────────────────────────────┘
  ```
- [ ] 实时状态更新 (pending → running → completed)
- [ ] 展开/收起详情
- [ ] 常用工具图标 (read/write/exec/web_search...)

### Phase 6: Memory 查看器 (Day 7-8)

- [ ] Files tab
  - 浏览 workspace 文件树
  - 文件内容预览
- [ ] Memory tab
  - MEMORY.md 专用视图
  - 分节显示
  - 搜索功能
- [ ] 编辑功能
  - 直接编辑 Memory
  - 保存 → 调用 write tool

### Phase 7: Sub-agents 可视化 (Day 8-9)

- [ ] Sub-agent 面板
  ```
  ┌─────────────────────────────┐
  │ 🤖 Sub-agents (2 running)   │
  ├─────────────────────────────┤
  │ ● research-task    running  │
  │ ● code-review      pending  │
  │ ✓ data-fetch       done     │
  └─────────────────────────────┘
  ```
- [ ] 点击查看 sub-agent 输出
- [ ] Steer/Kill 操作
- [ ] 完成通知

### Phase 8: 优化 & 完善 (Day 9-10)

- [ ] Markdown 渲染优化
  - 代码高亮
  - 表格
  - 数学公式（可选）
- [ ] 响应式设计
- [ ] 深色模式
- [ ] 键盘快捷键完善
- [ ] 性能优化

---

## 📁 文件结构

```
app/
├── models/
│   ├── project.rb
│   ├── thread.rb
│   ├── message.rb
│   └── tool_call.rb
├── services/
│   ├── gateway_connection.rb    # WebSocket 客户端
│   ├── gateway_protocol.rb      # 协议实现
│   └── session_manager.rb       # Session 管理
├── channels/
│   └── chat_channel.rb          # ActionCable (Browser ↔ Rails)
├── controllers/
│   ├── projects_controller.rb
│   ├── threads_controller.rb
│   └── messages_controller.rb
└── views/
    ├── layouts/
    │   └── _sidebar.html.erb
    ├── projects/
    ├── threads/
    └── messages/
```

---

## 🔑 关键决策

1. **WebSocket 双层架构**
   - Browser ↔ Rails: ActionCable (Turbo Streams)
   - Rails ↔ Gateway: websocket-client-simple gem

2. **Session 生命周期**
   - Thread 创建时 → 创建新 session
   - Thread 打开时 → 订阅 session 事件
   - Thread 切换时 → 切换订阅
   - Thread 归档时 → 保留 session 历史

3. **本地优先**
   - 消息先存本地 DB，再同步到 Gateway
   - 支持离线查看历史

---

## ⏱️ 时间估算

| Phase | 内容 | 天数 |
|-------|-----|------|
| 1 | 数据模型 | 2 |
| 2 | 侧边栏 UI | 2 |
| 3 | WebSocket 集成 | 3 |
| 4 | 多 Session | 2 |
| 5 | Tool Calls | 2 |
| 6 | Memory 查看器 | 2 |
| 7 | Sub-agents | 2 |
| 8 | 优化完善 | 2 |
| **总计** | | **~15-17 天** |

---

## 🚦 下一步

从 **Phase 1: 数据模型重构** 开始。

```bash
rails g model Project name:string workspace_path:string repo_url:string user:references
rails g model Thread title:string session_key:string status:integer project:references
rails g migration AddThreadToMessages thread:references
rails g model ToolCall thread:references message:references tool_name:string input:text output:text status:integer
```

Ready? 🦊
