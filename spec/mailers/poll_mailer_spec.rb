require "rails_helper"

RSpec.describe PollMailer, type: :mailer do
  let!(:poll) { create(:poll_date) }
  describe '#poll_creation_mail' do
    subject { described_class.poll_creation_mail(poll) }
    before do
      allow(described_class.poll_creation_mail).to receive(:deliver_later)
      allow(User).to receive(:company_mails) { ['mail1@addr.fr', 'mail2@addr.fr'] }
    end
    it { expect(subject.from).to eq(['no-reply@les-sesames.fr']) }
    it { expect(subject.to).to eq(['mail1@addr.fr', 'mail2@addr.fr']) }
    it { expect(subject.subject).to eq(I18n.t('polls.mails.new_poll.subject', firstname: poll.owner.firstname)) }
    it { expect(subject.body.encoded.to_s).to include('avis sur une question') }
  end

  describe '#poll_reminder_mail' do
    context 'with some recipients' do
      let(:user1) { create(:user) }
      let(:user2) { create(:user) }
      subject { described_class.poll_reminder_mail(poll) }
      before do
        allow(described_class.poll_reminder_mail).to receive(:deliver_later)
        allow(poll).to receive(:missing_voters_ids) { [user1.id, user2.id] }
      end
      it { expect(subject.from).to eq(['no-reply@les-sesames.fr']) }
      it { expect(subject.to).to eq([user1.prefered_email, user2.prefered_email]) }
      it { expect(subject.subject).to eq(I18n.t('polls.mails.reminder.subject', firstname: poll.owner.firstname)) }
      it { expect(subject.body.encoded.to_s).to include('Plus que') }
    end
  end

  describe '#poll_end_reminder_mail' do
    context 'with everything ok' do
      subject(:mailing) { described_class.poll_end_reminder_mail(poll) }
      before do
        allow(described_class.poll_end_reminder_mail).to receive(:deliver_later)
      end
      it { expect(mailing.from).to eq(['no-reply@les-sesames.fr']) }
      it { expect(mailing.to).to eq([poll.owner.prefered_email]) }
      it { expect(mailing.subject).to eq(I18n.t('polls.mails.reminder.end_subject')) }
      it { expect(mailing.body.encoded.to_s).to include('Tu peux penser ') }
    end
  end
end
