class ChatController < ApplicationController
  before_action :require_login

  def index
    @gateway_config = current_user.gateway_configs.first
    @messages = []
  end
end
