FactoryBot.define do
  factory :vote_opinion do
    user
    poll
    type { 'VoteOpinion' }
    vote_label { (0..1).to_a.sample }
    association :answer, factory: :answer_opinion
    after(:create) do |vote|
      vote.poll_id = vote.answer.poll_opinion.id
    end
  end
end
