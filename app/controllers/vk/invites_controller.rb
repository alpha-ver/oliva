class Vk::InvitesController < ApplicationController
  before_action :set_vk_invite, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @vk_invites = Vk::Invite.all
    respond_with(@vk_invites)
  end

  def show
    respond_with(@vk_invite)
  end

  def new
    @vk_invite = Vk::Invite.new
    respond_with(@vk_invite)
  end

  def edit
  end

  def create
    #render :json => vk_invite_params
  @vk_invite = Vk::Invite.new(vk_invite_params)
    @vk_invite.save
    respond_with(@vk_invite)
  end

  def update
    @vk_invite.update(vk_invite_params)
    respond_with(@vk_invite)
  end

  def destroy
    @vk_invite.destroy
    respond_with(@vk_invite)
  end

  private
    def set_vk_invite
      @vk_invite = Vk::Invite.find(params[:id])
    end

    def vk_invite_params
      params.require(:vk_invite).permit(:name, :interval, :vk_account_id, :active)

      #:invite_ids, :invited_ids, :find_ids,
    end
end
