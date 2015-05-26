class Vk::AccountGroupsController < ApplicationController
  before_action :set_vk_account_group, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  
  # GET /vk/account_groups
  # GET /vk/account_groups.json
  def index
    @vk_account_groups = Vk::AccountGroup.all
  end

  # GET /vk/account_groups/1
  # GET /vk/account_groups/1.json
  def show
  end

  # GET /vk/account_groups/new
  def new
    @vk_account_group = Vk::AccountGroup.new
  end

  # GET /vk/account_groups/1/edit
  def edit
  end

  # POST /vk/account_groups
  # POST /vk/account_groups.json
  def create
    @vk_account_group = Vk::AccountGroup.new(vk_account_group_params)

    respond_to do |format|
      if @vk_account_group.save
        format.html { redirect_to @vk_account_group, notice: 'Account group was successfully created.' }
        format.json { render :show, status: :created, location: @vk_account_group }
      else
        format.html { render :new }
        format.json { render json: @vk_account_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vk/account_groups/1
  # PATCH/PUT /vk/account_groups/1.json
  def update
    generate

    respond_to do |format|
      if @vk_account_group.update(vk_account_group_params)
        format.html { redirect_to @vk_account_group, notice: 'Account group was successfully updated.' }
        format.json { render :show, status: :ok, location: @vk_account_group }
      else
        format.html { render :edit }
        format.json { render json: @vk_account_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vk/account_groups/1
  # DELETE /vk/account_groups/1.json
  def destroy
    @vk_account_group.destroy
    respond_to do |format|
      format.html { redirect_to vk_account_groups_url, notice: 'Account group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vk_account_group
      @vk_account_group = Vk::AccountGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vk_account_group_params
      params.require(:vk_account_group).permit(:name, :cross, :cross_ids, :find_id, :active)
    end

    def generate
      #@vk_account_group = Vk::AccountGroup.last
      vk_find            = @vk_account_group.vk_find
      #vk_account        = @vk_account_group.vk_accounts[1]
      vk_all_invited_ids    = []
      account_count = @vk_account_group.vk_accounts.count
      @vk_account_group.vk_accounts.each do |vk_account|
        #vk_account.vk_invite
        if !vk_account.vk_invite.nil?
          vk_all_invited_ids = vk_all_invited_ids + vk_account.vk_invite.invited_ids
        end
      end

      vk_all_invited_ids.uniq!
      vk_all_user_ids    = Vk::User.where(:id => vk_find.find_ids, :status=>1).order(:friend_count => :desc).map{|i| i.id}
      vk_invite_user_ids = vk_all_user_ids - vk_all_invited_ids
      vk_all_user_ids.clear
      vk_all_invited_ids.clear

      i = 0
      vk_invite_ids = []
      0.upto(account_count){ |n| vk_invite_ids[n] = []} 

      0.upto(9999){ |n|
        0.upto(account_count){ |nn|
          vk_invite_ids[nn] << vk_invite_user_ids[i]
          i=i+1
        } 
      }

      vk_invite_user_ids.clear

      i = 0
      @vk_account_group.vk_accounts.each do |vk_account|
        #vk_account.vk_invite
        if !vk_account.vk_invite.nil?
          vk_account.vk_invite.invite_ids = vk_invite_ids[i]
          vk_account.vk_invite.save
        end
        i=i+1
      end

    end

end
