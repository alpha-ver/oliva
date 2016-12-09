# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
Rails.application.load_tasks
require 'rmagick'


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

  `echo "#{Process.pid}" > #{Rails.root}/tmp/pids/loop_m.pid`
  `echo "#{Process.ppid}" > #{Rails.root}/tmp/pids/loop_m.ppid`

  time_loop = 30
  loop{

    #begin

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
          res = ap.get('/items', task.p, 6)
          if res[:status] && res[:result]["count"] != task.count
            out = []

            res[:result]["items"].each do |ritem|
              if ritem['type'] == 'item'
                item = ritem['item']

                db = task.avito_tasklogs.where(:i => item['id'], :module_id => 1)
                if db.blank?
                  task.avito_tasklogs.new(:i => item['id'], :module_id => 1)
                  p item['id']
                  o = ap.get("/items/#{item['id']}", {'includeRefs'=>true, 'reducedParams'=>true}, 6 )
                  p o
                  if o[:status]
                    out << o[:result]
                  else
                    sleep 0.3
                  end
                end
                task.save
              end
            end

            #p out

            if !out.blank?

              if !task.e["email"].nil?
                p "---"
                p out
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

    #rescue Exception => e
      #отслеживание ошибок
      #File.open("tmp/ex", "a") { |f| f.write(e.to_s + "\n") }
    #end
  }
end

desc "### daemon service ###"
task :loop_p => :environment do
  time_loop = 60
  loop{
    #begin
      time_start=Time.now
      ###################
      aps=Avito::Posting.where(
        "next_at <= :time_start AND active=true",
        :time_start => time_start
      )
      ###################
      print  "Task Count = #{aps.count} | "
      unless aps.blank?
        aps.each do |task|
          #login def agent_init
          @avito_account = Avito::Account.find(task.e["account_id"])
          print "init = #{agent_init} | login = #{agent_login} | imgs = "
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

	        p images_id

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
          p task.p
          #post
          avito_additem.form.field('title'      ).value = "#{task.count}." + task.title["#{v}"]
          avito_additem.form.field('description').value = "#{task.count}." + task.description["#{v}"]
          avito_additem.form.field('price'      ).value = task.price["#{v}"]
          avito_additem.form.field('location_id').value = task.p['locationId']
          avito_additem.form.field('category_id').value = task.p['categoryId'] 
          #avito_additem.form.field('manager').value = ""
	        unless task.p["districtId"].blank?
            avito_additem.form.field('district_id').value = task.p["districtId"].first[1]
          end
          task.p["params"].map { |k,v| avito_additem.form.add_field!("params[#{k}]", v) }
          avito_additem.form.add_field!('allow_mails', task.allow_mail ? 1 : 0)
          #info

          #post
          avito_confirm = avito_additem.form.submit()
	        p avito_additem.form
          if  avito_confirm.uri.path  == "/additem/confirm"
            current_user = User.find(task.user_id)
            antigate_init(current_user)

            timestamp = Time.now.to_i
            File.open("public/captcha/#{timestamp}.jpg", "wb") { |f| 
              f << @agent.get("https://www.avito.ru/captcha?#{timestamp}",[], "https://www.avito.ru/additem/confirm").body 
            }

            recognized = @antigate.recognize("http://0liva.ru/captcha/#{timestamp}.jpg", 'jpg')
            p recognized
	          if recognized[1].nil?
              recognized = @antigate.recognize("http://0liva.ru/captcha/#{timestamp}.jpg", 'jpg')
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

              unless avito_pub.header["location"].nil?
                uri_avito_pub =  URI.parse(avito_pub.header["location"])
                if uri_avito_pub.path == "/additem/pay_service"
                  query_avito_pub = Hash[ uri_avito_pub.query.split("&").map{ |i| ii=i.split("=");[ii[0],ii[1]]} ]#айай
                  task.s     = {"item_id" => query_avito_pub['item_id'], "last_v"=>v, :pub=>true}
                  task.count = task.count.nil? ? 1 : task.count + 1
                  puts "+".green
                  task.next_at = time_start + task.interval.day
                else
                  task.s = task.s.merge({:pub=>false, :error=>'wrong captha 2'})
                end
              else
                task.s = task.s.merge({:pub=>false, :error=>'wrong captha 1'})
              end 
            end
            task.save
          else
      	    File.open("task_false", "w") { |f| f.write( avito_confirm.body.force_encoding("utf-8")  ) } 
      	    print 'task_false'
      	    task.active = false
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