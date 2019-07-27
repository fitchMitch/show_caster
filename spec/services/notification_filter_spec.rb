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
    let(:poll_id) { 123 }

    context 'when poll no longer exists' do
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
  end

  describe '.course_reminder_mailing' do
    let(:course_id) { 123 }
    subject(:mailing) { described_class.course_reminder_mailing(course_id) }

    context 'when course no longer exists' do
      before do
        allow(Course).to receive(:find_by) { nil }
      end
      it { expect(mailing).to be(nil) }
    end
    context 'when coach is no longer active' do
      let!(:course) { create(:auto_coached_course) }
      before do
        course.courseable.archived!
        allow(Course).to receive(:find_by) { course }
      end
      it { expect(mailing).to be(nil) }
    end

    context 'when course and coach are active' do
      let(:user) { create(:user) }
      let(:course) { build(:course, courseable: user) }
      let(:a_delivered_mail) { double('a_delivered_mail') }
      let(:a_mail) { double('a_mail') }
      before do
        allow(Course).to receive(:find_by) { course }
        allow(CourseMailer).to receive(
          :course_reminder_mail
        ).with(course) { a_mail }
        allow(a_mail).to receive(:deliver_now) { a_delivered_mail }
      end
      it { expect(mailing).to eq a_delivered_mail }
    end
  end
end
