require 'rails_helper'

RSpec.feature Exercice do
  feature 'as a registered admin' do
    given!(:admin) { create(:user, :admin, :registered, lastname: 'ADMIN') }
    feature 'visiting INDEX' do
      background :each do
        log_in admin
        3.times { create(:exercice) }
        visit exercices_path
      end
      it 'should list 3 exercices' do
        expect(page.body).to have_selector('.exercice-desc', count: 3)
      end
      it 'should list the exercice\'s band members' do
        expect(page.body).to have_selector('h2', text: I18n.t('exercices.list'))
      end
      it 'should propose an add button' do
        click_link I18n.t("exercices.new")
        expect(page.body).to have_selector('h2', text: I18n.t('exercices.new'))
      end
      it 'should lead to a new exercice page' do
        visit new_exercice_path
        expect(page.body).to have_selector('h2', text: I18n.t('exercices.new'))
      end
    end

    feature 'visiting NEW and CREATE' do
      background :each do
        log_in admin
        visit new_exercice_path
        within '#new_exercice' do
          fill_in 'exercice_title', with: 'Edouard IV'
          fill_in 'exercice_focus', with: 'the place to be'
          fill_in 'exercice_promess', with: 'Edouard himself'
          fill_in 'exercice_instructions', with: 'dial 0123654789'
        end
        click_button(I18n.t('helpers.submit.exercice.create'))
      end

      scenario 'it shall create a Exercice and some of its attributes are to' \
               ' be seen on index page' do
        exercice = Exercice.last
        expect(page.body).to have_content I18n.t('exercices.save_success')
        page_attr_matcher(
          exercice,
          %w[title instructions]
        )
        expect(page).to have_content(exercice.category_i18n)
        expect(page.body).to include(exercice.energy_level_i18n)
        expect(page.body).to include(exercice.max_people_i18n.to_s)
        # %w[title instructions focus promess category energy_level max_people]
      end
    end

    feature 'visiting UPDATE' do
      background :each do
        log_in admin
        exercice = create(:exercice)
        visit edit_exercice_path(exercice)
        within "#edit_exercice_#{exercice.id}" do
          fill_in 'exercice_title', with: 'Edouard IV'
          fill_in 'exercice_focus', with: 'the place to be'
          fill_in 'exercice_promess', with: 'Edouard himself'
          fill_in 'exercice_instructions', with: 'dial 0123654789'
          fill_in 'exercice_focus', with: 'focus you !'
          fill_in 'exercice_promess', with: 'a new you !'
        end
        click_button(I18n.t('helpers.submit.exercice.update'))
      end

      scenario 'it shall create a Exercice' do
        exercice = Exercice.last
        expect(page.body).to have_content I18n.t('exercices.update_success')
        page_attr_matcher( exercice, %w[title instructions] )
        expect(page).to have_content(exercice.category_i18n)
        expect(page.body).to include(exercice.energy_level_i18n)
        expect(page.body).to include(exercice.max_people_i18n.to_s)

        visit(exercice_path(exercice))
        page_attr_matcher( exercice, %w[focus promess instructions title] )
        expect(page).to have_content(exercice.category_i18n)
        expect(page.body).to include(exercice.energy_level_i18n)
        expect(page.body).to include(exercice.max_people_i18n.to_s)
      end
    end

    feature 'visiting UPDATE fails' do
      background :each do
        log_in admin
        exercice = create(:exercice)
        visit edit_exercice_path(exercice)
        within "#edit_exercice_#{exercice.id}" do
          fill_in 'exercice_title', with: 'a'
        end
        click_button(I18n.t('helpers.submit.exercice.update'))
      end

      scenario 'it shall create a Exercice' do
        expect(page.body).to have_content(I18n.t('exercices.save_fails'))
        expect(page.body).to have_selector(
          'h2', text: I18n.t('exercices.edit_exercice')
        )
      end
    end
  end
end
