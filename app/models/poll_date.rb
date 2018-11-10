class PollDate < Poll
  #-----------
  # Includes
  #-----------
  #-----------
  # Callbacks
  #-----------
  # Relationships
  #-----------
  has_many  :answers,
            dependent: :destroy,
            inverse_of: :poll_date,
            foreign_key: 'poll_id',
            class_name: 'Answer'

  has_many  :vote_dates,
            dependent: :destroy,
            inverse_of: :poll_date,
            foreign_key: 'poll_id',
            class_name: 'VoteDate'

  # Validations
  #-----------

  # Scope
  #-----------
  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
  scope :with_my_date_votes, -> (user) {
    active.joins(:vote_dates)
          .where('votes.user_id = ?', user.id)
  }
  scope :count_my_date_votes, -> (user) {
    active.joins(:vote_dates)
          .where('votes.user_id = ?', user.id)
          .group('polls.id')
          .count
          .keys
  }
end
