require 'sidekiq/api'

class NotificationService < Notification
  def self.poll_creation(poll)
    PollMailer.poll_creation_mail(poll).deliver_now
    self.set_poll_notification_mails(poll)
  end

  def self.course_creation(course)
    self.set_course_notification_mail(course)
  end

  def self.poll_notifications_update(poll)
    poll_changes = self.analyse_poll_changes(poll)
    # Poll changes should be noticed to adminstrators and owner only
    # identify which changes there were and which one are important
    self.destroy_all_notifications(poll)
    return nil if poll_changes.fetch("expiration_date", nil).nil?

    self.set_poll_notification_mails(poll)
  end

  def self.destroy_all_notifications(obj)
    scheduled_jobs = Sidekiq::ScheduledSet.new
    scheduled_jobs.each do |job|
      if job.args.present?
        #TODO withdraw following line
        Rails.logger.debug("----------------------------")
        Rails.logger.debug(self.destroy_conditions_ok?(obj, job))
        Rails.logger.debug("----------------------------")
        job.delete if self.destroy_conditions_ok?(obj, job)
      end
    end
  rescue StandardError => e
    Bugsnag.notify(e)
    Rails.logger.warn("destroy_all_notifications failure: #{e}")
  end

  private

  def self.destroy_conditions_ok?(obj, job)
    class_linker = {
      ReminderCourseMailJob: 'Course',
      ReminderMailJob: 'Poll',
      ReminderPollEndJob: 'Poll'
    }.with_indifferent_access
    job_hash = job.args.first
    job_hash['arguments'].first == obj.id &&
      class_linker[job_hash['job_class']] == self.super_klass(obj)
  end

  def self.super_klass(obj)
    obj.model_name
       .name
       .underscore
       .split('_')
       .first
       .capitalize
  end

  def self.set_poll_notification_mails(poll)
    seconds_till_poll_expiration,
    seconds_before_reminding_poll = self.get_delays(poll)

    # for some player to remember they should answer poll's question
    ReminderMailJob.set(
      wait: seconds_before_reminding_poll.seconds
    ).perform_later(poll.id) if seconds_before_reminding_poll > 0
    #for some poll's owner to remember they should announce the end of the poll

    ReminderPollEndJob.set(
      wait: seconds_till_poll_expiration.seconds
    ).perform_later(poll.id) if seconds_till_poll_expiration > 0
  end

  def self.set_course_notification_mail(course)
    seconds_till_course_start,
    seconds_before_course_reminder= self.get_delays(course)
    ReminderCourseMailJob.set(
      wait: seconds_before_course_reminder.seconds
    ).perform_later(course.id) if seconds_before_course_reminder > 0
  end

  def self.analyse_poll_changes(poll)
    answer_changes = []
    poll.answers.each { |answer| answer_changes << answer.previous_changes }
    poll.previous_changes.merge('answer_changes' => answer_changes)
  end

  # def self.get_delays(poll)
  #   seconds_till_poll_expiration = poll.expiration_date - Time.zone.now
  #   day_gap = Poll.days_threshold_for_first_mail_alert.days
  #   seconds_before_reminding_poll = seconds_till_poll_expiration - day_gap.to_i
  #
  #   [seconds_till_poll_expiration, seconds_before_reminding_poll]
  # end

  def self.get_delays(obj)
    trigger_in_secs = self.seconds_till_poll_expiration obj
    day_gap = obj.class.days_threshold_for_first_mail_alert.days
    seconds_before_reminding = trigger_in_secs - day_gap.to_i

    [trigger_in_secs, seconds_before_reminding]
  end

  def self.seconds_till_poll_expiration(obj)
    poll_like = %w[Poll PollOpinion PollDate PollSecretBallot]
    model_name = obj.model_name.name
    date = nil
    if poll_like.include?(model_name)
      date = obj.expiration_date
    elsif (model_name == 'Course')
      date = obj.event_date
    else
      date = obj.event_date
    end
    date - Time.zone.now
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
