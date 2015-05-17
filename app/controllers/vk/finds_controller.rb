class Vk::FindsController < ApplicationController
  before_action :set_vk_find, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!


  respond_to :html

  def index
    @vk_finds = Vk::Find.where(:user_id => current_user.id).all
    respond_with(@vk_finds)
  end

  def show
    respond_with(@vk_find)
  end

  def new
    @vk_find = Vk::Find.new
    respond_with(@vk_find)
  end

  def edit
  end

  def create
    @vk_find = Vk::Find.new(vk_find_params)
    current_user.vk_finds << @vk_find
    @vk_find.save
    respond_with(@vk_find)
  end

  def update
    #render :json => vk_find_params
    @vk_find.update(vk_find_params)
    respond_with(@vk_find)
  end

  def destroy
    @vk_find.destroy
    respond_with(@vk_find)
  end

  private
    def set_vk_find
      @vk_find = Vk::Find.find(params[:id])
    end

    def vk_find_params
      params.require(:vk_find).permit(
        :name,
        :count,
        :find_count, 
        :step_count,
        :error_code, 
        :interval, 
        :active
      ).tap do |while_listed|
        while_listed[:p] = params[:vk_find][:p].delete_if { |key, value| value.blank? }
      end
    end
end
