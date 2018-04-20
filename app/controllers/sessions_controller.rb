class SessionsController < ApplicationController
  def index
  end

  def new
  end

  def create
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if !@user.nil? && @user.persisted?
      self.current_user = @user
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      # sign_in_and_redirect @user, event: :authentication and return
      redirect_to root_url
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
      @user.nil? ? redirect_to(root_url) : redirect_to(root_url, alert: @user.errors.full_messages.join("\n"))
    end
  end

  def destroy
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end
