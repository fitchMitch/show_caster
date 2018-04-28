class Actor < ApplicationRecord
  # includes

  # Pre and Post processing

  # Enums
  enum stage_role: {
      :player => 0,
      :dj => 1,
      :mc => 2,
      :other => 3
    }

  # Relationships
  belongs_to :event
  belongs_to :user

  # Validations
  validates_associated :user, :event

  # Scopes

  # ------------------------
  # --    PUBLIC      ---
  # ------------------------

  # ------------------------
  # --    Protected      ---
  # ------------------------
  # protected
  # ------------------------
  # --    PRIVATE      ---
  # ------------------------
  # private
end
