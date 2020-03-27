#!/bin/bash
set -e

# chown -R $USER:$USER .

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi


# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

# Compile the assets
# bundle exec rake assets:precompile
# bundle exec rails s -b 0.0.0.0
# bundle exec rails db:setup
