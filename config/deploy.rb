# config valid only for Capistrano 3.1
lock '3.6.1'

set :application, '0liva'
set :repo_url, 'git@bitbucket.org:alphav/oliva.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/app/0liva'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}
append :linked_dirs, 'public/pf', 'tmp/pids'

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 2

namespace :monit do 
  desc "Task description"
  task :stop do
    on roles(:app) do
      sudo 'monit unmonitor rake-oliva'
      sudo 'monit stop thin-oliva'
      sudo '/app/oliva/current/rake_oliva.sh stop'
    end
  end

  desc "Task description"
  task :start do
    on roles(:app) do
      sudo 'monit monitor rake-oliva'
      sudo 'monit monitor thin-oliva'
      sudo 'monit start rake-oliva'
      sudo 'monit start thin-oliva'
    end    
  end
end

namespace :deploy do
  before :deploy, "monit:stop"
  after :deploy, "monit:start"
end