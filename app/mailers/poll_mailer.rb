class PollMailer < ApplicationMailer
  default from: "no-reply@www.les-sesames.fr"

  def poll_creation_mail(poll)
    @initiater = poll.owner.firstname
    @url = get_poll_url
    @final_call = poll.expiration_date
    mail( to: Proc.new { User.company_mails }, subject: I18n.t("polls.mails.new_poll.subject", firstname: @initiater ) )
  end

  private
    def get_poll_url
      "http://#{ get_site }/polls"
    end
end
