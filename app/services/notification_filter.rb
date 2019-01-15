class NotificationFilter < Notification

  def self.poll_reminder_mailing(poll_id)
    poll = Poll.find_by(id: poll_id)
    return nil if poll.nil? || poll.missing_voters_ids.empty?

    PollMailer.poll_reminder_mail(poll).deliver_now
  rescue StandardError => e
    Bugsnag.notify(e)
    Rails.logger.error("poll_reminder_mailing failure: #{e}")
    raise e
  end

  def self.poll_end_reminder_mailing(poll_id)
    poll = Poll.find_by(id: poll_id)
    return nil if poll.nil?

    PollMailer.poll_end_reminder_mail(poll).deliver_now
  rescue StandardError => e
    # Bugsnag.notify(e)
    Rails.logger.error("poll_end_reminder_mailing failure: #{e}")
  end
end
