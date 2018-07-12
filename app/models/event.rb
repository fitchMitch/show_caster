# == Schema Information
#
# Table name: events
#
#  id              :integer          not null, primary key
#  event_date      :datetime
#  duration        :integer
#  progress        :integer          default("draft")
#  note            :text
#  user_id         :integer
#  theater_id      :integer
#  fk              :string
#  provider        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  title           :string
#  type            :string           default("Performance")
#  courseable_id   :integer
#  courseable_type :string
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
    ["2 h 30",150],
    ["3 h",180]
  ]
  enum progress: {
      :draft => 0,
      :finalized => 1
    }
  # Relationships
  has_many :performances, class_name: 'Performance'
  has_many :courses, class_name: 'Course'
  belongs_to :theater


  # Scopes
 scope :future_events, -> {where('event_date >= ?', Time.zone.now).order(event_date: :asc)}
 scope :passed_events, -> {where('event_date < ?', Time.zone.now).order(event_date: :desc)}
 scope :courses, -> {where('type = ?' , 'Course')}
 scope :performances, -> {where('type = ?' , 'Performance')}

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
