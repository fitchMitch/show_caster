class ReminderPollEndJob < ApplicationJob
  include LoggingHelper
  queue_as :mailers

  def perform(poll_id)
    poll = Poll.find_by(id: poll_id)
    return nil if poll.nil?

    Rails.logger.debug("NotificationService.poll_end_reminder_mailing(poll_id)")
    NotificationService.poll_end_reminder_mailing(poll_id)
  rescue StandardError => e
    Bugsnag.notify(e)
    Rails.logger.error("=======================================")
    Rails.logger.error("poll_end_reminder_mailing failure: #{e}")
    Rails.logger.error("=======================================")
    raise e
  end
end
