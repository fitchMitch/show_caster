require 'rails_helper'
# index only !! according to routes
RSpec.describe 'Polls', type: :request do
  let!(:valid_attributes) do
    {
      question: 'A la belle Etoile ?',
      expiration_date: Time.zone.parse('2019-08-06 14:15:00 +0200')
    }
  end
  let!(:admin) { create(:user, :admin, :registered) }

  context '/ As logged as admin,' do
    before do
      sign_in(admin)
    end

    describe 'GET #index' do
      it 'renders polls index' do
        valid_attributes.merge!({type: 'PollDate'})
        Poll.create! valid_attributes
        get '/polls'
        expect(response).to render_template(:index)
      end
    end

    describe '#set_type' do
      subject { PollsController.new }
      context 'with faulty params' do
        before do
          allow_any_instance_of(PollsController).to receive(:params) do
            { type: 'bolo' }
          end
        end
        it 'should return nil to show it\'s faulty' do
          expect(subject.set_type).to be_nil
        end
      end
      context 'with params' do
        before do
          allow_any_instance_of(PollsController).to receive(:params) do
            { type: 'PollDate' }
          end
        end
        it 'should return class camel_case' do
          expect(subject.set_type).to eq('poll_date')
        end
      end
    end

  #   describe 'set_poll' do
  #     subject { PollsController.new }
  #     # bug workaround https://github.com/rspec/rspec-rails/issues/1357
  #     let!(:poll_opinion) { create(:poll_opinion) }
  #     before do
  #       PollOpinion.define_attribute_methods
  #       allow_any_instance_of(PollsController).to receive(:set_type) do
  #         'poll_opinion'
  #       end
  #       allow_any_instance_of(PollsController).to receive(:params) do
  #         { type: 'PollDate', id: 1 }
  #       end
  #       allow_any_instance_of(PollOpinion).to receive(:find) do
  #         poll_opinion
  #       end
  #     end
  #     it 'should return class camel_case' do
  #       expect(subject.send(:set_poll).id).to eq(poll_opinion.id)
  #     end
  #   end
  end
end
