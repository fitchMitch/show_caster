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
end
