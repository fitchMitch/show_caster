# == Schema Information
#
# Table name: teachers
#
#  id             :integer          not null, primary key
#  teachable_type :string
#  teachable_id   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryBot.define do
  factory :teacher do
    teachable nil
  end
end
