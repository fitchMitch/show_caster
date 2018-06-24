# == Schema Information
#
# Table name: coaches
#
#  id            :integer          not null, primary key
#  firstname     :string
#  lastname      :string
#  email         :string
#  cell_phone_nr :string
#  note          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
include Users::Formating
FactoryBot.define do
  factory :coach do
    firstname
    lastname
    email
    cell_phone_nr
    note                    {FFaker::LoremFR.phrases(2).join('')}
  end
end
