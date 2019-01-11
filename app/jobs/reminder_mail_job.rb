class ReminderMailJob < ApplicationJob
  queue_as :mailers

  def perform(poll_id)
    NotificationFilter.poll_reminder_mailing(poll_id)
  rescue StandardError => e
    Bugsnag.notify(e)
    Rails.logger.error("ReminderMailJob error : #{e}")
  end
end
