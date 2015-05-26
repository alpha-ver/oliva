namespace :parse  do

  desc "Парсим наши НЕ любимые сайты"
  task :task  => :environment do
    time_loop = 30
    loop{
      #begin
        time_start=Time.now
        ###################
        tasks=Parse::Task.where(
          "next_at <= :time_start AND active=true",
          :time_start => time_start
        )
        ###################
        print  "Task Count = #{tasks.count} | "
        unless tasks.blank?
          tasks.each do |task|
          #start main each
            parse = Parser.new(task)
            if task.out['service'] == "vk"
              vk_account = Vk::Account.find(task.out['user_id'])
              vka = VKA.new({ :antigate_key => vk_account.user.antigate_key, :token => vk_account.token })
            else
              raise #todo new service 
            end

            links = parse.links
            p links
            unless links.nil?
              links.each do |link|
                post = parse.post(link)
                if Parse::Db.find_by(:url => link).blank?
                  db = Parse::Db.new(
                    post.merge(
                      :task_id => task.id
                      )
                    )
                  db.save

                  ## Posting
                  if task.out['service'] == "vk"
                    vka_res=vka.post({
                      :owner_id=> task.out["owner_id"], 
                      :from_group=>task.out["from_group"], 
                      :message => "#{db.title}\n\n#{db.body}"
                    })


                  db.info = vka_res
                  db.save

                  else
                    raise #todo new service 
                  end

                end
                sleep 0.5 + rand
              end
            end

            task.next_at = time_start + task.interval.seconds
            task.save
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



