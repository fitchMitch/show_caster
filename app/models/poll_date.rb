# frozen_string_literal: true

class PollDate < Poll
  acts_as_commontable dependent: :destroy
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
  scope :with_my_date_votes, lambda { |user|
    active.joins(:vote_dates)
          .where('votes.user_id = ?', user.id)
  }
  scope :count_my_date_votes, lambda { |user|
    active.joins(:vote_dates)
          .where('votes.user_id = ?', user.id)
          .group('polls.id')
          .count
          .keys
  }

  def fill_answers_votes(user)
    answers_votes = []
    answers.each do |answer|
      votes = VoteDate.where(poll_id: id)
                      .where(answer_id: answer.id)
                      .where(user_id: user.id)
      vote = votes.any? ? votes.first : nil
      answers_votes << { answer: answer, vote: vote }
    end
    answers_votes
  end

  def self.best_hash_values(hash)
    hash.select { |_k, val| val == hash.values.max }
  end

  def best_dates_answer
    PollDate.best_hash_values(
      VoteDate.where(poll_id: id)
              .where(vote_label: 'yess')
              .group(:answer_id)
              .count
    )
  end

  def missing_voters_ids
    User.active.pluck(:id) - vote_dates.pluck(:user_id).uniq
  end
end
