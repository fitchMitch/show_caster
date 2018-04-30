# == Schema Information
#
# Table name: events
#
#  id                      :integer          not null, primary key
#  event_date              :datetime
#  datetime with time zone :datetime
#  duration                :integer
#  progress                :integer
#  note                    :text
#  user_id                 :integer
#  theater_id              :integer
#  fk                      :string
#  provider                :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
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

  # ------------------------
  # --    Protected      ---
  # ------------------------
  # protected
  # ------------------------
  # --    PRIVATE      ---
  # ------------------------
  # private
end
