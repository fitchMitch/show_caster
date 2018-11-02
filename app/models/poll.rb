class Poll < ApplicationRecord
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
  scope :passed_ordered, -> { unscoped.order('expiration_date DESC') }
  scope :expired, -> { where('expiration_date < ?', Time.zone.now) }
  scope :active, -> { where('expiration_date >= ?', Time.zone.now) }
  # ------------------------
  # --    PUBLIC      ---
  # ------------------------
  def self.expecting_my_vote(current_user)
    total =  PollOpinion.active.count
    total -= PollOpinion.with_my_opinion_votes(current_user).count

    total += PollDate.active.count
    total - PollDate.with_my_date_votes(current_user).count
  end

  def votes_count
    Vote.where(poll_id: id).group(:user).count.keys.size
  end

  def poll_creation_mail
    PollMailer.poll_creation_mail(self).deliver_now
  end

  def comments_count
    poll_thread = Commontator::Thread.where(commontable_id: id).take
    return 0 if poll_thread.nil?
    poll_thread.comments.count
  end

  def votes_destroy
    Vote.where(poll_id: id)
        .delete_all
    Rails.logger.info("----- success in votes_destroy ---------")
  end
end
