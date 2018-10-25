FactoryBot.define do
  factory :comment, class: 'Commontator::Comment' do
    creator
    editor
    deleted_at { Time.zone.now - 3.days }
    thread
    body { FFaker::Lorem.sentence(3) }
  end
end
