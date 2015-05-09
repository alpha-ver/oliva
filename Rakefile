# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

require 'RMagick'


def agent_init
  @agent = Mechanize.new
  true
end

def agent_login
  ex = false
  page_login = @agent.get "https://www.avito.ru/profile/login"
  if page_login.form.action == "/profile/login"
    page_login.form.field("login").value    = @avito_account.login
    page_login.form.field("password").value = @avito_account.pass
    page_profile = page_login.form.submit()
    ex = page_profile.uri.path == "/profile"
  end 
  ex
end

def antigate_init(current_user)
  unless current_user.antigate_key.nil?
    @antigate = Antigate.wrapper(current_user.antigate_key)
    antigate_money = Antigate.balance(current_user.antigate_key).to_s
    current_user.antigate_money = antigate_money
    current_user.save
  end 
end


#############################
#############################
#############################
desc "### daemon service ###"
task :loop_m => :environment do
  time_loop = 30
  loop{

    begin

      time_start=Time.now
      ###################
      print "+"
      tasks=Avito::Task.where(
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
              db = task.avito_tasklogs.where(:i => item['id'], :module_id => 1)
              if db.blank?
                task.avito_tasklogs.new(:i => item['id'], :module_id => 1)
                o = ap.get("/items/#{item['id']}", {:includeRefs=>true, :reducedParams=>true} )
                if o[:status]
                  out << o[:result]
                else
                  sleep 0.3
                end
              end
              task.save
            end

            #p out

            if !out.blank?

              if !task.e["email"].nil?
                Notification.mail_medium(task.e["email"], out)
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
      #################################################
      time_end   = Time.now                           #
      time_sleep = time_loop - (time_end - time_start)#
      #################################################
      if time_sleep > 0
        sleep time_sleep
      else
        # разфоркаться
        # сменить ip
        # функия логирования на аццкий диплей
        File.open("tmp/sleep", "a") { |f| f.write(time_sleep.to_s + "\n") }
      end

    rescue Exception => e
      #отслеживание ошибок
      File.open("tmp/ex", "a") { |f| f.write(e.to_s + "\n") }
    end
  }
end



desc "### daemon service ###"
task :loop_p => :environment do
  time_loop = 30
  loop{

    #begin
      time_start=Time.now
      ###################
      print "+"
      aps=Avito::Posting.where(
        "next_at <= :time_start AND active=true",
        :time_start => time_start
      )
      ###################

      unless aps.blank?
        aps.each do |task|
          #login def agent_init
          @avito_account = Avito::Account.find(task.e["account_id"])
          agent_init
          agent_login
          avito_additem = @agent.get "https://www.avito.ru/additem"
          #images
          images_id = []
          task.images.each do |img|
            image=Image.find(img)
            rnd = (("a".."z").to_a.shuffle.first(10)).join
            img = Magick::ImageList.new("public/image/#{task.user_id}/#{image.img_hash}.#{image.img_type}")
            x   = rand(50)+1
            y   = rand(50)+1

            img.crop_resized!(img.columns-x, img.rows-y, Magick::NorthGravity)
            img.crop_resized!(img.columns+y, img.rows+x, Magick::NorthGravity)
            img = img.wave(rand(2)+1, img.columns+x+y)
            img = img.implode(rand(100) * 0.001 - 0.05)
            img = img.crop_resized!(img.columns, img.rows-10, Magick::CenterGravity)
            img.write("public/image/#{task.user_id}/#{image.img_hash}_#{rnd}.#{image.img_type}")

            image_post = @agent.post "https://www.avito.ru/additem/image", { 
              "image" => File.new("public/image/#{task.user_id}/#{image.img_hash}_#{rnd}.#{image.img_type}")
            }
            image_id  = JSON.parse(image_post.body)['id']
            images_id << image_id

            avito_additem.form.add_field!('images[]', image_id)
            avito_additem.form.add_field!("rotate[#{image_id}]", 0)
          end

          #type avtomatization
          if task.e['type_uniq'] == "1"
            last_v = task.s['last_v']
            if last_v.nil? || last_v == 1
              v = 0
            else
              v = 1
            end
            #todo
          else
            v = 0
          end

          #post
          avito_additem.form.field('title'      ).value = task.title["#{v}"]
          avito_additem.form.field('description').value = task.description["#{v}"]
          avito_additem.form.field('price'      ).value = task.price["#{v}"]
          avito_additem.form.field('location_id').value = task.p['locationId']
          avito_additem.form.field('category_id').value = task.p['categoryId']
          unless task.p["districtId"].blank?
            avito_additem.form.field('district_id').value = task.p["districtId"].first[1]
          end
          task.p["params"].map { |k,v| avito_additem.form.add_field!("params[#{k}]", v) }
          avito_additem.form.add_field!('allow_mails', task.allow_mail ? 1 : 0)
          #info

          #post
          avito_confirm = avito_additem.form.submit()
          if  avito_confirm.uri.path  == "/additem/confirm"
            current_user = User.find(task.user_id)
            antigate_init(current_user)

            timestamp = Time.now.to_i
            File.open("public/captcha/#{timestamp}.jpg", "wb") { |f| 
              f << @agent.get("https://www.avito.ru/captcha?#{timestamp}",[], "https://www.avito.ru/additem/confirm").body 
            }

            recognized = @antigate.recognize("http://127.0.0.1:3000/captcha/#{timestamp}.jpg", 'jpg')
            if recognized[1].nil?
              recognized = @antigate.recognize("http://127.0.0.1:3000/captcha/#{timestamp}.jpg", 'jpg')
            end

            if recognized[1].nil?
              task.s  =  task.s.merge({:pub=>false, :error=>'nill captha'})
            else   

              avito_confirm.form.field('captcha').value = recognized[1].force_encoding('utf-8').encode
              avito_confirm.form.checkboxes[0].value    = 1 #302 /additem/pay_service ))))
              avito_confirm.form.checkboxes[1].value    = 0
              avito_confirm.form.checkboxes[2].value    = 0
              @agent.redirect_ok = false
              avito_pub          = avito_confirm.form.submit()
              @agent.redirect_ok = true
              uri_avito_pub =  URI.parse(avito_pub.header["location"])

              if uri_avito_pub.path == "/additem/pay_service"
                query_avito_pub = Hash[ uri_avito_pub.query.split("&").map{ |i| ii=i.split("=");[ii[0],ii[1]]} ]
                task.s    = {"item_id" => query_avito_pub['item_id'], "last_v"=>v, :pub=>true}
                task.count= task.count.nil? ? 0 : 1 + 1
                
                puts "OK!" 
                task.next_at = time_start + task.interval.day
              else
                task.s    =  task.s.merge({:pub=>false, :error=>'wrong captha'})
              end
            end
            task.save
          end
        end
      end
      #################################################
      time_end   = Time.now                           #
      time_sleep = time_loop - (time_end - time_start)#
      #################################################
      if time_sleep > 0
        sleep time_sleep
      else
        # разфоркаться
        # сменить ip
        # функия логирования на аццкий диплей
        File.open("tmp/sleep", "a") { |f| f.write(time_sleep.to_s + "\n") }
      end
    #rescue Exception => e
      #отслеживание ошибок
      #File.open("tmp/exp", "a") { |f| f.write(e.to_s + "\n") }
    #end
  }

end