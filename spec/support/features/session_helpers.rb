module Features
  module SessionHelpers
    def log_in(user, valid= true, strategy= :google_oauth2)
      OmniAuth.config.test_mode = true
      valid ?  mock_valid_auth_hash(user) : mock_invalid_auth_hash
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[strategy.to_sym]
      visit "/auth/#{strategy.to_s}"
      # visit "/users/auth/#{strategy.to_s}/callback?code=strange_sent_code"
    end

    def logout
      visit 'sign_out'
    end
  end
end
