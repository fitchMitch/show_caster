require 'rails_helper'
# require 'vcr'

RSpec.feature  "Events | " do
  feature "as a registered admin" do
    given (:admin) { create(:user, :admin, :registered, lastname: "ADMIN") }
    given (:performance) { create(:performance) }
    given (:other_performance) { create(:performance) }
    given! (:performance_w) { create(:performance_with_actors) }
    given! (:theater_w) { create(:theater_with_performance)}


    feature "visiting INDEX" do
      background :each do
        log_in admin
        visit performances_path
      end

      scenario "should list the performances" do
        expect(page.body).to have_selector("h2", text: I18n.t("performances.list"))
      end

      scenario "should propose an add button" do
        visit new_performance_path
        expect(page.body).to have_selector("h2", text: I18n.t("performances.new"))
      end
    end

    feature "visiting NEW and CREATE" do
      background :each do
        log_in admin
        visit new_performance_path
        last_theater_id = Theater.all.last.id
        page.find('#event_theater_id').find(:xpath, 'option[1]').select_option
        page.find('#event_duration').find(:xpath, 'option[3]').select_option
        click_button(I18n.t("helpers.submit.performance.create"))
      end

      # scenario "it shall create a Event", :vcr do
      scenario "it shall create a Event" do
        expect(page.body).to have_content I18n.t("performances.created")
        expect(page.body).to have_content Event::DURATIONS.rassoc(performance.duration)
        expect(page.body).to have_content performance.progress_i18n
      end
    end

    feature "visiting UPDATE" do
      background :each do
        log_in admin
        visit edit_performance_path(performance_w)
        page.find('#event_theater_id').find(:xpath, 'option[1]').select_option
        page.find('#event_duration').find(:xpath, 'option[4]').select_option
        click_button(I18n.t("helpers.submit.performance.update"))
      end

      scenario "it shall update Events" do
      # scenario "it shall update Events", :vcr do
        expect(page.body).to have_content I18n.t("performances.updated")
        expect(page.body).to have_content Event::DURATIONS.rassoc(performance.duration)
        expect(page.body).to have_content performance.progress_i18n
      end
    end

    feature "visiting UPDATE fails" do
      background :each do
        log_in admin
        visit edit_performance_path(performance_w)
        page.find('#event_theater_id').find(:xpath, 'option[1]').select_option
        click_button(I18n.t("helpers.submit.performance.update"))
      end

      scenario "it shall not update Events" do
        expect(page.body).to have_content (I18n.t("performances.desynchronized"))
        expect(page.body).to have_selector("h2", text: I18n.t("performances.edit_title"))
      end
    end

    feature "visiting DELETE fails" do
      background :each do
        log_in admin
        visit performances_path
        page.find('.destroy', match: :first).click
      end

      scenario "it shall delete Events" do
      # scenario "it shall delete Events" ,:vcr do
        expect(page.body).to have_content (I18n.t("performances.destroyed"))
        expect(page.body).to have_selector("h2", text: I18n.t("performances.list"))
      end
    end
  end
end
