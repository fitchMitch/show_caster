# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  firstname       :string
#  lastname        :string
#  email           :string
#  last_sign_in_at :datetime
#  status          :integer          default(0)
#  provider        :string
#  uid             :string
#  address         :string
#  cell_phone_nr   :string
#  photo_url       :string
#  role            :integer          default(0)
#  token           :string
#  refresh_token   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord

  # Pre and Post processing

  #The following should be close to devise declaration !
  # after_invitation_accepted  :welcome_mail

  # Enums
  enum status: {
    :set_up => 0,
    :invited => 1,
    :googled => 2,
    :full_registered => 3,
    :archived => 4
  }
  enum role: {
    :player => 0,
    :admin_com => 1 ,
    :admin => 2 ,
    :other => 3
  }

  # Relationships
  # =====================

  #delegate :firstname,:lastname, :full_name, to: :member
  # =====================

  # scope :found_by, -> (user_id) { where('user_id = ?', user_id) }
  # =====================

  # Validations
  # =====================

  # validates :cell_phone_nr, presence: true, length: { minimum:14, maximum: 25 }


  VALID_EMAIL_REGEX = /\A[\w+0-9\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
    presence: true,
    length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  validates :firstname,
    presence: true,
    length: { minimum: 2,maximum: 50 },
    uniqueness: { case_sensitive: false }
  validates :lastname,
    presence: true,
    length: { minimum: 2,maximum: 50 },
    uniqueness: { case_sensitive: false }

  # ------------------------
  # --    PUBLIC      ---
  # ------------------------

  def self.from_omniauth(access_token)
    data = access_token.info

    user = User.where(email: data['email']).first
    # Uncomment the section below if you want users to be created if they don't exist
    from_token = {
        firstname: data['first_name'],
        lastname: data['last_name'],
        email: data['email'].downcase,
        password: Devise.friendly_token[0,20],
        provider: access_token.provider,
        uid: access_token.uid,
        photo_url: data['image'],
        status: :active
    }
    user.nil? ? User.create(*from_token) : user.update(from_token)
    user
  end

  # def welcome_mail
  #   UserMailer.welcome_mail(self).deliver_now
  # end
  #
  # def promoted_mail(role)
  #   UserMailer.promoted_mail(self,role).deliver_now
  # end

  def full_name
    if self.archived?
      I18n.t("users.deleted_name")
    elsif (self.firstname.nil? && self.lastname.nil?)
      I18n.t("users.we_wait_for")
    else
      self.firstname.nil? || self.firstname == '' ? lastname.upcase : "#{firstname} #{lastname.upcase}"
    end
  end
end
