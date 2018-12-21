require 'rails_helper'
# require 'vcr'
RSpec.describe GoogleCalendarService, type: :service do
  let!(:user) { create(:user, :registered, :admin) }
  let(:id) { double('id') }
  # let(:calendar) { double('calendar') }
  let(:client_service) { double(Google::APIClient::ClientSecrets) }
  let(:google_api_calendar_service) { double(Google::Apis::CalendarV3::CalendarService) }
  let(:signet_object) { double(Signet::OAuth2::Client) }
  let!(:company_calendar_id) { double('company_calendar_id') }

  describe '#existing_event?' do
    subject { GoogleCalendarService.new(user) }
    before :each do
      mock_valid_auth_hash(user)
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
      allow_any_instance_of(
        GoogleCalendarService
      ).to receive(:company_calendar_id) { company_calendar_id }

      allow(Google::APIClient::ClientSecrets).to receive(:new).and_return(client_service)
      allow(
        Google::Apis::CalendarV3::CalendarService
      ).to receive(:new).and_return(google_api_calendar_service)
      allow(client_service).to receive(:to_authorization) { signet_object }
      allow(google_api_calendar_service).to receive(:authorization=)
      allow(google_api_calendar_service).to receive(:authorization) { signet_object }
      allow(signet_object).to receive(:refresh!)
      allow(google_api_calendar_service).to receive(:get_event) { response }
    end
    after do
      GoogleCalendarService.new(user)
    end
    context 'when service is up,' do
      let!(:response) { double('response', id: id) }
      it { expect(Google::APIClient::ClientSecrets).to receive(:new) }
      it { expect(Google::Apis::CalendarV3::CalendarService).to receive(:new) }
      it { expect(client_service).to receive(:to_authorization) }
      it { expect(google_api_calendar_service).to receive(:authorization=) }
      it { expect(google_api_calendar_service).to receive(:authorization) }
      it { expect(signet_object).to receive(:refresh!) }
      # it { expect(GoogleCalendarService.new(user)).to eq(google_api_calendar_service) }
      it 'existing_event should have the same id' do
        expect(GoogleCalendarService.new(user).existing_event?(id)).to be true
      end
    end

    context 'when service is down,' do
      let(:response) { double('response', id: "nil") }
      it 'existing_event should  not find the same id' do
        expect(GoogleCalendarService.new(user).existing_event?(id)).to be false
      end
    end
  end
end
