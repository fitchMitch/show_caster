# frozen_string_literal: true

# Session Controller
class SessionsController < ApplicationController
  skip_before_action :require_login
  before_action :get_current_user, only: [:index]

  def index; end

  def new
    # keep the following when working offline
    #-------------------------------------------
    # @user = User.find_by(email: "etienne.weil@gmail.com")
    # @current_user = @user
    # session['current_user_id'] = @current_user.id
    # redirect_to destination(@user),
    #   notice: I18n.t('sessions.omniauth.success', kind: 'Google')
  end

  def create
    @user = User.from_omniauth(auth_hash)
    if @user.is_a? String
      Rails.logger.warn('User is not welcome')
      redirect_to unknown_user_path, alert: I18n.t('sessions.omniauth.unknown')
    elsif @user.nil?
      Rails.logger.error('User is not welcome')
      Bugsnag.notify('user is not known ! how come ?')
      redirect_to root_url,
                  alert: I18n.t('sessions.omniauth.failure', kind: 'Google')
    elsif @user.archived?
      Rails.logger.warn('RIP player is trying to connect')
      redirect_to root_url,
                  alert: I18n.t('sessions.omniauth.archived_player')
    else
      @current_user = @user
      session['current_user_id'] = @current_user.id
      Setting.committees ||= ''
      redirect_to destination(@user),
                  notice: I18n.t('sessions.omniauth.success', kind: 'Google')
    end
  end

  def destroy
    reset_session
    redirect_to root_url, notice: I18n.t('sessions.signed_out')
  end

  def oauth_failure
    render text: I18n.t('sessions.omniauth.failure', kind: 'Google')
  end

  protected

  def destination(user)
    if user.registered? && user.has_downloaded_his_picture? && !user.bio.blank?
      about_me_user_path(user)
    elsif user.registered?
      user_path(user)
    else
      edit_user_path(user)
    end
  end

  def auth_hash
    raise 'Missing parameters' if request.nil?
    raise 'Missing parameters' if request.env.nil?
    if request.env['omniauth.auth'].nil?
      raise 'OmniAuth error. Parameters not defined.'
    end

    request.env['omniauth.auth']
  rescue Exception => e
    Rails.logger.warn("Omniauth missing parameter error : #{e}")
    Bugsnag.notify("Omniauth missing parameter error : #{e}")
  end

  private

  def get_current_user
    @current_user ||= current_user
  end
end
