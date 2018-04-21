class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :require_login

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

    def require_login
      unless user_signed_in?
        redirect_to root_path, alert: I18n.t("users.not_logged_in")
      end
    end

    def pointed_page
      params[:page] ? params[:page].to_i : 1
    end

    def user_not_authorized
      flash[:danger] = I18n.t('pundit.not_authorized')
      if user_signed_in?
        redirect_to(request.referrer || root_path)
      else
        redirect_to root_path
      end
    end
end
