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

class PollOpinion < Poll
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
    inverse_of: :poll_opinion ,
    foreign_key: "poll_id",
    class_name: 'Answer'

  has_many :vote_opinions,
    dependent: :destroy,
    inverse_of: :poll_opinion ,
    foreign_key: "poll_id",
    class_name: 'VoteOpinion'
  # Validations
  #-----------

  # Scope
  #-----------
  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
  # scope :expecting_answer, -> { where(status: [:invited, :googled, :registered])}

  scope :with_my_opinion_votes, -> (user) { active.joins(:vote_opinions).where('user_id = ?', user.id) }
  # scope :without_my_opinion_votes, -> (user) {
  #   active
  #     .left_outer_joins(:vote_opinions)
  #     .distinct
  #     .select('polls.*, count(votes.*) as total_votes')
  #     .group("polls.id")
  #     .where( 'user_id = ?', user.id)
  #     .having( 'count(votes.*) = ?', 0)
  #   }


  # ------------------------
  # --    PUBLIC      ---
  # ------------------------


end
