# == Schema Information
#
# Table name: events
#
#  id              :integer          not null, primary key
#  event_date      :datetime
#  duration        :integer
#  progress        :integer          default("draft")
#  note            :text
#  user_id         :integer
#  theater_id      :integer
#  fk              :string
#  provider        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  title           :string
#  type            :string           default("Performance")
#  courseable_id   :integer
#  courseable_type :string
#

require 'rails_helper'

RSpec.describe Course, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:theater) }
  it { should validate_presence_of(:event_date) }

  describe 'scope next_courses' do
    let!(:now) { Time.zone.now }
    let(:user) { create(:user) }
    let!(:course) { create(:course, event_date: now - 3.days) }
    let!(:course1) { create(:course, event_date: now + 2.days) }
    let!(:course2) { create(:course, event_date: now + 4.days) }
    it 'should give you 2 courses' do
      expect(Course.next_courses.to_a.size).to eq(2)
    end
    it 'should have course1 as first' do
      expect(
        Course.next_courses.to_a.first.event_date.to_i
      ).to eq (now + 2.days).to_i
    end
  end
  describe '#google_event_params' do
    let!(:course) { create(:course) }
    it 'should set google calendar params ok' do
      expect(course.google_event_params).to eq(
        {
          title: I18n.t(
            'courses.g_title_course', name: course.theater.theater_name
          ),
          location: course.theater.location,
          theater_name: course.theater.theater_name,
          event_date: course.event_date.iso8601,
          event_end: (course.event_date + course.duration * 60).iso8601,
          attendees_email: [],
          fk: course.fk
        }
      )
    end
  end
end
