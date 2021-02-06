# frozen_string_literal: true

class SplashController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    front_page_service = FrontPageService.new
    @next_performances = front_page_service.next_performances
    @very_next_performance = @next_performances.first || nil
    @other_performances = @next_performances.drop(1)
    @players_firstnames = []
    unless @very_next_performance.nil?
      @players_firstnames = front_page_service.players_on_stage(
        @very_next_performance
      )
    end
    @photo_list = front_page_service.photo_list(6, 9)
  end

  def signup
    mailchimp = MailchimpService.new
    @message = ''
    if mailchimp.setup_complete?
      @message = mailchimp.subscribe(params[:signup_email])
    else
      @message = 'The MAILCHIMP_API_KEY and MAILCHIMP_SPLASH_SIGNUP_LIST_ID \
                  environment variables need to be set for mailing list \
                  signup to work!'
    end
    @message
  end
end
