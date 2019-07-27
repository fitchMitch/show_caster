class CourseMailer < ApplicationMailer

  def course_reminder_mail(course)
    recipient = course.courseable

    mail(
      to: [course.courseable.email],
      subject: I18n.t('courses.mails.reminder.subject')
    )
  rescue StandardError => e
    Bugsnag.notify(e)

    Rails.logger.error("course_reminder_mail failure: #{e}")
    Rails.logger.error("Recipient: #{recipient}")
    raise e
  end

end
