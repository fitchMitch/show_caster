require 'rails_helper'

RSpec.feature 'vote opinion feature', type: :feature do
  given!(:admin) { create(:user, :admin, :registered, lastname: 'ADMIN') }
  describe 'creating the poll' do
    before do
      log_in admin
      visit new_poll_opinion_path
      within '#new_poll_opinion' do
        fill_in 'poll_opinion[question]', with: 'question'
        fill_in 'poll_opinion[answers_attributes][0][answer_label]', with: 'answer 1'
        fill_in 'poll_opinion[answers_attributes][1][answer_label]', with: 'answer 2'
      end
      click_button(I18n.t('helpers.submit.poll_opinion.create'))
      visit poll_opinions_path
    end
    it { expect(page.body).to have_content('question') }
    it { expect(page.body).to have_selector('i.fa.fa-bell') }
  end
# -----------------------------
  describe 'before voting' do
    before :each do
      log_in admin
      visit new_poll_opinion_path
      within '#new_poll_opinion' do
        fill_in 'poll_opinion[question]',
                with: 'question'
        fill_in 'poll_opinion[answers_attributes][0][answer_label]',
                with: 'answer 1'
        fill_in 'poll_opinion[answers_attributes][1][answer_label]',
                with: 'answer 2'
      end
      click_button(I18n.t('helpers.submit.poll_opinion.create'))
      find('.link-to-vote').click
    end
    it { expect(page.body).to have_content('question') }
    it { expect(page.body).to have_content('answer 1') }
    it { expect(page.body).to have_content('answer 2') }
  end
  # -----------------------------
  describe 'as admin after voting' do
    before :each do
      log_in admin
      visit new_poll_opinion_path
      within '#new_poll_opinion' do
        fill_in 'poll_opinion[question]',
                with: 'question'
        fill_in 'poll_opinion[answers_attributes][0][answer_label]',
                with: 'answer 1'
        fill_in 'poll_opinion[answers_attributes][1][answer_label]',
                with: 'answer 2'
      end
      click_button(I18n.t('helpers.submit.poll_opinion.create'))
      find('.link-to-vote').click
      find('.vote_opinion_answer').choose('answer 2')
      click_button(I18n.t('votes.new_opinion'))
    end
    it { expect(page.body).to have_content(I18n.t('votes.save_success')) }
    it 'empty the poll\'s page' do
      expect(page.find('#expecting_answer')).not_to have_content('question')
      click_link(I18n.t('polls.voted'))
      expect(page.find('#voted')).to have_content('question')
    end
    it { expect(page.body).not_to have_selector('i.fa.fa-bell') }
  end
end
