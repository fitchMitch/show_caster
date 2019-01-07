class ReminderPollEndJob < ApplicationJob
  include LoggingHelper
  queue_as :mailers

  def perform(poll_id)
    poll = Poll.find_by(id: poll_id)
    if poll.nil?
      return nil
    end

    PollMailer.poll_end_reminder_mail(poll).deliver_now
  rescue StandardError => e
    Bugsnag.notify(e)
    Rails.logger.error("poll_end_reminder_mailing failure: #{e}")
    # NotificationService.error_logging("poll_end_reminder_mailing failure: #{e}")
    raise e
  end
end
