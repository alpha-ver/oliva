class Parse::TasksController < ApplicationController
  before_action :set_parse_task, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  respond_to :html

  def index
    @parse_tasks = Parse::Task.all
    respond_with(@parse_tasks)
  end

  def show
    respond_with(@parse_task)
  end

  def new
    @parse_task = Parse::Task.new(user_id: current_user.id)
    @parse_task.step = 0
    respond_with(@parse_task)
  end

  def edit
  end

  def create
    @parse_task = Parse::Task.new(parse_task_params_step_1)
    @parse_task.step = 1   
    @parse_task.save
    respond_with(@parse_task)
  end

  def update
    #render :json => params

    if params[:step] == "1"
      @parse_task.update(parse_task_params_step_1)
    elsif params[:step] == "2"
      @parse_task.update(parse_task_params_step_2)
    elsif params[:step] == "3"
      @parse_task.update(parse_task_params_step_3)
    end

    #@parse_task.update(parse_task_params)
    
    respond_with(@parse_task)
  end

  def destroy
    @parse_task.destroy
    respond_with(@parse_task)
  end

  private
    def set_parse_task
      @parse_task = Parse::Task.find(params[:id])
    end

    def parse_task_params_step_1
      params.require(:parse_task).permit(:name, :interval, :base_url)
    end

    def parse_task_params_step_2
      params.require(:parse_task).permit().merge({:step => 2})
    end

    def parse_task_params_step_3
      params.require(:parse_task).permit().merge({:step => 3})
    end


end
