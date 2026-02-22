require "net/http"
require "json"

class OpenclawClient
  def initialize(gateway_config, session_key: nil)
    @endpoint = gateway_config.endpoint
    @token = gateway_config.api_token
    @uri = URI.parse(@endpoint)
    # 用 gateway_config.id 作为默认 session key，确保同一个 gateway 配置的对话共享 session
    @session_key = session_key || "halfhalf:gateway:#{gateway_config.id}"
  end

  def chat(messages:, stream: false, &block)
    uri = URI.join(@endpoint, "/v1/chat/completions")

    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{@token}"
    request["Content-Type"] = "application/json"
    request["x-openclaw-agent-id"] = "main"

    request.body = {
      model: "openclaw",
      stream: stream,
      messages: messages,
      user: @session_key  # 让 OpenClaw 保持 session
    }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")
    http.read_timeout = 300 # 5 minutes for long responses

    if stream && block_given?
      stream_response(http, request, &block)
    else
      response = http.request(request)
      parse_response(response)
    end
  end

  private

  def stream_response(http, request)
    http.request(request) do |response|
      raise "HTTP Error: #{response.code}" unless response.code == "200"

      response.read_body do |chunk|
        chunk.each_line do |line|
          next if line.strip.empty?
          next unless line.start_with?("data: ")

          data = line.sub("data: ", "").strip
          next if data == "[DONE]"

          begin
            json = JSON.parse(data)
            content = json.dig("choices", 0, "delta", "content")
            yield content if content
          rescue JSON::ParserError
            # Skip malformed JSON
          end
        end
      end
    end
  end

  def parse_response(response)
    raise "HTTP Error: #{response.code}" unless response.code == "200"

    json = JSON.parse(response.body)
    json.dig("choices", 0, "message", "content")
  end
end
