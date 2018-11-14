FactoryBot.define do
  factory :vote_opinion do
    user
    poll
    association :answer, factory: :answer_opinion
    vote_label { (0..1).to_a.sample }
    after(:create) do |vote|
      vote.poll_id = vote.poll.id
    end
    type { 'VoteOpinion' }
  end
end

FactoryBot.define do
  factory :vote_date do
    user
    poll
    type { 'VoteDate' }
    vote_label { (0..2).to_a.sample }
    association :answer, factory: :answer_date
    after(:create) do |vote|
      vote.poll_id = vote.answer.poll_date.id
    end
  end
end
