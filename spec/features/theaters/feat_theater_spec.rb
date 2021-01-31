require 'rails_helper'

RSpec.feature  'Theater' do
  feature 'as a registered admin' do
    given!(:admin) { create(:user, :admin, :registered, lastname: 'ADMIN') }
    feature 'visiting INDEX' do
      background :each do
        sign_in admin
        3.times { create(:theater) }
        visit theaters_path
      end
      it 'should list 3 theaters' do
        expect(page.body).to have_selector('.theater-desc', count: 3)
      end
      it 'should list the theater\'s band members' do
        expect(page.body).to have_selector('h2', text: I18n.t('theaters.list'))
      end
      it 'should propose an add button' do
        visit new_theater_path
        expect(page.body).to have_selector('h2', text: I18n.t('theaters.new'))
      end
      it 'should lead to a new theater page' do
        visit new_theater_path
        expect(page.body).to have_selector('h2', text: I18n.t('theaters.new'))
      end
    end

    feature 'visiting NEW and CREATE' do
      background :each do
        sign_in admin
        visit new_theater_path
        within '#new_theater' do
          fill_in 'theater_theater_name', with: 'Edouard IV'
          fill_in 'theater_location', with: 'the place to be'
          fill_in 'theater_manager', with: 'Edouard himself'
          fill_in 'theater_manager_phone', with: '0123654789'
        end
        click_button(I18n.t('helpers.submit.theater.create'))
      end

      scenario 'it shall create a Theater' do
        theater = Theater.last
        expect(page.body).to have_content I18n.t('theaters.save_success')
        page_attr_matcher(
          theater, %w[theater_name location manager manager_phone]
        )
      end
    end

    feature 'visiting UPDATE' do
      background :each do
        sign_in admin
        theater = create(:theater)
        visit edit_theater_path(theater)
        within "#edit_theater_#{theater.id}" do
          fill_in 'theater_theater_name', with: 'Edouard IV'
          fill_in 'theater_location', with: 'the place to be'
          fill_in 'theater_manager', with: 'Edouard himself'
          fill_in 'theater_manager_phone', with: '0123654789'
        end
        click_button(I18n.t('helpers.submit.theater.update'))
      end

      scenario 'it shall create a Theater' do
        theater = Theater.last
        expect(page.body).to have_content I18n.t('theaters.update_success')
        page_attr_matcher(
          theater, %w[theater_name location manager manager_phone]
        )
      end
    end

    feature 'visiting UPDATE fails' do
      background :each do
        sign_in admin
        theater = create(:theater)
        visit edit_theater_path(theater)
        within "#edit_theater_#{theater.id}" do
          fill_in 'theater_theater_name', with: ''
          fill_in 'theater_location', with: 'the place to be'
          fill_in 'theater_manager', with: 'Edouard himself'
          fill_in 'theater_manager_phone', with: '0123654789'
        end
        click_button(I18n.t('helpers.submit.theater.update'))
      end

      scenario 'it shall create a Theater' do
        expect(page.body).to have_content(I18n.t('theaters.save_fails'))
        expect(page.body).to have_selector(
          'h2', text: I18n.t('theaters.edit_theater')
        )
      end
    end
  end
end
