require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  context 'with VALID credentials' do
    before :each do
      get :destroy
    end
    # ----------------------------------------
    describe 'GET #index' do
      # it 'returns http success, even not logged' do
      #   get :index
      #   # expect(response).to have_http_status(204)
      #   expect(response).to redirect_to(root_path)
      # end
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
      it 'it sets the last login time to less than 6 secs ago' do
        time_diff = Time.zone.now.to_i - @user.last_sign_in_at.to_i
        expect(time_diff).to be < 6
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
end
