class NotificationService < Notification
  def self.poll_creation(poll)
    PollMailer.poll_creation_mail(poll).deliver_now
    self.set_future_mail_notifications(poll)
  end

  def self.poll_notifications_update(poll)
    # Poll changes should be noticed to adminstrators and owner only
    # identify which changes there were and which one are important
    poll_changes = self.analyse_poll_changes(poll)
    return nil if poll_changes.fetch('expiration_date', nil).nil?

    self.destroy_all_notifications(poll)
    self.set_future_mail_notifications(poll)
  end

  def self.destroy_all_notifications(poll)
    Delayed::Job.all.each do |job|
      job.destroy if job_corresponds_to_poll?(job, poll)
    end
  rescue StandardError => e
    Bugsnag.notify(e)
    Rails.logger.warn("destroy_all_notifications failure: #{e}")
  end

  private

  def self.set_future_mail_notifications(poll)
    # Both notifications will be set unless short notice
    seconds_till_poll_expiration,
    seconds_before_reminding_poll = self.get_delays(poll)

    ReminderPollEndJob.delay(
      run_at: seconds_till_poll_expiration.seconds.from_now,
      queue: 'mailers'
    ).perform_later(poll.id)

    # for some player to remember they should answer poll's question
    unless Notification.short_notice?(seconds_before_reminding_poll)
      ReminderMailJob.delay(
        run_at: seconds_before_reminding_poll.seconds.from_now,
        queue: 'mailers'
      ).perform_later(poll.id)
    end
  end
  # ========= Jobs are now set =====================

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

def job_corresponds_to_poll?(job, poll)
  job.payload_object.args.first == poll.id
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
