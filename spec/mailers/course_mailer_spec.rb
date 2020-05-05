require "rails_helper"

RSpec.describe CourseMailer, type: :mailer do
  let(:auto_coached_course) { create(:auto_coached_course) }
  let(:course_with_coach) { create(:course_with_coach) }
  describe '#course_reminder_mail' do
    context 'with everything ok' do
      subject(:mailing) { described_class.course_reminder_mail(auto_coached_course) }
      it { expect(mailing.from).to eq(['no-reply@les-sesames.fr']) }
      it { expect(mailing.to).to eq([auto_coached_course.courseable.email]) }
      it { expect(mailing.subject).to eq(I18n.t('courses.mails.reminder.subject')) }
    end
  end
end
