FactoryBot.define do
  factory :announce do
    title { FFaker::Lorem.sentence(1)[0..39] }
    body  { FFaker::Lorem.sentence(3)[0..249] }
    author
    expiration_date    { Time.zone.now + (1..10).to_a.sample.days }
  end
end
