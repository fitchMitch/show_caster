require 'rails_helper'

RSpec.feature 'vote opinion feature for secret ballots', type: :feature do
  feature 'voting for secret ballots' do
    given!(:admin_com) { create(:user, :admin_com, :registered) }
    given!(:poll_secret) do
      create(
        :secret_ballot_with_answers,
        expiration_date: Time.zone.now + 10.years
      )
    end

    describe 'as admin after voting for secret ballots' do
      before do
        log_in admin_com
        visit poll_opinion_path(poll_secret)
        selector = "#vote_opinion_answer_id_#{poll_secret.answers.first.id}"
        find(:css, selector).click
        click_button(I18n.t('votes.new_opinion'))
      end
      it 'should be a success', js: true do
        expect(page.body).to have_content(I18n.t('votes.save_success'))
        visit polls_path
        expect(page.find('#expecting_answer')).not_to have_content(poll_secret.question)
        click_link(I18n.t('polls.voted'))
        expect(page.body).to have_content(poll_secret.question)
      end
    end
  end
end
