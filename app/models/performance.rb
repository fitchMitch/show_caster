# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  event_date :datetime
#  duration   :integer
#  progress   :integer          default("draft")
#  note       :text
#  user_id    :integer
#  theater_id :integer
#  fk         :string
#  provider   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  title      :string
#

class Performance < Event
  # includes

  # Pre and Post processing

  # Enums

  # Relationships
  belongs_to :user
  belongs_to :theater
  has_many :actors, dependent: :destroy, inverse_of: :performance, foreign_key: "event_id"
  has_many :pictures, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :actors, allow_destroy: true

  # Validations
  validates_associated :user, :theater


  # Scopes


  # ------------------------
  # --    PUBLIC      ---
  # ------------------------
def short_label
  "#{self.theater.theater_name[0,25]} - #{self.event_date.strftime('%d-%b %Y')} | #{self.title[0,35]}"
end

def photo_count
  self.pictures.count
end

def self.last_four_images
  e = Event.passed_events.limit(2)
  e1, e2, res  = e.first , e.second, []
  unless e.empty?
    res += Picture.four_pictures(e1)
    res += Picture.four_pictures(e2) unless res.count == 4 || e2.nil?
    res = res[0..3] if res.count > 4
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
