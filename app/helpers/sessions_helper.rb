module SessionsHelper
  def log_out
    session.delete(:current_user_id)
    @current_user = nil
    redirect_to root_url, notice: t('sessions.signed_out')
  end
end
