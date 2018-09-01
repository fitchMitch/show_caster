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

class Vote < ApplicationRecord

  #-----------
  # Includes
  #-----------
  # Callbacks
  #-----------

  # Enums
  #-----------
  enum vote_label: {
    noway: 0,
    yess: 1,
    maybe: 2
  }

  # Relationships
  #-----------

  belongs_to :user
  belongs_to :answer
  belongs_to :poll
  has_many :vote_opinions, class_name: 'VoteOpinion'
  has_many :vote_dates, class_name: 'VoteDate'

  # Validations
  #-----------
  validates_associated :user, :answer
  validates :user, presence: true
  validates :answer, presence: true
  validates :poll, presence: true

  # Scope
  #-----------
  # default_scope  -> { order('expiration_date ASC')}
  scope :opinion_votes, -> { where('type = ?', 'VoteOpinion')}
  scope :date_votes, -> { where('type = ?', 'VoteDate')}
  # scope :passed_ordered, -> { unscoped.order('expiration_date DESC')}
  # ------------------------
  # --    PUBLIC      ---
  # ------------------------
  def clean_votes
    if self.class.name == "VoteOpinion"
      VoteOpinion
        .where('poll_id = ?', self.poll_id)
        .where('user_id = ?', self.user_id)
        .delete_all
    else
      VoteDate
        .where('poll_id = ?', self.poll_id)
        .where('answer_id = ?', self.answer_id)
        .where('user_id = ?', self.user_id)
        .delete_all
    end
  end
end
