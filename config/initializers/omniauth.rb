Rails.application.config.middleware.use OmniAuth::Builder do
  extra = {
    access_type: "offline",
    prompt: "consent",
    select_account: true,
    scope: 'userinfo.email, calendar, drive'
  }
  extra[:redirect_uri] = "http://etienneweil.fr:3200/auth/google_oauth2/callback" if Rails.env.production?

  provider :google_oauth2,
    ENV.fetch("GOOGLE_CLIENT_ID"),
    ENV.fetch("GOOGLE_CLIENT_SECRETS"),
    extra
end

OmniAuth.config.on_failure = SessionsController.action(:oauth_failure)

OmniAuth.config.full_host = Rails.env.production? ? 'https://etienneweil.fr:3200' : 'http://localhost:3000'
