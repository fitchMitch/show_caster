include Users::Formating
FactoryBot.define do
  sequence :email do |n|
    FFaker::Internet.unique.free_email
  end
end
FactoryBot.define do
  sequence :cell_phone_nr do |n|
    format_by_two(FFaker::PhoneNumberFR::unique.mobile_phone_number)
  end
end
FactoryBot.define do
  sequence :address do |n|
    FFaker::AddressFR::unique.full_address
  end
end
FactoryBot.define do
  sequence :firstname do |n|
    FFaker::NameFR.unique.first_name
  end
end
FactoryBot.define do
  sequence :lastname do |n|
    FFaker::NameFR.unique.last_name.upcase
  end
end
FactoryBot.define do
  sequence :uid do |n|
    105205260860063499768 + 1 + n
  end
end

FactoryBot.define do
  factory :user, aliases: %i[owner creator editor author] do
    firstname
    lastname
    email
    role                    { 2 } # Default is admin
    status                  { 3 } # Default is registered
    uid
    bio                     { "Sa bio : #{FFaker::Lorem.sentence(7).truncate(250)}" }
    alternate_email         { FFaker::Internet.email }

    trait :player do
      role                 { 0 }
    end
    trait :admin_com do
      role                 { 1 }
    end
    trait :admin do
      role                 { 2 }
    end
    trait :other_player do
      role                  { 3 }
    end

    trait :setup do
      status                { 0 }
    end
    trait :invited do
      status                { 1 }
    end
    trait :googled do
      status                { 2 }
    end
    trait :registered do
      status                { 3 }
      cell_phone_nr
      address
    end
    trait :archived do
      status                { 4 }
      cell_phone_nr
      address
    end

    factory :user_with_picture do
      after(:create) do |user|
        create(:picture, imageable: user)
      end
    end
  end
end
