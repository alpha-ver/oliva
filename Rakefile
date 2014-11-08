# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks


desc "daemon service"
task :default => :environment do
  time_loop = 30

  loop{
    time_start=Time.now
    ###################
    print "+"
    tasks=Task.where(
      "next_at <= :time_start AND active=true",
      :time_start => time_start
    )
    
    ap = AvitoApi.new()

    unless tasks.blank?
      tasks.each do |task|
        task.count   = task.count + 1
        task.next_at = (time_start + task.interval.minutes).utc.iso8601
        #
        res=ap.get('/items', task.p)
        if res[:status] && res[:result]["count"] != task.count


          ###

        end
        #
        task.stat = ""
        task.save
      end
    end





    
    ########################
    time_end   = Time.now
    time_sleep = time_loop - (time_end - time_start)
    if time_sleep > 0
      sleep time_sleep
    else
      # разфоркаться
      # сменить ip
      # функия логирования на аццкий диплей
    end
  }

end