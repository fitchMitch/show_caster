class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :user_signed_in?

  private

    def current_user
      begin
        @current_user ||= User.find(session[:current_user_id]) if session[:current_user_id]
      rescue Exception => e
        nil
      end
    end

    def user_signed_in?
      !current_user.nil?
    end
end
