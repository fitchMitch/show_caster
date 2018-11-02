require 'rails_helper'
# index only !! according to routes
RSpec.describe 'Polls', type: :request do
  let(:valid_attributes) do
    {
      question: 'A la belle Etoile ?',
      expiration_date: Time.zone.parse('2019-08-06 14:15:00 +0200')
    }
  end
  let!(:admin) { create(:user, :admin, :registered) }

  context '/ As logged as admin,' do
    before do
      request_log_in(admin)
    end

    describe 'GET #index' do
      it 'renders polls index' do
        Poll.create! valid_attributes
        get '/polls'
        expect(response).to render_template(:index)
      end
    end
  end
end
