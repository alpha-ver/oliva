namespace :vk  do
  desc "Задачи поиска людишек"
  task :find  => :environment do
    # it is OK?
    time_loop = 60
    loop{
      #begin
        time_start=Time.now
        ###################
        vks=Vk::Find.where(
          "next_at <= :time_start AND active=true",
          :time_start => time_start
        )
        ###################
        print  "Task Count = #{vks.count} | "
        unless vks.blank?
          vks.each do |task|
            #main code
            current_user = User.find(task.user_id)
            captcha      = current_user.antigate_key.blank? ? false : current_user.antigate_key
            vk_accounts  = current_user.vk_accounts
            all_tokens   = current_user.vk_accounts.all.map{|i| i.token}.compact
            count = 1

            vka = VKA.new(
              :antigate_key => captcha,
              :token        => all_tokens[0]
            )

            #if task.count.nil?
              vk_find = vka.find(task.p)
              print vk_find[:count]

              if vk_find[:count] < 12000 && vk_find[:count] > 1000
                1.upto(12){ |m| 
                  respose = vka.find(task.p.merge(:birth_month => m.to_s))
                  vk_find.items = vk_find.items + respose.items
                  sleep 0.3

                } 
              elsif vk_find[:count] >= 12000 && vk_find[:count] < 30000
                1.upto(31){ |d| 
                  respose = vka.find(task.p.merge(:birth_day => d))
                  vk_find.items = vk_find.items + respose.items
                  sleep 1
                }                 
              elsif vk_find[:count] >= 31000
                1.upto(12){ |m| 
                    response = vka.find(task.p.merge(:birth_month => m))
                    vk_find.items = vk_find.items + response.items
                    sleep 1               
                  1.upto(31){ |d|
                    response = vka.find(task.p.merge(:birth_day => d, :birth_month => m))
                    vk_find.items = vk_find.items + response.items
                    #гыыы
                    if response['count'] == 0
                      count = count+1
                      print count

                      vka = VKA.new(
                        :antigate_key => captcha,
                        :token        => all_tokens[rand(all_tokens.count)]
                      )

                    end
                    sleep 0.3
                  }
                } 
              end

              vk_find.items.uniq!
              ids = vk_find.items.map do |item|
                unless item.blank? || item.id.nil?
                  vk_user = Vk::User.find_by(:id=>item.id)
                  if vk_user.nil?
                    vk_user = Vk::User.new(
                      id:              item.id, 
                      first_name:      item.first_name, 
                      last_name:       item.last_name, 
                      sex:             item.sex, 
                      city_id:         item.city.nil? ? nil : item.city.id, 
                      country_id:      item.country.nil? ? nil : item.country.id,
                      private_message: item.can_write_private_message == 1 ? true : false 
                      )
                    save = vk_user.save
                  end
                  item.id
                end
              end

              task.count        = vk_find[:count]
              task.find_count   = ids.count
              task.find_ids     = ids
              task.active       = false
              task.save



            #else
              #повтор события
              
              #
            #end
          end
        end
        #################################################
        time_end   = Time.now                           #
        time_sleep = time_loop - (time_end - time_start)#
        #################################################
        if time_sleep > 0
          sleep time_sleep
        else
          # Не слип:)
          File.open("tmp/sleep", "a") { |f| f.write(time_sleep.to_s + "\n") }
        end
      #rescue Exception => e
        #отслеживание ошибок
        #File.open("tmp/exp", "a") { |f| f.write(e.to_s + "\n") }
      #end
    }


  end

  desc "Дополинельная информация о людишках"
  task :user  => :environment do
    time_loop = 600
    loop{
      begin
        time_start=Time.now
        ###################
        vku=Vk::User.where(:status => nil)            
        vka=VKA.new()
        ###################
        print  "Task Count = #{vku.count} | "

        unless vku.blank?
          vku.each do |task|
            res = vka.friends(task.id)
            if res[:success] 
              puts "#{task.id} -> #{res[:result][:count]}".green
              task.friend_ids   = res[:result][:items]
              task.friend_count = res[:result][:count]
              task.status       = 1
            else
              puts "#{task.id} ->  #{res[:result][:code]}".red
              task.status       = "-#{res[:result][:code]}".to_i
            end
            task.save
          end
        end

        #################################################
        time_end   = Time.now                           #
        time_sleep = time_loop - (time_end - time_start)#
        #################################################
        if time_sleep > 0
          sleep time_sleep
        else
          # Не слип:)
          File.open("tmp/sleep", "a") { |f| f.write(time_sleep.to_s + "\n") }
        end
      rescue Exception => e
        #отслеживание ошибок
        File.open("tmp/vk_user_err", "a") { |f| f.write(e.to_s + "\n") }
      end
    }
  end


  desc "Дополинельная информация о людишках"
  task :invite  => :environment do
    time_loop = 30
    loop{
      #begin
        time_start=Time.now
        ###################
        tasks=Vk::Invite.where(
          "next_at <= :time_start AND active=true",
          :time_start => time_start
        )
        ###################
        print  "Task Count = #{tasks.count} | "
        unless tasks.blank?
          tasks.each do |task|
          #start main each
            if task.status.nil?
              task.invite_ids = Vk::User.where(:status => 1).order(:friend_count=> :desc).map{|i| i.id}
              task.status     = 1
              task.save
            elsif  task.status == 1
              ###init 
              vk_account    = Vk::Account.find(task.vk_account_id)
              current_user  = User.find(vk_account.user_id)
              vka = VKA.new(
                :antigate_key => current_user.antigate_key,
                :token        => vk_account.token
              )
              ##
              inv_ids = task.invite_ids
              inv_id  = inv_ids.first
              inv     = vka.invite(inv_id)

              if inv[:success]
                puts "#{vk_account.id} -> #{inv_id}".green
                task.invite_ids  = inv_ids - [inv_id]
                task.invited_ids = task.invited_ids + [inv_id]
                task.next_at = time_start + task.interval.seconds
                task.save

              elsif inv[:result][:code] == 1
                puts "#{vk_account.id} -> #{inv_id}".red 
                task.next_at = time_start + 600.minutes
                task.save
              end


            end

          #end main each
          end
        end
        #################################################
        time_end   = Time.now                           #
        time_sleep = time_loop - (time_end - time_start)#
        #################################################
        if time_sleep > 0
          sleep time_sleep
        else
          # Не слип:)
          File.open("tmp/sleep", "a") { |f| f.write(time_sleep.to_s + "\n") }
        end
      #rescue Exception => e
        #отслеживание ошибок
        #File.open("tmp/exp", "a") { |f| f.write(e.to_s + "\n") }
      #end
    }
  end
end



