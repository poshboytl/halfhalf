# Tech Stack

## Overview

**服务端**: Rails 8 + Hotwire
**客户端**: Web (Hotwire) + TUI (Go)
**后端**: OpenClaw Gateway

## Backend: Ruby on Rails 8

```ruby
# Gemfile
ruby '3.3.0'

gem 'rails', '~> 8.0'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.4'
gem 'redis', '~> 5.0'

# Hotwire
gem 'turbo-rails'
gem 'stimulus-rails'

# HTTP client (for OpenClaw API)
gem 'faraday'
gem 'faraday-retry'

# Utilities
gem 'rack-attack'
gem 'solid_queue'
gem 'solid_cache'
```

### 关键功能

| 功能 | 实现 |
|------|------|
| Authentication | Devise 或自己写 |
| OpenClaw 连接 | Faraday HTTP client |
| Real-time (Web) | ActionCable + Turbo Streams |
| Real-time (API) | SSE proxy |
| Encryption | Active Record Encryption (gateway token) |

## OpenClaw Client

```ruby
class OpenClawClient
  def initialize(gateway_config)
    @conn = Faraday.new(url: gateway_config.endpoint) do |f|
      f.request :json
      f.response :json
      f.adapter Faraday.default_adapter
      f.headers['Authorization'] = "Bearer #{gateway_config.api_token}"
    end
  end
  
  # Sessions
  def sessions_list(filters = {})
  def sessions_history(session_key, options = {})
  def sessions_send(session_key, message)
  
  # Sub-agents
  def subagents_list(session_key)
  def subagent_steer(id, message)
  def subagent_kill(id)
  
  # Memory
  def memory_search(query)
  def memory_get(path)
  
  # Streaming
  def stream(session_key, &block)
    # SSE connection to OpenClaw
  end
end
```

## Web Frontend: Hotwire

- **Turbo Drive**: SPA-like 导航
- **Turbo Frames**: 局部更新
- **Turbo Streams**: 实时推送（消息、sub-agent 状态）
- **Stimulus**: 交互（折叠/展开、复制代码等）

### JavaScript 依赖

```javascript
import "@hotwired/turbo-rails"
import "controllers"

// Markdown
import { marked } from "marked"
import hljs from "highlight.js"
import DOMPurify from "dompurify"
```

### CSS: Tailwind

```ruby
gem 'tailwindcss-rails'
```

## TUI Client: Go + Bubble Tea

```go
// go.mod
module github.com/poshboytl/halfhalf-tui

require (
    github.com/charmbracelet/bubbletea v0.25
    github.com/charmbracelet/glamour v0.6
    github.com/charmbracelet/lipgloss v0.9
)
```

### 架构

```
┌─────────────────────────────────────────────────────────┐
│                    Bubble Tea App                        │
│  ┌───────────┐  ┌─────────────┐  ┌───────────────────┐  │
│  │ Sessions  │  │    Chat     │  │   Sub-agents      │  │
│  │  Panel    │  │    Panel    │  │     Panel         │  │
│  └───────────┘  └─────────────┘  └───────────────────┘  │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│                  OpenClaw API Client                     │
│  ┌──────────────┐  ┌────────────────────────────────┐   │
│  │  HTTP (REST) │  │   SSE (streaming/events)       │   │
│  └──────────────┘  └────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

## Database: PostgreSQL

主要存储本地配置和缓存：

```ruby
create_table :users do |t|
  t.string :email
  t.string :password_digest
end

create_table :gateway_configs do |t|
  t.references :user
  t.string :name
  t.string :endpoint
  t.text :api_token  # encrypted
end

# 可选：本地缓存
create_table :cached_sessions do |t|
  t.references :user
  t.string :session_key
  t.string :title
  t.datetime :last_message_at
end
```

## Real-time Architecture

### OpenClaw → Rails → Client

```
OpenClaw Gateway
      │
      │ SSE events
      ▼
┌─────────────────────┐
│  Rails SSE Proxy    │
│  (ActionController  │
│   ::Live)           │
└──────────┬──────────┘
           │
     ┌─────┴─────┐
     │           │
     ▼           ▼
┌─────────┐  ┌─────────┐
│   Web   │  │   TUI   │
│  Turbo  │  │   SSE   │
│ Streams │  │         │
└─────────┘  └─────────┘
```

### SSE 事件类型

```
event: message
data: {"type": "chunk", "content": "...", "session_key": "..."}

event: tool_call
data: {"type": "start", "tool": "exec", "id": "..."}

event: tool_call
data: {"type": "end", "id": "...", "result": "...", "duration_ms": 123}

event: subagent
data: {"type": "spawned", "id": "...", "task": "..."}

event: subagent
data: {"type": "progress", "id": "...", "output": "..."}

event: subagent
data: {"type": "completed", "id": "...", "result": "..."}
```

## Deployment

### Kamal

```yaml
service: halfhalf
image: your-registry/halfhalf
servers:
  web:
    hosts:
      - your-server-ip
env:
  secret:
    - RAILS_MASTER_KEY
    - DATABASE_URL
```

### Docker Compose

```yaml
services:
  halfhalf:
    image: halfhalf:latest
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgres://...
  db:
    image: postgres:16
```

### TUI 分发

```bash
# Homebrew
brew install poshboytl/tap/halfhalf

# 或直接下载
curl -L https://github.com/poshboytl/halfhalf/releases/download/v1.0/halfhalf-darwin-arm64 -o halfhalf
chmod +x halfhalf
```

## 参考

| 项目 | 参考点 |
|------|--------|
| Campfire | Rails 架构、Turbo Streams |
| OpenClaw | API 设计 |
| Charm | TUI 架构 |
