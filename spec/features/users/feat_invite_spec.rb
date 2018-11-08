require 'rails_helper'

RSpec.feature 'user feature', type: :feature do
  let!(:admin) { create(:user, :admin, :registered, lastname: 'ADMIN') }
  let!(:player) { create(:user, :player, :setup) }
  describe 'invitation' do
    before :each do
      log_in admin
      visit users_path
    end

    it 'users page should show a red button to invite' do
      expect(page.body).to have_selector('input.btn.btn-danger.btn-xs')
      click_button(I18n.t('users.invite'))
      expect(page.body).to have_content(
        I18n.t('users.invited', name: player.full_name)
      )
      expect(player.reload.status).to eq('invited')
    end
  end
end
