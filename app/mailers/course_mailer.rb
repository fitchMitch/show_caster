class CourseMailer < ApplicationMailer
  def course_reminder_mail(course)
    recipient = course.courseable

    if recipient.try(:email)
      mail(
        to: [recipient.email],
        subject: I18n.t('courses.mails.reminder.subject')
      )
    else
      Rails.logger.warn(
        'Impossible de notifier ce coach sans son adresse email'
      )
    end
  rescue StandardError => e
    Bugsnag.notify(e)

    Rails.logger.error("course_reminder_mail failure: #{e}")
    Rails.logger.error("Recipient: #{recipient}")
    raise e
  end
end
