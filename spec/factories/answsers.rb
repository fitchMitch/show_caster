# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  answer      :string
#  date_answer :datetime
#  poll_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :answer do
    answer_label "MyString"
    date_answer {Time.zone.now - (1..10).to_a.sample.days}

    factory :answer_opinion do
      poll_opinion
    end

    factory :answer_date do
      poll_date
    end
  end
end
