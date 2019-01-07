class ReminderMailJob < ApplicationJob
  include LoggingHelper
  queue_as :mailers

  def perform(poll_id)
    NotificationService.poll_reminder_mailing(poll_id)
  rescue StandardError => e
    Bugsnag.notify(e)
    ReminderMailJob.error_logging(e)
    raise e
  end
end
