FactoryBot.define do
  factory :actor do
    performance
    user
    stage_role    {(0..3).to_a.sample }
  end
end
