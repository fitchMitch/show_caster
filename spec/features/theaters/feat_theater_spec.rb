require 'rails_helper'

RSpec.feature  "Theater" do
  feature "as a registered admin" do
    given (:admin) { create(:user, :admin, :registered, lastname: "ADMIN") }
    feature "visiting INDEX" do
      background :each do
        log_in admin
        visit theaters_path
      end

      scenario "should list the theater's band members" do
        expect(page.body).to have_selector("h2", text: I18n.t("theaters.list"))
      end

      scenario "should propose an add button" do
        # expect(page.body).to have_button text:I18n.t("theaters.new")
        # click_button(I18n.t("theaters.new"))
        visit new_theater_path
        expect(page.body).to have_selector("h2", text: I18n.t("theaters.new"))
      end
    end

    feature "visiting NEW and CREATE" do
      background :each do
        log_in admin
        visit new_theater_path
        within "#new_theater" do
          fill_in "theater_theater_name", with: "Edouard IV"
          fill_in "theater_location", with: "the place to be"
          fill_in "theater_manager", with: "Edouard himself"
          fill_in "theater_manager_phone", with: "0123654789"
        end
        click_button(I18n.t("helpers.submit.theater.create"))
      end

      scenario "it shall create a Theater" do
        theater = Theater.last
        expect(page.body).to have_content I18n.t("theaters.save_success")
        expect(page.body).to have_content theater.theater_name
        expect(page.body).to have_content theater.location
        expect(page.body).to have_content theater.manager
        expect(page.body).to have_content "01 23 65 47 89"
      end
    end

    feature "visiting UPDATE" do
      background :each do
        log_in admin
        theater = create(:theater)
        visit edit_theater_path(theater)
        within "#edit_theater_#{theater.id}" do
          fill_in "theater_theater_name", with: "Edouard IV"
          fill_in "theater_location", with: "the place to be"
          fill_in "theater_manager", with: "Edouard himself"
          fill_in "theater_manager_phone", with: "0123654789"
        end
        click_button(I18n.t("helpers.submit.theater.update"))
      end

      scenario "it shall create a Theater" do
        theater = Theater.last
        expect(page.body).to have_content I18n.t("theaters.update_success")
        expect(page.body).to have_content theater.theater_name
        expect(page.body).to have_content theater.location
        expect(page.body).to have_content theater.manager
        expect(page.body).to have_content "01 23 65 47 89"
      end
    end

    feature "visiting UPDATE fails" do
      background :each do
        log_in admin
        theater = create(:theater)
        visit edit_theater_path(theater)
        within "#edit_theater_#{theater.id}" do
          fill_in "theater_theater_name", with: ""
          fill_in "theater_location", with: "the place to be"
          fill_in "theater_manager", with: "Edouard himself"
          fill_in "theater_manager_phone", with: "0123654789"
        end
        click_button(I18n.t("helpers.submit.theater.update"))
      end

      scenario "it shall create a Theater" do
        theater = Theater.last
        expect(page.body).to have_content (I18n.t("theaters.save_fails"))
        expect(page.body).to have_selector("h2", text: I18n.t("theaters.edit_theater"))
      end
    end
  end
end
