class PollMailer < ApplicationMailer
  include LoggingHelper
  def poll_creation_mail(poll)
    @initiater = poll.owner.firstname
    @url = get_poll_url
    @url_login = url_login
    @final_call = poll.expiration_date
    mail(
      to: User.company_mails.join(','),
      subject: I18n.t('polls.mails.new_poll.subject', firstname: @initiater)
    )
  end

  def poll_reminder_mail(poll)
    @initiater = poll.owner.firstname
    @url = get_poll_url
    @url_login = url_login
    @final_call = poll.expiration_date
    recipients = poll.missing_voter_ids.map do |uid|
      User.find(uid).prefered_email
    end
    warn_logging('Strange Reminder !')
    warn_logging(recipients.join(','))
    mail(
      to: recipients.join(','),
      subject: I18n.t('polls.mails.reminder.subject')
    ) unless recipients.empty?
  rescue StandardError => e
    Bugsnag.notify(e)
    warn_logging('poll_reminder_mail failure') { puts e }
  end

  private

  def get_poll_url
    "http://#{get_site}/polls"
  end
end
