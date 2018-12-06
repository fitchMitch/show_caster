require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  context 'with VALID credentials' do
    before :each do
      get :destroy
    end

    # ----------------------------------------
    describe 'GET #create' do
      before :each do
        admin = create(:user,
                       :admin,
                       :setup,
                       email: 'weil.etienne@hotmail.fr',
                       firstname: 'Etienne',
                       lastname: 'WEIL')
        log_in(admin)
        @user = User.last
      end
      it { should set_session }
      it 'returns http success' do
        expect(response).to have_http_status(302)
      end
      it 'it sets the last login time to less than 1 secs ago' do
        time_diff = Time.zone.now.to_i - @user.last_sign_in_at.to_i
        expect(time_diff).to be < 1
      end
      it 'sets the cache for committees settings' do
        expect(Setting.committees).not_to be(nil)
      end
    end
    # ----------------------------------------
    describe 'GET #destroy' do
      before :each do
        log_in_admin
        get :destroy
      end
      it 'leads to root_path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end
  # ======================================
  context 'with INVALID credentials' do
    describe 'GET #index' do
      let!(:admin) { create(:user, :admin) }
      let!(:session) { nil }
      before :each do
        wrong_log_in(admin)
        get :destroy
      end
      it 'shall not reach users index page' do
        expect(response).not_to redirect_to users_path
      end
    end
  end

  describe '#destination' do
    context 'user is registered, has a bio and a picture' do
      let!(:picture_user) { create(:picture_user) }
      let!(:user) { build(:user, :registered, id: picture_user.imageable_id) }
      before :each do
        log_in_admin
      end
      it 'landing page : about_me !' do
        expect(
          controller.send(:destination, user)
        ).to eq "/users/#{user.id}/about_me"
      end
    end

    context 'user is registered, has a NO bio and a picture' do
      let(:picture_user) { create(:picture_user) }
      let(:user) do
        build(:user, :registered, bio: nil, id: picture_user.imageable_id)
      end
      before :each do
        log_in_admin
      end
      it 'landing page : user_s page !' do
        expect(controller.send(:destination, user)).to eq "/users/#{user.id}"
      end
    end

    context 'user is NOT registered' do
      let(:picture_user) { create(:picture_user) }
      let(:user) do
        build(:user, :setup, bio: nil, id: picture_user.imageable_id)
      end
      before :each do
        log_in_admin
      end
      it 'landing page : details_about me !' do
        expect(
          controller.send(:destination, user)
        ).to eq "/users/#{user.id}/edit"
      end
    end
  end
end
