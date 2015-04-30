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
    @avito_posting = Avito::Posting.new(posting_params)
    @avito_posting.save
    respond_with(@avito_posting)
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

    def posting_params
      params.require(:avito_posting).permit(:name, :title, :description, :manager, :price, :images, :p, :e, :count, :user_id, :active, :allow_mail, :next_at)
    end
end
