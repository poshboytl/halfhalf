class ConversationsController < ApplicationController
  before_action :require_login
  before_action :set_project, only: [:new, :create]
  before_action :set_conversation, only: [:show, :edit, :update, :destroy]

  def index
    # 首页：显示最近的对话或引导创建
    @recent_conversations = current_user.conversations.includes(:project)
                                       .order(updated_at: :desc)
                                       .limit(20)
    
    # 如果有最近的对话，显示最新的一个
    if @recent_conversations.any?
      @conversation = @recent_conversations.first
      @messages = @conversation.messages.ordered
    end
  end

  def show
    @messages = @conversation.messages.ordered
    @conversation.touch # 更新 updated_at
  end

  def new
    @conversation = @project.conversations.build
  end

  def create
    # 支持两种创建方式：通过 project 或 quick create
    if @project
      @conversation = @project.conversations.build(conversation_params)
    else
      # Quick create: 使用默认项目或创建一个
      default_project = current_user.projects.first || 
                        current_user.projects.create!(name: "General")
      @conversation = default_project.conversations.build(conversation_params)
    end

    # 如果没有标题，使用默认标题
    @conversation.title ||= "New Conversation"

    if @conversation.save
      redirect_to @conversation
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @conversation.update(conversation_params)
      redirect_to @conversation, notice: "Conversation updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    project = @conversation.project
    @conversation.archived!
    redirect_to project_path(project), notice: "Conversation archived."
  end

  private

  def set_project
    @project = current_user.projects.find(params[:project_id]) if params[:project_id]
  end

  def set_conversation
    @conversation = current_user.conversations.find(params[:id])
  end

  def conversation_params
    params.require(:conversation).permit(:title)
  end
end
