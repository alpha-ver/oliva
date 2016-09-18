#!/bin/bash
export PATH=$PATH:/usr/local/lib/ruby/2.3.0/rubygems

case $1 in
    start)
      cd /app/oliva/current;
      unbuffer bundle exec /app/oliva/current/bin/rake loop_m RAILS_ENV=production >> /app/oliva/current/log/rake_oliva.log &
      ;;
    stop)
      kill `cat /app/oliva/current/tmp/pids/loop_m.pid`
      while ps -p `cat /app/oliva/current/tmp/pids/loop_m.pid` > /dev/null; do sleep 1; done
      rm -rf /app/oliva/current/tmp/pids/loop_m.pid
      echo 'End pid!'
      ;;
    *)
      echo "usage: oliva_worker {start|stop}" ;;
esac
exit 0