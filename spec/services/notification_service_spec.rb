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

    context 'when something goes wrong' do
      let(:poll_id) { 123 }
      before do
        allow(Poll).to receive(:find_by).and_raise(StandardError.new('message'))
        allow_any_instance_of(Class).to receive(:raise).and_return(nil)
      end
      it 'does notify Bugsnag' do
        expect(Bugsnag).to receive(:notify)
        mailing
      end
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
        allow(a_mail).to receive(:deliver_now!) { a_delivered_mail }
      end
      it { expect(mailing).to eq a_delivered_mail }
    end

    context 'when something goes wrong' do
      let(:poll_id) { 123 }
      before do
        allow(Poll).to receive(:find_by).and_raise(StandardError.new('message'))
        allow_any_instance_of(Class).to receive(:raise).and_return(nil)
      end
      it 'does notify Bugsnag' do
        expect(Bugsnag).to receive(:notify)
        mailing
      end
    end
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

  describe '.set_future_mail_notifications' do
    subject { described_class.set_future_mail_notifications(poll) }
    let!(:poll) { build(:poll_date) }

    let(:mailjob) { double('mailjob') }
    let(:mailendjob) { double('mailendjob') }
    before :each do
      allow(mailjob).to receive(:perform_later)
      allow(mailendjob).to receive(:perform_later)
      allow(described_class).to receive(:get_delays) { [2, 1] }
    end
    it { expect(ReminderMailJob).to receive(:set).with({ wait: 1 }) { mailjob } }
    it { expect(ReminderPollEndJob).to receive(:set).with({ wait: 2 }) { mailendjob } }
    after :each do
      subject
    end
  end

  describe '.destroy_all_notifications' do
    let!(:poll_id) { 123 }
    let!(:poll) { build(:poll_date, id: poll_id) }
    let(:scheduled_jobs) { [a_scheduled_job] }
    let(:arguments_array) { double('arguments_array', { 'arguments' => [poll_id]  }) }
    let(:a_scheduled_job) { double('a_scheduled_job', { 'args' => [arguments_array] }) }
      # {
      # 'class'=>'ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper',
      # 'wrapped'=>'ReminderPollEndJob',
      # 'queue'=>'mailers',
      # 'args'=> [
      #   {
      #     'job_class'=>'ReminderPollEndJob',
      #     'job_id'=>'2db0c540-6bf3-49b2-b496-db22733b80bf',
      #     'provider_job_id'=>nil,
      #     'queue_name'=>'mailers',
      #     'priority'=>nil,
      #     'arguments'=>[poll.id],
      #     'locale'=>'fr'
      #   }
      # ],
      # 'retry'=>true,
      # 'jid'=>'a9decad10eb3374c7d74276a',
      # 'created_at'=>1545506938.8081102
      # }
    context 'everything is ok' do
      before do
        allow(Sidekiq::ScheduledSet).to receive(:new) { scheduled_jobs }
        allow(a_scheduled_job).to receive(:delete)
        allow(scheduled_jobs.first).to receive(:delete)
      end
      it 'should delete the related notifications' do
        skip 'missing test due  to double not being a correct object'
        expect(a_scheduled_job).to receive(:delete) {}
        described_class.destroy_all_notifications(poll)
      end
    end
    context 'when something goes wrong' do
      before do
        allow(Sidekiq::ScheduledSet).to receive(
          :new
        ).and_raise(StandardError.new 'message')
      end
      it 'does notify Bugsnag' do
        expect(Bugsnag).to receive(:notify)
        described_class.destroy_all_notifications(poll)
      end
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
end

# {
# 'class'=>'ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper',
# 'wrapped'=>'ReminderPollEndJob',
# 'queue'=>'mailers',
# 'args'=> [
#   {
#     'job_class'=>'ReminderPollEndJob',
#     'job_id'=>'2db0c540-6bf3-49b2-b496-db22733b80bf',
#     'provider_job_id'=>nil,
#     'queue_name'=>'mailers',
#     'priority'=>nil,
#     'arguments'=>[poll.id],
#     'locale'=>'fr'
#   }
# ],
# 'retry'=>true,
# 'jid'=>'a9decad10eb3374c7d74276a',
# 'created_at'=>1545506938.8081102
# }
