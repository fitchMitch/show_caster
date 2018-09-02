require 'rails_helper'

RSpec.feature 'Users', type: :feature do
  feature 'invite mail feature' do
    given!(:admin) { create(:user, :admin, :registered, lastname: 'ADMIN') }
    given!(:player) { create(:user, :player, :setup) }

    before :each do
      log_in admin
      visit users_path
      selector = ".row.user-list.#{player.firstname}.#{player.lastname}"
      within (selector) do
        find_button.click
      end
    end

    it 'should send to the user a promote mail ' do
      expect(last_email_address).to eq(player.email)
    end
    it 'welcome mail should have the subject ' do
      expect(last_email.subject).to eq(I18n.t('users.welcome_mail.subject'))
    end
    it 'welcome mail should have the right body' do
      status_text = 'bienvenue'
      expect(last_email.body.encoded).to have_content(status_text)
    end
  end

  feature 'promote mail feature' do
    let!(:admin) { create(:user, :admin, :registered, lastname: 'ADMIN') }
    describe 'real promotion' do
      let!(:player) { create(:user, :player, :registered) }

      before :each do
        log_in admin
        visit user_path(player)
        page.find('.users_promote').find("option[value='admin']").select_option
        click_button(I18n.t('users.promote'))
      end

      it 'should send to the user a promote mail' do
        expect(last_email_address).to eq(player.email)
      end
      it 'welcome mail should have the subject' do
        expect(last_email.subject).to eq(I18n.t('users.promote_mail.subject'))
      end
      it 'promote mail should have the right body ' do
        status_text = "L'administrateur vient de changer ton statut sur le site"
        expect(last_email.body.encoded).to have_content(status_text)
      end
    end

    describe 'false promotion' do
      let!(:future_player) { create(:user, :admin, :registered) }

      before do
        reset_email
        log_in admin
        visit user_path(future_player)
        page.find('.users_promote').find("option[value='player']").select_option
        click_button(I18n.t('users.promote'))
      end

      it 'should not send to the user a promote mail' do
        expect(last_email_address).not_to be(future_player.email)
      end
    end
  end
end
