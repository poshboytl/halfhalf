# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Half & Half is an OpenClaw-specific AI client built with Rails 8. It provides a web interface for interacting with OpenClaw agents, featuring real-time SSE streaming, sub-agent visualization, tool call display, and memory browsing. Documentation is in Chinese; the codebase is in English.

## Commands

```bash
bin/setup              # Install deps, create DB, run migrations
bin/dev                # Start dev server (Puma + Tailwind watcher)
bin/rails server       # Web server only (port 3000)
bin/rails tailwindcss:watch  # Tailwind CSS watcher only

bin/rails db:create    # Create development database
bin/rails db:migrate   # Run pending migrations
bin/rails db:reset     # Reset DB with seeds

bin/rubocop            # Lint (rubocop-rails-omakase style)
bin/brakeman           # Security scan
bin/bundler-audit      # Gem vulnerability audit
bin/ci                 # Run all checks
```

No test framework is configured yet. Database is PostgreSQL (`halfhalf_development`).

## Architecture

```
Browser → Rails Controllers → OpenclawClient (Net::HTTP) → OpenClaw Gateway → AI Agent
                                    ↓ SSE streaming
                              Browser (real-time updates)
```

**Key flow**: User sends message via `POST /messages` → `MessagesController` creates user Message record → `OpenclawClient` calls OpenClaw Gateway `/v1/chat/completions` with SSE streaming → chunks streamed back to browser via `ActionController::Live` → assistant Message saved on completion.

### Core components

- **`app/services/openclaw_client.rb`** — HTTP client for OpenClaw Gateway API. Handles both sync and SSE streaming responses. Sends `Authorization: Bearer` and `x-openclaw-agent-id: "main"` headers.
- **`app/controllers/chat_controller.rb`** — Main chat page (`root`). Displays current gateway config and message history.
- **`app/controllers/messages_controller.rb`** — Message submission with `ActionController::Live` for SSE streaming.
- **`app/controllers/gateway_configs_controller.rb`** — CRUD for OpenClaw Gateway connections (endpoint + encrypted API token).
- **`app/javascript/controllers/chat_controller.js`** — Stimulus controller handling message submission, SSE stream reading via Fetch API, and real-time UI updates.

### Data model

- **User** → has many **GatewayConfigs** (OpenClaw connections with encrypted `api_token`)
- **GatewayConfig** → has many **Messages** (role: user/assistant/system, status: pending/streaming/completed/failed)

### Auth

Custom session-based auth (no Devise). `ApplicationController` provides `current_user`, `logged_in?`, and `require_login` helpers.

## Tech stack

- Rails 8.1 with Hotwire (Turbo + Stimulus), Propshaft, Import Maps (no Node.js)
- Tailwind CSS via `tailwindcss-rails`
- PostgreSQL, Solid Queue/Cache/Cable
- Kamal for Docker-based deployment

## Project plans

Detailed roadmap and design docs are in `plans/` (OVERVIEW.md, ARCHITECTURE.md, TECH_STACK.md, MILESTONES.md). Current phase: M2 (Chat & Streaming). Planned features include sub-agent visualization, tool call display, memory viewer, and a Go TUI client.
