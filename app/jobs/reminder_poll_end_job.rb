class ReminderPollEndJob < ApplicationJob
  queue_as :mailers

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    Rails.logger.error 'found an exception with a RecordNotFound'
  end

  def perform(poll_id)
    poll = Poll.find_by(id: poll_id)
    return nil if is_invalid_poll?(poll)

    Rails.logger.debug('NotificationService.poll_end_reminder_mailing')
    NotificationFilter.poll_end_reminder_mailing(poll_id)
  rescue StandardError => e
    # Bugsnag.notify(e)
    Rails.logger.error("ReminderPollEnd JOB is raising a error: #{e}")
  end

  def error(job, exception)
    Rails.logger.error("Error !  #{exception} on #{job.name}")
  end

  private

  def is_invalid_poll?(poll)
    poll.nil?
  end
end
