# == Schema Information
#
# Table name: pictures
#
#  id                 :integer          not null, primary key
#  fk                 :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  note               :string
#  descro             :string
#  imageable_id       :integer
#  imageable_type     :string
#

class Picture < ApplicationRecord
  # Extra accessors
  # includes
  # Pre and Post processing

  # Enums

  # Relationships
  # =====================

  belongs_to :imageable,
    polymorphic: true,
    optional: true

  has_attached_file :photo,
    url: "/system/:hash.:extension",
    default_url: "public/missing/:style/missing_avatar.jpg",
    hash_secret: "acara124",
    styles: {
      square: "450x450#",
      medium: "600x600>",
      thumb: "100x100>"
    } ,
    processors: [:papercrop]
    # default_url: "images/default_photo/:style/default.jpg",
    # ,default_url: "/images/:style/missing.png"

  #delegate :firstname,:lastname, :full_name, to: :member
  # =====================

  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
  # =====================

  # Validations
  # =====================
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/
  crop_attached_file :photo, :aspect => false
  validates_attachment :photo,
    presence: true,
    size: { in: 0..4.megabytes }

  # ------------------------
  # --    PUBLIC      ---
  # ------------------------


  protected


end
