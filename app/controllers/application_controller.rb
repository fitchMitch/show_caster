# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_bugsnag_notify :add_user_info_to_bugsnag
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  private

  def after_sign_in_path_for(user)
    case user.status
    when "invited"
      edit_user_path(user)
    when "missing_phone_nr"
      edit_user_path(user)
    when "registered_with_no_pic"
      user_path(user)
    when "registered"
      user.bio.blank? ? user_path(user) : about_me_user_path(user)
    else
      root_path
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
