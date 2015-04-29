# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

desc "### daemon service ###"
task :loop => :environment do
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