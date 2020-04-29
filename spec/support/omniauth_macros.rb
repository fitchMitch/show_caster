# frozen_string_literal: true

module OmniauthMacros
  def mock_valid_auth_hash(user = nil)
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.test_mode = true
    opts = {
      'provider' => 'google_oauth2',
      'uid' => user.uid,
      # "uid"=>"105205260860062499768",
      'info' => {
        'name' => user.full_name,
        'email' => user.email,
        'first_name' => user.firstname,
        'last_name' => user.lastname.upcase,
        'image' => 'https://lh6.googleusercontent.com/-rjQ1xttjdEM/AAAAAAAAAAI/AAAAAAAACAM/7XxFDEm3Vyg/photo.jpg',
        'urls' => { 'Google' => 'https://plus.google.com/105205260860062499768' }
      },
      'credentials' => {
        'token' => 'ya29.GlvfBdlv1aKyb5hTqTgPsI1AZDDamW3RlRZ2eggisR7pYnQKd45aqRiRIqkjCSmwIDdQ6qDr0qks7LS2Kbj2cX2lH-nA3_6YIlNB4mJQ5gxDvMof9bOfcXa9JO9H',
        'refresh_token' => '1/TSHAZDTWa2ez01-e63fOiBbv6ZUd52qdFzQO5jTN2HE',
        'expires_at' => 1_727_567_394,
        'expires' => true,
        'secret' => 'secret'
      }
    }
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(opts)
  end

  def mock_invalid_auth_hash
    # OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
    OmniAuth.config.mock_auth[:google_oauth2] = {}
  end
end
