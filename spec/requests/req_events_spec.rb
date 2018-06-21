require 'rails_helper'
# require 'vcr' TODO

RSpec.describe "Events", type: :request do
  let(:valid_attributes) { {
    duration: 20,
    note: "A string",
    event_date: 2.days.from_now,
    user_id: create(:user).id,
    theater_id: create(:theater).id,
    provider: "google",
    progress: "draft"
    } }
  let(:invalid_attributes) { {
    duration: 10, # !!!
    note: "A string",
    event_date: 2.days.from_now,
    user_id: create(:user).id,
    theater_id: create(:theater).id,
    provider: "google",
    progress: "draft"
    } }

  context "/ As logged as admin," do
    let!(:admin) {create(:user)}
    before :each do
      request_log_in(admin)
    end

    describe "GET #index" do
      it "renders events index" do
        event = Event.create! valid_attributes
        get '/events'
        expect(response).to render_template(:index)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "builds a new Event" do
          event = Event.new valid_attributes
          expect(event).to be_valid
        end

        # it "creates a new Event", :vcr do
        it "creates a new Event" do
          expect {
            post '/events', params: {event: valid_attributes}
          }.to change(Event, :count).by(1)
        end
      end

      context "with invalid params" do
        it "fails building a new Event" do
          event = Event.new invalid_attributes
          expect(event).not_to be_valid
        end
      end

      context "posting with valid params" do
        before :each do
          post '/events', params: {event: valid_attributes}
        end
        # it "creates every attribute", :vcr do
        it "creates every attribute"do
          expect(Event.last.note).to eq(valid_attributes[:note])
          expect(Event.last.user.id) == valid_attributes[:user_id]
          expect(Event.last.theater.id) == valid_attributes[:theater_id]
          expect(Event.last.duration) == valid_attributes[:duration]
          expect(Event.last.progress) == 0
        end
      end
      context "posting with invalid params" do
        before :each do
          post '/events', params: {event: invalid_attributes}
        end
        it "creates nothing" do
          expect(Event.count.zero?).to be(true)
        end
      end
    end

    describe "PUT #update" do
      let!(:other_theater){ create(:other_theater)}
      let!(:theater){ create(:theater)}
      let(:new_attributes_theater) {
        {theater_id: other_theater.id}
      }
      let(:new_attributes) {
        { note:"A strange delight",
          duration: 120
        }
      }
      let(:invalid_attributes) { { theater_id: nil } }

      let(:valid_session) { request_log_in( admin ) }
      let!(:event){ create(:event) }

      context "with invalid params" do

        it "updates the requested event with a new theater_id" do
          url = "/events/#{event.to_param}"
          put url , params:{ id: event.id, event:new_attributes_theater }
          event.reload
          expect(event).to have_attributes(
            theater_id: new_attributes_theater[:theater_id]
          )
        end

        it "redirects to the users page" do
          url = "/events/#{event.to_param}"
          put url , params:{ id: event.id, event: new_attributes }
          expect(response).to redirect_to events_path
        end
      end

      context "with invalid params" do
        it "assigns the event as @event" do
          url = "/events/#{event.to_param}"
          put url , params:{ id: event.id, event: invalid_attributes }
          event.reload
          expect(event.theater_id).not_to eq(invalid_attributes[:theater_id])
        end

        it "re-renders the 'edit' template" do
          url = "/events/#{event.to_param}"
          put url, params:{ id: event.id, event: invalid_attributes }
          expect(response).to render_template :edit
        end
      end
    end
    describe "DELETE #destroy" do
      let(:valid_session) { request_log_in( admin ) }
      let!(:event) { create(:event) }
      let(:url) { "/events/#{event.to_param}" }

      # it "deletes Event", :vcr do
      it "deletes Event" do
        expect {
          delete url, params:{ id: event.id, event: event.attributes }
        }.to change(Event, :count).by(-1)
      end

      # it "redirects to the events page", :vcr do
      it "redirects to the events page" do
        delete url , params:{ id: event.id, event: event.attributes }
        expect(response).to redirect_to(events_path)
      end
    end
  end
end
