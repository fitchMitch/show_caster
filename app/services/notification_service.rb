require 'sidekiq/api'

class NotificationService
  include LoggingHelper
  @@too_short_notice_days = 2.days

  def self.poll_creation(poll)
    PollMailer.poll_creation_mail(poll).deliver_now

    poll_end_delay, reminder_delay = NotificationService.get_delays(poll)
    return nil if self.short_notice(reminder_delay)

    NotificationService.set_future_mail_notifications(poll)
  end

  def self.poll_notifications_update(poll)
    poll_changes = NotificationService.analyse_poll_changes(poll)
    # Poll changes should be noticed to adminstrators and owner only
    # TODO with analyse_poll_changes
    # identify which changes there were and which one are important
    NotificationService.destroy_all_notifications(poll)
    return nil if poll_changes.fetch("expiration_date", nil).nil?

    NotificationService.set_future_mail_notifications(poll)
  end

  def self.set_future_mail_notifications(poll)
    poll_end_delay, reminder_delay = NotificationService.get_delays(poll)
    # for some player to remember they should answer poll's question
    ReminderMailJob.set(wait: reminder_delay.seconds).perform_later(poll.id)
    # for some poll's owner to remember they should announce the end of the poll
    ReminderPollEndJob.set(wait: poll_end_delay.seconds).perform_later(poll.id)
  end
  # ========= Jobs are now set =====================


  # ========= Jobs launch the following services =====================
  def self.destroy_all_notifications(poll)
    scheduled_jobs = Sidekiq::ScheduledSet.new
    scheduled_jobs.each do |job|
      unless job['args'].empty?
        job.delete if job['args'].first['arguments'] == [poll.id]
      end
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
  end

  def self.poll_reminder_mailing(poll_id)
    poll = Poll.find(poll_id)
    return nil if poll.nil? || poll.missing_voters_ids.empty?

    PollMailer.poll_reminder_mail(poll)
  rescue StandardError => e
    Bugsnag.notify(e)
    error_logging('poll_reminder_mailing failure') { puts e }
  end

  def self.poll_end_reminder_mailing(poll_id)
    poll = Poll.find(poll_id)
    return nil if poll.nil?

    PollMailer.poll_end_reminder_mail(poll)
  rescue StandardError => e
    Bugsnag.notify(e)
    error_logging('poll_end_reminder_mailing failure') { puts e }
  end

  # ============ These are just helpers =======================
  def self.too_short_notice_days
    @@too_short_notice_days
  end

  def self.short_notice(delay)
    delay < NotificationService.too_short_notice_days.to_i
  end

  def self.analyse_poll_changes(poll)
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
    answer_changes = []
    poll.answers.each { |answer| answer_changes << answer.previous_changes }
    poll.previous_changes.merge('answer_changes' => answer_changes)
  end

  def self.get_delays(poll)
    poll_end_delay = poll.expiration_date - Time.zone.now
    day_gap = Poll.days_threshold_for_first_mail_alert.days
    reminder_delay = poll_end_delay - day_gap.to_i

    [poll_end_delay, reminder_delay]
  end
end
