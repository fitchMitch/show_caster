require 'rails_helper'
include ActionView::Helpers::DateHelper
include EventsHelper

# require 'vcr'

RSpec.feature  'Performance | ' do
  feature 'as a registered admin' do
    given!(:admin) { create(:user, :admin, :registered, lastname: 'ADMIN') }
    given!(:performance) { create(:performance) }
    given!(:passed_performance) do
      create(:performance, event_date: Time.zone.now - 2.days)
    end
    given!(:performance_w) { create(:performance_with_actors) }
    given!(:theater_w) { create(:theater_with_performance) }
    given(:note) { 'Du nanan' }
    given(:title) { 'Un bien bon spectacle' }
    given(:google_service) { double('google_service') }
    given(:result) { double('result', id: 1_231_045_874_521) }

    feature 'visiting INDEX' do
      background :each do
        log_in admin
        visit performances_path
      end

      scenario 'should list the performances' do
        expect(page.body).to have_selector(
          'h2', text: I18n.t('performances.list')
        )
      end
      scenario 'should propose an add button' do
        expect(page.body).to have_link(I18n.t('performances.new_button'))
      end
      scenario 'should list some performances in the future' do
        expect(page.body).to have_content(performance.note)
        expect(page.body).to have_content(performance_w.note)
      end
      scenario 'should list some performances in the past' do
        expect(page.body).to have_content(passed_performance.note)
      end
      scenario 'delete and image links are shownaccording to past or future', js: true do
        # save_and_open_page
        click_link(I18n.t('performances.nexting'))
        expect(page.body).to have_selector('a > i.fa.fa-trash.fa-lg')
        expect(page.body).to have_selector('a > i.fa.fa-trash.fa-lg', count: 3)
        click_link(
          ActionView::Base.full_sanitizer.sanitize(
            passed_label(Performance.all)
          ).strip
        )
        expect(page.body).to have_selector('a > i.fa.fa-image.fa-lg', count: 2)
      end
    end

    feature 'visiting CREATE' do
      background :each do
        log_in admin
        allow(GoogleCalendarService).to receive(:new) { google_service }
        allow(google_service).to receive(:add_to_google_calendar) { result }
      end
      scenario 'it shall create a Performance' do
        visit new_performance_path
        #--------------------
        # inside new page
        #--------------------
        within '#new_performance' do
          fill_in 'performance[title]', with: title
          fill_in 'performance[note]', with: note
        end
        page.find('#performance_theater_id')
            .find(:xpath, 'option[1]')
            .select_option
        page.find('#performance_duration')
            .find(:xpath, 'option[3]')
            .select_option
        click_button(I18n.t('helpers.submit.event.new'))
        #--------------------
        # inside index page
        #--------------------
        expect(page.body).to have_content(I18n.t('performances.created'))
        click_link(
          ActionView::Base.full_sanitizer.sanitize(
            passed_label(Performance.all)
          ).strip
        )
        expect(page.body).to have_content(note)
        expect(page.body).to have_content(40) # minutes
        click_link(title)
        #--------------------
        # inside show page
        #--------------------
        expect(page.body).to have_content(40)
        expect(page.body).to have_content(title)
        expect(page.body).to have_content(note)
        expect(page.body).to have_content(
          Performance.last.actors.first.user.firstname_extended
        )
        expect(page.body).to have_content(
          Performance.last.actors.last.user.firstname_extended
        )
      end
    end

    feature 'visiting UPDATE' do
      given(:google_service) { double('google_service') }
      background :each do
        allow(GoogleCalendarService).to receive(:new) { google_service }
        allow(google_service).to receive(:update_google_calendar) { result }
        log_in admin
        #--------------------
        # inside new performance
        #--------------------
        visit edit_performance_path(performance_w)
        within "#edit_performance_#{performance_w.id}" do
          fill_in 'performance[title]', with: title
          fill_in 'performance[note]', with: note
        end
        page.find('#performance_theater_id')
            .find(:xpath, 'option[1]')
            .select_option
        page.find('#performance_duration')
            .find(:xpath, 'option[4]')
            .select_option
        click_button(I18n.t('helpers.submit.performance.update'))
      end

      scenario 'it shall update Events' do
        #--------------------
        # inside performances_page
        #--------------------
        expect(page.body).to have_content I18n.t('events.updated_with_Google')
        click_link(title)
        #--------------------
        # inside show page
        #--------------------
        expect(page.body).to have_content(
          time_ago_in_words((performance_w.duration * 60).seconds.from_now)
        )
        # expect(page.body).to have_content Event::DURATIONS.rassoc(
        #   performance_w.duration
        # )
        expect(page.body).to have_content(title)
        expect(page.body).to have_content(note)
        expect(page.body).to have_content(
          performance_w.actors.first.user.firstname_extended
        )
        expect(page.body).to have_content(
          performance_w.actors.last.user.firstname_extended
        )
      end
    end

    feature 'visiting UPDATE with Google unknown event' do
      background :each do
        allow(GoogleCalendarService).to receive(:new) { google_service }
        allow(google_service).to receive(:update_google_calendar) { 'a string' }
        log_in admin
        #--------------------
        # inside new performance
        #--------------------
        visit edit_performance_path(performance_w)
        within "#edit_performance_#{performance_w.id}" do
          fill_in 'performance[title]', with: title
          fill_in 'performance[note]', with: note
        end
        page.find('#performance_theater_id')
            .find(:xpath, 'option[1]')
            .select_option
        page.find('#performance_duration')
            .find(:xpath, 'option[4]')
            .select_option
        click_button(I18n.t('helpers.submit.performance.update'))
      end

      scenario 'it shall not update Events though' do
        expect(page.body).to have_content(I18n.t('events.desynchronized'))
        expect(page.body).to have_selector(
          'h2',
          text: I18n.t('performances.list')
        )
      end
    end

    feature '#delete' do
      given!(:count) { Performance.all.count }
      feature 'visiting DELETE fails with an ' \
              ' existing Google event associated' do
        background :each do
          allow(GoogleCalendarService).to receive(:new) { google_service }
          allow(google_service).to receive(:delete_google_calendar) { result }
          log_in admin
          visit performances_path
          page.find('.destroy', match: :first).click
        end

        scenario 'it shall delete Events' do
          # scenario "it shall delete Events",:vcr do
          expect(page.body).to have_content(I18n.t('performances.destroyed'))
          expect(page.body).to have_selector(
            'h2',
            text: I18n.t('performances.list')
          )
          expect(count).to eq(Performance.all.count + 1)
        end
      end
      feature 'visiting DELETE fails with no Google event associated' do
        background :each do
          allow(GoogleCalendarService).to receive(:new) { google_service }
          allow(google_service).to receive(:delete_google_calendar) { nil }
          log_in admin
          visit performances_path
          page.find('.destroy', match: :first).click
        end

        scenario 'it shall delete Events' do
          # scenario "it shall delete Events",:vcr do
          expect(page.body).to have_content(
            I18n.t('performances.google_locked')
          )
          expect(page.body).to have_selector(
            'h2',
            text: I18n.t('performances.list')
          )
          expect(count).to eq(Performance.all.count + 1)
        end
      end
    end
  end
end
