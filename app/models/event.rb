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

class Event < ApplicationRecord
  # includes

  # Pre and Post processing

  # Enums
  DURATIONS = [
    ["20 min",20],
    ["30 min",30],
    ["40 min",40],
    ["1 h",60],
    ["1 h 15",75],
    ["1 h 30",90],
    ["2 h",120],
    ["3 h",180]
  ]
  enum progress: {
      :draft => 0,
      :finalized => 1
    }
  # Relationships
  belongs_to :user
  belongs_to :theater
  has_many :actors, dependent: :destroy, inverse_of: :event
  has_many :pictures, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :actors, allow_destroy: true

  # Validations
  validates_associated :user, :theater
  validates :event_date, presence: true
  validates :duration,
    presence: true,
    numericality: {
      greater_than_or_equal_to: 15
    }

  # Scopes
 scope :future_events, -> {where('event_date >= ?', Time.zone.now).order(event_date: :asc)}
 scope :passed_events, -> {where('event_date < ?', Time.zone.now).order(event_date: :desc)}
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
  e = Event.passed_events
  e1, e2 = e.first , e.second
  res = Picture.where("imageable_id = ? and imageable_type=?", e1.id, 'Event' ).limit(4).order("RANDOM()")
  res2 = Picture.where("imageable_id = ? and imageable_type=?", e2.id, 'Event' ).limit(4).order("RANDOM()")
  res += res2 if res.count < 4
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
