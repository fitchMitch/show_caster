module Requests
  module LoginHelper
    def request_log_in(user)
      OmniAuth.config.test_mode = true
      mock_valid_auth_hash(user)
      get '/auth/google_oauth2'
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
      get '/auth/google_oauth2/callback'
    end

    def request_log_in_admin
      admin = create(:user, :admin, :registered)
      request_log_in(admin)
    end
  end
end
