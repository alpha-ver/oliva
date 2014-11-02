class FeedBackController < ApplicationController

  def beta
    f = true
    phone = params[:inv].gsub(/(\d)/).map{|i|i}.join

    if phone.nil? && params[:inv].scan("@").empty?
      f = false
      m = "Проверьте введенные данные."
    elsif !params[:inv].scan("@").empty?
      m = "До запуска мы отправим инвайт на почту #{params[:inv]}."
      File.open("db/forms/inv-email", "a"){|f| f.write(params[:inv] + "\n")}
    elsif phone.size == 11 || phone.size == 10
      m = "До запуска мы отправим инвайт по SMS, на номер #{phone}."
      File.open("db/forms/inv-phone", "a"){|f| f.write(phone + "\n")}
    else
      m = "Проверьте введенные данные."
      f = false
    end

    render :json => {:status => f, :message => m}
  end

  

end
