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

class VoteOpinion < Vote
  #-----------
  # Includes
  #-----------
  #-----------
  # Callbacks
  #-----------
  # Relationships
  #-----------
  belongs_to :poll_opinion,
    foreign_key: "poll_id",
    class_name: 'PollOpinion',
    optional: true,
    touch: true
  belongs_to :answer
  belongs_to :user
  # Validations
  #-----------

  # Scope
  #-----------
  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
  # scope :expecting_answer, -> { where(status: [:invited, :googled, :registered])}
  # ------------------------
  # --    PUBLIC      ---
  # ------------------------
end
