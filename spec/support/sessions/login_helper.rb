module Sessions
  module LoginHelper
    def request_for_google(user, valid= true)
      request.env['omniauth.auth'] = {
        'info' =>  {
          'name' =>  user.full_name,
          'email' =>  user.email,
          'first_name' =>  user.firstname,
          'last_name' =>  user.lastname,
          'image' => 'https://lh6.googleusercontent.com/-rjQ1xttjdEM/AAAAAAAAAAI/AAAAAAAACAM/7XxFDEm3Vyg/photo.jpg',
          'urls' => {
            'google' => 'https://plus.google.com/105205260860062499768'
          }
        },
        'credentials' =>  {
          'token' => 'ya29.GlukBbAsVH4LTKRytn0EKgsR8omN_nwO22DM56nS9skMrXbV9ZaI8SkPfIbdpwex4trWyPBZJr1W0I8V2D0IqLMDGzZiOKwRMYM68kyIpTFpbJx4ISGsLsAJxa1W',
          'refresh_token' => '1/52gjoGWkNN4ae5fP_i4-P9ZsrjXosy_zBmpjWOGhzBQ',
          'expires_at' => 1624340628,
          'expires' => true
        }
      }
      if valid == true
        request.env['omniauth.auth']['provider'] = 'google_oauth2'
        request.env['omniauth.auth']['uid'] = user.uid
      end
      request.env['omniauth.auth'].with_indifferent_access
    end

    def log_in(user)
      request.env['omniauth.auth'] = request_for_google(user)
      get :create, params: { provider: 'google_oauth2' }
    end

    def wrong_log_in(user)
      request.env['omniauth.auth'] = request_for_google(user, false)
      get :create, params: { provider: 'google_oauth2' }
    end

    def log_in_admin
      admin = FactoryBot.build(:user, :admin, :registered)
      log_in(admin)
      admin
    end
  end
end
