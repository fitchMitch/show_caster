# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Coach' do
  feature 'as a registered admin' do
    given!(:admin) { create(:user, :admin, :registered, lastname: 'ADMIN') }
    feature 'visiting INDEX' do
      background :each do
        log_in admin
        3.times { create(:coach) }
        visit coaches_path
      end
      it 'should list 3 members' do
        expect(page.body).to have_selector('.coach-desc', count: 3)
      end
      it 'should list the coaches list' do
        expect(page.body).to have_selector('h2', text: I18n.t('coaches.list'))
      end
      it 'should have an add button' do
        expect(page.body).to have_selector('.btn', text: I18n.t('coaches.new'))
      end
      it 'should lead to a new coach page' do
        visit new_coach_path
        expect(page.body).to have_selector('h2', text: I18n.t('coaches.new'))
      end
    end

    feature 'visiting NEW and CREATE' do
      background :each do
        log_in admin
        visit new_coach_path
        within '#coach_new' do
          fill_in 'coach_firstname', with: 'Edouard IV'
          fill_in 'coach_lastname', with: 'berurier'
          fill_in 'coach_email', with: 'bg@fra.fr'
          fill_in 'coach_cell_phone_nr', with: '0123654789'
          fill_in 'coach_note', with: 'fracan'
        end
        click_button(I18n.t('helpers.submit.coach.create'))
      end

      scenario 'it shall create a Coach' do
        coach = Coach.last
        expect(page.body).to have_content I18n.t('coaches.save_success')
        page_attr_matcher(
          coach,
          %w[firstname lastname email note cell_phone_nr]
        )
      end
    end

    feature 'visiting UPDATE' do
      background :each do
        log_in admin
        coach = create(:coach)
        visit edit_coach_path(coach)
        within '#coach_new' do
          fill_in 'coach_firstname', with: 'Edouard IV'
          fill_in 'coach_lastname', with: 'berurier'
          fill_in 'coach_email', with: 'bg@fra.fr'
          fill_in 'coach_cell_phone_nr', with: '0123654789'
          fill_in 'coach_note', with: 'fracan'
        end
        click_button(I18n.t('helpers.submit.coach.update'))
      end

      scenario 'it shall create a Coach' do
        coach = Coach.last
        expect(page.body).to have_content I18n.t('coaches.update_success')
        page_attr_matcher(coach, %w[firstname lastname email note cell_phone_nr])
      end
    end

    feature 'visiting UPDATE fails' do
      background :each do
        log_in admin
        coach = create(:coach)
        visit edit_coach_path(coach)
        within '#coach_new' do
          fill_in 'coach_firstname', with: ''
          fill_in 'coach_lastname', with: 'berurier'
          fill_in 'coach_email', with: 'bg@fra.fr'
          fill_in 'coach_cell_phone_nr', with: '0123654789'
          fill_in 'coach_note', with: 'fracan'
        end
        click_button(I18n.t('helpers.submit.coach.update'))
      end

      scenario 'it shall create a Coach' do
        expect(page.body).to have_content(I18n.t('coaches.save_fails'))
        expect(page.body).to have_selector('h2', text: I18n.t('edit'))
      end
    end
  end
end
