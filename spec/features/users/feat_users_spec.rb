require 'rails_helper'

RSpec.feature  "Users list" do
  feature "as a registered admin" do
    given! (:admin2) { create(:user, :admin, :registered, email: "margoulin@free.fr") }
    given (:admin) { create(:user, :admin, :registered, lastname: "ADMIN") }
    given! (:player) { create(:user, :player, :registered, lastname: "PLAYER") }

    background :each do
      log_in admin
      visit users_path
    end

    scenario "should list the theater's band members" do
      expect(page.body).to have_selector("h2", text: I18n.t('users.list'))
    end

    scenario "should show at least an administrator" do
      expect(page.body).to have_text "Administrateur"
    end

    scenario "I should access everyone else's show page" do
      expect(page.body).to have_link(text: player.full_name)
      click_link(text: player.full_name)
      expect(page.body).to have_selector("h2", text: player.full_name)
    end

    scenario "I should access my own edit page" do
      click_link(text: admin.full_name)
      expect(page.body).to have_selector(".container > h2.edit_user", text: admin.full_name)
      expect(page.body).to have_selector("i.fa.fa-pencil")
      next_url = "/users/#{ admin.id }/edit"
      visit next_url
      expect(page.body).to have_selector("h2", text: I18n.t('users.complementary'))
    end
    scenario "I should not be able to edit to somebody else's page" do
      click_link(text: player.full_name)
      expect(page.body).not_to have_selector("i.fa.fa-pencil")
    end
  end
  feature "PROMOTE - status" do
    given! (:admin) { create(:user, :admin, :registered) }
    background :each do
      log_in admin
    end
    scenario "with setup status, it proposes archived status" do
      player = create(:user, :player, :invited)
      visit user_path(player)
      page.find('.users_promote').find("option[value='archived']").select_option
      click_button(I18n.t('users.promote'))
      expect(page.body).to have_selector("h2", text: I18n.t('users.list'))
      expect(page.body).to have_text("RIP")
    end
    scenario "with invited status, it proposes archived status" do
      player = create(:user, :player, :invited)
      visit user_path(player)
      page.find('.users_promote').find("option[value='archived']").select_option
      click_button(I18n.t('users.promote'))
      expect(page.body).to have_selector("h2", text: I18n.t('users.list'))
      expect(page.body).to have_text("RIP")
    end
    scenario "with googled status, it proposes archived status" do
      player = create(:user, :player, :googled)
      visit user_path(player)
      page.find('.users_promote').find("option[value='archived']").select_option
      click_button(I18n.t('users.promote'))
      expect(page.body).to have_selector("h2", text: I18n.t('users.list'))
      expect(page.body).to have_text("RIP")
    end
    scenario "with registered status, it proposes archived status" do
      player = create(:user, :player, :registered)
      visit user_path(player)
      page.find('.users_promote').find("option[value='archived']").select_option
      click_button(I18n.t('users.promote'))
      expect(page.body).to have_selector("h2", text: I18n.t('users.list'))
      expect(page.body).to have_text("RIP")
    end
    scenario "with archived status, it proposes setup status" do
      player = create(:user, :player, :archived)
      visit user_path(player)
      page.find('.users_promote').find("option[value='setup']").select_option
      click_button(I18n.t('users.promote'))
      expect(page.body).to have_selector("h2", text: I18n.t('users.list'))
      expect(page.body).not_to have_text("RIP")
    end
  end

  feature "PROMOTE - role" do
    given! (:admin) { create(:user, :admin, :registered) }
    background :each do
      log_in admin
    end
    scenario "with setup status, it proposes archived status" do
      player = create(:user, :player, :invited)
      visit user_path(player)
      page.find('.users_promote').find("option[value='admin']").select_option
      click_button(I18n.t('users.promote'))
      expect(page.body).to have_selector("h2", text: I18n.t('users.list'))
      click_link(player.full_name)
      expect(page.body).to have_text(I18n.t('enums.user.role.admin'))
    end
  end

  feature "As visitor " do
    scenario "getting INDEX it fails mouwhahahahaa" do
      visit users_path
      expect(page.body).not_to have_selector("h2", text: I18n.t('users.list'))
    end
  end
end
