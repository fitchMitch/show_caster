# frozen_string_literal: true

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
             foreign_key: 'poll_id',
             class_name: 'PollOpinion',
             optional: true,
             touch: true

  belongs_to :answer,
             dependent: :destroy
  belongs_to :user
  # Validations
  #-----------

  # Scope
  #-----------
  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
  scope :votes_for, lambda { |poll_opinion, answer|
    where(poll_id: poll_opinion.id).where(answer_id: answer.id)
                                   .pluck(:user_id)
  }
  scope :who_voted_for, lambda { |poll_opinion, answer|
    votes_for(poll_opinion, answer).uniq
  }
  scope :count_votes_for, lambda { |poll_opinion, answer|
    votes_for(poll_opinion, answer).count
  }
  scope :which_answer, lambda { |poll_opinion, user|
    where(poll_id: poll_opinion.id).where(user_id: user.id)
                                   .pluck(:answer_id)
                                   .uniq
  }
  # ------------------------
  # --    PUBLIC      ---
  # ------------------------
  def clean_votes
    VoteOpinion.where(poll_id: poll_id)
               .where(user_id: user_id)
               .delete_all
  end
end
