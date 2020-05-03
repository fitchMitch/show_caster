# frozen_string_literal: true

require 'sidekiq/api'

class NotificationService < Notification
  def self.poll_creation(poll)
    PollMailer.poll_creation_mail(poll).deliver_now
    NotificationService.set_poll_notification_mails(poll)
  end

  def self.course_creation(course)
    course_notification_mail(course)
  end

  def self.poll_notifications_update(poll)
    poll_changes = analyse_poll_changes(poll)
    # Poll changes should be noticed to adminstrators and owner only
    # identify which changes there were and which one are important
    destroy_all_notifications(poll)
    return nil if poll_changes.fetch('expiration_date', nil).nil?

    NotificationService.set_poll_notification_mails(poll)
  end

  def self.destroy_all_notifications(obj)
    scheduled_jobs = Sidekiq::ScheduledSet.new
    has_error = false

    scheduled_jobs.each do |job|
      next unless job.args.present?
      job.delete if destroy_conditions_ok?(obj, job)
    end
    has_error
  rescue StandardError => e
    Bugsnag.notify(e)
    Rails.logger.warn("destroy_all_notifications failure: #{e}")
    has_error = true
  end

  def self.get_delays(obj)
    trigger_in_secs = seconds_till_poll_expiration obj
    day_gap = obj.class.days_threshold_for_first_mail_alert.days
    seconds_before_reminding = trigger_in_secs - day_gap.to_i

    [trigger_in_secs, seconds_before_reminding]
  end

  def self.seconds_till_poll_expiration(obj)
    poll_like = %w[Poll PollOpinion PollDate PollSecretBallot]
    model_name = obj.model_name.name
    date = if poll_like.include?(model_name)
             obj.expiration_date
           elsif model_name == 'Course'
             obj.event_date
           else
             obj.event_date
           end
    date - Time.zone.now
  end

  def self.destroy_conditions_ok?(obj, job)
    class_linker = {
      ReminderCourseMailJob: 'Course',
      ReminderMailJob: 'Poll',
      ReminderPollEndJob: 'Poll'
    }.with_indifferent_access
    job_hash = job.args.first
    job_hash['arguments'].first == obj.id &&
      class_linker[job_hash['job_class']] == super_klass(obj)
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
    seconds_before_reminding_poll = get_delays(poll)

    # for some player to remember they should answer poll's question
    if seconds_before_reminding_poll.positive?
      ReminderMailJob.set(
        wait: seconds_before_reminding_poll.seconds
      ).perform_later(poll.id)
    end
    # for some poll's owner to remember they should announce the end of the poll

    if seconds_till_poll_expiration.positive?
      ReminderPollEndJob.set(
        wait: seconds_till_poll_expiration.seconds
      ).perform_later(poll.id)
    end
  end

  def self.course_notification_mail(course)
    _, seconds_before_course_reminder = get_delays(course)
    if seconds_before_course_reminder.positive?
      ReminderCourseMailJob.set(
        wait: seconds_before_course_reminder.seconds
      ).perform_later(course.id)
    end
  end

  def self.analyse_poll_changes(poll)
    answer_changes = []
    poll.answers.each { |answer| answer_changes << answer.previous_changes }
    poll.previous_changes.merge('answer_changes' => answer_changes)
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
