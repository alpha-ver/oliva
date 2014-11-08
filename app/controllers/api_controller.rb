class ApiController < ApplicationController
  before_action :authenticate_user!

  def avito
    swoop = Proc.new { |k, v| v.delete_if(&swoop) if v.kind_of?(Hash);  v.empty? }
    if params[:task].nil?
      unless params[:p].nil?
        p=params[:p].delete_if(&swoop)
      end
    else
      unless params[:task][:p].nil?
        p=params[:task][:p].delete_if(&swoop)
      end
    end

    p p 

    if params[:path].nil?
      params[:path]="items"
    end


    json = AvitoApi.new().get("/#{params[:path]}", p)    
    render :json => json
  end

  def test
    swoop = Proc.new { |k, v| v.delete_if(&swoop) if v.kind_of?(Hash);  v.empty? }
    render :json => params.delete_if(&swoop)
  end

end
