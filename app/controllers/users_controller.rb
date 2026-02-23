class UsersController < ApplicationController
  def new
    redirect_to root_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # 自动配置 Gateway（如果 OpenClaw 配置可用）
      if OPENCLAW_CONFIG[:auto_discovered] && OPENCLAW_CONFIG[:token]
        @user.gateway_configs.create!(
          name: "Local Gateway",
          endpoint: OPENCLAW_CONFIG[:endpoint],
          api_token: OPENCLAW_CONFIG[:token]
        )
      end
      
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Welcome to Half & Half!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
