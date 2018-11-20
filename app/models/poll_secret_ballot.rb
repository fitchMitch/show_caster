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
class PollSecretBallot < PollOpinion
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
           inverse_of: :poll_secret_ballot,
           foreign_key: 'poll_id',
           class_name: 'Answer'

  has_many :vote_opinions,
           dependent: :destroy,
           foreign_key: 'poll_id',
           class_name: 'VoteOpinion'
           # inverse_of: :poll_secret_ballot,

  # Validations
  #-----------

  # Scope
  #-----------
  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
end
