# frozen_string_literal: true

require 'rails_helper'

RSpec.feature Exercice do
  given!(:admin) { create(:user, :admin, :registered, lastname: 'ADMIN') }
  feature 'as a registered admin' do
    describe 'searching through categories' do
      background do
        log_in admin
        visit exercices_path
      end
      it { expect(page.body).to have_selector('#q_title_or_instructions_cont') }
      it { expect(page.body).to have_selector('#q_category_eq') }
      it { expect(page.body).to have_selector('#q_energy_level_eq') }
      it { expect(page.body).to have_selector('#q_skills_name_in') }
    end
  end

  describe 'searching through categories', js: true do
    let!(:exercice1) { create(:exercice, category: 'imagination') }
    let!(:exercice2) { create(:exercice, category: 'imagination') }
    let!(:exercice3) do
      create(
        :exercice,
        category: 'connexion',
        instructions: 'test instructions'
      )
    end

    background do
      log_in admin
      visit exercices_path
      select(I18n.t('enums.exercice.category.imagination'), from: 'q[category_eq]')
      sleep 0.95
    end
    it 'should find two records ' do
      expect(page.body).to have_selector('.exo-category', count: 2)
      expect(page.body).not_to have_content('test instructions')
    end
  end

  describe 'searching through text', js: true do
    let!(:exercice1) do
      create(:exercice,
             category: 'imagination',
             title: 'errare humanum est',
             energy_level: 'high')
    end
    let!(:exercice2) do
      create(:exercice,
             category: 'imagination',
             title: 'test',
             energy_level: 'high')
    end
    let!(:exercice3) do
      create(
        :exercice,
        category: 'connexion',
        instructions: 'test instructions',
        energy_level: 'high'
      )
    end
    background do
      log_in admin
      visit exercices_path
      fill_in(
        'q[title_or_instructions_cont]', with: 'test'
      )
      page.execute_script("$('form').submit()")
      sleep 0.95
    end

    it 'should find records according to situations' do
      expect(page.body).to have_selector('.exo-category', count: 2)
      expect(page.body).not_to have_content('humanum')
      create(
        :exercice,
        energy_level: 'low', title: 'miracle',
        instructions: 'share bread and wine'
      )
      select(
        I18n.t('enums.exercice.energy_level.low'), from: 'q[energy_level_eq]'
      )
      page.execute_script("$('form').submit()")
      sleep 0.95
      # because of 'test' in the input field
      expect(page.body).to have_selector('.exo-category', count: 0)
      fill_in(
        'q[title_or_instructions_cont]', with: ''
      )
      page.execute_script("$('form').submit()")
      sleep 0.95
      expect(page.body).to have_selector('.exo-category', count: 1)
    end
  end
end
