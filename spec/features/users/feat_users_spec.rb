require 'rails_helper'

RSpec.feature  "Users list" do
  feature "as a fully_registered admin" do
    given (:admin) { create(:user, :admin, :fully_registered, lastname: "ADMIN") }
    given! (:player) { create(:user, :player, :fully_registered, lastname: "PLAYER") }

    background :each do
      logout
      log_in admin
      visit users_path
    end

    scenario "should list the theater's band members" do
      expect(page.body).to have_selector("h2", text: I18n.t("users.list"))
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
      next_url = "/users/#{admin.id}/edit"
      visit next_url
      expect(page.body).to have_selector("h2", text: I18n.t('users.complementary'))
    end
    scenario "I should not be able to edit to somebody else's page" do
      click_link(text: player.full_name)
      expect(page.body).not_to have_selector("i.fa.fa-pencil")
    end

    feature "PROMOTE" do
      scenario "whatever the status, it" do
        it "proposes archived status"
        it "cannot be invited unless invited already"
        it "cannot be googled unless googled already"
        it "cannot be fully_registered unless fully_registered already"
      end
      scenario ", when status is archived, it" do
        it "proposes set_up status"
      end
      scenario " with role" do
        it "is possible to change role"
      end
    end

  end

  feature "as a not fully_registered admin" do
    given (:admin) { create(:user, :admin, :fully_registered) }
    background :each do
      logout
      log_in admin
      visit users_path
    end

    scenario "should list the theater's band members" do
      expect(page.body).to have_selector("h2", text: I18n.t("users.list"))
    end

    scenario "should show at least an administrator" do
      expect(page.body).to have_text "Administrateur"
    end
  end
  context "As visitor" do
    context "get INDEX" do
      it "renders users index" do
        get '/users/index'
        expect(response).to redirect_to root_path
      end
    end
  end
  end
end
