require 'rails_helper'

RSpec.describe 'VoteOpinion', type: :request do
  let(:poll_opinion) { create(:poll_opinion_with_answers) }
  let!(:admin) { create(:user, :admin, :registered) }
  let!(:valid_attributes) do
    {
      answer_id: poll_opinion.answers.first.id,
      user_id: admin.id,
      type: 'VoteOpinion',
      vote_label: 'yess'
    }
  end
  let!(:invalid_attributes) do
    {
      answer_id: poll_opinion.answers.first.id,
      user_id: admin.id,
      type: 'VoteOpinion',
      vote_label: 'yes' # invalid
    }
  end
  let(:url) { "/poll_opinions/#{poll_opinion.id}/vote_opinions" }

  context 'As logged as admin,' do
    before do
      request_log_in(admin)
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new VoteOpinion' do
          expect do
            post url, params: { vote_opinion: valid_attributes }
          end.to change(VoteOpinion, :count).by(1)
        end
        it 'assigns a newly created vote_opinion as @poll' do
          post url, params: { vote_opinion: valid_attributes }
          attr_matcher(VoteOpinion.last, valid_attributes)
        end
        it 'redirects to the created vote_opinion' do
          post url, params: { vote_opinion: valid_attributes }
          # t = VoteOpinion.find_by(vote_opinion: valid_attributes[:vote_opinion_label])
          expect(response).to redirect_to polls_path
        end
        it 'flashes a notice' do
          post url, params: { vote_opinion: valid_attributes }
          expect(flash[:notice]).to eq I18n.t('votes.save_success')
        end
      end

    end
  end
end

RSpec.describe 'VoteDate', type: :request do
  let(:poll_date) { create(:poll_date_with_answers) }
  let!(:admin) { create(:user, :admin, :registered) }
  # let(:user) { create(:user, :admin, :registered) }
  let!(:valid_attributes) do
    {
      answer_id: poll_date.answers.first.id,
      poll_id: poll_date.id,
      user_id: admin.id,
      type: 'VoteDate',
      vote_label: 'yess'
    }
  end
  let!(:invalid_attributes) do
    {
      answer_id: poll_date.answers.first.id,
      poll_id: poll_date.id,
      user_id: admin.id,
      type: 'VoteDate',
      vote_label: 'yes' # !!! ss
    }
  end
  let(:url) { "/poll_dates/#{poll_date.id}/vote_dates" }

  context 'As logged as admin,' do
    before do
      request_log_in(admin)
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new VoteDate' do
          expect do
            post url, params: { vote_date: valid_attributes }
          end.to change(VoteDate, :count).by(1)
        end
        it 'assigns a newly created vote_date as @poll' do
          post url, params: { vote_date: valid_attributes }
          attr_matcher(VoteDate.last, valid_attributes)
        end
        it 'redirects to the created vote_date' do
          post url, params: { vote_date: valid_attributes }
          expect(response).to redirect_to poll_date_path(
            valid_attributes[:poll_id]
          )
        end
        it 'flashes a notice' do
          post url, params: { vote_date: valid_attributes }
          expect(flash[:notice]).to eq I18n.t('votes.save_success')
        end
      end

    end
  end
end
