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
#  owner_id        :integer
#

class PollDate < Poll
  #-----------
  # Includes
  #-----------
  #-----------
  # Callbacks
  #-----------
  # Relationships
  #-----------

  has_many :answers,
    dependent: :destroy,
    inverse_of: :poll_date ,
    foreign_key: "poll_id",
    class_name: 'Answer'

  has_many :vote_dates ,
    dependent: :destroy ,
    inverse_of: :poll_date ,
    foreign_key: "poll_id" ,
    class_name: 'VoteDate'

  # Validations
  #-----------

  # Scope
  #-----------
  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
  # scope :expecting_answer, -> { where(status: [:invited, :googled, :registered])}
  scope :with_my_date_votes, -> (user) {
    active
    .joins(:vote_dates)
    .where('user_id = ?', user.id)
  }
  # ------------------------
  # --    PUBLIC      ---
  # ------------------------
end
