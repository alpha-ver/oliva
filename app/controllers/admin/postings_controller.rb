class Admin::PostingsController < ApplicationController
  before_action :set_posting, only: [:show, :edit, :update, :destroy]

  def index
    @admin_postings = Admin::Posting.all
    respond_with(@admin_postings)
  end

  def show
    respond_with(@posting)
  end

  def new
    @posting = Admin::Posting.new
    respond_with(@posting)
  end

  def edit
  end

  def create
    @posting = Admin::Posting.new(posting_params)
    @admin_posting.save
    respond_with(@posting)
  end

  def update
    @admin_posting.update(posting_params)
    respond_with(@posting)
  end

  def destroy
    @admin_posting.destroy
    respond_with(@posting)
  end

  private
    def set_posting
      @posting = Admin::Posting.find(params[:id])
    end

    def posting_params
      params.require(:posting).permit(:title, :description, :manager, :price, :images, :p, :count, :user_id, :active, :allow_mail, :next_at)
    end
end
