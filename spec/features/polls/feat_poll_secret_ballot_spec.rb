require 'rails_helper'
require 'polls_helper'

RSpec.feature 'PollSecretBallot' do
  feature 'as a registered admin' do
    def fill_form(form_type, id=nil, valid=true)
      form_label = id.nil? ? "##{form_type}_poll_secret_ballot" : "##{form_type}_poll_secret_ballot_#{id}"
      source = valid == true ? poll_secret_ballot_attributes : poll_secret_ballot_bad_attributes
      within form_label do
        fill_in 'poll_secret_ballot_question', with: source[:question]
        fill_in 'poll_secret_ballot_expiration_date', with: source[:expiration_date]
        fill_in 'poll_secret_ballot_answers_attributes_0_answer_label', with: source[:answers][0]
        fill_in 'poll_secret_ballot_answers_attributes_1_answer_label', with: source[:answers][1]
      end
    end

    given!(:admin) { create(:user, :admin, :registered, lastname: 'ADMIN') }
    given!(:poll_secret_ballot_attributes) {
      {
        question: 'Au square Edouard IV, vous êtes d\'accord ?',
        expiration_date: Date.today.weeks_since(2),
        answers: ['une réponse', 'une autre réponse']
      }
    }
    given!(:poll_secret_ballot_bad_attributes) {
      {
        question: nil,
        expiration_date: nil,
        answers: ['une réponse bad', 'une autre réponse bad']
      }
    }

    feature 'visiting INDEX' do
      background :each do
        log_in admin
        visit poll_secret_ballots_path
      end

      scenario 'should list the poll_secret_ballot\'s band members' do
        expect(page.body).to have_selector('h2', text: I18n.t('polls.list'))
      end

      scenario 'should propose an add button' do
        visit new_poll_secret_ballot_path
        expect(page.body).to have_selector(
          'h2', text: I18n.t('secret_polls.new')
        )
      end
    end

    feature 'visiting NEW and CREATE' do
      background :each do
        log_in admin
        visit new_poll_secret_ballot_path
        fill_form('new')
        click_button(I18n.t('helpers.submit.poll_secret_ballot.create'))
      end

      scenario 'it shall create a PollOpinion' do
        expect(page.body).to have_content I18n.t('polls.save_success')
        expect(page.body).to have_content poll_secret_ballot_attributes[:question]
        expect(page.body).to have_content poll_date poll_secret_ballot_attributes[:expiration_date]
      end
    end

    feature 'visiting UPDATE fails' do
      background :each do
        log_in admin
        poll_secret_ballot = create(:secret_ballot_with_answers)
        visit edit_poll_secret_ballot_path(poll_secret_ballot)
        fill_form('edit', poll_secret_ballot.id, false)
        click_button(I18n.t('helpers.submit.poll_secret_ballot.update'))
      end

      scenario 'it shall create a PollOpinion' do
        expect(page.body).to have_content (I18n.t('polls.save_fails'))
        expect(page.body).to have_selector('h2', text: I18n.t('edit'))
      end
    end

    feature 'visiting DELETE' do
      background :each do
        log_in admin
        poll_secret_ballot = create(:secret_ballot_with_answers)
        visit poll_secret_ballots_path
        page.find('.destroy', match: :first).click
      end

      scenario 'it shall create a PollOpinion' do
        poll_secret_ballot = PollOpinion.last
        expect(page.body).to have_content (I18n.t('polls.destroyed'))
        expect(page.body).to have_selector('h2', text: I18n.t('polls.list'))
      end
    end
  end
end
