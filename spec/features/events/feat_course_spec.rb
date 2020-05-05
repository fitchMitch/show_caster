require 'rails_helper'
include ActionView::Helpers::DateHelper
include EventsHelper

# require 'vcr'

RSpec.feature  'Course | ' do
  feature 'as a registered admin' do
    given!(:admin) { create(:user, :admin, :registered, lastname: 'ADMIN') }
    given!(:course) { create(:course) } # in two days (future)
    given!(:passed_course) do
      create(:course, event_date: Time.zone.now - 2.days)
    end
    given!(:course_w) { create(:course_with_coach) } # in two days
    given!(:theater_w) { create(:theater) }
    given(:note) { 'Du nanan' }
    given(:title) { 'Un bien bon petit cours' }
    given(:google_service) { double('google_service') }
    given(:result) { double('result', id: 1_231_045_874_521) }

    feature 'visiting INDEX' do
      background :each do
        log_in admin
        visit courses_path
      end

      scenario 'should list the courses' do
        expect(page.body).to have_selector(
          'h2', text: I18n.t('courses.list')
        )
      end
      scenario 'should propose an add button' do
        expect(page.body).to have_link(I18n.t('courses.new_button'))
      end
      scenario 'should list some courses in the future' do
        expect(page.body).to have_content(course.note)
        expect(page.body).to have_content(course_w.note)
      end
      scenario 'should list some courses in the past' do
        expect(page.body).to have_content(passed_course.note)
      end
      scenario 'you cannot delete links and image in the past' do
        click_link(I18n.t('courses.passed_events_title'))
        expect(page.find('.tab-content')).not_to have_selector('a > i.fa.fa-trash.fa-lg')
      end
      scenario 'delete links and image links when in the future' do
        expect(page.find('.tab-content')).to have_selector('a > i.fa.fa-trash.fa-lg')
      end
    end

    feature 'visiting CREATE' do
      background :each do
        log_in admin
        allow(GoogleCalendarService).to receive(:new) { google_service }
        allow(google_service).to receive(:add_to_google_calendar) { result }
      end
      scenario 'it shall create a Course' do
        visit new_course_path
        #--------------------
        # inside new page
        #--------------------
        within '#new_course' do
          fill_in 'course[title]', with: title
          fill_in 'course[note]', with: note
        end
        page.find('#course_theater_id')
            .find(:xpath, 'option[1]')
            .select_option
        page.find('#course_duration')
            .find(:xpath, 'option[3]')
            .select_option
        click_button(I18n.t('helpers.submit.course.create'))
        #--------------------
        # inside index page
        #--------------------
        # click_link(
        #   ActionView::Base.full_sanitizer.sanitize(
        #     passed_label(Course.all)
        #   ).strip # clic sur 'cours du temps passé'
        # )
        expect(page.body).to have_content('40') # minutes
        expect(page.body).to have_content(note)

        click_link(title)
        #--------------------
        # inside show page
        #--------------------
        expect(page.body).to have_content('40')
        expect(page.body).to have_content(note)
        expect(page.body).to have_content(
          Course.all.last.courseable.full_name
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
        # inside new course
        #--------------------
        visit edit_course_path(course_w)
        within "#edit_course_#{course_w.id}" do
          fill_in 'course[title]', with: title
          fill_in 'course[note]', with: note
        end
        page.find('#course_theater_id')
            .find(:xpath, 'option[1]')
            .select_option
        page.find('#course_duration')
            .find(:xpath, 'option[4]')
            .select_option
        click_button(I18n.t('helpers.submit.course.update'))
      end

      scenario 'it shall update Events' do
        #--------------------
        # inside courses_page
        #--------------------
        expect(page.body).to have_content I18n.t('events.updated_with_Google')
        click_link(title)
        #--------------------
        # inside show page
        #--------------------
        expect(page.body).to have_content Event::DURATIONS.rassoc(
          course_w.duration
        ).first
        expect(find_field(I18n.t('courses.title')).value).to eq(title)
        expect(find_field(I18n.t('performances.note')).value).to eq(note)
        expect(
          page.find('#course_coaches_list').select.text
        ).to have_content(course_w.courseable.full_name)
      end
    end

    feature 'visiting UPDATE with Google unknown event' do
      background :each do
        allow(GoogleCalendarService).to receive(:new) { google_service }
        allow(google_service).to receive(:update_google_calendar) { 'a string' }
        log_in admin
        #--------------------
        # inside new course
        #--------------------
        visit edit_course_path(course_w)
        within "#edit_course_#{course_w.id}" do
          fill_in 'course[title]', with: title
          fill_in 'course[note]', with: note
        end
        page.find('#course_theater_id')
            .find(:xpath, 'option[1]')
            .select_option
        page.find('#course_duration')
            .find(:xpath, 'option[4]')
            .select_option
        click_button(I18n.t('helpers.submit.course.update'))
      end

      scenario 'it shall not update Events though' do
        expect(page.body).to have_content(I18n.t('events.desynchronized'))
        expect(page.body).to have_selector(
          'h2',
          text: I18n.t('courses.list')
        )
      end
    end

    feature '#delete' do
      given!(:count) { Course.all.count }
      feature 'visiting DELETE fails with an ' \
              ' existing Google event associated' do
        background :each do
          allow(GoogleCalendarService).to receive(:new) { google_service }
          allow(google_service).to receive(:delete_google_calendar) { result }
          log_in admin
          visit courses_path
          page.find('.destroy', match: :first).click
        end

        scenario 'it shall delete Events' do
          # scenario "it shall delete Events",:vcr do
          expect(page.body).to have_content(I18n.t('performances.destroyed'))
          expect(page.body).to have_selector(
            'h2',
            text: I18n.t('courses.list')
          )
          expect(count).to eq(Course.all.count + 1)
        end
      end
      feature 'visiting DELETE fails with no Google event associated' do
        background :each do
          allow(GoogleCalendarService).to receive(:new) { google_service }
          allow(google_service).to receive(:delete_google_calendar) { nil }
          log_in admin
          visit courses_path
          page.find('.destroy', match: :first).click
        end

        scenario 'it shall delete Events' do
          # scenario "it shall delete Events",:vcr do
          expect(page.body).to have_content(
            I18n.t('performances.google_locked')
          )
          expect(page.body).to have_selector(
            'h2',
            text: I18n.t('courses.list')
          )
          expect(count).to eq(Course.all.count + 1)
        end
      end
    end
  end
end
