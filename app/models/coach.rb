# == Schema Information
#
# Table name: coaches
#
#  id            :integer          not null, primary key
#  firstname     :string
#  lastname      :string
#  email         :string
#  cell_phone_nr :string
#  note          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Coach < ApplicationRecord
  # includes
  include Users::Formating
  include Users::Validating
  # Pre and Post processing
  before_validation :format_fields, on: %i[create update]

  # Enums

  # Relationships
  # =====================
  has_many :courses, as: :courseable
  #delegate :firstname,:lastname, :full_name, to: :member
  # =====================

  # Scopes
  # =====================
  # scope :found_by, -> (user) { where('user_id = ?', user_id) }

  # Validations
  # =====================
  validates :email,
    length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false },
    allow_blank: true

  # ------------------------
  # --    PUBLIC      ---
  # ------------------------
  def full_name
    self.first_and_last_name.html_safe
  end

  protected

    def format_fields
      self.lastname = lastname.upcase if lastname.present?
      self.email = email.downcase if email.present?
      self.phone_number_format
    end

end
