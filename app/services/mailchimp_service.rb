class MailchimpService
  include LoggingHelper

  def setup_complete?
    @message = 'The MAILCHIMP_API_KEY and MAILCHIMP_SPLASH_SIGNUP_LIST_ID \
               environment variables need to be set for mailing list \
               signup to work!'
    complete = !ENV['MAILCHIMP_SPLASH_SIGNUP_LIST_ID'].blank? &&
               !ENV['MAILCHIMP_API_KEY'].blank?
    warn_logging(@message) unless complete
    complete
  end

  def subscribe(email)
    begin
      MAILCHIMP.lists(ENV['MAILCHIMP_SPLASH_SIGNUP_LIST_ID'])
               .members
               .create(
                 body: {
                   email_address: email,
                   status: 'subscribed'
                 }
               )
      @message = I18n.t('splash.ok_then')
    rescue Gibbon::MailChimpError => e
      # When returning glike 401, 403...)
      if e.status_code.to_s[0] == '4'
        @message = I18n.t('splash.enthousiast')
        info_logging(@message) do
          Rails.logger.info("MailChimp : #{e.title}")
        end
      else
        warn_logging("MailChimp : #{e.status_code}") do
          Rails.logger.warn(e.status_code)
        end
        Bugsnag.notify(e)
        @message = I18n.t('splash.error')
      end
      @message
    end
  end
end
