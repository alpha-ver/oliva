class Avito::TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  respond_to    :html
  before_action :authenticate_user!

  def index
    @tasks = current_user.avito_tasks.all
    respond_with(@tasks)
  end

  def show
    respond_with(@task)
  end

  def new
    @task = Avito::Task.new
    respond_with(@task)
  end

  def edit
  end


  def create
    swoop = Proc.new { |k, v| v.delete_if(&swoop) if v.kind_of?(Hash);  v.empty? }
    @task = Avito::Task.new(task_params.delete_if(&swoop))

    @task.user = current_user
    render :json => {:status=>@task.save, :result=>@task}
  end

  def update
    @task.update(task_params_strong)
    respond_with(@task)
  end

  def destroy
    @task.destroy
    respond_with(@task)
  end


  ###-_-_-_###
  private
    def set_task
      @task = Avito::Task.find_by(:id => params[:id], :user_id => current_user.id)
    end

    def task_params
      params.require(:avito_task).permit(:name, :interval, :active).tap do |while_listed|
        while_listed[:p] = params[:task][:p]
        while_listed[:e] = params[:task][:e]
      end
    end

    def task_params_strong
      params.require(:avito_task).permit(:name, :interval, :active)
    end


end
