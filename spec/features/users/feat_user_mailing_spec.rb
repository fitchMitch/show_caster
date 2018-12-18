require 'rails_helper'

RSpec.feature 'Users', type: :feature do
  feature 'invite mail feature' do
    given!(:admin) { create(:user, :admin, :registered, lastname: 'ADMIN') }
    given!(:player) { create(:user, :player, :setup) }

    before :each do
      log_in admin
      visit users_path
      selector = ".row.user-list.#{player.firstname}.#{player.lastname}"
      within(selector) do
        find_button.click
      end
    end

    it 'should send to the user a promote mail ' do
      expect(last_email_address).to eq(player.prefered_email)
    end
    it 'welcome mail should have the subject ' do
      expect(last_email.subject).to eq(I18n.t('users.welcome_mail.subject'))
    end
    it 'welcome mail should have the right body' do
      status_text = 'bienvenue'
      expect(last_email.body.encoded).to have_content(status_text)
    end
  end
end
