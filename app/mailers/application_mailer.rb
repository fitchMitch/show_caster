class ApplicationMailer < ActionMailer::Base
  default from: "#{I18n.t('company_name_long')} <no-reply@les-sesames.fr>"
  layout 'mailer'

  def get_site
    Rails.application.config.action_mailer.default_url_options[:site]
  end

  def url_login
    "#{get_site}/sesame_login"
  end
end
