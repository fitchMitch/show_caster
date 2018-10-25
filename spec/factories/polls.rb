FactoryBot.define do
  factory :poll do
    question          { "Poll : #{ FFaker::Lorem::sentence(1)} ?"}
    expiration_date   { Date.today + (1..15).to_a.sample.days }
    owner
    transient do
      answers_count { 3 }
      comments_count { 3 }
    end
  end

  factory :poll_opinion, parent: :poll, class: 'PollOpinion' do
    type { 'PollOpinion' }

    factory :poll_opinion_with_answers do
      after(:create) do |poll_opinion, evaluator|
        create_list(
          :answer_opinion,
          evaluator.answers_count,
          poll_opinion: poll_opinion
        )
      end
      after(:create) do |poll_opinion, evaluator|
        create_list(
          :poll_opinion_thread,
          evaluator.comments_count,
          poll_opinion: poll_opinion
        )
      end
    end
  end

  factory :poll_date, parent: :poll, class: 'PollDate' do
    type { 'PollDate' }

    factory :poll_date_with_answers do
      after(:create) do |poll_date, evaluator|
        create_list(:answer_date, evaluator.answers_count, poll_date: poll_date)
      end
    end
  end
end
