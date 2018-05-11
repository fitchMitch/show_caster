# == Schema Information
#
# Table name: pictures
#
#  id                 :integer          not null, primary key
#  fk                 :string
#  event_id           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  note               :string
#  descro             :string
#

class Picture < ApplicationRecord
  # includes
  # Pre and Post processing

  # Enums

  # Relationships
  # =====================
  belongs_to :event, optional: true
  has_attached_file :photo,
    url: "/system/:hash.:extension",
    hash_secret: "acara124",
    styles: {
      medium: "300x300>",
      thumb: "100x100>"
    },
    default_url: "/images/:style/missing.png"

  #delegate :firstname,:lastname, :full_name, to: :member
  # =====================

  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
  # =====================

  # Validations
  # =====================
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/
  validates_attachment :photo,
    presence: true,
    size: { in: 0..4.megabytes }


  # ------------------------
  # --    PUBLIC      ---
  # ------------------------


  protected


end
