# frozen_string_literal: true

class Theater < ApplicationRecord
  include Users::Formating
  before_save { formatting }
  # Relationships
  has_many :performances
  has_many :courses
  has_many :events

  # Validations
  validates :theater_name,
            presence: true,
            length: {
              minimum: 2,
              maximum: 40
            }
  # ------------------------
  # --    PUBLIC      ---
  # ------------------------

  def formatting
    self.manager_phone = format_by_two(manager_phone) if manager_phone.present?
  end
end
