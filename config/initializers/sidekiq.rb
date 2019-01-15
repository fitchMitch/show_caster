Sidekiq.configure_server do |config|
  # config.redis = { db: 1 } # works localy
  config.redis = { url: "redis://#{ENV['REDIS_SITE']}" }
end

Sidekiq.configure_client do |config|
  # config.redis = { db: 1 } # works localy
  config.redis = { url: "redis://#{ENV['REDIS_SITE']}" }
  #localy REDIS has no password but redis is set with norequiredpassword option
end
# Sidekiq.configure_server do |config|
#   # config.redis = { db: 1 } # works localy
#   config.redis = {
#     url: "redis://#{ENV['REDIS_SITE']}",
#     password: ENV['REDIS_PWD']
#   }
# end
#
# Sidekiq.configure_client do |config|
#   # config.redis = { db: 1 } # works localy
#   config.redis = {
#     url: "redis://#{ENV['REDIS_SITE']}",
#     password: ENV['REDIS_PWD']
#   }
#   #localy REDIS has no password but redis is set with norequiredpassword option
# end
