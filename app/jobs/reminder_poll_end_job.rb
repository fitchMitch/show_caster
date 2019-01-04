class ReminderPollEndJob < ApplicationJob
  include LoggingHelper
  queue_as :mailers

  def perform(poll_id)
    ReminderPollEndJob.debug_logging('before NotificationService')
    NotificationService.poll_end_reminder_mailing(poll_id)
    ReminderPollEndJob.debug_logging('after NotificationService')
  rescue StandardError => e
    Bugsnag.notify(e)
    ReminderPollEndJob.error_logging(e)
  end
end
