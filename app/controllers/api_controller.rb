class ApiController < ApplicationController
  
  def avito
    sleep 1
    json = AvitoApi.new().get("/#{params[:path]}", params[:p])
    render :json => json
  end

end
