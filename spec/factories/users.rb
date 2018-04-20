# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  firstname       :string
#  lastname        :string
#  email           :string
#  last_sign_in_at :datetime
#  status          :integer          default(0)
#  provider        :string
#  uid             :string
#  address         :string
#  cell_phone_nr   :string
#  photo_url       :string
#  role            :integer          default(0)
#  token           :string
#  refresh_token   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :user do
    firstname "MyString"
    lastname "MyString"
    email "MyString"
    last_sign_in_at "2018-04-20 12:59:32"
    status 1
    provider "MyString"
    uid "MyString"
    address "MyString"
    cell_phone_nr "MyString"
    photo_url "MyString"
    role 1
    token "MyString"
    refresh_token "MyString"
  end
end
