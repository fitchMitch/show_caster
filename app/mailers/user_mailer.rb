class UserMailer < ApplicationMailer
  default from: "no-reply@www.les-sesames.fr"

  def welcome_mail(user)
    # This mails informs the user he's been invited to be a member
    @user = user
    @url  = get_user_s_url(@user)
    mail(to: @user.email, subject: I18n.t("users.welcome_mail.subject"))
  end

  def promoted_mail(user)
    # This mails informs the users of his role update.
    @user = user
    @url  = get_user_s_url(@user)
    @role = user.role
    mail(to: @user.email, subject: I18n.t("users.promote_mail.subject"))
  end

  private
    def get_user_s_url(user)
      site = Rails.application.config.action_mailer.default_url_options[:host]
      "http://#{site}/users/#{user.id}"
    end
end
