# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  firstname       :string           not null
#  lastname        :string           not null
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
#  bio             :text
#

class User < ApplicationRecord
  # includes
  include Users::Formating
  include Users::Validating
  # Pre and Post processing
  before_validation :format_fields, on: %i[create update]

  # Enums
  enum status: {
    setup: 0,
    invited: 1,
    googled: 2,
    registered: 3,
    archived: 4
  }
  enum role: {
    player: 0,
    admin_com: 1,
    admin: 2,
    other: 3
  }

  # Relationships
  # =====================
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :courses, as: :courseable
  has_many :vote_opinions
  has_many :vote_dates
  has_many :polls, foreign_key: :owner_id
  #delegate :firstname,:lastname, :full_name, to: :member
  # =====================

  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
  scope :active, -> { where(status: [:invited, :googled, :registered])}
  scope :active_count, -> { active.count}
  # =====================

  # Validations
  # =====================

  validates :email,
    presence: true,
    length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  validates :uid, uniqueness: { case_sensitive: true }, allow_nil: true
  validates :bio, length: { maximum: 250 }

  # ------------------------
  # --    PUBLIC      ---
  # ------------------------
  def full_name
    text = self.first_and_last_name
    text = "#{I18n.t("users.deleted_name")} -  #{text}" if self.archived?
    text.html_safe
  end

  def self.from_omniauth(access_token)
    data = access_token[:info]
    user = User.retrieve(data)
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
  end

  def self.company_mails
    User.active.pluck(:email)
  end

  def welcome_mail
    UserMailer.welcome_mail(self).deliver_now
  end

  def promoted_mail
    UserMailer.promoted_mail(self).deliver_now
  end

  def restricted_statuses
    self.archived? ? ["setup", "archived"] : [self.status, "archived"]
  end

  protected

    def format_fields
      self.lastname = lastname.upcase if lastname.present?
      self.email = email.downcase if email.present?
      self.role ||= 'player'
      self.color ||= pick_color
      self.phone_number_format
    end

end
