class UserMailer < ApplicationMailer
  def welcome_mail(user)
    # This mails informs the user he's been invited to be a member
    @user = user
    @url = login_url
    mail(
      to: @user.prefered_email,
      subject: I18n.t('users.welcome_mail.subject')
    )
  end

  def send_promotion_mail(user, changes)
    # This mails informs the users of his new role.
    @user = user
    @url  = get_user_s_url(@user)
    @role = changes.fetch(:role, nil)
    @role = @user.role_i18n.downcase.capitalize unless @role.nil?

    @committee_plus = to_sentence(changes.fetch(:gained_committees, nil))
    @committee_minus = to_sentence(changes.fetch(:lost_committees, nil))

    mail(to: @user.prefered_email, subject: I18n.t('users.promote_mail.subject'))
  end

  private

  def get_user_s_url(user)
    "http://#{get_site}/users/#{user.id}"
  end

  def to_sentence(list)
    list.map!(&:capitalize) unless list.nil?
    list.nil? || list.empty? ? nil : list.join(', ')
  end

  def login_url
    "http://#{get_site}/sesame_login"
  end
end
