class Picture < ApplicationRecord
  # includes
  # Pre and Post processing

  # Enums

  # Relationships
  # =====================
  belongs_to :event, optional: true

  #delegate :firstname,:lastname, :full_name, to: :member
  # =====================

  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
  # =====================

  # Validations
  # =====================


  # ------------------------
  # --    PUBLIC      ---
  # ------------------------


  protected


end
