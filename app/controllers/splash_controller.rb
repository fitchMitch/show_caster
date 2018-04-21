class SplashController < ApplicationController
  # skip_before_action :require_login, only: [:new, :create]
  skip_before_action :require_login

  def index
  end

  def signup

    if ENV['MAILCHIMP_SPLASH_SIGNUP_LIST_ID'].blank? or ENV['MAILCHIMP_API_KEY'].blank?
      @message = "The MAILCHIMP_API_KEY and MAILCHIMP_SPLASH_SIGNUP_LIST_ID environment variables need to be set for mailing list signup to work! If you don't want this feature, you can just remove the mailing list signup feature from app/views/splash/index.html.haml"
    else
      begin
        gb = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'], debug: true)
        gb.lists(ENV['MAILCHIMP_SPLASH_SIGNUP_LIST_ID']).members.create(
         body: {
           email_address: params[:signup_email],
           status: "subscribed"
           }
         )
        @message = I18n.t("splash.ok_then")
      rescue StandardError => e
        @error = true
        if try(e.message) == "You must set an api_key prior to making a call"
          @message = I18n.t("splash.enthousiast")
        else
          @message = I18n.t("splash.error")
        end
      end
    end
  end

  private

    def gem_available?(name)
       Gem::Specification.find_by_name(name)
    rescue Gem::LoadError
       false
    rescue
       Gem.available?(name)
    end

end
