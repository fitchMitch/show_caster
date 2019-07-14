# frozen_string_literal: true

# == Schema Information
#
# Table name: theaters
#
#  id            :integer          not null, primary key
#  theater_name  :string           not null
#  location      :string
#  manager       :string
#  manager_phone :string
#

FactoryBot.define do
  factory :theater do
    theater_name        { "Au #{FFaker::AnimalUS.common_name} enfumé" }
    location            { FFaker::AddressFR.full_address }
    manager             { 'Tolier' }
    manager_phone       { '0148245774' }

    factory :theater_with_performance do
      transient do
        events_count { 1 }
      end
      after(:create) do |theater, evaluator|
        create_list(:performance, evaluator.events_count, theater: theater)
      end
    end

    factory :theater_with_course do
      transient do
        events_count { 1 }
      end
      after(:create) do |theater, evaluator|
        create_list(:course, evaluator.events_count, theater: theater)
      end
    end
  end

  factory :other_theater, class: Theater do
    theater_name        { 'MJC Oudine' }
    location            { '25 rue Eugène Oudiné, 75013 PARIS' }
    manager             { 'un autre Tolier' }
    manager_phone       { '07 35252145' }
  end
end
