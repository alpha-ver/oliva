class ApiController < ApplicationController
  
  def avito
    json = AvitoApi.new().get("/#{params[:path]}", params[:p])
    render :json => json
  end

end
