# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  firstname       :string
#  lastname        :string
#  email           :string
#  last_sign_in_at :datetime
#  status          :integer          default("set_up")
#  provider        :string
#  uid             :string
#  address         :string
#  cell_phone_nr   :string
#  photo_url       :string
#  role            :integer          default("player")
#  token           :string
#  refresh_token   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  sequence :email do |n|
    FFaker::Internet.unique.free_email
  end
end

FactoryBot.define do
  factory :user do
    firstname               {FFaker::NameFR.unique.first_name}
    lastname                {FFaker::NameFR.unique.last_name}
    email
    role =                  0
    status =                0

    trait :player do
      role =                0
    end
    trait :admin_com do
      role =                1
    end
    trait :admin do
      role =                2
    end
    trait :other_player do
      role =                3
    end

    trait :set_up do
      status =            0
    end
    trait :invited do
      status =            1
    end
    trait :googled do
      status =            2
    end
    trait :full_registered do
      status =            3
    end
    trait :archived do
      status =            4
    end
  end
end
