require 'rails_helper'

RSpec.feature 'user feature', type: :feature do
  let!(:admin) { create(:user, :admin, :registered, lastname: 'ADMIN') }
  describe 'invitation' do

    it 'invitation sends an email' do
      player_email = "truc@machine.fr"
      sign_in admin
      visit users_path
      click_link('Admin')
      click_link('Invitations')
      fill_in "user_email",	with: player_email
      fill_in "user_firstname",	with: "truc"
      fill_in "user_lastname",	with: "machine"
      click_button 'Envoyer'
      player = User.last
      expect(page.body).to have_content(
        I18n.t('devise.invitations.send_instructions', email: player_email)
      )
      expect(last_email_address).to eq(player.email)
      expect(last_email.subject).to eq(I18n.t 'devise.mailer.invitation_instructions.subject')
      expect(last_email.body.encoded).to have_content("Quelqu'un de charmant")
    end
  end
end
