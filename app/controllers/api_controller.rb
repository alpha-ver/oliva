class ApiController < ApplicationController
  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token, :only => [:txt]

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
      v=6
      if p.nil?
        p={}
      end
      p[:limitVip] = 0
      p[:deviceId] = '1122334455667788'
    else
      v=2
    end

    json = AvitoApi.new().get("/#{params[:path]}", p, v)    
    p json
    render :json => json
  end

  def test
    swoop = Proc.new { |k, v| v.delete_if(&swoop) if v.kind_of?(Hash);  v.empty? }
    render :json => params.delete_if(&swoop)
  end

  def txt
    render :json => {:q=>'66', :results=>[{:id=>'7', :text=>'66'}]}


  end



end
