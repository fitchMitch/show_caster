class ReminderPollEndJob < ApplicationJob
  include LoggingHelper
  queue_as :mailers

  def perform(poll_id)
    # ReminderPollEndJob.debug_logging('before NotificationService')
    #NotificationService.poll_end_reminder_mailing(poll_id)
    # ReminderPollEndJob.debug_logging('after NotificationService')
    poll = Poll.find(poll_id)
    if poll.nil?
      Rails.logger.warn("This poll cannot be sent since it no longer exists")
      return nil
    end

    PollMailer.poll_end_reminder_mail(poll).deliver_later
  rescue StandardError => e
    Bugsnag.notify(e)
    Rails.logger.error("poll_end_reminder_mailing failure: #{e}")
    # NotificationService.error_logging("poll_end_reminder_mailing failure: #{e}")
    raise e
  end
end
