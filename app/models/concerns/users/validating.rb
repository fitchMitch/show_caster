module Users
  module Validating
    extend ActiveSupport::Concern

    # attr_accessor :cell_phone_nr, :email, :firstname, :lastname

    included do
      validates :cell_phone_nr,
        allow_nil: true,
        length:
          { minimum:14,
            maximum: 25
          },
        uniqueness: true,
        presence: true

      VALID_EMAIL_REGEX = /\A[\w+0-9\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

      validates :firstname,
        presence: true,
        length: { minimum: 2, maximum: 50 }
      validates :lastname,
        presence: true,
        length: { minimum: 2, maximum: 50 }
    end
  end
end
