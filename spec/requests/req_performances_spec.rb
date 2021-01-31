

require 'rails_helper'
# require 'vcr' TODO

RSpec.describe 'Performances', type: :request do
  let!(:user_attribute) { create(:user) }
  let!(:theater) { create(:theater) }
  let!(:valid_attributes) do
    {
      duration: 20,
      title: 'a title',
      note: 'a note',
      event_date: 2.days.from_now,
      user_id: user_attribute.id,
      theater_id: theater.id
    }
  end
  let!(:invalid_attributes) do
    {
      duration: 10, # !!!
      note: 'a note',
      event_date: 2.days.from_now,
      user_id: user_attribute.id,
      theater_id: theater.id
    }
  end
  let(:admin) { create(:user, :admin, :registered) }

  context '/ As logged as admin,' do
    before :each do
      sign_in(admin)
    end

    describe '#new' do
      it 'should get new page' do
        get '/performances/new'
        expect(response).to render_template :new
      end
    end

    describe 'GET #index' do
      it 'renders performances index' do
        Event.create! valid_attributes
        get '/performances'
        expect(response).to render_template(:index)
      end
    end

    describe 'GET #index with empty collection' do
      it 'renders performances index' do
        get '/performances'
        expect(response).to render_template(:index)
      end
    end

    describe 'POST #create' do
      context 'with form' do
        let(:google_service) { double('google_service') }
        let(:result) { double('result', id: '0123145874521') }
        context 'valid conditions' do
          # it 'creates a new Event', :vcr do
          it 'creates a new Event' do
            expect {
              post '/performances', params: { performance: valid_attributes }
            }.to change(Event, :count).by(1)
            expect(flash[:notice]).to include(
              I18n.t('performances.created')
            )
          end
          it 'creates every attribute' do
            post '/performances', params: { performance: valid_attributes }
            attr_matcher(
              Event.last,
              valid_attributes.slice(
                :note,
                :theater_id,
                :duration
              )
            )
            expect(Event.last.user_id).to eq(admin.id)
          end
        end
        context 'invalid params' do
          it 'fails building a new Event' do
            expect do
              post '/performances', params: { performance: invalid_attributes }
            end.to change(Event, :count).by(0)
          end
        end
      end
    end

    describe 'PUT #update' do
      let!(:other_theater){ create(:other_theater) }
      let(:new_attributes_theater) { { theater_id: other_theater.id } }
      let(:invalid_attributes) { { duration: "a string" } }
      let!(:performance) { create(:performance) }
      let(:url) { "/performances/#{performance.to_param}" }
      describe 'with valid parameters' do
        it 'redirects to the performances page' do
          put url,
              params: {
                id: performance.id,
                performance: new_attributes_theater
              }
          expect(response).to redirect_to performances_path
          expect(flash[:notice]).to eq(
            I18n.t('events.updated')
          )
        end
        it 'keeps the number of events the same' do
          expect {
            put url,
                params: {
                  id: performance.id,
                  performance: new_attributes_theater
                }
          }.to change(Event, :count).by(0)
        end
        it 'changes the theater id' do
          put url,
              params: {
                id: performance.id,
                performance: new_attributes_theater
              }
          attr_matcher(Event.last, new_attributes_theater.slice(:theater_id))
        end
      end
      describe 'with invalid parameters' do
        before(:each) do
          put url,
              params: {
                id: performance.id,
                performance: invalid_attributes
              }
        end
        it 'render the edit page again' do
          expect(response).to render_template :edit
        end
        it 'give a flashes an alert' do
          expect(flash[:alert]).to eq(I18n.t('events.update_failed'))
        end
        it 'changes the theater id' do
          put url,
              params: {
                id: performance.id,
                performance: invalid_attributes
              }
          attr_matcher(Event.last, performance.attributes.slice(:theater_id))
        end
      end
    end
    describe '#destroy' do
      let!(:performance) { create(:performance) }
      let!(:url) { "/performances/#{performance.to_param}" }
      # let(:valid_session) { sign_in( admin ) }
      context 'with valid local ActiveRecord service' do
        it 'destroys the performance' do
          expect {
            delete url, params: {
              id: performance.id,
              performance: valid_attributes
            }
          }.to change(Event, :count).by(-1)
        end
        it 'redirects to the performance list' do
          delete url, params: {
            id: performance.id,
            performance: valid_attributes
          }
          expect(response).to redirect_to performances_path
        end
        it 'flashes a notice' do
          delete url, params: {
            id: performance.id,
            performance: valid_attributes
          }
          expect(flash[:notice]).to eq(I18n.t('performances.destroyed'))
        end
      end

      context 'with INvalid local ActiveRecord service' do
        before(:each) do
          allow_any_instance_of(Performance).to receive(:destroy) { false }
        end
        it 'doesn\'t destroy the performance' do
          expect {
            delete url, params: {
              id: performance.id,
              performance: valid_attributes
            }
          }.to change(Event, :count).by(0)
        end
        it 'redirects to the performance itme' do
          delete url, params: {
            id: performance.id,
            performance: valid_attributes
          }
          expect(response).to redirect_to performance_path(performance)
        end
        it 'flashes a notice' do
          delete url, params: {
            id: performance.id,
            performance: valid_attributes
          }
          expect(flash[:alert]).to eq(
            I18n.t('performances.fail_to_destroyed')
          )
        end
      end
    end
  end
end
