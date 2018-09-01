require 'rails_helper'

RSpec.describe "Polls", type: :request do
  let(:valid_attributes) { { question: "A la belle Etoile ?", expiration_date: Date.today } }
  let!(:admin) { create(:user, :admin, :registered) }

  context "/ As logged as admin," do
    before do
      request_log_in(admin)
    end

    describe "GET #index" do
      it "renders polls index" do
        poll = Poll.create! valid_attributes
        get '/polls'
        expect(response).to render_template (:index)
      end
    end
  end
end
