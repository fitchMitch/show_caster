class PollMailer < ApplicationMailer
  include LoggingHelper

  def poll_creation_mail(poll)
    @initiater = poll.owner.firstname
    @url = get_polls_url
    @url_login = url_login
    @final_call = poll.expiration_date
    mail(
      to: User.company_mails,
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
      subject: I18n.t('polls.mails.reminder.subject'),
      template_path: 'poll_mailer',
      template_name: 'poll_reminder_mail'
    )
  rescue StandardError => e
    Bugsnag.notify(e)

    PollMailer.error_logging('poll_reminder_mail failure') do
      puts e
      puts "Recipients: #{recipients.join(',')}"
    end
  end


  def poll_end_reminder_mail(poll)
    @url = get_polls_url
    @url_login = url_login
    @poll = poll
    mail(
      to: poll.owner.prefered_email,
      subject: I18n.t('polls.mails.reminder.end_subject')
    )
  rescue StandardError => e
    Bugsnag.notify(e)
    Rails.logger.error("poll_end_reminder_mail failure: #{e}")
    # PollMailer.error_logging("poll_end_reminder_mail failure: #{e}")
  end

  private

  def get_polls_url
    "http://#{get_site}/polls"
  end
end
