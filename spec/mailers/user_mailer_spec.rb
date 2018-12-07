require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'User Mailer new_player_notice_mail' do
    let!(:admin) { create(:user, :admin, :registered) }
    let!(:player) { create(:user, :player, :setup) }
    let(:w_mail) { UserMailer.welcome_mail(player).deliver_now }
    let(:url) { "http://localhost:3000/users/#{player.id}" }
    let(:to) { player.email }

    it 'should have a correct from' do
      expect(w_mail.from).to eq(['no-reply@les-sesames.fr'])
    end

    it 'should have a correct to' do
      expect(w_mail.to.first).to eq(to)
    end

    it 'should have a correct subject' do
      expect(w_mail.subject).to eq(I18n.t('users.welcome_mail.subject'))
    end

    it 'should have a correct body' do
      expect(w_mail.body.encoded.to_s).to include('marque page')
    end
  end

  describe 'User Mailer send_promotion_mail' do
    let(:player) { create(:user, :player, :setup) }
    let(:admin) { create(:user, :admin, :registered) }
    let!(:changes) do
      {
        gained_committees:['commission danse'],
        lost_committees:['commission chanson'],
        role: 'admin'
      }
    end
    let(:w_mail) { UserMailer.send_promotion_mail(player, changes).deliver_now }
    let(:url) { "http://localhost:3000/users/#{player.id}" }
    let(:to) { player.email }

    it 'should have a correct from' do
      expect(w_mail.from).to eq(['no-reply@les-sesames.fr'])
    end

    it 'should have a correct to' do
      expect(w_mail.to.first).to eq(to)
    end

    it 'should have a correct subject' do
      expect(w_mail.subject).to eq(I18n.t('users.promote_mail.subject'))
    end

    it 'should have a correct body' do
      expect(w_mail.body.encoded.to_s).to include(
        'L\'administrateur vient de changer ton statut sur le site'
      )
      expect(w_mail.body.encoded.to_s).to include(changes[:gained_committees].map(&:capitalize).join(',' ))
      expect(w_mail.body.encoded.to_s).to include(changes[:lost_committees].map(&:capitalize).join(', '))
      expect(w_mail.body.encoded.to_s).to include(player.role_i18n)
    end
  end
  describe '#to_sentence' do
    subject { UserMailer.new.send(:to_sentence, list) }
    context 'when submitted nil' do
      let(:list) { nil }
      it 'should render nil' do
        expect(subject).to be(nil)
      end
    end
    context 'when submitted an empty list' do
      let(:list) { [] }
      it 'should render nil' do
        expect(subject).to be(nil)
      end
    end
    context 'when submitted a list with several elements' do
      let(:list) { ['el1', 'el2'] }
      it 'should render nil' do
        expect(subject).to eq('El1, El2')
      end
    end
    context 'when submitted a list with one element' do
      let(:list) { ['el1'] }
      it 'should render nil' do
        expect(subject).to eq('El1')
      end
    end
  end
end
