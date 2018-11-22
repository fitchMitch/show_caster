#
FactoryBot.define do
  factory :committee do
    name        { "Commission #{FFaker::Animal.common_name}" }
    mission     { FFaker::LoremFR.phrases(2).join('') }
  end
end
