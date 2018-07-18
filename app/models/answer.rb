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

class Answer < ApplicationRecord
  # belongs_to :poll, foreign_key: "poll_id", class_name: 'Poll'
  # belongs_to :poll_opinion, optional: true, type: 'PollOpinion'
  belongs_to :poll_opinion,
    foreign_key: "poll_id",
    class_name: 'PollOpinion',
    optional: true,
    touch: true

end
