# == Schema Information
#
# Table name: polls
#
#  id              :integer          not null, primary key
#  question        :string
#  expiration_date :date
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :poll do
    question          'MyString'
    expiration_date   { Date.today + (1..15).to_a.sample.days }

    transient do
      answers_count 3
    end
  end

  factory :poll_date, parent: :poll, class: 'PollDate' do
    type 'PollDate'

    factory :poll_date_with_answers do
      after(:create) do |poll_date, evaluator|
        create_list(:answer_date, evaluator.answers_count, poll_date: poll_date)
      end
    end
  end

  factory :poll_opinion, parent: :poll, class: 'PollOpinion' do
    type 'PollOpinion'

    factory :poll_opinion_with_answers do
      after(:create) do |poll_opinion, evaluator|
        create_list(:answer_opinion, evaluator.answers_count, poll_opinion: poll_opinion)
      end
    end
  end
end
