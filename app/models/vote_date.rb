# frozen_string_literal: true

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
  # ------------------------
  # --    PUBLIC      ---
  # ------------------------
  def clean_votes
    VoteDate.search(poll_id, answer_id, user_id)
            .delete_all
  end

  def self.select_votes(answer, user)
    VoteDate.search(answer.poll_id, answer.id, user.id)
  end

  def self.search(poll_id, answer_id, user_id)
    VoteDate.where('poll_id = ?', poll_id)
            .where('answer_id = ?', answer_id)
            .where('user_id = ?', user_id)
  end
end
