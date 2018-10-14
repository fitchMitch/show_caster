class SplashController < ApplicationController

  skip_before_action :require_login

  def index
    @players_firstnames = []
    @next_performances = Event.performances.future_events.limit(5).includes(:actors)
    @very_next_performance = @next_performances.first || nil

    unless @very_next_performance.nil?
      @next_players = @very_next_performance.actors.where('stage_role = ?', 0)
      @next_players.each do |player|
        @players_firstnames << player.user.firstname
      end
    end
    @other_performances = @next_performances.drop(1)
  end

  def signup
    env_condition_1 = ENV['MAILCHIMP_SPLASH_SIGNUP_LIST_ID'].blank?
    env_condition_2 = ENV['MAILCHIMP_API_KEY'].blank?
    if env_condition_1 || env_condition_2
      @message = "The MAILCHIMP_API_KEY and MAILCHIMP_SPLASH_SIGNUP_LIST_ID \
      environment variables need to be set for mailing list signup to work! \
      If you don't want this feature, you can just remove the mailing \
      list signup feature from app/views/splash/index.html.haml"
    else
      begin
         MAILCHIMP.lists(ENV['MAILCHIMP_SPLASH_SIGNUP_LIST_ID'])
                  .members.create(
                     body: {
                       email_address: params[:signup_email],
                       status: "subscribed" } )
        @message = I18n.t('splash.ok_then')
      rescue Gibbon::MailChimpError => e
        @error = true
        if e.status_code.to_s[0] == "4" #like 401, 403...)
          @message = I18n.t('splash.enthousiast')
          Rails.logger.info("MailChimp : #{e.title}")
        else
          Rails.logger.warn('---------MailChimpError--------------')
          Rails.logger.warn(e.body)
          Rails.logger.warn(e.status_code)
          Rails.logger.warn('---------MailChimpError end--------------')
          @message = I18n.t('splash.error')
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
