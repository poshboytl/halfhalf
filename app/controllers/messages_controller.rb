class MessagesController < ApplicationController
  include ActionController::Live

  before_action :require_login

  def create
    @gateway_config = current_user.gateway_configs.first
    return head :unprocessable_entity unless @gateway_config

    # Create user message
    user_message = @gateway_config.messages.create!(
      role: :user,
      content: params[:content],
      status: :completed
    )

    # Create pending assistant message
    assistant_message = @gateway_config.messages.create!(
      role: :assistant,
      content: "",
      status: :pending
    )

    # Build conversation history
    messages = @gateway_config.messages.ordered.map do |msg|
      { role: msg.role, content: msg.content }
    end.reject { |m| m[:content].blank? }

    # Stream response
    response.headers["Content-Type"] = "text/event-stream"
    response.headers["Cache-Control"] = "no-cache"
    response.headers["X-Accel-Buffering"] = "no"

    client = OpenclawClient.new(@gateway_config)
    full_content = ""

    begin
      assistant_message.update!(status: :streaming)

      client.chat(messages: messages, stream: true) do |chunk|
        full_content += chunk
        assistant_message.update!(content: full_content)

        # Send SSE event
        data = { content: full_content, message_id: assistant_message.id }.to_json
        response.stream.write("data: #{data}\n\n")
      end

      assistant_message.update!(status: :completed)
      response.stream.write("data: {\"done\": true, \"message_id\": #{assistant_message.id}}\n\n")
    rescue => e
      assistant_message.update!(status: :failed, content: "Error: #{e.message}")
      response.stream.write("data: {\"error\": \"#{e.message}\"}\n\n")
    ensure
      response.stream.close
    end
  end
end
