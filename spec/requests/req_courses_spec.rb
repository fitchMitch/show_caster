

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
      theater_id: theater.id,
      provider: 'google'
    }
  end
  let!(:invalid_attributes) do
    {
      duration: 10, # !!!
      note: 'a note',
      event_date: 2.days.from_now,
      user_id: user_attribute.id,
      theater_id: theater.id,
      provider: 'google'
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
        expect(response).to render_template :new
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
        let(:google_service) { double('google_service') }
        let(:result) { double('result', id: '0123145874521') }
        before(:each) do
          allow(GoogleCalendarService).to receive(:new) { google_service }
          allow(google_service).to receive(:add_to_google_calendar) { result }
        end
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
            expect(Event.last.provider).to eq('google_calendar_v3')
            expect(Event.last.fk).to eq(result.id)
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
      context 'with invalid Google API' do
        let(:google_service) { double('google_service') }
        let(:result) { nil }
        before(:each) do
          allow(GoogleCalendarService).to receive(:new) { google_service }
          allow(google_service).to receive(:add_to_google_calendar) { result }
        end
        context 'valid conditions' do
          # it 'creates a new Event', :vcr do
          it 'creates a new Event' do
            expect {
              post '/courses', params: { course: valid_attributes }
            }.to change(Event, :count).by(0)
            expect(flash[:alert]).to eq(
              I18n.t('performances.fail_to_create')
            )
          end
        end
        context 'invalid params' do
          it 'fails building a new Event' do
            expect {
              post '/courses', params: { course: invalid_attributes }
            }.to change(Event, :count).by(0)
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
      context 'with valid Google Service' do
        let(:result) { double('result', id: '0123145874521') }
        describe 'with valid parameters' do
          context 'and exisiting event in Google Calendar' do
            before(:each) do
              allow(GoogleCalendarService).to receive(:new) { google_service }
              allow(google_service).to receive(:update_google_calendar) { result }
              allow(result).to receive(:is_a?) { false }
            end
            it 'redirects to the permances page' do
              put url,
                  params: {
                    id: course.id,
                    course: new_attributes_theater
                  }
              expect(response).to redirect_to courses_path
              expect(flash[:notice]).to eq(
                I18n.t('events.updated_with_Google')
              )
            end
            it 'keeps the number of events the same' do
              expect {
                put url,
                    params: {
                      id: course.id,
                      course: new_attributes_theater
                    }
              }.to change(Event, :count).by(0)
            end
            it 'changes the theater id' do
              put url,
                  params: {
                    id: course.id,
                    course: new_attributes_theater
                  }
              attr_matcher(Event.last, new_attributes_theater.slice(:theater_id))
            end
          end
          context 'and missing event in Google Calendar' do
            before(:each) do
              allow(GoogleCalendarService).to receive(:new) { google_service }
              allow(google_service).to receive(:update_google_calendar) { "a String" }
            put url,
              params: {
                id: course.id,
                course: new_attributes_theater
              }
            end
            it 'redirects to the permances page' do
              expect(response).to redirect_to courses_path
            end
            it 'flashes the proper message' do
              expect(flash[:notice]).to eq(I18n.t('events.desynchronized'))
            end
            it 'updates the theater_id' do
              attr_matcher(Event.last, new_attributes_theater.slice(:theater_id))
            end
          end
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
      context 'with invalid Google Service' do
        describe 'with valid parameters' do
          before(:each) do
            allow(GoogleCalendarService).to receive(:new) { google_service }
            allow(google_service).to receive(:update_google_calendar) { nil }
            put url,
                params: {
                  id: course.id,
                  course: valid_attributes
                }
          end
          it 'redirects to courses page' do
            expect(response).to redirect_to courses_path
          end
          it 'give a flashes an alert' do
            expect(flash[:notice]).to eq(I18n.t('events.desynchronized'))
          end
          it 'changes the theater id' do
            attr_matcher(Event.last, valid_attributes.slice(:theater_id))
          end
        end
      end
    end
    describe '#destroy' do
      let!(:course) { create(:course) }
      let!(:url) { "/courses/#{course.to_param}" }
      let(:google_service) { double('google_service') }
      let(:result) { 123456789 }
      # let(:valid_session) { request_log_in( admin ) }
      context 'with valid local ActiveRecord service' do
        context 'with valid Google service' do
          before(:each) do
            allow(GoogleCalendarService).to receive(:new) { google_service }
            allow(google_service).to receive(:delete_google_calendar){ result }
          end
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
        context 'with INvalid Google service' do
          before(:each) do
            allow(GoogleCalendarService).to receive(:new) { google_service }
            allow(google_service).to receive(:delete_google_calendar) { nil }
          end
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
            expect(flash[:notice]).to eq(I18n.t('performances.google_locked'))
          end
        end
      end

      context 'with INvalid local ActiveRecord service' do
        context 'with valid Google service' do
          before(:each) do
            allow_any_instance_of(Course).to receive(:destroy) { false }
            allow(GoogleCalendarService).to receive(:new) { google_service }
            allow(google_service).to receive(:delete_google_calendar) { result }
          end
          it 'doesn\'t destroy the course' do
            expect {
              delete url, params: {
                id: course.id,
                course: valid_attributes
              }
            }.to change(Event, :count).by(0)
          end
          it 'redirects to the course itme' do
            delete url, params: {
              id: course.id,
              course: valid_attributes
            }
            expect(response).to redirect_to course_path(course)
          end
          it 'flashes a notice' do
            delete url, params: {
              id: course.id,
              course: valid_attributes
            }
            expect(flash[:alert]).to eq(
              I18n.t('performances.fail_to_destroyed')
            )
          end
        end
      end
    end
  end
end
