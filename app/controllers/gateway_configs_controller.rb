class GatewayConfigsController < ApplicationController
  before_action :require_login

  def new
    @gateway_config = current_user.gateway_configs.build
  end

  def create
    @gateway_config = current_user.gateway_configs.build(gateway_config_params)

    if @gateway_config.save
      redirect_to root_path, notice: "Gateway connected!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @gateway_config = current_user.gateway_configs.find(params[:id])
  end

  def update
    @gateway_config = current_user.gateway_configs.find(params[:id])

    if @gateway_config.update(gateway_config_params)
      redirect_to root_path, notice: "Gateway updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @gateway_config = current_user.gateway_configs.find(params[:id])
    @gateway_config.destroy
    redirect_to root_path, notice: "Gateway disconnected"
  end

  private

  def gateway_config_params
    params.require(:gateway_config).permit(:name, :endpoint, :api_token)
  end
end
