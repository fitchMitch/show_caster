# == Schema Information
#
# Table name: answers
#
#  id           :integer          not null, primary key
#  answer_label :string
#  date_answer  :datetime
#  poll_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Answer < ApplicationRecord

    # includes
    # Pre and Post processing

    # Enums

    # Relationships
    # =====================
    # belongs_to :poll, foreign_key: "poll_id", class_name: 'Poll'
    # belongs_to :poll_opinion, optional: true, type: 'PollOpinion'
    belongs_to :poll_opinion,
      foreign_key: "poll_id",
      class_name: 'PollOpinion',
      optional: true,
      touch: true
    belongs_to :poll_date,
      foreign_key: "poll_id",
      class_name: 'PollDate',
      optional: true,
      touch: true
    #delegate :firstname,:lastname, :full_name, to: :member
    # =====================

    # Scopes
    # =====================
    # scope :found_by, -> (user) { where('user_id = ?', user_id) }

    # Validations
    # =====================
    validates_associated :poll_opinion, :poll_date
    # validates :answer,
    #   length: { minimum: 3, maximum: 100 }
    # validates :date_answer,
    #   presence: true


    # ------------------------
    # --    PUBLIC      ---
    # ------------------------

end
