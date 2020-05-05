class CourseMailer < ApplicationMailer
  def course_reminder_mail(course)
    recipient = course.courseable

    if recipient.try(:email)
      mail(
        to: recipient.email,
        subject: I18n.t('courses.mails.reminder.subject'),
        template_path: 'course_mailer',
        template_name: 'course_reminder_mail'
      )
    else
      Rails.logger.warn(
        'Impossible de notifier ce coach sans son adresse email'
      )
    end
  end
end
