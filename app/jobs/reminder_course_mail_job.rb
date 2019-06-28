class ReminderCourseMailJob < ApplicationJob
  queue_as :mailers

  def perform(course_id)
    NotificationFilter.course_reminder_mailing(course_id)
  rescue StandardError => e
    Bugsnag.notify(e)
    Rails.logger.error("ReminderMailJob error : #{e}")
  end

  def error(job, exception)
    Rails.logger.error("Error !  #{exception} on #{job.name}")
  end
end
