class SessionsController < ApplicationController
  skip_before_action :require_login
  before_action :get_current_user, :only => [:index]

  def index
  end

  def new
  end

  def create
    @user = User.from_omniauth(auth_hash)
    if @user.is_a? String
      redirect_to unknown_user_path,  alert: I18n.t('sessions.omniauth.unknown')
    elsif @user.nil? || @user.archived?
      redirect_to root_url, alert: I18n.t('sessions.omniauth.failure', kind: 'Google')
    else
      @current_user = @user
      session['current_user_id'] = @current_user.id
      redirect_to destination(@user), notice: I18n.t('sessions.omniauth.success', kind: 'Google')
    end
  end


  def destroy
    reset_session
    redirect_to root_url, :notice => I18n.t("sessions.signed_out")
  end

  def oauth_failure
    render text: I18n.t("sessions.omniauth.failure", kind: 'Google')
  end

  protected

  def destination(user)
    user.registered? ? users_path : edit_user_path(user)
  end

  def auth_hash
    raise "Missing parameters" if request.nil?
    raise "Missing parameters" if request.env.nil?
    raise "OmniAuth error. Parameters not defined." if request.env['omniauth.auth'].nil?
    request.env['omniauth.auth']
  end

  private
    def get_current_user
      @current_user ||= current_user
    end

end
