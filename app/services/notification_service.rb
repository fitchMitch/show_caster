class NotificationService
  def self.poll_creation(poll)
    PollMailer.poll_creation_mail(poll).deliver_later
    # TODO delay
    delay = 1.minutes
    ReminderMailJob.set(wait: delay).perform_later(poll.id)
  end
end
