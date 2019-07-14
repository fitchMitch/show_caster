# frozen_string_literal: true

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
  scope :opinion_votes, -> { where(type: 'VoteOpinion') }
  scope :date_votes, -> { where(type: 'VoteDate') }

  # scope :passed_ordered, -> { unscoped.order('expiration_date DESC')}
  # ------------------------
  # --    PUBLIC      ---
  # ------------------------
  def clean_votes
    raise 'Shall be overriden'
  end
end
