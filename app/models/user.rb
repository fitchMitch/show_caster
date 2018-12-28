

class User < ApplicationRecord
  acts_as_commontator
  acts_as_taggable_on :committees
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
  belongs_to :committee
  # =====================

  scope :active, -> {
    where(status: %i[invited googled registered]).where.not(role: :other)
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
    User.active.map(&:prefered_email)
  end


  def has_downloaded_his_picture?
    !Picture.where(imageable_id: id).where(imageable_type: 'User').empty?
  end

  def last_connexion_at
    return former_connexion_at unless former_connexion_at.nil?

    last_sign_in_at.nil? ? (Time.zone.now - 100.years) : last_sign_in_at
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

  def send_promotion_mail(changes)
    UserMailer.send_promotion_mail(self, changes).deliver_now
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

  def self.committee_names_list
    User.committee_counts.pluck(:name)
  end

  def get_committee_changes(old_user_committees)
    lost_committees = old_user_committees - committee_list
    gained_committees = committee_list - old_user_committees
    {
      lost_committees: lost_committees,
      gained_committees: gained_committees,
      changed: !(lost_committees.empty? && gained_committees.empty?)
    }
  end

  def inform_promoted_person(current_user, old_user, old_user_committees)
    return 'users.updated' if current_user == self || status == 'archived'

    committy_changes = get_committee_changes(old_user_committees)
    committee_changed = committy_changes[:changed]

    muted_promotion = promotions_to_mute(old_user)
    role_changed = old_user.role != role

    if muted_promotion
      send_promotion_mail(committy_changes) if committee_changed
    elsif role_changed && !committee_changed
      send_promotion_mail(role: status)
    elsif (role_changed && committee_changed) ||  old_user.status == 'archived'
      send_promotion_mail(committy_changes.merge(role: role))
    elsif committee_changed
      send_promotion_mail(committy_changes)
    end

    # messaging
    flash_promotion_with((role_changed && !muted_promotion) || committee_changed)
  end

  def prefered_email
    alternate_email.nil? ? email : alternate_email
  end

  protected

  def promotions_to_mute(old_user)
    show_promotion = old_user.status == 'archived' || more_power(old_user)
    !show_promotion
  end

  def flash_promotion_with(changes)
    changes ? 'users.promoted' : 'users.promoted_muted'
  end

  def more_power(o_user)
    return true if o_user.role == 'other'

    User.roles[role] >= User.roles[o_user.role]
  end



  def format_fields
    self.lastname = lastname.upcase if lastname.present?
    self.email = email.downcase if email.present?
    self.role ||= 'player'
    self.color ||= pick_color
    self.phone_number_format
  end
end
