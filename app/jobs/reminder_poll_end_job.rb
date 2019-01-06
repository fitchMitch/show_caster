class ReminderPollEndJob < ApplicationJob
  include LoggingHelper
  queue_as :mailers

  def perform(poll_id)
    # ReminderPollEndJob.debug_logging('before NotificationService')
    Rails.logger.debug(" right before ReminderPollEndJob ")
    # NotificationService.poll_end_reminder_mailing(poll_id)
    poll = Poll.find(poll_id)
    Rails.logger.debug "***** Just before poll's test *****"
    if poll.nil?
      Rails.logger.warn("This poll cannot be sent since it no longer exists")
      return nil
    end
    Rails.logger.debug "***** Just before PollMailer.poll_end_reminder_mail call *****"

    PollMailer.poll_end_reminder_mail(poll).deliver_now
  rescue StandardError => e
    Bugsnag.notify(e)
    Rails.logger.error("poll_end_reminder_mailing failure: #{e}")
    # NotificationService.error_logging("poll_end_reminder_mailing failure: #{e}")
    raise e

    # ReminderPollEndJob.debug_logging('after NotificationService')
  # rescue StandardError => e
  #   Bugsnag.notify(e)
  #   Rails.logger.error("ReminderPollEndJob error with: #{e}")
  #   # ReminderPollEndJob.error_logging(e)
  end
end
