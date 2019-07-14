# frozen_string_literal: true

FactoryBot.define do
  factory :vote_opinion do
    user
    poll_opinion
    type { 'VoteOpinion' }
    vote_label { (0..1).to_a.sample }
    association :answer, factory: :answer_opinion

    after(:create) do |vote|
      vote.poll_id = vote.answer.poll_id
      vote.save
    end
  end
end

FactoryBot.define do
  factory :vote_date do
    user
    poll_date
    type { 'VoteDate' }
    vote_label { (0..2).to_a.sample }
    association :answer, factory: :answer_date

    after(:create) do |vote|
      vote.poll_id = vote.answer.poll_id
      vote.save
    end
  end
end
