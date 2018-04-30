require 'rails_helper'
require 'vcr'

RSpec.feature  "Events | " do
  feature "as a registered admin" do
    given (:admin) { create(:user, :admin, :registered, lastname: "ADMIN") }
    given (:event) { create(:event) }
    given (:other_event) { create(:other_event) }
    given! (:event_w) { create(:event_with_actors) }
    given! (:theater_w) { create(:theater_with_event)}


    feature "visiting INDEX" do
      background :each do
        log_in admin
        visit events_path
      end

      scenario "should list the events" do
        expect(page.body).to have_selector("h2", text: I18n.t("events.list"))
      end

      scenario "should propose an add button" do
        visit new_event_path
        expect(page.body).to have_selector("h2", text: I18n.t("events.new"))
      end
    end

    feature "visiting NEW and CREATE" do
      background :each do
        log_in admin
        visit new_event_path
        last_theater_id = Theater.all.last.id
        page.find('#event_theater_id').find(:xpath, 'option[1]').select_option
        page.find('#event_duration').find(:xpath, 'option[3]').select_option
        click_button(I18n.t("helpers.submit.event.create"))
      end

      scenario "it shall create a Event", :vcr do
        expect(page.body).to have_content I18n.t("events.created")
        expect(page.body).to have_content Event::DURATIONS.rassoc(event.duration)
        expect(page.body).to have_content event.progress_i18n
      end
    end

    feature "visiting UPDATE" do
      background :each do
        log_in admin
        visit edit_event_path(event_w)
        page.find('#event_theater_id').find(:xpath, 'option[1]').select_option
        page.find('#event_duration').find(:xpath, 'option[4]').select_option
        click_button(I18n.t("helpers.submit.event.update"))
      end

      scenario "it shall update Events", :vcr do
        expect(page.body).to have_content I18n.t("events.updated")
        expect(page.body).to have_content Event::DURATIONS.rassoc(event.duration)
        expect(page.body).to have_content event.progress_i18n
      end
    end

    feature "visiting UPDATE fails" do
      background :each do
        log_in admin
        visit edit_event_path(event_w)
        page.find('#event_theater_id').find(:xpath, 'option[1]').select_option
        click_button(I18n.t("helpers.submit.event.update"))
      end

      scenario "it shall not update Events" do
        expect(page.body).to have_content (I18n.t("events.desynchronized"))
        expect(page.body).to have_selector("h2", text: I18n.t("events.edit_title"))
      end
    end

    feature "visiting DELETE fails" do
      background :each do
        log_in admin
        visit events_path
        page.find('.destroy', match: :first).click
      end

      scenario "it shall delete Events" ,:vcr do
        expect(page.body).to have_content (I18n.t("events.destroyed"))
        expect(page.body).to have_selector("h2", text: I18n.t("events.list"))
      end
    end
  end
end
