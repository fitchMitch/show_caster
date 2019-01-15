require 'sidekiq/api'

class NotificationService < Notification
  def self.poll_creation(poll)
    PollMailer.poll_creation_mail(poll).deliver_now

    # Both notifications will be set unless short notice
    seconds_till_poll_expiration,
    seconds_before_reminding_poll = self.get_delays(poll)
    return nil if Notification.short_notice(seconds_before_reminding_poll)

    self.set_future_mail_notifications(poll)
  end

  def self.poll_notifications_update(poll)
    poll_changes = self.analyse_poll_changes(poll)
    # Poll changes should be noticed to adminstrators and owner only
    # identify which changes there were and which one are important
    self.destroy_all_notifications(poll)
    return nil if poll_changes.fetch("expiration_date", nil).nil?

    self.set_future_mail_notifications(poll)
  end

  def self.destroy_all_notifications(poll)
    scheduled_jobs = Sidekiq::ScheduledSet.new
    scheduled_jobs.each do |job|
      if job['args'].present?
        job.delete if job['args'].first['arguments'] == [poll.id]
      end
    end
  rescue StandardError => e
    # Bugsnag.notify(e)
    Rails.logger.warn("destroy_all_notifications failure: #{e}")
  end

  private

  def self.set_future_mail_notifications(poll)
    seconds_till_poll_expiration,
    seconds_before_reminding_poll = self.get_delays(poll)

    # for some player to remember they should answer poll's question
    ReminderMailJob.set(
      wait: seconds_before_reminding_poll.seconds
    ).perform_later(poll.id) unless seconds_before_reminding_poll < 0
    #for some poll's owner to remember they should announce the end of the poll

    ReminderPollEndJob.set(
      wait: seconds_till_poll_expiration.seconds
    ).perform_later(poll.id) unless seconds_till_poll_expiration < 0
  end

  def self.analyse_poll_changes(poll)
    answer_changes = []
    poll.answers.each { |answer| answer_changes << answer.previous_changes }
    poll.previous_changes.merge('answer_changes' => answer_changes)
  end

  def self.get_delays(poll)
    seconds_till_poll_expiration = poll.expiration_date - Time.zone.now
    day_gap = Poll.days_threshold_for_first_mail_alert.days
    seconds_before_reminding_poll = seconds_till_poll_expiration - day_gap.to_i

    [seconds_till_poll_expiration, seconds_before_reminding_poll]
  end
end
  # Sample
  # {
  #   "expiration_date"=>[
  #     Tue, 01 Jan 2019 00:00:00 CET +01:00,
  #     Wed, 02 Jan 2019 00:00:00 CET +01:00
  #   ],
  #   "question"=>[
  #     "Question deuxxx",
  #     "Question deux"
  #   ],
  #   "answer_changes"=>[
  #     {
  #       "date_answer"=>[
  #         Wed, 26 Dec 2018 19:00:00 CET +01:00,
  #         Wed, 26 Dec 2018 18:00:00 CET +01:00
  #       ],
  #       "updated_at"=>[
  #         Mon, 24 Dec 2018 10:26:40 CET +01:00,
  #         Mon, 24 Dec 2018 10:29:17 CET +01:00
  #       ]
  #     },
  #     {}
  #   ]
  # }
