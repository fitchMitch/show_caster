class UserMailer < ApplicationMailer
  def welcome_mail(user)
    # This mails informs the user he's been invited to be a member
    @user = user
    @url = login_url
    mail(to: @user.email, subject: I18n.t('users.welcome_mail.subject'))
  end

  def promoted_mail(user)
    # This mails informs the users of his role update.
    @user = user
    @url  = get_user_s_url(@user)
    @role = user.role_i18n
    mail(to: @user.email, subject: I18n.t('users.promote_mail.subject'))
  end

  private

  def get_user_s_url(user)
    "http://#{get_site}/users/#{user.id}"
  end

  def login_url
    "http://#{get_site}/sesame_login"
  end
end
