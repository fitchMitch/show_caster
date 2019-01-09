class ReminderPollEndJob < ApplicationJob
  include LoggingHelper
  queue_as :mailers

  def perform(poll_id)
    poll = Poll.find_by(id: poll_id)
    return nil if is_invalid_poll?(poll)

    Rails.logger.debug('NotificationService.poll_end_reminder_mailing')
    NotificationService.poll_end_reminder_mailing(poll_id)
  rescue StandardError => e
    Bugsnag.notify(e)
    Rails.logger.error("ReminderPollEnd JOB is raising a error: #{e}")
    raise e
  end

  private

  def is_invalid_poll?(poll)
    poll.nil?
  end
end
