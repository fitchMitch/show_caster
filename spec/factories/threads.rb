FactoryBot.define do
  factory :thread, class: 'Commontator::Thread' do
    transient do
      comments_count { 2 }
    end
    factory :poll_opinion_thread do
      commontable { |c| c.association(:poll) }
      after(:create) do |poll_opinion_thread, evaluator|
        create_list(
          :comment,
          evaluator.comments_count,
          thread: poll_opinion_thread
        )
      end
    end
  end
end
