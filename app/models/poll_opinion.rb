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
  acts_as_commontable dependent: :destroy
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
           inverse_of: :poll_opinion,
           foreign_key: 'poll_id',
           class_name: 'Answer'

  has_many :vote_opinions,
           dependent: :destroy,
           inverse_of: :poll_opinion,
           foreign_key: 'poll_id',
           class_name: 'VoteOpinion'

  # Validations
  #-----------

  # Scope
  #-----------
  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
  scope :with_my_opinion_votes, -> (user) {
    active.joins(:vote_opinions)
          .where('user_id = ?', user.id)
  }

  def missing_voters_ids
    User.active.pluck(:id) - vote_opinions.pluck(:user_id).uniq
  end
end
