require 'rails_helper'

RSpec.describe SplashController, type: :controller do
  let!(:unset_var_message){ 'environment variables need to be set' }
  after do
    ENV['HTTP_AUTH_USERNAME'] = nil
    ENV['HTTP_AUTH_PASSWORD'] = nil
  end

  it 'should return the index page' do
    get :index
    expect(response).to render_template(:index)
  end

  it 'should not request authentication even if http_auth is set' do
    ENV['HTTP_AUTH_USERNAME'] = 'user'
    ENV['HTTP_AUTH_PASSWORD'] = 'pass'

    get :index
    expect(response).to render_template(:index)

    ENV['HTTP_AUTH_USERNAME'] = nil
    ENV['HTTP_AUTH_PASSWORD'] = nil
  end

  context 'with views' do
    render_views
    it 'should return the index page with the correct google tracking code' do
      ENV['GOOGLE_ANALYTICS_SITE_ID'] = '123456'

      get :index
      expect(response.body).to include("ga('create', '123456'");

      ENV['GOOGLE_ANALYTICS_SITE_ID'] = nil
    end
  end

  context 'mailing list signup' do
    it 'should require mailchimp env to be setup' do
      ENV['MAILCHIMP_SPLASH_SIGNUP_LIST_ID'] = nil
      ENV['MAILCHIMP_API_KEY'] = nil

      post :signup, xhr: true

      expect(assigns(:message)).to include(unset_var_message)
    end

    it 'should talk to mail chimp if the ENV is set' do
      skip "when understanding xhr requests...."
      ENV['MAILCHIMP_SPLASH_SIGNUP_LIST_ID'] = '1'
      ENV['MAILCHIMP_API_KEY'] = '1'
      stub_request(:post, 'https://us17.api.mailchimp.com/3.0/lists/1/members')
         .with(
           body: '{\'email_address\':null,\'status\':\'subscribed\'}',
           headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization'=>'Basic YXBpa2V5OmYwYjI0Yjk1ZTQyOTNjMWVkMDFlMTMxYmMyZTQ5MTIwLXVzMTc=',
            'Content-Type'=>'application/json',
            'User-Agent'=>'Faraday v0.12.2'}
           ).to_return(status: 200, body: '', headers: {})

      post :signup, xhr: true, params: { email: 'wschenk@gmail.com' }
      expect(assigns(:message)).not_to include(unset_var_message)
      ENV['MAILCHIMP_SPLASH_SIGNUP_LIST_ID'] = nil
      ENV['MAILCHIMP_API_KEY'] = nil
    end
  end
end
