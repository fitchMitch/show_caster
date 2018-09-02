require 'rails_helper'
require 'polls_helper'

RSpec.feature "PollOpinion" do
  feature "as a registered admin" do
    def fill_form(form_type, id=nil, valid=true)
      form_label = id.nil? ? "##{form_type}_poll_opinion" : "##{form_type}_poll_opinion_#{id}"
      source = valid == true ? poll_opinion_attributes : poll_opinion_bad_attributes
      within form_label do
        fill_in "poll_opinion_question", with: source[:question]
        fill_in "poll_opinion_expiration_date", with: source[:expiration_date]
        fill_in "poll_opinion_answers_attributes_0_answer_label", with: source[:answers][0]
        fill_in "poll_opinion_answers_attributes_1_answer_label", with: source[:answers][1]
      end
    end

    def page_test page
      poll_opinion = PollOpinion.last
      expect(page.body).to have_content poll_opinion_attributes[:question]
      expect(page.body).to have_content poll_date poll_opinion_attributes[:expiration_date]
      expect(page.body).to have_content poll_date poll_opinion_attributes[:answers][0]
      expect(page.body).to have_content poll_date poll_opinion_attributes[:answers][1]
    end

    given!(:admin) { create(:user, :admin, :registered, lastname: "ADMIN") }
    given!(:poll_opinion_attributes) {
      {
        question: "Au square Edouard IV, vous êtes d'accord ?",
        expiration_date: Date.today.weeks_since(2),
        answers: ["une réponse", "une autre réponse"]
      }
    }
    given!(:poll_opinion_bad_attributes) {
      {
        question: nil,
        expiration_date: nil,
        answers: ["une réponse bad ", "une autre réponse bad"]
      }
    }

    feature "visiting INDEX" do
      background :each do
        log_in admin
        visit poll_opinions_path
      end

      scenario "should list the poll_opinion's band members" do
        expect(page.body).to have_selector("h2", text: I18n.t("polls.list"))
      end

      scenario "should propose an add button" do
        visit new_poll_opinion_path
        expect(page.body).to have_selector("h2", text: I18n.t("polls.new_opinion"))
      end
    end

    feature "visiting NEW and CREATE" do
      background :each do
        log_in admin
        visit new_poll_opinion_path
        fill_form("new")
        click_button(I18n.t("helpers.submit.poll_opinion.create"))
      end

      scenario "it shall create a PollOpinion" do
        expect(page.body).to have_content I18n.t("polls.save_success")
        page_test page
      end
    end

    feature "visiting UPDATE" do
      background :each do
        log_in admin
        poll_opinion = create(:poll_opinion_with_answers)
        visit edit_poll_opinion_path(poll_opinion)
        fill_form("edit", poll_opinion.id)
        click_button(I18n.t("helpers.submit.poll_opinion.update"))
      end

      scenario "it shall create a PollOpinion" do
        expect(page.body).to have_content I18n.t("polls.update_success")
        page_test page
      end
    end

    feature "visiting UPDATE fails" do
      background :each do
        log_in admin
        poll_opinion = create(:poll_opinion_with_answers)
        visit edit_poll_opinion_path(poll_opinion)
        fill_form("edit", poll_opinion.id, false)
        click_button(I18n.t("helpers.submit.poll_opinion.update"))
      end

      scenario "it shall create a PollOpinion" do
        expect(page.body).to have_content (I18n.t("polls.save_fails"))
        expect(page.body).to have_selector("h2", text: I18n.t("edit"))
      end
    end

    feature "visiting DELETE" do
      background :each do
        log_in admin
        poll_opinion = create(:poll_opinion_with_answers)
        visit poll_opinions_path
        page.find('.destroy', match: :first).click
      end

      scenario "it shall create a PollOpinion" do
        poll_opinion = PollOpinion.last
        expect(page.body).to have_content (I18n.t("polls.destroyed"))
        expect(page.body).to have_selector("h2", text: I18n.t("polls.list"))
      end
    end
  end
end
