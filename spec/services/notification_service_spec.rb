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
    it { expect(described_class).to receive(:set_poll_notification_mails) }
  end

  describe '.course_creation' do
    let(:course) { create(:course) }
    subject { described_class.course_creation(course) }
    let(:course_creation_done) { double 'course_creation_done'  }
    before do
      allow(NotificationService).to receive(:set_course_notification_mail).once do
        course_creation_done
      end
    end
    it { expect(subject).to eq course_creation_done }
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
          :set_poll_notification_mails
        ).with(poll_date)
        subject
      end
    end
  end
# Sample
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
  describe '.destroy_all_notifications' do
    let!(:poll_id) { 123 }
    let!(:poll) { build(:poll_date, id: poll_id) }
    let(:scheduled_jobs) { [a_scheduled_job] }
    let(:a_scheduled_job) do
      double('scheduled_jobs', args: 'something')
    end
    subject { described_class.destroy_all_notifications(poll)}
    context 'everything is ok' do
      before do
        allow(Sidekiq::ScheduledSet).to receive(:new) { scheduled_jobs }
        allow(NotificationService).to receive(:destroy_conditions_ok?) { true }
        allow(a_scheduled_job).to receive(:delete)
      end
      after do
        subject
      end
      it 'should delete the related notifications' do
        # skip 'missing test due  to double not being a correct object'
        expect(a_scheduled_job).to receive(:delete) { nil }
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

  describe '.destroy_conditions_ok?' do
    let(:obj) { create(:poll_opinion) }
    let(:job) do
      double('job', args: [
        {
          job_class: 'ReminderMailJob',
          arguments: [obj.id]
        }.with_indifferent_access
      ])
    end
    let(:job_wrong) do
      double('job', args: [
        {
          job_class: 'ReminderMailJob',
          arguments: [0] # there
        }.with_indifferent_access
      ])
    end
    let(:subject1) { described_class.send(:destroy_conditions_ok?, obj, job) }
    let(:subject2) { described_class.send(:destroy_conditions_ok?, obj, job_wrong) }
    it { expect(subject1).to be(true) }
    it { expect(subject2).to be(false) }
  end

  describe '.super_klass' do
    let(:poll_opinion) { build(:poll_opinion) }
    let(:poll_date) { build(:poll_date) }
    let(:course) { build(:course) }

    it { expect(NotificationService.super_klass(poll_opinion)).to eq 'Poll' }
    it { expect(NotificationService.super_klass(poll_date)).to eq 'Poll' }
    it { expect(NotificationService.super_klass(course)).to eq 'Course' }
  end

  describe '.set_poll_notification_mails' do
    subject { described_class.set_poll_notification_mails(poll) }
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

  describe '.set_course_notification_mail' do
    let(:course) { create(:course) }
    let(:a_mail_job) { double('a_mail_job') }
    before do
      allow(NotificationService).to receive(:get_delays) { [0,10] }
      allow(ReminderCourseMailJob).to receive(:set) { a_mail_job }
      allow(a_mail_job).to receive(:perform_later) { nil }
    end
    it { expect(a_mail_job).to receive(:perform_later).with(course.id)  }
    after do
      NotificationService.set_course_notification_mail(course)
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
