redis: redis-server
worker: bundle exec sidekiq --environment development test -q mailers -c 3 -C config/sidekiq.yml  -L log/sidekiq.log
web: bundle exec rails s -p 3000
