# WebMock.disable_net_connect!(
#   allow_localhost: true,
#   allow: "chromedriver.storage.googleapis.com"
# )
# With activesupport gem
driver_urls = Webdrivers::Common.subclasses.map do |driver|
  byebug
  Addressable::URI.parse(driver.base_url).host
end

# Without activesupport gem
# driver_urls = (ObjectSpace.each_object(Webdrivers::Common.singleton_class).to_a - [Webdrivers::Common]).map(&:base_url)

# VCR.configure { |config| config.ignore_hosts(*driver_urls) }
WebMock.disable_net_connect!(allow_localhost: true, allow: driver_urls.first)
