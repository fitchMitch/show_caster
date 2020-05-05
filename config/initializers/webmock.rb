# if Rails.env.test?
#   require 'webmock'
#   net = Socket.ip_address_list.detect{ |addr| addr.ipv4_private? }
#   ip = net.nil? ? 'localhost' : net.ip_address
#   socket = "#{ip}:4444/wd/hub"
#   puts "------------------------------------"
#   puts socket + ' from webmock initializer'
#   puts "------------------------------------"
#   allowed_urls = ['127.0.0.1', socket, 'localhost']
#   allowed_urls = [socket]
#   allowed_sites = lambda{ |uri| allowed_urls.include?(uri) }
#   WebMock.disable_net_connect!(allow_localhost: true)
#   # WebMock.disable_net_connect!(allow: allowed_sites)
# end