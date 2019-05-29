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
  scope :ahead_start, ->(month_count) {
    where('time_start <= ?', (Time.zone.now + month_count.month))
  }
  scope :before_end, -> {
    where('time_end >= ?', Time.zone.now)
  }
  # Validations
  # =====================
  validates :title,
           presence: true,
           length: { maximum: 40, minimum: 3 }
  validates :body,
            presence: true,
            length: { maximum: 250, minimum: 10 }
  validates :time_start,
            presence: true
  validates :time_end,
            presence: true
  validate :end_after_start

   # ------------------------
   # --    PUBLIC      ---
   # ------------------------

  def self.shown_as_active
    Announce.ahead_start(1).before_end
  end

  private

  def end_after_start
    if time_end <= time_start
      errors.add(
        :time_end,
        I18n.t('announces.errors.future_not_passed')
      )
    end
  end
end
