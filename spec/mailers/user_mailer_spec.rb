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
    let!(:changes) { { committee: 'commission chanson', role: 'admin' } }
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
      expect(w_mail.body.encoded.to_s).to include(changes[:committee])
      expect(w_mail.body.encoded.to_s).to include(player.role_i18n)
    end
  end
end
