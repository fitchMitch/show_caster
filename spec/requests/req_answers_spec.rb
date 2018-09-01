require 'rails_helper'

RSpec.describe 'Answers', type: :request do
  let!(:poll_opinion) { create(:poll_opinion) }
  let!(:poll_date) { create(:poll_date) }
  let!(:valid_attributes) do
    { answer_label: 'A la belle Etoile',
      date_answer: Date.today,
      poll_id: poll_opinion.id }
  end
  let!(:invalid_attributes) { { answer_label: nil, date_answer: nil, poll_id: nil } }
  let!(:admin) { create(:user, :admin, :registered) }

  context 'As logged as admin,' do
    before do
      request_log_in(admin)
    end

    describe 'DELETE #destroy' do
      let!(:answer) { create(:answer) }
      let(:url) { "/answers/#{ answer.to_param }" }

      it 'deletes Answer' do
        expect do
          delete url, params: { id: answer.id, answer: answer.attributes }
        end.to change(Answer, :count).by(-1)
      end

      it 'redirects to the answers page' do
        delete url, params: { id: answer.id, answer: answer.attributes }
        expect(response).to redirect_to(answers_path)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Answer' do
          expect do
            post '/answers', params: { answer: valid_attributes }
          end.to change(Answer, :count).by(1)
        end

        it 'assigns a newly created answer as @pol' do
          post '/answers', params: { answer: valid_attributes }
          expect(Answer.last.answer_label).to eq(valid_attributes[:answer_label])
        end

        it 'redirects to the created answer' do
          post '/answers', params: { answer: valid_attributes }
          # t = Answer.find_by(answer: valid_attributes[:answer_label])
          expect(response).to redirect_to answers_path
        end
      end

      context 'with invalid params' do
        it "re-renders the 'new' template" do
          skip("for this never happens due to nested forms")
          post '/answers', params: { answer: invalid_attributes }
          expect(response).to render_template :new
        end

        it "doesn't persist answer" do
          expect do
            post '/answers', params: { answer: invalid_attributes }
          end.to change(Answer, :count).by(0)
        end
      end
    end

    describe 'PUT #update' do
      let(:new_attributes) {
        {
          answer_label: "Sous les ponts, wesh !",
          date_answer: Date.today.weeks_since(2)
        }
      }
      let!(:answer_date) { create(:answer_date) }
      let!(:answer_opinion) { create(:answer_opinion) }


      context 'with valid params' do
        it 'updates the requested answer (opinion)' do
          url = "/answers/#{ answer_opinion.to_param }"
          put url, params: {
            id: answer_opinion.id,
            answer_label: new_attributes[:answer_label],
            date_answer: nil
          }
          answer_opinion.reload
          expect(answer_opinion).to have_attributes(answer_label: new_attributes[:answer_label])
        end

        it 'updates the requested answer (date)' do
          url = "/answers/#{ answer_date.to_param }"
          put url, params: {
            id: answer_date.id,
            date_answer: new_attributes[:date_answer],
            answer_label: nil
          }
          answer_date.reload
          expect(answer_date).to have_attributes(date_answer: new_attributes[:date_answer])
        end
      end

      context 'with invalid params' do
        before :each do
          admin = create(:user, :admin, :registered)
          request_log_in(admin)
        end
        let(:answer) { create(:answer) }

        it 'assigns the answer as @answer' do
          url = "/answers/#{ answer.to_param }"
          put url, params: { id: answer.id, answer: invalid_attributes }
          answer.reload
          expect(answer.answer_label).not_to eq(invalid_attributes[:answer_label])
        end

        it "re-renders the 'edit' template" do
          skip("for this never happens due to nested forms")
          url = "/answers/#{ answer.to_param }"
          put url, params: { id: answer.id, answer: invalid_attributes }
          expect(response).to render_template :edit
        end
      end
    end
  end
end
