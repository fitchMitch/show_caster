# == Schema Information
#
# Table name: theaters
#
#  id            :integer          not null, primary key
#  theater_name  :string           not null
#  location      :string
#  manager       :string
#  manager_phone :string
#

class Theater < ApplicationRecord
  include Users::Formating
  before_save { self.formatting }
  # Relationships
  # has_many :events

  # Validations
  validates :theater_name,
    presence: true,
    length: {
      minimum: 2,
      maximum: 40
    }
  # ------------------------
  # --    PUBLIC      ---
  # ------------------------

  def formatting
    self.manager_phone = format_by_two(self.manager_phone) unless self.manager_phone.nil?
    self.theater_name.upcase
  end
end
