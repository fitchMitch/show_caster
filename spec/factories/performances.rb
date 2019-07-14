# frozen_string_literal: true

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

FactoryBot.define do
  factory :performance do
    event_date      { Time.zone.now + 2.days }
    duration        { 75 }
    note            { 'MyText' }
    title           { 'Les mentals enterrés' }
    theater
    user
    provider        { 'google' }
    fk              { 'a' * 40 }

    factory :performance_with_actors do
      transient do
        actors_count { 6 }
      end
      after(:create) do |performance, evaluator|
        create_list(:actor, evaluator.actors_count, performance: performance)
      end
    end
    factory :performance_with_actors_standard do
      transient do
        actors_count { 5 }
        mc_count { 1 }
        dj_count { 1 }
      end
      after(:create) do |performance, evaluator|
        create_list(
          :actor,
          evaluator.actors_count,
          stage_role: 'player',
          performance: performance
        )
        create_list(
          :actor,
          evaluator.mc_count,
          stage_role: 'mc',
          performance: performance
        )
        create_list(
          :actor,
          evaluator.dj_count,
          stage_role: 'dj',
          performance: performance
        )
      end
    end

    factory :performance_with_picture do
      transient do
        picture_count { 4 }
      end
      after(:create) do |event|
        create(:picture, imageable: event)
      end
    end
  end
end
