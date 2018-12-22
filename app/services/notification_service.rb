class NotificationService
  include LoggingHelper
  @@too_short_notice_days = 2.days

  def self.too_short_notice_days
    @@too_short_notice_days
  end

  def self.poll_creation(poll)
    PollMailer.poll_creation_mail(poll).deliver_now

    day_gap = Poll.days_threshold_for_first_mail_alert.days
    poll_end_delay = poll.expiration_date - Time.zone.now
    reminder_delay = poll_end_delay - day_gap.to_i
    return nil if self.short_notice(reminder_delay)

    ReminderMailJob.set(wait: reminder_delay.seconds).perform_later(poll.id)
    ReminderPollEndJob.set(wait: poll_end_delay.seconds).perform_later(poll.id)
  end

  def self.short_notice(delay)
    delay < NotificationService.too_short_notice_days.to_i
  end
  # ========= Jobs are now set =====================


  # ========= Jobs launch the following services =====================
  def self.poll_reminder_mailing(poll_id)
    poll = Poll.find(poll_id)
    return nil if poll.nil? || poll.missing_voters_ids.empty?

    PollMailer.poll_reminder_mail(poll)
  rescue StandardError => e
    Bugsnag.notify(e)
    warn_logging('poll_reminder_mailing failure') { puts e }
  end

  def self.poll_end_reminder_mailing(poll_id)
    poll = Poll.find(poll_id)
    return nil if poll.nil?

    PollMailer.poll_end_reminder_mail(poll)
  rescue StandardError => e
    Bugsnag.notify(e)
    warn_logging('poll_end_reminder_mailing failure') { puts e }
  end
end
