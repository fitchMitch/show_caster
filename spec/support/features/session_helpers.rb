module Features
  module SessionHelpers

    def log_in(user, valid= true, strategy= :google_oauth2)
      OmniAuth.config.test_mode = true
      valid ? mock_valid_auth_hash(user) : mock_invalid_auth_hash
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[strategy.to_sym]
      visit "/auth/#{strategy.to_s}/callback"
    end

    def capy_logout
      visit "/users"
      find(:css, 'i.fa.fa-sign-out.fa-lg').click
    end
  end
  RSpec.configure do |config|
    config.before(:each) do
      body = {
        'client_id'=>ENV['GOOGLE_CLIENT_ID'],
        'client_secret'=>ENV['GOOGLE_CLIENT_SECRETS'],
        'grant_type'=>'refresh_token',
        'refresh_token'=>'1/TSHAZDTWa2ez01-e63fOiBbv6ZUd52qdFzQO5jTN2HE'
      }
      headers = {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type'=>'application/x-www-form-urlencoded',
        'User-Agent'=>'Faraday v0.12.2'
      }
      stub_request(:post, 'https://accounts.google.com/o/oauth2/token')
        .with( body: body, headers: headers)
        .to_return(status: 200, body: 'bad santa', headers: {})
    end
  end
end
