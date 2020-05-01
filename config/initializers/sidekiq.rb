sidekiq_config = { url: "redis://#{ENV['REDIS_SITE']}" }

Sidekiq.configure_server do |config|
  # config.redis = { db: 1 } # works localy
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  # config.redis = { db: 1 } # works localy
  config.redis = sidekiq_config
  # localy REDIS has no password but redis is set with norequiredpassword option
end