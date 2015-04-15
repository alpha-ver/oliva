class Avito::PostingsController < ApplicationController
  respond_to :html
  before_action :set_posting, only: [:show, :edit, :update, :destroy]


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
    @posting = Avito::Posting.new(posting_params)
    @avito_posting.save
    respond_with(@posting)
  end

  def update
    @avito_posting.update(posting_params)
    respond_with(@posting)
  end

  def destroy
    @avito_posting.destroy
    respond_with(@posting)
  end

  private
    def set_posting
      @posting = Avito::Posting.find(params[:id])
    end

    def posting_params
      params.require(:posting).permit(:title, :description, :manager, :price, :images, :p, :e, :count, :user_id, :active, :allow_mail, :next_at)
    end
end
