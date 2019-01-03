class ReminderPollEndJob < ApplicationJob
  extend LoggingHelper
  queue_as :mailers

  def perform(poll_id)
    debug_logging('before NotificationService')
    NotificationService.poll_end_reminder_mailing(poll_id)
    debug_logging('after NotificationService') { puts Time.zone.now.to_s }
  rescue StandardError => e
    Bugsnag.notify(e)
    error_logging('Message ReminderPollEndJob mail') { puts e }
  end
end
