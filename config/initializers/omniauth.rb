Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    ENV.fetch("GOOGLE_CLIENT_ID"),
    ENV.fetch("GOOGLE_CLIENT_SECRETS"),{
      access_type: "offline",
      prompt: "consent",
      select_account: true,
      scope: 'userinfo.email, calendar, drive'
    }
end

OmniAuth.config.on_failure = SessionsController.action(:oauth_failure)

OmniAuth.config.full_host = Rails.env.production? ? 'https://etienneweil.fr:3200' : 'http://localhost:3000'
