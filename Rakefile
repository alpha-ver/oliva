# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks


desc "daemon service"
task :default => :environment do

  Mail.defaults do
    delivery_method :smtp,
      address:    "smtp.yandex.ru",
      port:       465,
      enable_ssl: false,
      user_name:  "r0b0t@0liva.ru",
      password:   "sznX8Db9HLpcZgrvBtXe",
      authentication: "plain",
      enable_starttls_auto: true,
      ssl: true
  end

  time_loop = 30

  loop{

    begin

      time_start=Time.now
      ###################
      print "+"
      tasks=Task.where(
        "next_at <= :time_start AND active=true",
        :time_start => time_start
      )
      ap = AvitoApi.new()
      ###################

      unless tasks.blank?
        tasks.each do |task|
          
          task.next_at = time_start + task.interval.minutes
          ###
          res = ap.get('/items', task.p)
          if res[:status] && res[:result]["count"] != task.count
            out = []
            res[:result]["items"].each do |item|
              db = task.tasklogs.where(:i => item['id'], :module_id => 1)
              if db.blank?
                task.tasklogs.new(:i => item['id'], :module_id => 1)
                o = ap.get("/items/#{item['id']}", {:includeRefs=>true, :reducedParams=>true} )
                if o[:status] 
                  out << o[:result]
                  sleep 0.1
                else
                  sleep 0.3
                end
              end
              task.save
            end
            
            #p out 
            
            if !out.blank?

              if !task.e["email"].nil?
                new_mail(task.e, out)
              end

              if !task.e["sms"].nil?
              
              end

              if !task.e["jabber"].nil?
              
              end

              if !task.e["skype"].nil?
              
              end

            end

            task.count = res[:result]["count"]
            task.stat  = ""
            task.save

          end

        end
      end
      
      #####################
      time_end   = Time.now
      time_sleep = time_loop - (time_end - time_start)
      if time_sleep > 0
        sleep time_sleep
      else
        # разфоркаться
        # сменить ip
        # функия логирования на аццкий диплей
        File.open("tmp/sleep", "a") { |f| f.write(time_sleep + "\n") }
      end
      

    rescue Exception => e
      #отслеживание ошибок
      File.open("tmp/ex", "a") { |f| f.write(e + "\n") }
    end
  }

end



def new_mail(e, out)


  if  out.count == 1
    p = "Одно новое обьявлеиние."
  else
    p = "#{out.count} новых обьявлений."
  end

  body =  "<table border=\"1\" width=\"100%\">"
  out.each do |i|
    if !i['price'].nil?
      price = i['price']['value']
    else
      price = "без цены"
    end

    body += 
    "<tr>
      <td>#{i['id']}</td>
      <td>
        <h3><a href=\"#{i['url']}\">#{i['title']}</a></h3>
        <div>#{i['seller'].to_a.map{|i|i[1]}.join(", ")}</div>
        <div>#{i['phone']}</div>
      </td>
      <td>
        <b>#{price}&nbsp;Р.</p>
      </td>
    </tr>"
  end
  body += "</table>"

  Mail.deliver do
    to                 e['email']
    from               "r0b0t@0liva.ru"
    subject            p

    html_part do
      content_type 'text/html; charset=UTF-8'
      body body
    end

   # file_data = File.read(letter.attach)

   # attachments["#{letter.subject}.pdf"] = {
   #   :mime_type => 'application/pdf',
   #   :content   => file_data
   # }

  end






  #@m['List-Unsubscribe'] = "<mailto:rm-unsubscribe@0liva.ru>"
  #@m['List-Help']        = "<mailto:list@cons-gp.ru> (List Instructions)"
  #@m['List-Subscribe']   = "<mailto:list@cons-gp.ru?subject=subscribe>"

end




def a
  Mail.deliver do
    to                 "hav0k@me.com"
    from               "r0b0t@0liva.ru"
    subject            "k"

    html_part do
      content_type 'text/html; charset=UTF-8'
      body "y"
    end
  end
end