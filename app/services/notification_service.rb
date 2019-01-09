require 'sidekiq/api'

class NotificationService
  include LoggingHelper
  @@too_short_notice_days = 2.days

  def self.poll_creation(poll)
    PollMailer.poll_creation_mail(poll).deliver_now

    # Both notifications will be set unless short notice
    seconds_till_poll_expiration,
    seconds_before_reminding_poll = NotificationService.get_delays(poll)
    return nil if self.short_notice(seconds_before_reminding_poll)

    NotificationService.set_future_mail_notifications(poll)
  end

  def self.poll_notifications_update(poll)
    poll_changes = NotificationService.analyse_poll_changes(poll)
    # Poll changes should be noticed to adminstrators and owner only
    # identify which changes there were and which one are important
    NotificationService.destroy_all_notifications(poll)
    return nil if poll_changes.fetch("expiration_date", nil).nil?

    NotificationService.set_future_mail_notifications(poll)
  end

  def self.set_future_mail_notifications(poll)
    seconds_till_poll_expiration,
    seconds_before_reminding_poll = NotificationService.get_delays(poll)

    # for some player to remember they should answer poll's question
    ReminderMailJob.set(
      wait: seconds_before_reminding_poll.seconds
    ).perform_later(poll.id) unless seconds_before_reminding_poll < 0
    #for some poll's owner to remember they should announce the end of the poll

    ReminderPollEndJob.set(
      wait: seconds_till_poll_expiration.seconds
    ).perform_later(poll.id) unless seconds_till_poll_expiration < 0
  end
  # ========= Jobs are now set =====================


  # ========= Jobs launch the following services =====================

  def self.destroy_all_notifications(poll)
    scheduled_jobs = Sidekiq::ScheduledSet.new
    scheduled_jobs.each do |job|
      if job['args'].present?
        job.delete if job['args'].first['arguments'] == [poll.id]
      end
    end
  rescue StandardError => e
    Bugsnag.notify(e)
    NotificationService.warn_logging("destroy_all_notifications failure: #{e}")
  end

  # @item={
  # "class"=>"ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper",
  # "wrapped"=>"ReminderPollEndJob",
  # "queue"=>"mailers",
  # "args"=>
  #   [
  #     {
  #       "job_class"=>"ReminderPollEndJob",
  #       "job_id"=>"2db0c540-6bf3-49b2-b496-db22733b80bf",
  #       "provider_job_id"=>nil,
  #       "queue_name"=>"mailers",
  #       "priority"=>nil,
  #       "arguments"=>[39],
  #       "locale"=>"fr"
  #     }
  #   ],
  # "retry"=>true,
  # "jid"=>"a9decad10eb3374c7d74276a",
  # "created_at"=>1545506938.8081102}

  def self.poll_reminder_mailing(poll_id)
    poll = Poll.find_by(id: poll_id)
    return nil if poll.nil? || poll.missing_voters_ids.empty?

    PollMailer.poll_reminder_mail(poll).deliver_now
  rescue StandardError => e
    Bugsnag.notify(e)
    NotificationService.error_logging("poll_reminder_mailing failure: #{e}")
    raise e
  end

  def self.poll_end_reminder_mailing(poll_id)
    Rails.logger.debug("=================================")
    Rails.logger.debug("before finding poll")
    Rails.logger.debug("=================================")
    poll = Poll.find_by(id: poll_id)
    return nil if poll.nil?

    Rails.logger.debug poll.question
    Rails.logger.debug '---------deliver_now------------------'
    PollMailer.poll_end_reminder_mail(poll).deliver_now!
    Rails.logger.debug '---------end of deliver_now ------------------'
  rescue StandardError => e
    Bugsnag.notify(e)
    Rails.logger.error("poll_end_reminder_mailing failure: #{e}")
    # NotificationService.error_logging("poll_end_reminder_mailing failure: #{e}")
    raise e
  end

  # ============ These are just helpers =======================
  def self.too_short_notice_days
    @@too_short_notice_days
  end

  def self.short_notice(delay)
    delay < NotificationService.too_short_notice_days.to_i
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
