class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@les-sesames.fr'
  layout 'mailer'

  def get_site
    Rails.application.config.action_mailer.default_url_options[:host]
  end

  def url_login
    "#{get_site}/sesame_login"
  end
end
