我看完了最新的 README.md 和 plans/ 下的设计文档。plans/PROTOCOL.md 与 plans/CRYPTO.md 已不存在（我这边读取报错），整体方向确实从 E2E 转到 AI 体验与并行会话。下面是 review 与建议。
整体评价
- 方向更聚焦，围绕“AI 友好 + 并行处理”把技术栈和里程碑都收敛到 Rails + Hotwire，落地性提升。
- 设计从“通信协议/加密”转向“体验/渲染/流式”，与产品目标一致，风险降低。
主要亮点
- Hotwire + Turbo Streams 适合做高频 UI 更新，开发速度快，契合 MVP。
- Web + TUI 双端策略清晰，并且 API/SSE 设计能覆盖 CLI 场景。
- 里程碑重新压缩到 5–7 周，更现实。
关键问题与建议
- 数据安全与隐私边界：去掉 E2E 后，建议明确“服务端可见数据范围”和“保留策略”，并把 Active Record Encryption 的密钥管理策略说清楚（Rails master key/rotation/backup）。  
  建议在 plans/ARCHITECTURE.md 加一小节：日志脱敏、保留周期、数据导出/删除。
- API 设计不一致：  
  - README.md 里 POST /api/v1/conversations/:id/messages → SSE stream，  
  - plans/ARCHITECTURE.md 里是 POST /api/v1/conversations/:id/stream。  
  建议统一端点与语义（推荐单独 /stream，消息创建保持常规 POST）。
- ActionCable + SSE 的并存策略：需要明确：  
  - Web 走 Turbo Streams / ActionCable  
  - TUI 走 SSE  
  但后台流式 AI 生成的“单一源事件”如何转成这两种？建议定义一个内部事件总线（例如 AiStreamEvent）统一消费。
- 并行会话 UX 的定义仍偏抽象：建议给出明确的关键动作与交互：  
  - 标签页创建/关闭/固定  
  - 分屏视图的同步滚动或独立滚动  
  - 跨会话引用（引用块或消息 link）  
  这些是“并行体验”的护城河，值得在 plans/MILESTONES.md 里细化成验收标准。
- TUI 技术选型不一致：README.md 写 Go，plans/ARCHITECTURE.md 写 Go/Rust，plans/TECH_STACK.md 写 Go。建议统一为 Go，避免偏离。
- AI Provider 抽象缺少失败与限额策略：建议在 plans/ARCHITECTURE.md 中补充：  
  - 超时/重试/降级  
  - 费用记录/限额（tokens, cost）  
  - 用户自带 key 与系统 key 的优先级
我对新方向的看法
- 你做的是“AI 对话体验层”，这个方向比 E2E 更能形成差异化，也更容易验证。  
- 关键不是“聊天功能”，而是把“并行 + 渲染 + 流式 + 可配置模型”做到让人回不去别的工具。  
- 建议尽快做出“并行会话 + 真实流式 + 复杂 Markdown”三件套的 demo，哪怕没有完整账户体系，也能快速验证价值。
具体可落地的补强建议（优先级）
1) 在 plans/ARCHITECTURE.md 添加“数据安全与保留策略”  
2) 统一 API 端点命名与流式语义（README 与 plans 对齐）  
3) 在 plans/MILESTONES.md 的 M4 加验收标准（并行会话的具体行为）
如果你希望，我可以直接给出这些文档的补充改写稿，或直接在 plans/ARCHITECTURE.md / plans/MILESTONES.md 帮你补章节。
