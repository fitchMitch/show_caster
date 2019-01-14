require 'rails_helper'

RSpec.describe NotificationService, type: :service do
  describe '.poll_creation,' do
    let(:poll) { create(:poll, expiration_date: Time.zone.now + 8.days) }
    let(:poll_to_deliver) { double('poll_to_deliver') }
    let(:delivered) { double('delivered') }
    subject { described_class.poll_creation(poll) }

    before :each do
      allow(PollMailer).to receive(:poll_creation_mail) { poll_to_deliver }
      allow(poll_to_deliver).to receive(:deliver_now) { delivered }
    end
    after :each do
      subject
    end
    it { expect(poll_to_deliver).to receive(:deliver_now) }
    it { expect(described_class).to receive(:set_future_mail_notifications) }
  end

  describe '.poll_notifications_update' do
    subject { described_class.poll_notifications_update(poll_date) }
    context 'when expiration_date does not change' do
      let(:poll_date) { build(:poll_date) }
      before do
        allow(NotificationService).to receive(:analyse_poll_changes) { {} }
      end
      it { expect(subject).to be nil }
    end

    context 'when expiration_date does not change' do
      let(:poll_date) { build(:poll_date) }
      let(:job_done) { double('job_done') }
      before do
        allow(NotificationService).to receive(:analyse_poll_changes) do
          {
            'expiration_date' => [
              Time.zone.now + 2.days,
              Time.zone.now + 3.days
            ]
          }
        end
      end
      it 'should destroy old notifications' do
        expect(NotificationService).to receive(:destroy_all_notifications).with(poll_date)
        expect(NotificationService).to receive(
          :set_future_mail_notifications
        ).with(poll_date)
        subject
      end
    end
  end

  describe '.destroy_all_notifications' do
    let!(:poll_id) { 123 }
    let!(:poll) { build(:poll_date, id: poll_id) }
    let(:scheduled_jobs) { [a_scheduled_job] }
    let(:arguments_array) { double('arguments_array', { 'arguments' => [poll_id]  }) }
    let(:a_scheduled_job) { double('a_scheduled_job', { 'args' => [arguments_array] }) }

    context 'everything is ok' do
      before do
        allow(Delayed::Job).to receive(:all) { scheduled_jobs }
        allow_any_instance_of(
          Class
        ).to receive(:job_corresponds_to_poll?) { true }
      end
      it 'should delete the related notifications' do
        expect(a_scheduled_job).to receive(:destroy)
        described_class.destroy_all_notifications(poll)
      end
    end
    context 'when something goes wrong' do
      before do
        allow(Delayed::Job).to receive(
          :all
        ).and_raise(StandardError.new 'message')
      end
      it 'does notify Bugsnag' do
        expect(Bugsnag).to receive(:notify)
        described_class.destroy_all_notifications(poll)
      end
    end
  end

  describe '.set_future_mail_notifications' do
    subject { described_class.set_future_mail_notifications(poll) }
    let!(:poll) { build(:poll_date) }
    let!(:t) { Time.zone.now }

    let(:mailjob) { double('mailjob') }
    let(:mailendjob) { double('mailendjob') }
    let(:ten_seconds) { double('ten_seconds') }
    context 'with an expiration_date set far far away' do
      before :each do
        allow(mailjob).to receive(:perform_later)
        allow(mailendjob).to receive(:perform_later)
        allow(described_class).to receive(:get_delays) { [20, 10] }
        allow(Notification).to receive(:short_notice?) { false }
        allow(10.seconds).to receive(:from_now) { t + 10 }
        allow(20.seconds).to receive(:from_now) { t + 20 }
      end
      it 'sets a reminder for players not to forget to vote' do
        expect(ReminderMailJob).to receive(:delay).with(
          { run_at: a_value_within(0.1).of(10.seconds.from_now), queue: 'mailers' }
        ) { mailjob }
        expect(mailjob).to receive(:perform_later).with(poll.id)
      end
      it 'sets a reminder for the poll owner to' \
        'communicate the result of the poll' do
        expect(ReminderPollEndJob).to receive(:delay).with(
          { run_at: a_value_within(1).of(20.seconds.from_now), queue: 'mailers' }
        ) { mailendjob }
        expect(mailendjob).to receive(:perform_later).with(poll.id)
      end
      after(:each) do
        subject
      end
    end

    context 'with short notice' do
      before :each do
        allow(mailjob).to receive(:perform_later)
        allow(mailendjob).to receive(:perform_later)
        allow(described_class).to receive(:get_delays) { [2, 1] }
        allow(described_class).to receive(:short_notice?) { true }
      end
      it { expect(subject).to be(nil) }
    end
  end

  describe '.analyse_poll_changes' do
    subject { described_class.analyse_poll_changes(poll) }
    context 'with a question change' do
      let(:poll) { build(:poll_date) }
      let(:question_change) do
        {
          'question' => ['Question deuxxx', 'Question deux']
        }
      end
      before do
        allow(poll).to receive(:previous_changes) { question_change }
      end
      it { expect(subject).to eq question_change.merge({ 'answer_changes'=>[] }) }
    end
    context 'with a question change in the answers' do
      let!(:answer_opinion) { create(:answer_opinion) }
      let(:poll) { answer_opinion.poll_opinion }
      let(:answer_change) do
        {
          'answer_label'=>[
            'Answer 1',
            'Answer 1 altered'
          ],
          'updated_at'=>[
            Time.zone.now,
            Time.zone.now
          ]
        }
      end
      let(:result) { { 'answer_changes'=>[answer_change] } }
      before do
        allow(poll).to receive(:previous_changes) { {} }
        allow_any_instance_of(Answer).to receive(:previous_changes) { answer_change }
      end
      it { expect(subject).to eq result }
    end
  end

  describe '.get_delays' do
    subject { described_class.get_delays(poll_date) }
    context 'when expiration_date is set two weeeks away from current date' do
      let(:poll_date) { build(:poll_date, expiration_date: Time.zone.now + 2.weeks) }
      it { expect(subject[0]).to be > 0 }
      it { expect(subject[1]).to be > 0 }
      it { expect(subject[0]).to be > subject[1] }
      it { expect(subject[0]).to be > Poll.days_threshold_for_first_mail_alert.days.to_i }
    end
    context 'when expiration_date is set one day away from current date' do
      let(:poll_date) { build(:poll_date, expiration_date: Time.zone.now + 1.day) }
      it { expect(subject[0]).to be > 0 }
      it { expect(subject[1]).to be < 0 }
      it { expect(subject[0]).to be > subject[1] }
      it { expect(subject[0]).to be < Poll.days_threshold_for_first_mail_alert.days.to_i }
    end
  end

  describe '#job_corresponds_to_poll?' do
    let(:job) { double('a_job') }
    let(:poll) { build(:poll, id: 13) }
    let(:a_payload) { double('a_payload') }
    subject { described_class.send(:job_corresponds_to_poll?, job, poll) }
    context 'when similar' do
      before do
        allow(job).to receive(:payload_object) { a_payload }
        allow(a_payload).to receive(:args) { [13] }
      end
      it { expect(subject).to be(true) }
    end
    context 'when different' do
      before do
        allow(job).to receive(:payload_object) { a_payload }
        allow(a_payload).to receive(:args) { [14] }
      end
      it { expect(subject).to be(false) }
    end
  end
end
