# 自动发现 OpenClaw Gateway 配置
# Half & Half 设计为运行在 OpenClaw 同一台机器上

OPENCLAW_CONFIG = begin
  config_path = File.expand_path("~/.openclaw/openclaw.json")
  
  if File.exist?(config_path)
    config = JSON.parse(File.read(config_path))
    port = config.dig("gateway", "port") || 18789
    token = config.dig("gateway", "auth", "token")
    
    {
      endpoint: "http://127.0.0.1:#{port}",
      token: token,
      auto_discovered: true
    }
  else
    {
      endpoint: nil,
      token: nil,
      auto_discovered: false
    }
  end
rescue JSON::ParserError => e
  Rails.logger.error "Failed to parse OpenClaw config: #{e.message}"
  { endpoint: nil, token: nil, auto_discovered: false }
end
