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
  acts_as_commontator
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
  # =====================

  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
  scope :active, -> {
    where(
      status: [:invited, :googled, :registered]
    ).where.not(
      role: :other
    )
  }
  scope :active_count, -> { active.count }
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
  def self.from_omniauth(access_token)
    user = User.retrieve(access_token[:info])
    return 'unknown user' if user.nil?

    update_parameters = GoogleCalendarService.token_user_information(
      user, access_token
    )

    if access_token[:credentials][:expires_at].nil? ||
       access_token[:info][:email].nil?
      Rails.logger.error(access_token.to_s)
      nil
    elsif user.update_attributes(update_parameters)
      user
    else
      Rails.logger.error 'OAuth user updating went wrong'
      Rails.logger.error user_update_parameters
      Bugsnag.notify("Oauth and update user faulty : #{from_token}")
      nil
    end
  end

  def self.retrieve(data)
    user = User.find_by_email(data[:email].downcase)
    if user.nil? && data[:last_name].presence && data[:first_name].presence
      user = User.find_by_firstname_and_lastname(
        data[:first_name], data[:last_name]
      )
    end
    user
  end

  def self.company_mails
    User.active.pluck(:email)
  end

  def full_name
    text = first_and_last_name
    text = "#{I18n.t('users.deleted_name')} -  #{text}" if archived?
    text.html_safe
  end

  def is_commontator
    true
  end

  def welcome_mail
    UserMailer.welcome_mail(self).deliver_now
  end

  def send_promotion_mail
    UserMailer.send_promotion_mail(self).deliver_now
  end

  def restricted_statuses
    archived? ? %w[setup archived] : [status, 'archived']
  end

  def hsl_user_color1
    color.split(';').first
  end

  def hsl_user_color2
    color.split(';').second
  end

  def inform_promoted_person(current_user, old_user)
    # No mail when
    exclusion_cases = current_user == self ||
                      (role == 'player' && old_user.status != 'archived') ||
                      (role == 'admin_com' && old_user.role == 'admin')
    send_promotion_mail unless exclusion_cases
    # messaging
    promotion_message(exclusion_cases)
  end

  def promotion_message(exclusion)
    exclusion ? 'users.promoted_muted' : 'users.promoted'
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
