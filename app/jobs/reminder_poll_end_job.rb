class ReminderPollEndJob < ApplicationJob
  queue_as :mailers

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    Rails.logger.error 'found an exception with a RecordNotFound'
  end

  def perform(poll_id)
    poll = Poll.find_by(id: poll_id)
    return nil if invalid_poll?(poll)

    Rails.logger.debug('NotificationService.poll_end_reminder_mailing')
    NotificationFilter.poll_end_reminder_mailing(poll_id)
  end

  private

  def invalid_poll?(poll)
    poll.nil?
  end
end
