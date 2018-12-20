Sidekiq.configure_server do |config|
  # config.redis = { db: 1 } # works localy
  config.redis = {
    url: "redis://#{ENV['SITE']}:6379/0",
    password: ENV['REDIS_PWD']
  }
end

Sidekiq.configure_client do |config|
  # config.redis = { db: 1 } # works localy
  config.redis = {
    url: "redis://#{ENV['SITE']}:6379/0",
    password: ENV['REDIS_PWD']
  }
  #localy REDIS has no password but redis is set with norequiredpassword option
end
