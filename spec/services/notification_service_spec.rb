require 'rails_helper'
RSpec.describe NotificationService, type: :service do
  describe '.poll_creation,' do
    let(:poll_to_deliver) { double('poll_to_deliver')}
    let(:delivered) { double('delivered') }
    subject { described_class.poll_creation(poll) }
    before :each do
      allow(PollMailer).to receive(:poll_creation_mail) { poll_to_deliver }
      allow(poll_to_deliver).to receive(:deliver_now) { delivered }
    end
    context 'when long time before established' do
      let(:poll) { create(:poll, expiration_date: Time.zone.now + 8.days) }
      let(:to_be_performed) { double('to_be_performed') }
      let(:performed_later) { double('performed_later') }
      before do
        allow(ReminderMailJob).to receive(:set) { to_be_performed }
        allow(to_be_performed).to receive(:perform_later) { performed_later }
        allow(poll).to receive(:missing_voters_ids) { [1, 2] }
      end
      it 'should return because of too short notice' do
        day_gap = Poll.days_threshold_for_first_mail_alert.days
        delay = poll.expiration_date - Time.zone.now - day_gap.to_i
        expect(delay).to be > 2.days.to_i
        expect(subject).to eq performed_later
      end
    end
    context 'with short notice' do
      let(:poll) { create(:poll, expiration_date: Time.zone.now + 5.days) }
      before do
        allow(poll).to receive(:missing_voters_ids) { [1, 2] }
      end
      it 'should not return because of too short notice' do
        expect(subject).to be(nil)
      end
    end
    context 'with nobody to remind to' do
      let(:poll) { create(:poll, expiration_date: Time.zone.now + 8.days) }
      let(:to_be_performed) { double('to_be_performed') }
      let(:performed_later) { double('performed_later') }
      before do
        allow(ReminderMailJob).to receive(:set) { to_be_performed }
        allow(to_be_performed).to receive(:perform_later) { performed_later }
        allow(poll).to receive(:missing_voters_ids) { [] }
      end
      it 'should not return because of too short notice' do
        expect(subject).to be(nil)
      end
    end
  end
end
