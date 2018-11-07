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
  #delegate :firstname,:lastname, :full_name, to: :member
  # =====================

  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
  scope :active, -> { where(status: [:invited, :googled, :registered])}
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
    data = access_token[:info]
    user = User.retrieve(data)
    result = if user.nil?
      'unknown user'
    else
      credentials = access_token[:credentials]
      if credentials[:expires_at].nil? || data[:email].nil?
        Rails.logger.error(access_token.to_s)
        nil
      else
        firstname = data[:first_name].nil? ? user.firstname : data[:first_name]
        lastname = data[:last_name].nil? ? user.lastname : data[:last_name].upcase
        from_token = {
          firstname: firstname,
          lastname: lastname,
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
          Rails.logger.error 'OAuth user updating went wrong'
          Rails.logger.error from_token
          nil
        end
      end
    end
  end

  def self.retrieve(data)
    user = User.find_by_email(data[:email].downcase)
    if user.nil? && !data[:last_name].nil? && !data[:first_name].nil?
      users = User.where(firstname: data[:first_name])
                  .where(lastname: data[:last_name])
      user = users.count >= 1 ? users.first : nil
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
