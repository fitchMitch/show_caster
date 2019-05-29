FactoryBot.define do
  factory :announce do
    title               { FFaker::Lorem.sentence(1)[0..39] }
    body                { FFaker::Lorem.sentence(3)[0..249] }
    author
    time_start          { Time.zone.now + (1..10).to_a.sample.days }
    time_end            { time_end + (1..10).to_a.sample.days }
  end
end
