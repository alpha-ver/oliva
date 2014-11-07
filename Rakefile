# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks


desc "daemon service"
task :default => :environment do
  time_loop = 30

  loop{
    time_start=Time.now.to_i
    ########################
    print "+"




    
    ########################
    time_end   = Time.now.to_i
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