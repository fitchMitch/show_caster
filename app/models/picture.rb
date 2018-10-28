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
                    url: '/system/:hash.:extension',
                    default_url: 'public/missing/:style/missing_avatar.jpg',
                    hash_secret: 'acara124',
                    styles: {
                      square: '450x450#',
                      medium: '600x600>',
                      thumb: '100x100>'
                    },
                    processors: [:papercrop]
  # =====================
  # Validations
  # =====================
  validates_attachment :photo, presence: true, size: { in: 0.1..4.megabytes }
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/
  crop_attached_file :photo, aspect: false
  # =====================

  scope :last_pictures, -> (image, number_of) {
    where(
      'imageable_id = ? and imageable_type=?',
      image.id,
      'Event'
    ).limit(number_of)
     .order("RANDOM()")
  }
end
