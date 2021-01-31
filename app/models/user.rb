# frozen_string_literal: true
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable
  acts_as_commontator
  acts_as_taggable_on :committees
  # includes
  include Users::Formating
  include Users::Validating
  # Pre and Post processing
  before_validation :format_fields, on: %i[create update]
  after_invitation_accepted :ask_for_phone_number
  after_invitation_accepted :format_fields

  # Enums
  enum status: {
    invited: 0,
    missing_phone_nr: 1,
    registered_with_no_pic: 2,
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
  # scope :inactive,
  #       lambda  {
  #         where(role: :other).or(where(status: %i[setup archived]))
  #       }
  scope :active,
        lambda {
          where(status: %i[invited registered]).where.not(role: :other)
        }
  scope :active_admins,
        -> { active.where(role: :admin) }
  scope :active_count,
        -> { active.count }
  # =====================
  # Validations
  # =====================

  validates :email,
            presence: true,
            length: { maximum: 255, minimum: 5 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  validates :uid, uniqueness: { case_sensitive: true }, allow_nil: true
  validates :bio, length: { maximum: 250 }

  # =====================
  # --    PUBLIC      ---
  # =====================

  def self.company_mails
    User.active.pluck(:email)
  end

  def has_downloaded_his_picture?
    Picture.where(imageable_id: id)
           .where(imageable_type: 'User')
           .present?
  end

  def last_connexion_at
    return former_connexion_at if former_connexion_at.present?

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

  def update_status(user_params)
    if invited? && user_params[:cell_phone_nr].blank?
      missing_phone_nr!
    elsif (invited? || missing_phone_nr?) && user_params[:cell_phone_nr].present?
      registered_with_no_pic!
    elsif registered_with_no_pic? && has_downloaded_his_picture?
      registered!
    end
    self
  end

  def welcome_mail
    UserMailer.welcome_mail(self).deliver_now
  end

  def send_promotion_mail(changes)
    UserMailer.send_promotion_mail(self, changes).deliver_now
  end

  def restricted_statuses
    archived? ? ['missing_phone_nr', 'archived'] : [status.to_s, 'archived']
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

  def self.active_count
    User.active.count
  end

  protected

  def promotions_to_mute(old_user)
    show_promotion = old_user.status == 'archived' || more_privileges?(old_user)
    !show_promotion
  end

  def flash_promotion_with(changes)
    changes ? 'users.promoted' : 'users.promoted_muted'
  end

  def more_privileges?(previous_user)
    return true if previous_user.role == 'other'

    User.roles[role] >= User.roles[previous_user.role]
  end

  def format_fields
    self.lastname = lastname.upcase if lastname.present?
    self.email = email.downcase if email.present?
    self.role ||= 'player'
    self.color ||= pick_color
    phone_number_format
  end

  def ask_for_piask_for_phone_numbercture
    missing_phone_nr!
  end
end
