# == Schema Information
#
# Table name: votes
#
#  id         :integer          not null, primary key
#  poll_id    :integer
#  answer_id  :integer
#  user_id    :integer
#  type       :string
#  vote_label :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# FactoryBot.define do
#   factory :vote do
#     user
#     poll
#     answer
#   end
# end
