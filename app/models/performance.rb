class Performance < Event
  # includes

  # Pre and Post processing

  # Enums

  # Relationships
  belongs_to :user
  belongs_to :theater
  has_many :pictures, as: :imageable, dependent: :destroy

  has_many  :actors,
            dependent: :destroy,
            inverse_of: :performance,
            foreign_key: 'event_id'
  accepts_nested_attributes_for :actors,
                                allow_destroy: true

  # Validations
  validates_associated :user,
                       :theater
  validates :event_date,
            presence: true
  validates :duration,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 15
            }

  # Scopes

  # ------------------------
  # --    PUBLIC      ---
  # ------------------------
def short_label
  "#{ self.theater.theater_name[0, 25]} -" \
  " #{ self.event_date.strftime('%d-%b %Y')} | #{ self.title[0, 35]}"
end

def photo_count
  self.pictures.count
end

def self.last_performance_photos(n)
  return if n < 1
  e = Performance.passed_events.limit(2)
  e1, e2  = e.first, e.second
  res = []
  unless e.empty?
    res += Picture.last_pictures(e1, n)
    res += Picture.last_pictures(e2, n) if res.count < n && e2.present?
    res = res[0..n] if res.count > n
  end
  res
end

  # ------------------------
  # --    Protected      ---
  # ------------------------
  # protected
  # ------------------------
  # --    PRIVATE      ---
  # ------------------------
  # private
end
