require 'rails_helper'

RSpec.feature 'vote opinion feature', type: :feature do
  given!(:admin) { create(:user, :admin, :registered, lastname: 'ADMIN') }
  given!(:poll) { create(:poll_opinion_with_answers) }
  given!(:vote) do
    create(
      :vote_opinion,
      answer_id: poll.answers.first.id,
      poll_id: poll.id
    )
  end
  describe 'before voting' do
    before :each do
      log_in admin
      visit poll_opinion_path(poll)
    end
    it ' should show the poll in the poll\'s page' do
      expect(page.body).to have_content(poll.question)
    end
    it 'should show a red alert' do
      expect(page.body).to have_selector('i.fa.fa-bell')
    end
  end
  describe 'after voting' do
    before :each do
      log_in admin
      visit poll_opinion_path(poll)
      selector = "#vote_opinion_answer_id_#{poll.answers.first.id}"
      find(:css, selector).click
      click_button(I18n.t('votes.new_opinion'))
    end
    it 'should be a success' do
      expect(page.body).to have_content(I18n.t('votes.save_success'))
    end
    it 'empty the poll\'s page' do
      skip 'due to javascript Driver missing'
      # it 'empty the poll\'s page', js: true do
      visit poll_opinion_path(poll)
      expect(page.body).not_to have_content(poll.question)
    end
    it 'make the red alert disappear' do
      expect(page.body).not_to have_selector('i.fa.fa-bell')
    end
    it 'poll should be available in the other tab' do
      skip 'due to javascript Driver missing'
      click_link(I18n.t('polls.voted'))
      expect(page.body).to have_content(poll.question)
    end
  end
end
