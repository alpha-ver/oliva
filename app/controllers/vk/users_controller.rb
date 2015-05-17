class Vk::UsersController < ApplicationController
  before_action :set_vk_user, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @vk_users = Vk::User.all
    respond_with(@vk_users)
  end

  def show
    respond_with(@vk_user)
  end

  def new
    @vk_user = Vk::User.new
    respond_with(@vk_user)
  end

  def edit
  end

  def create
    @vk_user = Vk::User.new(user_params)
    @vk_user.save
    respond_with(@vk_user)
  end

  def update
    @vk_user.update(user_params)
    respond_with(@vk_user)
  end

  def destroy
    @vk_user.destroy
    respond_with(@vk_user)
  end

  private
    def set_vk_user
      @vk_user = Vk::User.find(params[:id])
    end

    def vk_user_params
      params.require(:vk_user).permit(:first_name, :last_name, :sex, :status, :city_id, :country_id, :friend_ids, :friend_count, :private_message)
    end
end
