require 'rails_helper'

RSpec.describe 'PollDates', type: :request do
  let!(:valid_attributes) do
    {
      type: 'PollDate',
      question: 'A la belle Etoile ?',
      expiration_date: Date.today
    }
  end
  let!(:invalid_attributes) do
    { type: 'PollDate', question: nil, expiration_date: nil }
  end
  let!(:invalid_attributes_question_only) do
    { type: 'PollDate', question: '', expiration_date: Date.today }
  end
  let!(:admin) { create(:user, :admin, :registered) }

  context '/ As logged as admin,' do
    let!(:poll) { create(:poll_date) }
    before do
      sign_in(admin)
    end

    describe 'DELETE #destroy' do
      let(:url) { "/poll_dates/#{poll.to_param}" }

      it 'deletes Poll' do
        expect do
          delete url, params: { id: poll.id, poll: poll.attributes }
        end.to change(Poll, :count).by(-1)
      end

      it 'redirects to the polls page' do
        delete url, params: { id: poll.id, poll: poll.attributes }
        expect(response).to redirect_to(polls_path)
      end
    end
  end
end
