class SmsSenderJob < ApplicationJob
  include LoggingHelper
  queue_as :default

  def perform(*args)
    info_logging("message start")
    sleep 10
    info_logging("message end")
  end
end
