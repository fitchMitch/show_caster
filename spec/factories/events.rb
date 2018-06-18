# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  event_date :datetime
#  duration   :integer
#  progress   :integer          default("draft")
#  note       :text
#  user_id    :integer
#  theater_id :integer
#  fk         :string
#  provider   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  title      :string
#

FactoryBot.define do
  factory :event do
    event_date      Time.zone.now + 2.days
    duration        100
    note            "MyText"
    title           "Les mentals enterrés"
    theater
    # user
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

    factory :event_with_picture do
      transient do
        picture_count 1
      end
      after(:create) do |event|
        create(:picture, imageable: event)
      end
    end
  end
end
