module Requests
  module Loging
    def trace
      Rails.logger.info("----------request.env------------")
      Rails.logger.info(request.env)
      Rails.logger.info("= = = = request.headers = = = ")
      Rails.logger.info(request.headers)
      Rails.logger.info("---------------------------------")
    end
  end
end
