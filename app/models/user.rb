# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  firstname       :string
#  lastname        :string
#  email           :string
#  last_sign_in_at :datetime
#  status          :integer          default("setup")
#  provider        :string
#  uid             :string
#  address         :string
#  cell_phone_nr   :string
#  photo_url       :string
#  role            :integer          default("player")
#  token           :string
#  refresh_token   :string
#  expires_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  color           :string
#

class User < ApplicationRecord
  # includes
  include Users::Formating
  # Pre and Post processing
  before_validation :format_fields, on: %i[ create update]

  # Enums
  enum status: {
    :setup => 0,
    :invited => 1,
    :googled => 2,
    :registered => 3,
    :archived => 4
  }
  enum role: {
    :player => 0,
    :admin_com => 1,
    :admin => 2 ,
    :other => 3
  }

  # Relationships
  # =====================

  #delegate :firstname,:lastname, :full_name, to: :member
  # =====================

  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
  scope :active, -> { where(status: [:invited, :googled, :registered])}
  # =====================

  # Validations
  # =====================
  validates :cell_phone_nr, allow_nil: true, length: { minimum:14, maximum: 25 }, uniqueness: true


  VALID_EMAIL_REGEX = /\A[\w+0-9\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
    presence: true,
    length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  validates :firstname,
    presence: true,
    length: { minimum: 2,maximum: 50 }
  validates :lastname,
    presence: true,
    length: { minimum: 2,maximum: 50 }

  validates :uid, uniqueness: true, allow_nil: true

  # ------------------------
  # --    PUBLIC      ---
  # ------------------------

  def self.from_omniauth(access_token)
    data = access_token[:info]
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
      # Additional attributes
      from_token[:status] = :googled if user.setup? || user.invited?
      from_token[:last_sign_in_at] = Time.zone.now

      if user.update_attributes(from_token)
        user
      else
        logger.error "OAuth user updating went wrong"
        logger.error from_token
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

  def welcome_mail
    UserMailer.welcome_mail(self).deliver_now
  end

  def promoted_mail
    UserMailer.promoted_mail(self).deliver_now
  end

  def full_name
    text = self.firstname.nil? || self.firstname == '' ? lastname.upcase : "#{firstname} #{lastname.upcase}"
    text = "#{I18n.t("users.deleted_name")} -  #{text}" if self.archived?
    text.html_safe
  end

  def restricted_statuses
    self.archived? ? ["setup", "archived"] : [self.status, "archived"]
  end


  protected
    def self.hsl_colors
      # background
      s_bckg = pick(66, 100)
      l_bckg = pick(32, 50)
      # txt
      s_txt  = pick(36,76)
      l_txt  = pick(76, 95)
      # hue
      h_user = h_random pick(0, 1000)

      letters = to_hsl(h_user,s_txt,l_txt)
      background = to_hsl(h_user,s_bckg,l_bckg)
      letters + ";" + background
    end

    def format_fields
      self.lastname = lastname.upcase unless self.lastname.nil?
      self.email = email.downcase unless self.email.nil?
      self.role ||= 'player'
      self.color ||= User.hsl_colors
      self.phone_number_format
    end

  end
