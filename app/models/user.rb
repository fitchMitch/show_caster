# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  firstname       :string
#  lastname        :string
#  email           :string
#  last_sign_in_at :datetime
#  status          :integer          default("set_up")
#  provider        :string
#  uid             :string
#  address         :string
#  cell_phone_nr   :string
#  photo_url       :string
#  role            :integer          default("player")
#  token           :string
#  refresh_token   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  # includes
  include Users::Formating
  # Pre and Post processing
  before_save :format_fields

  #The following should be close to devise declaration !
  # after_invitation_accepted  :welcome_mail

  # Enums
  enum status: {
    :set_up => 0,
    :invited => 1,
    :googled => 2,
    :fully_registered => 3,
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
  validates :lastname,
    presence: true,
    length: { minimum: 2,maximum: 50 },
    uniqueness: { case_sensitive: false }

    with_options if: :fully_registered? do |user|
      user.validates :uid, uniqueness: true
    end

    with_options if: :googled? do |user|
      user.validates :uid, uniqueness: true
    end

  # ------------------------
  # --    PUBLIC      ---
  # ------------------------

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.retrieve(data)
    #TODO try change User with self
    result = if user.nil?
      "unknown user"
    else
      credentials = access_token[:credentials]
      from_token = {
        firstname: data[:first_name],
        lastname: data[:last_name].upcase,
        email: data[:email].downcase,
        provider: access_token[:provider],
        uid: access_token[:uid],
        photo_url: data[:image],
        token: credentials[:token],
        refresh_token: credentials[:refresh_token],
        expires_at: Time.at(credentials[:expires_at].to_i).to_datetime
      }
      from_token[:status] = :googled if user.status == :set_up
      if user.update_attributes(from_token)
        logger.fatal "False Terminating application, raised unrecoverable error!!!"
        user
      else
        logger.error "OAuth user updating went wrong"
        nil
      end
    end
  end

  def self.retrieve(data)
    user = User.find_by(
      email: data[:email].downcase
    )
    if user.nil?
      user = User.find_by(
        firstname: data[:first_name],
        lastname: data[:last_name].upcase
      )
    end
    user
    #TODO try remove user
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

  private
    def format_fields
      self.lastname.upcase
      # TODO try without self
      self.cell_phone_nr = format_by_two(cell_phone_nr)
    end
end
