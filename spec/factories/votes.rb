# == Schema Information
#
# Table name: votes
#
#  id         :integer          not null, primary key
#  poll_id    :integer
#  answer_id  :integer
#  user_id    :integer
#  type       :string
#  comment    :string
#  vote_label :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :vote do
    comment { FFaker::Lorem.sentence(1)}
    user
    poll
    answer
    factory :vote_opinion do
      vote_label { (0..1).to_a.sample }
      association :answer, factory: :answer_opinion
      after(:create) do |vote|
        vote.poll_id = vote.answer.poll_opinion.id
      end
    end

    factory :vote_date do
      vote_label { (0..2).to_a.sample }
      association :answer, factory: :answer_date
      after(:create) do |vote|
        vote.poll_id = vote.answer.poll_date.id
      end
    end
  end
end
