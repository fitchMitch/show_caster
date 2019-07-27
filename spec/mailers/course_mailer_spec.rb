require "rails_helper"

RSpec.describe CourseMailer, type: :mailer do
  let(:auto_coached_course) { create(:auto_coached_course) }
  let(:course_with_coach) { create(:course_with_coach) }
  describe '#course_reminder_mail' do
    context 'with everything ok' do
      subject(:mailing) { described_class.course_reminder_mail(auto_coached_course) }
      # before do
      #   allow(described_class.course_reminder_mail).to receive(:deliver_later)
      # end
      it { expect(mailing.from).to eq(['no-reply@les-sesames.fr']) }
      it { expect(mailing.to).to eq([auto_coached_course.courseable.email]) }
      it { expect(mailing.subject).to eq(I18n.t('courses.mails.reminder.subject')) }
    end

    context 'with some problem' do
      after do
        # allow(subject).to receive(:deliver_later) {  }
        raise(StandardError.new('message'))
      end
      it 'should notify Bugsnag' do
        skip 'until I know how to deal with raising errors'
        expect(Bugsnag).to receive(:notify)
        described_class.poll_reminder_mail(poll)
      end
    end
  end
end
