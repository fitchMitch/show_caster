# == Schema Information
#
# Table name: pictures
#
#  id         :integer          not null, primary key
#  fk         :string
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Picture < ApplicationRecord
  # includes
  # Pre and Post processing

  # Enums

  # Relationships
  # =====================
  belongs_to :event, optional: true

  #delegate :firstname,:lastname, :full_name, to: :member
  # =====================

  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
  # =====================

  # Validations
  # =====================


  # ------------------------
  # --    PUBLIC      ---
  # ------------------------


  protected


end
