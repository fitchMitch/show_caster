require 'rails_helper'

RSpec.describe 'PollDates', type: :request do
  let!(:valid_attributes) do
    { type: 'PollDate',
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
    before do
      request_log_in(admin)
    end

    describe 'DELETE #destroy' do
      let!(:poll) { create(:poll_date) }
      let(:url) { "/poll_dates/#{poll.to_param}" }

      it 'deletes Poll' do
        expect {
          delete url, params: { id: poll.id, poll: poll.attributes }
        }.to change(Poll, :count).by(-1)
      end

      it 'redirects to the polls page' do
        delete url, params: { id: poll.id, poll: poll.attributes }
        expect(response).to redirect_to(polls_path)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Poll' do
          expect {
            post '/poll_dates', params: { poll_date: valid_attributes }
          }.to change(Poll, :count).by(1)
        end

        it 'assigns a newly created poll as @pol' do
          post '/poll_dates', params: { poll_date: valid_attributes }
          expect(PollDate.last.question).to eq(valid_attributes[:question])
        end

        it 'redirects to the created poll' do
          post '/poll_dates', params: { poll_date: valid_attributes }
          PollDate.find_by(question: valid_attributes[:question])
          expect(response).to redirect_to polls_path
        end
      end

      context 'with invalid params' do
        it "re-renders the 'new' template" do
          post '/poll_dates', params: {
            poll_date: invalid_attributes_question_only
          }
          expect(response).to render_template :new
        end

        it 'doesn\'t persist poll' do
          expect {
            post '/poll_dates', params: {
              poll_date: invalid_attributes_question_only
            }
          }.to change(Poll, :count).by(0)
        end
      end
    end
  end

  describe 'PUT #update' do
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
      let!(:poll) { create(:poll_date) }

      it 'updates the requested poll_question with a new poll_question' do
        url = "/poll_dates/#{poll.to_param}"
        put url, params: {
          id: poll.id,
          poll_date: new_attributes_poll_question
        }
        poll.reload
        expect(poll).to have_attributes(
          question: new_attributes_poll_question[:question]
        )
      end

      it 'updates the requested poll' do
        url = "/poll_dates/#{poll.to_param}"
        put url, params: { id: poll.id, poll_date: new_attributes }
        poll.reload
        expect(poll).to have_attributes(question: new_attributes[:question])
        expect(poll).to have_attributes(
          expiration_date: new_attributes[:expiration_date]
        )
      end

      it 'redirects to the users page' do
        url = "/poll_dates/#{poll.to_param}"
        put url, params: { id: poll.id, poll_date: new_attributes }
        expect(response).to redirect_to polls_path
      end
    end

    context 'with invalid params' do
      before :each do
        admin = create(:user, :admin, :registered)
        request_log_in(admin)
      end
      let(:poll) { create(:poll_date) }

      it 'assigns the poll as @poll' do
        url = "/poll_dates/#{poll.to_param}"
        put url, params:{ id: poll.id, poll_date: invalid_attributes }
        poll.reload
        expect(poll.question).not_to eq(invalid_attributes[:question])
      end

      it "re-renders the 'edit' template" do
        url = "/poll_dates/#{poll.to_param}"
        put url, params: { id: poll.id, poll_date: invalid_attributes }
        expect(response).to render_template :edit
      end
    end
  end
end
