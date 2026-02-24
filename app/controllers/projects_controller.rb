class ProjectsController < ApplicationController
  before_action :require_login
  before_action :set_project, only: [ :show, :edit, :update, :destroy ]

  def index
    @projects = current_user.projects.includes(:conversations).order(:name)
  end

  def show
    @conversations = @project.conversations.active.order(updated_at: :desc)
  end

  def new
    @project = current_user.projects.build
  end

  def create
    @project = current_user.projects.build(project_params)

    if @project.save
      redirect_to @project, notice: "Project created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Project updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to root_path, notice: "Project deleted."
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :workspace_path, :repo_url)
  end
end
