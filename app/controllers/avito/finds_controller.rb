class Avito::FindsController < ApplicationController
  before_action :set_avito_find, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  respond_to :html

  def index
    @avito_finds = current_user.avito_finds.all
    respond_with(@avito_finds)
  end

  def show
    respond_with(@avito_find)
  end

  def new
    @avito_find = Avito::Find.new
    respond_with(@avito_find)
  end

  def edit
  end

  def create
    @avito_find = Avito::Find.new(find_params)
    @avito_find.save
    respond_with(@avito_find)
  end

  def update
    @avito_find.update(find_params)
    respond_with(@avito_find)
  end

  def destroy
    @avito_find.destroy
    respond_with(@avito_find)
  end

  private
    def set_avito_find
      @avito_find = Avito::Find.find(params[:id])
    end

    def avito_find_params
      params.require(:avito_find).permit(:require, :response)
    end
end
