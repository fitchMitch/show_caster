# == Schema Information
#
# Table name: theaters
#
#  id            :integer          not null, primary key
#  theater_name  :string
#  location      :string
#  manager       :string
#  manager_phone :string
#
FactoryBot.define do
  factory :theater do
    theater_name        "Kibele"
    location            "12, rue de l'échiquier, PARIS 10"
    manager             "Tolier"
    manager_phone       "0148245774"
  end

  factory :other_theater, class: Theater do
    theater_name        "MJC Oudine"
    location            "25 rue Eugène Oudiné, 75013 PARIS"
    manager             "un autre Tolier"
    manager_phone       "07 35252145"
  end
end
