require 'rails_helper'

RSpec.describe NotificationFilter, type: :service do
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

    context 'some have not voted for this still existing poll' do
      let!(:poll_opinion) { create(:poll_opinion) }
      let!(:poll_id) { poll_opinion.id }
      let(:a_mail) { double('a_mail') }
      let(:a_delivered_mail) { double('a_delivered_mail') }
      before do
        allow(PollMailer).to receive(
          :poll_reminder_mail
        ).with(poll_opinion) { a_mail }
        allow(a_mail).to receive(:deliver_now) { a_delivered_mail }
      end
      it { expect(mailing).to eq a_delivered_mail }
    end
  end

  describe '.poll_end_reminder_mailing' do
    subject(:mailing) { described_class.poll_end_reminder_mailing(poll_id) }

    context 'when poll no longer exists' do
      let(:poll_id) { 123 }
      before do
        allow(Poll).to receive(:find_by) { nil }
      end
      it { expect(mailing).to be(nil) }
    end

    context 'some have not voted for this still existing poll' do
      let!(:poll_opinion) { create(:poll_opinion) }
      let!(:poll_id) { poll_opinion.id }
      let(:a_mail) { double('a_mail') }
      let(:a_delivered_mail) { double('a_delivered_mail') }
      before do
        allow(PollMailer).to receive(
          :poll_end_reminder_mail
        ).with(poll_opinion) { a_mail }
        allow(a_mail).to receive(:deliver_now) { a_delivered_mail }
      end
      it { expect(mailing).to eq a_delivered_mail }
    end

    # context 'when something goes wrong' do
    #   let(:poll_id) { 123 }
    #   before do
    #     allow(Poll).to receive(:find_by).and_raise(StandardError.new('message'))
    #     allow_any_instance_of(Class).to receive(:raise).and_return(nil)
    #   end
    #   it 'does notify Bugsnag' do
    #     expect(Bugsnag).to receive(:notify)
    #     mailing
    #   end
    # end
  end
end
