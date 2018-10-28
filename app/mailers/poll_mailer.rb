class PollMailer < ApplicationMailer
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

  private

  def get_poll_url
    "http://#{get_site}/polls"
  end
end
