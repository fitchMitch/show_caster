# frozen_string_literal: true

class Poll < ApplicationRecord
  DAYS_THRESHOLD_FOR_FIRST_MAIL_ALERT = 5
  DAYS_THRESHOLD_FOR_SECOND_MAIL_ALERT = 2
  DAYS_THRESHOLD_FOR_SMS_ALERT = 2
  #-----------
  # Includes
  #-----------
  #-----------
  # Callbacks
  #-----------
  # Relationships
  #-----------
  has_many :poll_opinions,
           class_name: 'PollOpinion'
  has_many :poll_dates,
           class_name: 'PollDate'

  belongs_to :owner,
             class_name: 'User'

  has_many :answers,
           dependent: :destroy
  accepts_nested_attributes_for :answers,
                                reject_if: :all_blank,
                                allow_destroy: true
  # Validations
  #-----------
  validates :question,
            presence: true,
            length: { minimum: 5, maximum: 120 }
  validates :expiration_date,
            presence: true
  # Scope
  #-----------
  default_scope -> { order('expiration_date ASC') }
  scope :opinion_polls, -> { where(type: 'PollOpinion') }
  scope :date_polls, -> { where(type: 'PollDate') }
  scope :secret_ballot_polls, -> { where(type: 'PollSecretBallot') }
  scope :passed_ordered, -> { unscoped.order('expiration_date DESC') }
  scope :expired, -> { where('expiration_date < ?', Time.zone.now) }
  scope :active, -> { where('expiration_date >= ?', Time.zone.now) }
  scope :last_results, lambda { |user|
    expired.where('expiration_date > ?', user.last_connexion_at)
  }
  # ------------------------
  # --    PUBLIC      ---
  # ------------------------
  def self.days_threshold_for_first_mail_alert
    DAYS_THRESHOLD_FOR_FIRST_MAIL_ALERT
  end

  def self.days_threshold_for_second_mail_alert
    DAYS_THRESHOLD_FOR_SECOND_MAIL_ALERT
  end

  def self.days_threshold_for_sms_alert
    DAYS_THRESHOLD_FOR_SMS_ALERT
  end

  def self.expecting_my_vote(current_user)
    # the following  includes Secret Ballots
    total =  PollOpinion.active.count
    total -= PollOpinion.with_my_opinion_votes(current_user).count
    total -= PollSecretBallot.with_my_opinion_votes(current_user).count

    total += PollDate.active.count
    total - PollDate.count_my_date_votes(current_user).count
  end

  def self.polls_with_my_votes(user)
    voted_polls = [
      PollOpinion.with_my_opinion_votes(user).distinct,
      PollSecretBallot.with_my_opinion_votes(user).distinct,
      PollDate.with_my_date_votes(user).distinct
    ]
    voted_polls.inject([]) { |poll, sum| sum + poll }
               .uniq
  end

  def answer_id_sorted_by_vote_count
    Vote.where(poll_id: id)
        .group('answer_id')
        .count('votes.id')
        .sort_by(&:last)
        .reverse
  end

  def answers_sorted_by_vote_count
    Answer.unscope(:order)
          .where(poll_id: id)
          .joins(:votes)
          .select('answers.*, count(votes.id) as ccount')
          .group('answers.id')
          .order('count(votes.id) DESC')
  end

  def votes_count
    Vote.where(poll_id: id)
        .group(:user)
        .count
        .keys
        .size
  end

  def comments_count
    poll_thread = Commontator::Thread.where(commontable_id: id).take
    return 0 if poll_thread.nil?

    poll_thread.comments.count
  end

  def votes_destroy
    res = Vote.where(poll_id: id)
              .delete_all
    Rails.logger.info("----- success in votes_destroy #{id}---------")
    res
  end
end
