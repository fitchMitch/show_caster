# frozen_string_literal: true

class Course < Event
  DAYS_THRESHOLD_FOR_FIRST_MAIL_ALERT = 8
  COURSE_HOUR_START = 20
  COURSE_DURATION = 150
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
  scope :next_courses, lambda {
    where('event_date > ?', Time.zone.now).order('event_date ASC')
  }

  # METHODS
  def self.days_threshold_for_first_mail_alert
    DAYS_THRESHOLD_FOR_FIRST_MAIL_ALERT
  end

  def google_event_params
    theater_name = theater.theater_name
    {
      title: I18n.t('courses.g_title_course', name: theater_name),
      location: theater.location,
      theater_name: theater_name,
      event_date: event_date.iso8601,
      event_end: (event_date + duration * 60).iso8601,
      attendees_email: [],
      fk: fk
    }
  end
end
