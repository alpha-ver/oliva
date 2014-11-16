class StaticPageController < ApplicationController
  def main
    #render layout: 'main'
  end

  def about
  end

  def help
  end

  def test
    ad = [1,2,3,5,6]
    Notification.mail_medium('hav0k@me.com', ad)
    render :json => ""
  end
end
