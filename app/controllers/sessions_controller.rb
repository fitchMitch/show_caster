class SessionsController < ApplicationController
  before_filter :get_current_user, :only => [:index]

  def index
  end

  def new
  end

  def create
    @user = User.from_omniauth(auth_hash)
    if @user.is_a? String
      redirect_to unknown_user_path,  warning: I18n.t('users.omniauth.unknown')
    elsif @user.nil?
      redirect_to root_url, alert: I18n.t('users.omniauth.failure', kind: 'Google')
    else
      @current_user = @user
      session['current_user_id'] = @current_user.id
      # sign_in_and_redirect @user, event: :authentication and return
      redirect_to root_url, notice: I18n.t('users.omniauth.success', kind: 'Google')
    end
  end

  def unknown
    render 'unknown'
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end

  def oauth_failure
    # TODO: Render something appropriate here
    render text:"failed..."
  end

  protected

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
