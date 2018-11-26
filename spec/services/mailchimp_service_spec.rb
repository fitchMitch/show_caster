require 'rails_helper'
RSpec.describe 'FrontPageService', type: :service do
  let(:subject) { MailchimpService.new }
  describe '#setup_complete?' do
    it 'it should be true when mailchimp env variables are set' do
      ENV['MAILCHIMP_SPLASH_SIGNUP_LIST_ID'] = '1'
      ENV['MAILCHIMP_API_KEY'] = '1'
      expect(subject.setup_complete?).to be true
    end
    it 'it should be false if one mailchimp env variables is missing' do
      ENV['MAILCHIMP_SPLASH_SIGNUP_LIST_ID'] = nil
      ENV['MAILCHIMP_API_KEY'] = '1'
      expect(subject.setup_complete?).to be false
    end
  end

  describe '#subscribe' do
    let(:a_list) { double('a list') }
    let(:email) { 'email@truc.fr' }
    let(:member_list) { double('member_list') }
    let(:params) do
      {
        title: 'truc',
        detail: '',
        body: '',
        raw_body: '',
        status_code: '403'
      }
    end
    let(:error_503) { { status_code: '503' } }
    before :each do
      allow(MAILCHIMP).to receive(:lists) { a_list }
      allow(a_list).to receive(:members) { member_list }
      allow(member_list).to receive(:create) { 'success ' }
    end
    it 'should subscribe users to the mailing list' do
      expect {subject.subscribe(email)}.not_to raise_error
    end
    it 'should return a happy_message' do
      expect(subject.subscribe(email)).to eq(I18n.t('splash.ok_then'))
    end
    describe 'should deal with MailChimpErrors' do
      before :each do
        allow(MAILCHIMP).to receive(:lists) { a_list }
        allow(a_list).to receive(:members) { member_list }
      end
      context 'when user resubscribes' do
        before do
          allow(member_list).to receive(:create) do
            raise(Gibbon::MailChimpError.new("stg", params))
          end
        end
        it 'should return a happy_message too' do
          expect(subject.subscribe(email)).to eq(I18n.t('splash.enthousiast'))
        end
      end
      context 'when code doesn\'t starts with a \'4\'' do
        before do
          allow(member_list).to receive(:create) do
            raise(Gibbon::MailChimpError.new("stg", params.merge(error_503)))
          end
        end
        it 'should notify a Bugsnag error' do
          expect(Bugsnag).to receive(:notify)
          expect(subject.subscribe(email)).to eq(I18n.t('splash.error'))
        end
      end
    end
  end
end
