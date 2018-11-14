require 'rails_helper'

RSpec.describe 'PollOpinions', type: :request do
  let!(:valid_attributes) do
    { type: 'PollOpinion',
      question: 'A la belle Etoile ?',
      expiration_date: Time.zone.parse('2019-08-06 14:15:00 +0200')
    }
  end
  let!(:invalid_attributes) { { type: 'PollOpinion', question: nil, expiration_date: nil } }
  let!(:invalid_attributes_question_only) { { type:'PollOpinion', question: nil, expiration_date: Date.today } }
  let!(:admin) { create(:user, :admin, :registered) }

  context '/ As logged as admin,' do
    before do
      request_log_in(admin)
    end
    describe '#new' do
      it 'should make a new poll_opinion' do
        get '/poll_opinions/new'
        expect(response).to render_template(:new)
      end
    end

    describe '#destroy' do
      let!(:poll) { create(:poll_opinion) }
      let(:url) { "/poll_opinions/#{poll.to_param }" }
      it 'deletes Poll' do
        expect {
          delete url, params:{ id: poll.id, poll: poll.attributes }
        }.to change(Poll, :count).by(-1)
      end
      it 'redirects to the polls page' do
        delete url, params:{ id: poll.id, poll: poll.attributes }
        expect(response).to redirect_to(polls_path)
      end
    end

    describe '#create' do
      context 'with valid params' do
        it 'creates a new Poll' do
          expect {
            post '/poll_opinions', params: { poll_opinion: valid_attributes }
          }.to change(Poll, :count).by(1)
        end

        it 'assigns a newly created poll as @pol' do
          post '/poll_opinions', params: { poll_opinion: valid_attributes }
          expect(PollOpinion.last.question).to eq(valid_attributes[:question])
        end

        it 'redirects to the created poll' do
          post '/poll_opinions', params: { poll_opinion: valid_attributes }
          PollOpinion.find_by(question: valid_attributes[:question])
          expect(response).to redirect_to polls_path
        end
      end

      context 'with invalid params' do
        it "re-renders the 'new' template" do
          post '/poll_opinions', params: {
            poll_opinion: invalid_attributes_question_only
          }
          expect(response).to render_template :new
        end

        it 'doesn\'t persist poll' do
          expect do
            post '/poll_opinions', params: {
              poll_opinion: invalid_attributes_question_only
            }
          end.to change(Poll, :count).by(0)
        end
      end
    end

    describe '#update' do
      context 'with valid params' do
        before :each do
          request_log_in(admin)
        end
        let(:new_attributes_poll_question) do
          {
            question: 'Sous les ponts ?',
            expiration_date: Date.today.weeks_since(2)
          }
        end
        let(:new_attributes) do
          {
            question: 'Sous les toits ?',
            expiration_date: Date.today.weeks_since(2)
          }
        end
        let!(:poll) { create(:poll_opinion) }

        it 'updates the requested poll_question with a new poll_question' do
          url = "/poll_opinions/#{poll.to_param}"
          put url, params: {
            id: poll.id,
            poll_opinion: new_attributes_poll_question
          }
          poll.reload
          expect(poll).to have_attributes(
            question: new_attributes_poll_question[:question]
          )
        end

        it 'updates the requested poll' do
          url = "/poll_opinions/#{poll.to_param}"
          put url, params: { id: poll.id, poll_opinion: new_attributes }
          poll.reload
          expect(poll).to have_attributes(question: new_attributes[:question])
          expect(poll.expiration_date.to_date.to_s).to eq(
            new_attributes[:expiration_date].to_s
          )
        end

        it 'redirects to the users page' do
          url = "/poll_opinions/#{poll.to_param}"
          put url, params: { id: poll.id, poll_opinion: new_attributes }
          expect(response).to redirect_to polls_path
        end
      end

      context 'with invalid params' do
        before :each do
          admin = create(:user, :admin, :registered)
          request_log_in(admin)
        end
        let(:poll) { create(:poll_opinion) }

        it 'assigns the poll as @poll' do
          url = "/poll_opinions/#{poll.to_param}"
          put url, params:{ id: poll.id, poll_opinion: invalid_attributes }
          poll.reload
          expect(poll.question).not_to eq(invalid_attributes[:question])
        end

        it "re-renders the 'edit' template" do
          url = "/poll_opinions/#{poll.to_param}"
          put url, params:{ id: poll.id, poll_opinion: invalid_attributes }
          expect(response).to render_template :edit
        end
      end
    end
  end
end
