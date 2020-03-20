#!/bin/bash
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

# # Remove a potentially pre-existing server.pid for Rails.
# rm -f /myapp/tmp/pids/server.pid

# # Then exec the container's main process (what's set as CMD in the Dockerfile).
# exec "$@"

# Compile the assets
bundle exec rake assets:precompile
bundle exec rails s -b 0.0.0.0
