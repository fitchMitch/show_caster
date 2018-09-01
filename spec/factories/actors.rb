# == Schema Information
#
# Table name: actors
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  user_id    :integer
#  stage_role :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :actor do
    performance
    user
    stage_role    {(0..3).to_a.sample }
  end
end
