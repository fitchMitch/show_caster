class Announce < ApplicationRecord
  # Relationships
  # =====================
  belongs_to :author,
             class_name: 'User'
   # Pre and Post processing

   # Enums

   # =====================
   # Scopes
   # =====================
   scope :active, -> {
     where('expiration_date > ?', Time.zone.now)
   }

   # Validations
   # =====================

   validates :title,
             presence: true,
             length: { maximum: 40, minimum: 3 }
   validates :body,
              presence: true,
              length: { maximum: 250, minimum: 10 }
   validates :expiration_date,
              presence: true

   # ------------------------
   # --    PUBLIC      ---
   # ------------------------
end
