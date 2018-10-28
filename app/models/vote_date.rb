class VoteDate < Vote
  #-----------
  # Includes
  #-----------
  #-----------
  # Callbacks
  #-----------
  # Relationships
  #-----------
  belongs_to  :poll_date,
              foreign_key: 'poll_id',
              class_name: 'PollDate',
              optional: true,
              touch: true

  belongs_to  :answer,
              dependent: :destroy

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
  def clean_votes
    VoteDate.where(poll_id: poll_id)
            .where(user_id: user_id)
            .where(answer_id: answer_id)
            .delete_all
  end
end
