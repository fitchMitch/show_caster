module OmniauthMacros
  def mock_valid_auth_hash(user= nil)
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.test_mode = true
    opts = {
      "provider"=>"google_oauth2",
      "uid"=> user.uid,
      # "uid"=>"105205260860062499768",
      "info"=> {
        "name"=> user.full_name,
        "email"=> user.email,
        "first_name"=> user.firstname,
        "last_name"=> user.lastname.upcase,
        "image"=>"https://lh6.googleusercontent.com/-rjQ1xttjdEM/AAAAAAAAAAI/AAAAAAAACAM/7XxFDEm3Vyg/photo.jpg",
        "urls"=> { "Google"=>"https://plus.google.com/105205260860062499768" }
      },
      "credentials"=> {
        "token"=> "ya29.GlueBeaBWWCExZDU3BzeUopl9dfuoT2NpEqsnC5ePZgi-_yWWiIvreVZo-dPe_EXYi3rPaFzvFxJ3tZSSSDiWzI3l4AwLQ4jOcxd1qg6ivyYL4GHRRAXiXVPhQhl",
        "refresh_token"=>"1/4mAkSPsy0-auHIJgxACaQSYIFxu6J8frVOw_HYcQ_cY",
        "expires_at"=>1532959394,
        "expires"=>true
      }
    }
    OmniAuth.config.mock_auth[:google_oauth2] =  OmniAuth::AuthHash.new(opts)
  end

  def mock_invalid_auth_hash
    # OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
    OmniAuth.config.mock_auth[:google_oauth2] = {}
  end
end
