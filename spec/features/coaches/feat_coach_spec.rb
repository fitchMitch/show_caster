require 'rails_helper'

RSpec.feature  "Coach" do
  feature "as a registered admin" do
    given! (:admin) { create(:user, :admin, :registered, lastname: "ADMIN") }
    feature "visiting INDEX" do
      background :each do
        log_in admin
        visit coaches_path
      end

      scenario "should list the coach's band members" do
        expect(page.body).to have_selector("h2", text: I18n.t('coaches.list'))
      end

      scenario "should propose an add button" do
        # expect(page.body).to have_button text:I18n.t('coaches.new')
        # click_button(I18n.t('coaches.new'))
        visit new_coach_path
        expect(page.body).to have_selector("h2", text: I18n.t('coaches.new'))
      end
    end

    feature "visiting NEW and CREATE" do
      background :each do
        log_in admin
        visit new_coach_path
        within "#coach_new" do
          fill_in "coach_firstname", with: "Edouard IV"
          fill_in "coach_lastname", with: "berurier"
          fill_in "coach_email", with: "bg@fra.fr"
          fill_in "coach_cell_phone_nr", with: "0123654789"
          fill_in "coach_note", with: "fracan"
        end
        click_button(I18n.t('helpers.submit.coach.create'))
      end

      scenario "it shall create a Coach" do
        coach = Coach.last
        expect(page.body).to have_content I18n.t('coaches.save_success')
        expect(page.body).to have_content coach.firstname
        expect(page.body).to have_content coach.lastname
        expect(page.body).to have_content coach.email
        expect(page.body).to have_content "01 23 65 47 89"
        expect(page.body).to have_content coach.note
      end
    end

    feature "visiting UPDATE" do
      background :each do
        log_in admin
        coach = create(:coach)
        visit edit_coach_path(coach)
        within "#coach_new" do
          fill_in "coach_firstname", with: "Edouard IV"
          fill_in "coach_lastname", with: "berurier"
          fill_in "coach_email", with: "bg@fra.fr"
          fill_in "coach_cell_phone_nr", with: "0123654789"
          fill_in "coach_note", with: "fracan"
        end
        click_button(I18n.t('helpers.submit.coach.update'))
      end

      scenario "it shall create a Coach" do
        coach = Coach.last
        expect(page.body).to have_content I18n.t('coaches.update_success')
        expect(page.body).to have_content coach.firstname
        expect(page.body).to have_content coach.lastname
        expect(page.body).to have_content coach.email
        expect(page.body).to have_content "01 23 65 47 89"
        expect(page.body).to have_content coach.note
      end
    end

    feature "visiting UPDATE fails" do
      background :each do
        log_in admin
        coach = create(:coach)
        visit edit_coach_path(coach)
        within "#coach_new" do
          fill_in "coach_firstname", with: ""
          fill_in "coach_lastname", with: "berurier"
          fill_in "coach_email", with: "bg@fra.fr"
          fill_in "coach_cell_phone_nr", with: "0123654789"
          fill_in "coach_note", with: "fracan"
        end
        click_button(I18n.t('helpers.submit.coach.update'))
      end

      scenario "it shall create a Coach" do
        coach = Coach.last
        expect(page.body).to have_content (I18n.t('coaches.save_fails'))
        expect(page.body).to have_selector("h2", text: I18n.t('edit'))
      end
    end
  end
end
