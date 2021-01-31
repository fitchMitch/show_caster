require 'rails_helper'

RSpec.feature 'promotion feature', type: :feature do
  feature 'promote with mail feature' do
    let!(:admin) { create(:user, :admin, :registered, lastname: 'ADMIN') }
    let!(:player) { create(:user, :player, :registered) }
    describe 'real promotion' do
      before :each do
        sign_in admin
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
        status_text = 'L\'administrateur vient de' \
                      ' changer ton statut sur le site'
        expect(last_email.body.encoded).to have_content(status_text)
      end
      it 'should be visible in both user \'s page and in users page' do
        page_attr_matcher(User.last, %w[firstname lastname])
        expect(page.body).to have_content(
          I18n.t('users.promoted', name: player.full_name)
        )
        visit users_path
        expect(page.body).to have_content(player.reload.role_i18n)
      end
    end

    describe 'false promotion' do
      let!(:future_player) { create(:user, :admin, :registered) }
      before do
        reset_email
        sign_in admin
        visit user_path(future_player)
        page.find('.users_promote').find("option[value='player']").select_option
        click_button(I18n.t('users.promote'))
      end

      it 'should not send to the user a promote mail' do
        expect(last_email_address).not_to be(future_player.email)
      end
    end
  end

  feature 'PROMOTE - role' do
    given!(:admin) { create(:user, :admin, :registered) }
    background :each do
      sign_in admin
    end
    scenario 'with setup status, it proposes archived status' do
      player = create(:user, :player, :invited)
      visit user_path(player)
      page.find('.users_promote').find("option[value='admin']").select_option
      click_button(I18n.t('users.promote'))
      visit users_path
      expect(page.body).to have_selector('h2', text: I18n.t('users.list'))
      click_link(player.full_name)
      expect(page.body).to have_text(I18n.t('enums.user.role.admin'))
    end
  end

  feature 'PROMOTE - status' do
    let!(:admin) { create(:user, :admin, :registered) }
    background :each do
      reset_email
      sign_in admin
    end
    scenario 'with setup status, it proposes archived status' do
      visit user_path(create(:user, :player, :registered))
      page.find('.users_promote').find("option[value='archived']").select_option
      click_button(I18n.t('users.promote'))
      visit users_path
      expect(page.body).to have_selector('h2', text: I18n.t('users.list'))
      expect(page.body).to have_text('RIP')
    end
    scenario 'with RIP status, it proposes missing_phone_nr status' do
      rip_player = create(:user, :player, :archived)
      visit user_path(rip_player)
      page.find('#user_status').find("option[value='missing_phone_nr']").select_option
      click_button(I18n.t('users.promote'))
      visit users_path
      expect(page.body).to have_selector('h2', text: I18n.t('users.list'))
      expect(page.body).to have_selector('span.label.label-danger')
      expect(last_email_address).to eq(rip_player.email)
    end
  end
end
