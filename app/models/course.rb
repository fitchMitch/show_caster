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

class Course < Event
  # includes
  attr_accessor :is_autocoached, :users_list, :coaches_list
  # Pre and Post processing

  # Enums

  # Relationships
  belongs_to :courseable, polymorphic: true
  belongs_to :theater
  belongs_to :user



  # Validations
  # validates_associated :user, :theater
  validates :event_date, presence: true
  validates :duration,
    presence: true,
    numericality: {
      greater_than_or_equal_to: 15
    }


  # Scopes


  # ------------------------
  # --    PUBLIC      ---
  # ------------------------

  private


end
