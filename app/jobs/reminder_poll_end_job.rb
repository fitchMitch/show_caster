class ReminderPollEndJob < ApplicationJob
  include LoggingHelper
  queue_as :mailers

  def perform(poll_id)
    NotificationService.poll_end_reminder_mailing(poll_id)
  rescue StandardError => e
    Bugsnag.notify(e)
    error_logging('Message ReminderPollEndJob mail') { puts e }
  end
end
