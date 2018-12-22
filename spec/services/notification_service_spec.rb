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
    context 'when expiration date is far away' do
      let(:poll) { create(:poll, expiration_date: Time.zone.now + 8.days) }
      let(:to_be_performed) { double('to_be_performed') }
      let(:performed_later) { double('performed_later') }
      let(:end_to_be_performed) { double('end_to_be_performed') }
      let(:end_performed_later) { double('end_performed_later') }
      describe 'it first' do
        before do
          allow(ReminderMailJob).to receive(:set) { to_be_performed }
          allow(to_be_performed).to receive(:perform_later) { performed_later }
          allow(ReminderPollEndJob).to receive(:set) { end_to_be_performed }
          allow(end_to_be_performed).to receive(:perform_later) { end_performed_later }
          allow(NotificationService).to receive(:short_notice) { false }
        end
        it 'should should not hit any delay threshold' do
          day_gap = Poll.days_threshold_for_first_mail_alert.days
          delay = poll.expiration_date - Time.zone.now - day_gap.to_i
          expect(delay).to be > 2.days.to_i
        end
        it 'should set a player reminder' do
          expect(ReminderMailJob).to receive(:set) { to_be_performed }
          subject
        end
      end
      describe 'it then' do
        before do
          allow(ReminderMailJob).to receive(:set) { to_be_performed }
          allow(to_be_performed).to receive(:perform_later) { performed_later }
          allow(ReminderPollEndJob).to receive(:set) { end_to_be_performed }
          allow(end_to_be_performed).to receive(:perform_later) { end_performed_later }
          allow(NotificationService).to receive(:short_notice) { false }
        end
        it 'should set an "owner" reminder' do
          expect(subject).to eq end_performed_later
        end
      end
    end
    context 'with short notice' do
      let(:poll) { create(:poll, expiration_date: Time.zone.now + 5.days) }
      before do
        allow(NotificationService).to receive(:short_notice) { true }
      end
      it 'should not return because of too short notice' do
        expect(subject).to be(nil)
      end
    end
  end

  describe '.poll_reminder_mailing' do

    subject(:mailing) { described_class.poll_reminder_mailing(poll_id) }

    context 'when poll no longer exists' do
      let(:poll_id) { 123 }
      before do
        allow(Poll).to receive(:find) { nil }
      end
      it { expect(mailing).to be(nil) }
    end

    context 'when everyone has voted' do
      let!(:poll) { create(:poll_date) }
      let(:poll_id) { poll.id }
      before do
        allow_any_instance_of(PollDate).to receive(:missing_voters_ids) { [] }
      end
      it { expect(mailing).to be(nil) }
    end

    context 'some have not voted this still existing poll' do
      let!(:poll_opinion) { create(:poll_opinion) }
      let!(:poll_id) { poll_opinion.id }
      let(:a_mail) { double('a_mail')}
      before do
        allow(PollMailer).to receive(:poll_reminder_mail).with(poll_opinion) { a_mail }
      end
      it { expect(mailing).to eq a_mail }
    end
  end
end
