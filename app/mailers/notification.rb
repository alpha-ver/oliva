class Notification < ActionMailer::Base
  default from: "r0b0t@0liva.ru"

  def mail_medium(mail, ad)
    m=mail(to: mail, subject: "#{ad.count} – Новых обьявлений") do |format|
      @ad = ad
      format.html
    end
    m.deliver

    p smtp_settings
  end

end


