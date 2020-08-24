# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id              :integer          not null primary key
#  event_date      :datetime
#  duration        :integer
#  progress        :integer          default(draft)
#  note            :text
#  user_id         :integer
#  theater_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  title           :string
#  type            :string           default(Performance)
#  courseable_id   :integer
#  courseable_type :string
#
FactoryBot.define do
  factory :course do
    event_date      { Time.zone.now + 2.days }
    duration        { Event::DURATIONS.sample.second }
    note            { 'MyText' }
    title           { 'Un bon petit cours de derrière les fagots' }
    theater
    user
    progress        { 0 }
    type            { 'Course' }

    factory :course_with_coach do
      association :courseable, factory: :coach
    end
    factory :auto_coached_course do
      association :courseable, factory: :user
    end
  end
end
