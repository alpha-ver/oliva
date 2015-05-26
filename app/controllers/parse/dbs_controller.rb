class Parse::DbsController < ApplicationController
  before_action :set_parse_db, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  respond_to :html

  def index
    @parse_dbs = Parse::Db.where(:user_id => curren_user.id)
    respond_with(@parse_dbs)
  end

  def show
    respond_with(@parse_db)
  end

  def new
    @parse_db = Parse::Db.new
    respond_with(@parse_db)
  end

  def edit
  end

  def create
    @parse_db = Parse::Db.new(db_params)
    @parse_db.save
    respond_with(@parse_db)
  end

  def update
    @parse_db.update(db_params)
    respond_with(@parse_db)
  end

  def destroy
    @parse_db.destroy
    respond_with(@parse_db)
  end

  private
    def set_parse_db
      @parse_db = Parse::Db.find_by(:id => params[:id], :user_id => curren_user.id)
    end

    def parse_db_params
      params.require(:parse_db).permit(:task_id, :url, :title, :body, :img, :date, :additional)
    end
end
