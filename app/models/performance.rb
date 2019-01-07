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
  validates :title,
            presence: true,
            length:  {
              minimum: 5,
              maximum: 60
            }
  validates :duration,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 15
            }

  # Scopes
  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
  scope :next_shows, -> (user_id) {
    joins(:actors).where('actors.user_id = ?', user_id)
                  .where('events.event_date > ?', Time.zone.now)
                  .order('events.event_date ASC')
  }
  scope :previous_shows, -> (user_id) {
    joins(:actors).where('actors.user_id = ?', user_id)
                  .where('events.event_date < ?', Time.zone.now)
                  .order('events.event_date DESC')
  }

  # ------------------------
  # --    PUBLIC      ---
  # ------------------------
  def short_label
    "#{theater.theater_name[0, 25]} -" \
    " #{event_date.strftime('%d-%b %Y')} | #{title[0, 35]}"
  end

  def photo_count
    pictures.count
  end

  def google_event_params
    attendees_ids = actors.pluck(:user_id)
    attendees_email = []
    theater_name = theater.theater_name
    attendees_ids.each do |id|
      email = User.find_by(id: id).email
      attendees_email << { email: email }
    end

    {
      title: I18n.t('performances.g_title_performance', name: theater_name),
      location: theater.location,
      theater_name: theater_name,
      event_date: event_date.iso8601,
      event_end: (event_date + duration * 60).iso8601,
      attendees_email: attendees_email,
      fk: fk
    }
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
