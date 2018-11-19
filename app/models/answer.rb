class Answer < ApplicationRecord
  # includes
  # Pre and Post processing

  # Enums

  # Relationships
  # =====================
  # belongs_to :poll, foreign_key: 'poll_id', class_name: 'Poll'
  # belongs_to :poll_opinion, optional: true, type: 'PollOpinion'
  belongs_to :poll_opinion,
             foreign_key: 'poll_id',
             class_name: 'PollOpinion',
             optional: true,
             touch: true
  belongs_to :poll_secret_ballot,
             foreign_key: 'poll_id',
             class_name: 'PollSecretBallot',
             optional: true,
             touch: true
  belongs_to :poll_date,
             foreign_key: 'poll_id',
             class_name: 'PollDate',
             optional: true,
             touch: true
  has_many :votes
  # =====================

  # Scopes
  # =====================
  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
  default_scope -> { order('date_answer asc') }

  # Validations
  # =====================
  validates_associated :poll_opinion,
                       :poll_date
  validates :answer_label,
            length: { minimum: 3, maximum: 100 },
            presence: true,
            if: :date_answer_nil?
  validates :date_answer,
            presence: true,
            if: :answer_label_nil?
  validate :no_date_in_the_past,
           if: :answer_label_nil?

  # ------------------------
  # --    PUBLIC      ---
  # ------------------------
  def no_date_in_the_past
    return nil if !date_answer_nil? && date_answer >= Time.zone.now
    errors.add(
      :date_answer,
      I18n.t('answers.in_the_past_error')
    )
  end

  def date_answer_nil?
    date_answer.nil?
  end

  def answer_label_nil?
    answer_label.nil?
  end
end
