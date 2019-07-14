# frozen_string_literal: true

FactoryBot.define do
  factory :announce do
    title               { FFaker::Lorem.sentence(1)[0..39] }
    body                { FFaker::Lorem.sentence(3)[0..249] }
    author
    time_start          { Time.zone.now + (1..10).to_a.sample.days }
    time_end            { time_start + (1..10).to_a.sample.days }
  end
end
