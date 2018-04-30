# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  firstname       :string
#  lastname        :string
#  email           :string
#  last_sign_in_at :datetime
#  status          :integer          default("setup")
#  provider        :string
#  uid             :string
#  address         :string
#  cell_phone_nr   :string
#  photo_url       :string
#  role            :integer          default("player")
#  token           :string
#  refresh_token   :string
#  expires_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  color           :string
#

include Users::Formating
FactoryBot.define do
  sequence :email do |n|
    FFaker::Internet.unique.free_email
  end
end
FactoryBot.define do
  sequence :uid do |n|
    105205260860063499768 + 1 + n
  end
end

FactoryBot.define do
  factory :user do
    firstname               {FFaker::NameFR.unique.first_name}
    lastname                {FFaker::NameFR.unique.last_name.upcase}
    email
    role                    2
    status                  3

    trait :player do
      role                  0
    end
    trait :admin_com do
      role                  1
    end
    trait :admin do
      role                  2
    end
    trait :other_player do
      role                  3
    end

    trait :setup do
      status                0
    end
    trait :invited do
      status                1
    end
    trait :googled do
      status                2
    end
    trait :registered do
      status                3
      cell_phone_nr         {format_by_two(FFaker::PhoneNumberFR::mobile_phone_number)}
      address               {FFaker::AddressFR::unique.full_address}
    end
    trait :archived do
      status                4
      cell_phone_nr         {format_by_two(FFaker::PhoneNumberFR::mobile_phone_number)}
      address               {FFaker::AddressFR::unique.full_address}
    end
  end
end
