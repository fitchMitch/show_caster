# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_bugsnag_notify :add_user_info_to_bugsnag
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :require_login

  helper_method :current_user
  helper_method :logout
  helper_method :user_signed_in?

  private

  def current_user
    if session[:current_user_id]
      @current_user ||= User.find(session[:current_user_id])
    end
  rescue Exception => e
    Rails.logger.error(e)
    Bugsnag.notify(e)
  end

  def user_signed_in?
    current_user.present?
  end

  def logout
    reset_session
    @current_user = nil
    redirect_to root_url, notice: I18n.t('sessions.signed_out')
  end

  def require_login
    unless user_signed_in?
      redirect_to root_path, alert: I18n.t('users.not_logged_in')
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

  def add_user_info_to_bugsnag(report)
    report.add_tab(
      :user_info, name: "#{current_user.full_name} (id: #{current_user.id})"
    )
  end
end
