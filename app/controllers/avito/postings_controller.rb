class Avito::PostingsController < ApplicationController
  respond_to    :html
  before_action :authenticate_user!
  before_action :set_posting, only: [:show, :edit, :update, :destroy]
  before_action :work_account


  def index
    @avito_postings = Avito::Posting.all
    respond_with(@avito_postings)
  end

  def show
    respond_with(@posting)
  end

  def new
    @avito_posting = Avito::Posting.new
    respond_with(@avito_posting)
  end

  def edit
  end

  def create
    swoop = Proc.new { |k, v| v.delete_if(&swoop) if v.kind_of?(Hash);  v.blank? }
    @posting = Avito::Posting.new(posting_params.delete_if(&swoop))

    @posting.user = current_user
    render :json => {:status=>@posting.save, :result=>@posting}
  end

  def update
    @avito_posting.update(posting_params)
    respond_with(@avito_posting)
  end

  def destroy
    @avito_posting.destroy
    respond_with(@avito_posting)
  end

  private
    def set_posting
      @avito_posting = Avito::Posting.find(params[:id])
    end


    def work_account
      @work_account = current_user.avito_accounts.where(:status => 1)
      if @work_account.blank?
        flash[:notice] = 'В начале добавте хотя бы один рабочий аккаунт.'
        redirect_to :controller=>'accounts', :action => 'index'
      end
    end

    def posting_params_strong
      params.require(:avito_posting).permit(:name, :title, :description, :manager, :price, :images, :count, :user_id, :active, :allow_mail)
    end

    def posting_params
      params.require(:avito_posting).permit(:name, :count, :active, :allow_mail, :interval).tap do |while_listed|
        if params[:action] == "create"
          while_listed[:p] = params[:task][:p]
        end 

        while_listed[:e] = params[:task][:e]

        while_listed[:title]       = params[:avito_posting][:title]
        while_listed[:description] = params[:avito_posting][:description]
        while_listed[:manager]     = params[:avito_posting][:manager]
        while_listed[:price]       = params[:avito_posting][:price]
        while_listed[:images]      = params[:avito_posting][:images]

      end
    end


end
