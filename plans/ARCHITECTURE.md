# Architecture

## High-Level Overview

```
┌─────────────────┐     ┌─────────────────┐
│   Web Browser   │     │    TUI Client   │
│   (Hotwire)     │     │    (Go)         │
└────────┬────────┘     └────────┬────────┘
         │                       │
         │ HTML + Turbo Streams  │ JSON + SSE
         │                       │
         └───────────┬───────────┘
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                      Rails Application                       │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                OpenClaw Integration                   │    │
│  │  ┌───────────┐ ┌───────────┐ ┌───────────┐          │    │
│  │  │ Sessions  │ │Sub-agents │ │Tool Calls │          │    │
│  │  └───────────┘ └───────────┘ └───────────┘          │    │
│  │  ┌───────────┐ ┌───────────┐                        │    │
│  │  │  Memory   │ │   Cron    │                        │    │
│  │  └───────────┘ └───────────┘                        │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │  Controllers │  │   Channels   │  │   Stream Bus     │   │
│  │  (Web + API) │  │ (ActionCable)│  │  (Turbo + SSE)   │   │
│  └──────────────┘  └──────────────┘  └──────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ 
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     OpenClaw Gateway                         │
│   Sessions API  │  Sub-agents  │  Memory  │  Cron  │ ...   │
└─────────────────────────────────────────────────────────────┘
```

## OpenClaw Integration

这是核心差异化。Half & Half 深度集成 OpenClaw 的独特能力。

### 1. Sessions 管理

```ruby
class OpenClawClient
  # 获取 session 列表
  def sessions_list(filters = {})
    # GET /api/sessions
  end
  
  # 获取 session 历史
  def sessions_history(session_key, options = {})
    # GET /api/sessions/:key/history
  end
  
  # 发送消息到 session
  def sessions_send(session_key, message)
    # POST /api/sessions/:key/send
  end
end
```

**UI 展示：**
- 侧边栏显示所有 sessions
- 点击切换 session
- 显示 session 状态（active/idle）
- 搜索历史消息

### 2. Sub-agents 可视化

```ruby
class OpenClawClient
  # 列出当前 session 的 sub-agents
  def subagents_list(session_key)
    # GET /api/sessions/:key/subagents
  end
  
  # 查看 sub-agent 状态
  def subagent_status(subagent_id)
    # GET /api/subagents/:id
  end
  
  # 干预 sub-agent
  def subagent_steer(subagent_id, message)
    # POST /api/subagents/:id/steer
  end
  
  # 终止 sub-agent
  def subagent_kill(subagent_id)
    # POST /api/subagents/:id/kill
  end
end
```

**UI 展示：**
```
┌─────────────────────────────────────────────────────────────┐
│  Main Chat                              │ Sub-agents (3)    │
├─────────────────────────────────────────┼───────────────────┤
│                                         │ ● PR Review       │
│  You: Review these 3 PRs                │   Running 2m      │
│                                         │   "checking..."   │
│  Agent: I'll spawn sub-agents...        │                   │
│                                         │ ● Code Refactor   │
│                                         │   Running 1m      │
│                                         │   "refactoring.." │
│                                         │                   │
│                                         │ ✓ Tests           │
│                                         │   Completed       │
│                                         │   [View Result]   │
└─────────────────────────────────────────┴───────────────────┘
```

**功能：**
- 实时显示所有 sub-agent 状态
- 显示每个 sub-agent 的最新输出
- 点击展开详细日志
- Steer（发送指令）按钮
- Kill（终止）按钮

### 3. Tool Calls 展示

Agent 调用工具时，实时展示：

```
┌─────────────────────────────────────────────────────────────┐
│  Agent: Let me check the weather...                         │
│                                                              │
│  ┌─ Tool Call ──────────────────────────────────────────┐   │
│  │ 🔧 web_fetch                                          │   │
│  │ URL: https://wttr.in/SF?format=j1                    │   │
│  │ Status: ✓ completed (234ms)                          │   │
│  │ [Show Response]                                       │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
│  Agent: The weather in SF is 18°C and sunny.                │
└─────────────────────────────────────────────────────────────┘
```

**展示内容：**
- Tool 名称
- 输入参数（可折叠）
- 执行状态（running/completed/failed）
- 耗时
- 输出结果（可折叠）

### 4. Memory 查看器

```ruby
class OpenClawClient
  # 搜索 memory
  def memory_search(query)
    # GET /api/memory/search?q=...
  end
  
  # 获取 memory 文件内容
  def memory_get(path, options = {})
    # GET /api/memory/files/:path
  end
end
```

**UI 展示：**
- Memory 文件树
- 搜索框
- 文件内容预览
- 高亮搜索结果

### 5. Cron Jobs（可选）

```ruby
class OpenClawClient
  def cron_list
  def cron_status(job_id)
  def cron_trigger(job_id)
  def cron_logs(job_id)
end
```

## Data Models

```ruby
# 连接到 OpenClaw Gateway 的配置
class GatewayConfig < ApplicationRecord
  belongs_to :user
  encrypts :api_token
  
  # endpoint: OpenClaw Gateway URL
  # api_token: 认证 token
end

# 本地缓存的 session 信息
class Session < ApplicationRecord
  belongs_to :user
  
  # session_key: OpenClaw session key
  # title, last_message_at, status
end

# 本地缓存的消息（可选，用于离线查看）
class Message < ApplicationRecord
  belongs_to :session
  
  enum :role, { user: 0, assistant: 1, system: 2, tool: 3 }
  enum :status, { pending: 0, streaming: 1, completed: 2, failed: 3, canceled: 4 }
  
  # tool_calls: JSON (for assistant messages that call tools)
  # tool_result: JSON (for tool role messages)
end
```

## API Design

### Authentication

```
Authorization: Bearer <token>
```

### Endpoints

```
# Gateway Config
GET    /api/v1/gateway          # 当前配置
POST   /api/v1/gateway          # 设置 gateway
DELETE /api/v1/gateway          # 断开

# Sessions (proxy to OpenClaw)
GET    /api/v1/sessions
GET    /api/v1/sessions/:key
GET    /api/v1/sessions/:key/messages
POST   /api/v1/sessions/:key/messages

# Sub-agents
GET    /api/v1/sessions/:key/subagents
GET    /api/v1/subagents/:id
POST   /api/v1/subagents/:id/steer
POST   /api/v1/subagents/:id/kill

# Memory
GET    /api/v1/memory/search?q=...
GET    /api/v1/memory/files/*path

# Streaming
GET    /api/v1/sessions/:key/stream   (SSE)
```

### SSE Events

```
event: message
data: {"type": "chunk", "content": "Hello", "message_id": "..."}

event: message
data: {"type": "tool_call_start", "tool": "web_fetch", "id": "..."}

event: message
data: {"type": "tool_call_end", "id": "...", "result": "...", "duration_ms": 234}

event: subagent
data: {"type": "spawned", "id": "...", "task": "..."}

event: subagent
data: {"type": "progress", "id": "...", "output": "..."}

event: subagent
data: {"type": "completed", "id": "...", "result": "..."}
```

## UI Layout

### Web

```
┌──────────────────────────────────────────────────────────────────────┐
│  Half & Half                                    [Memory] [Settings]  │
├─────────────┬────────────────────────────────────┬───────────────────┤
│             │  [Tab 1] [Tab 2] [+]               │                   │
│  Sessions   ├────────────────────────────────────┤  Sub-agents       │
│             │                                    │                   │
│  > Main     │  Agent: Here's the code:          │  ● Task 1         │
│    Research │  ```python                        │    Running...     │
│    Debug    │  def hello():                     │                   │
│             │      print("world")               │  ✓ Task 2         │
│             │  ```                              │    Completed      │
│             │                                    │                   │
│             │  ┌─ Tool Call ─────────────────┐  │                   │
│             │  │ 🔧 exec: python test.py     │  │                   │
│             │  │ ✓ completed (1.2s)          │  │                   │
│             │  └─────────────────────────────┘  │                   │
│             ├────────────────────────────────────┤                   │
│             │  [Input...]                 [Send] │                   │
└─────────────┴────────────────────────────────────┴───────────────────┘
```

### TUI

```
┌─ Sessions ──┐┌─ Main ─────────────────────────────┐┌─ Sub-agents ─┐
│ > Main      ││ You: Review the PR                 ││ ● PR Review  │
│   Research  ││                                    ││   2m ago     │
│   Debug     ││ Agent: I'll check it...            ││              │
│             ││                                    ││ ✓ Tests      │
│             ││ [Tool: gh pr view #123]            ││   Done       │
│             ││ Status: ✓ (0.8s)                   ││              │
│             │├────────────────────────────────────┤│              │
│             ││ > Type message...                  ││              │
└─────────────┘└────────────────────────────────────┘└──────────────┘
```

## Streaming Architecture

### Stream Bus

统一处理 OpenClaw 的各种实时事件：

```ruby
class OpenClawStreamBus
  def self.connect(session_key)
    # 连接到 OpenClaw Gateway SSE
    # 解析事件并分发给 Web/TUI
  end
  
  def self.broadcast(session, event)
    case event.type
    when 'chunk'
      broadcast_message_update(session, event)
    when 'tool_call_start', 'tool_call_end'
      broadcast_tool_call(session, event)
    when 'subagent_spawned', 'subagent_progress', 'subagent_completed'
      broadcast_subagent(session, event)
    end
  end
end
```

## Security

- Gateway API token 加密存储
- 不存储 OpenClaw 凭证明文
- 本地消息缓存可选
- 自托管 = 完全控制

## Deployment

### 用户需要

1. 运行中的 OpenClaw Gateway
2. Half & Half 服务器（自托管或托管）
3. 配置 Gateway 连接

### Docker Compose

```yaml
services:
  halfhalf:
    image: halfhalf:latest
    environment:
      - DATABASE_URL=postgres://...
      - RAILS_MASTER_KEY=...
    ports:
      - "3000:3000"
  
  db:
    image: postgres:16
```
