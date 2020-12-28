require 'rails_helper'
# require 'vcr' TODO

RSpec.describe 'Courses', type: :request do
  let!(:user_attribute) { create(:user) }
  let!(:theater) { create(:theater) }
  let!(:valid_attributes) do
    {
      duration: 20,
      title: 'Cabaret !',
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
  let!(:admin) { create(:user) }

  context '/ As logged as admin,' do
    before :each do
      request_log_in(admin)
    end

    describe '#new' do
      it 'should get new page' do
        get '/courses/new'
        expect(response).to render_template(:new)
      end
    end

    describe 'GET #index' do
      it 'renders courses index' do
        Event.create! valid_attributes
        get '/courses'
        expect(response).to render_template(:index)
      end
    end

    describe 'GET #index with empty collection' do
      it 'renders courses index' do
        get '/courses'
        expect(response).to render_template(:index)
      end
    end

    describe 'POST #create' do
      context 'with form' do

        context 'valid conditions' do
          # it 'creates a new Event', :vcr do
          it 'creates a new Event' do
            expect {
              post '/courses', params: { course: valid_attributes }
            }.to change(Event, :count).by(1)
            expect(flash[:notice]).to include(
              I18n.t('performances.created')
            )
          end
          it 'creates every attribute' do
            post '/courses', params: { course: valid_attributes }
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
        context 'valid conditions test for notification planning' do
          it { expect(NotificationService).to receive(:course_creation)  }
          after do
            post '/courses', params:{ course: valid_attributes}
          end
        end
        context 'invalid params' do
          it 'fails building a new Event' do
            expect do
              post '/courses', params: { course: invalid_attributes }
            end.to change(Event, :count).by(0)
          end
        end
      end
    end

    describe 'PUT #update' do
      let!(:other_theater){ create(:other_theater) }
      let(:new_attributes_theater) { { theater_id: other_theater.id } }
      let(:invalid_attributes) { { duration: "a string" } }
      let!(:course) { create(:course) }
      let(:url) { "/courses/#{course.to_param}" }
      let(:google_service) { double('google_service') }
      let(:result) { double('result', id: '0123145874521') }
      describe 'with valid parameters' do
      end
      describe 'with invalid parameters' do
        before(:each) do
          put url,
              params: {
                id: course.id,
                course: invalid_attributes
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
                id: course.id,
                course: invalid_attributes
              }
          attr_matcher(Event.last, course.attributes.slice(:theater_id))
        end
      end
    end
    describe '#destroy' do
      let!(:course) { create(:course) }
      let!(:url) { "/courses/#{course.to_param}" }
      let(:google_service) { double('google_service') }
      let(:result) { 123456789 }
      # let(:valid_session) { request_log_in( admin ) }
      context 'with every condition ok' do
        after do
          delete url, params: {
            id: course.id,
            course: valid_attributes
          }
        end
        it 'sends a Notification by mail' do
          expect(NotificationService).to receive(:destroy_all_notifications).once
        end
      end

      context 'with valid local ActiveRecord service' do
        context 'with valid Google service' do
          it 'destroys the course' do
            expect {
              delete url, params: {
                id: course.id,
                course: valid_attributes
              }
            }.to change(Event, :count).by(-1)
          end
          it 'redirects to the course list' do
            delete url, params: {
              id: course.id,
              course: valid_attributes
            }
            expect(response).to redirect_to courses_path
          end
          it 'flashes a notice' do
            delete url, params: {
              id: course.id,
              course: valid_attributes
            }
            expect(flash[:notice]).to eq(I18n.t('performances.destroyed'))
          end
        end
      end

    end
  end

  it 'expect a date for next course' do
    expect(CoursesController.new.next_course_day.class.name).to eq('Date')
  end
end
