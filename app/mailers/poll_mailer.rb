class PollMailer < ApplicationMailer
  include LoggingHelper

  def poll_creation_mail(poll)
    @initiater = poll.owner.firstname
    @url = get_poll_url
    @url_login = url_login
    @final_call = poll.expiration_date
    mail(
      to: User.company_mails,
      subject: I18n.t('polls.mails.new_poll.subject', firstname: @initiater)
    )
  end

  def poll_reminder_mail(poll)
    # recipients shall not be empty
    recipients = poll.missing_voters_ids.map do |uid|
      User.find(uid).prefered_email
    end
    @initiater = poll.owner.firstname
    @url = get_poll_url
    @url_login = url_login
    @final_call = poll.expiration_date
    warn_logging('A Reminder ! to')
    warn_logging(recipients.join(','))
    mail(
      to: recipients.join(','),
      subject: I18n.t('polls.mails.reminder.subject')
    )
  rescue StandardError => e
    Bugsnag.notify(e)
    warn_logging('poll_reminder_mail failure') { puts e }
  end

  private

  def get_poll_url
    "http://#{get_site}/polls"
  end
end
