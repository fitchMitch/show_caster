require 'rails_helper'
# require 'vcr'
RSpec.describe 'GoogleCalendarService', type: :service do
  let!(:user) { create(:user, :registered, :admin) }

  describe '#existing_event?' do
    let(:id) { double('id') }
    let(:calendar) { double('calendar') }
    let!(:company_calendar_id) { double('company_calendar_id') }
    before :each do
      mock_valid_auth_hash(user)
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
      allow_any_instance_of(
        GoogleCalendarService
      ).to receive(:company_calendar_id) { company_calendar_id }
      # allow_any_instance_of(
      #   GoogleCalendarService
      # ).to receive(:initialize) { calendar }
      allow(calendar).to receive(:get_event).with(
        company_calendar_id, id
      ) { response }
    end
    context 'when service is up,' do
      let!(:response) { double('response', id: id) }
      before do
      end
      it 'existing_event should have the same id' do
        skip 'for a short time'
        # VCR.use_cassette('whatever cassette name you want') do
          expect(GoogleCalendarService.new(user).existing_event?(id)).to be true
        # end
      end
    end


    context 'when service is down,' do
      let(:response) { double('response', id: "nil") }
      before do
        allow(calendar).to receive(:get_event).with(
          company_calendar_id, id
        ) { response }
      end
      it 'existing_event should  not find the same id' do
        skip 'for a short time'
        expect(gs.existing_event(id)).to be false
      end
    end
  end
end
