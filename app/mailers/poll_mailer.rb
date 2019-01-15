class PollMailer < ApplicationMailer
  def poll_creation_mail(poll)
    @initiater = poll.owner.firstname
    @url = get_polls_url
    @url_login = url_login
    @final_call = poll.expiration_date
    recipients = User.company_mails
    mail(
      to: recipients,
      subject: I18n.t('polls.mails.new_poll.subject', firstname: @initiater)
    )
  end

  def poll_reminder_mail(poll)
    recipients = poll.missing_voters_ids.map do |uid|
      User.find(uid).prefered_email
    end
    @initiater = poll.owner.firstname
    @url = get_polls_url
    @url_login = url_login
    @final_call = poll.expiration_date

    mail(
      to: recipients.join(','),
      subject: I18n.t('polls.mails.reminder.subject')
    )
  rescue StandardError => e
    Bugsnag.notify(e)

    Rails.logger.error("poll_reminder_mail failure: #{e}")
    Rails.logger.error("Recipients: #{recipients.join(',')}")
  end

  def poll_end_reminder_mail(poll)
    @url = get_polls_url
    @url_login = url_login
    @poll = poll
    Rails.logger.debug('------ poll_end_reminder_mail -------')
    Rails.logger.debug("subject: #{I18n.t('polls.mails.reminder.end_subject')}")
    Rails.logger.debug('-----------------------------')
    mail(
      to: poll.owner.prefered_email,
      subject: I18n.t('polls.mails.reminder.end_subject')
    ).deliver_now
  rescue StandardError => e
    Bugsnag.notify(e)
    Rails.logger.error("poll_end_reminder_mail failure: #{e}")
  end

  private

  def get_polls_url
    "http://#{get_site}/polls"
  end
end
