# == Schema Information
#
# Table name: events
#
#  id                      :integer          not null, primary key
#  event_date              :datetime
#  datetime with time zone :datetime
#  duration                :integer
#  progress                :integer
#  note                    :text
#  user_id                 :integer
#  theater_id              :integer
#  fk                      :string
#  provider                :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

FactoryBot.define do
  factory :event do
    event_date      Time.zone.now + 2.days
    duration        100
    note            "MyText"
    theater
    user
    provider        "google"
    fk              {"a" * 40}
    progress        0

    factory :event_with_actors do

      transient do
        actors_count 6
      end

      after(:create) do |event, evaluator|
        create_list(:actor, evaluator.actors_count, event: event)
      end
    end
  end
end
