class NotificationService
  @@too_short_notice_days = 2.days

  def self.too_short_notice_days
    @@too_short_notice_days
  end

  def self.poll_creation(poll)
    PollMailer.poll_creation_mail(poll).deliver_now

    day_gap = Poll.days_threshold_for_first_mail_alert.days
    delay = poll.expiration_date - Time.zone.now - day_gap.to_i
    return nil if delay < NotificationService.too_short_notice_days.to_i ||
                  poll.missing_voters_ids.empty?

    ReminderMailJob.set(wait: delay.seconds).perform_later(poll.id)
  end
end
