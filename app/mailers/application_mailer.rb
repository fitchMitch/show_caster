class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@www.les-sesames.fr'
  layout 'mailer'

  def get_site
    Rails.application.config.action_mailer.default_url_options[:host]
  end
end
