#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec sidekiq -q mailers -c 3 -C config/sidekiq.yml
# bundle exec sidekiq -q mailers -c 3 -C config/sidekiq.yml  -L log/sidekiq.log