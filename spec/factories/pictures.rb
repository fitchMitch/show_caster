# == Schema Information
#
# Table name: pictures
#
#  id         :integer          not null, primary key
#  fk         :string
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :picture do
    fk "MyString"
    event
  end
end
