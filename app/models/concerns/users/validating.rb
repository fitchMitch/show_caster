module Users
  module Validating
    extend ActiveSupport::Concern
    VALID_EMAIL_REGEX = /\A[\w+0-9\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    included do
      validates :cell_phone_nr,
                allow_nil: true,
                length: {
                  minimum: 14,
                  maximum: 25
                },
                uniqueness: true,
                presence: true
      validates :firstname,
                presence: true,
                length: { minimum: 2, maximum: 50 }
      validates :lastname,
                presence: true,
                length: { minimum: 2, maximum: 50 }
    end
  end
end
