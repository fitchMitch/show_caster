# == Schema Information
#
# Table name: polls
#
#  id              :integer          not null, primary key
#  question        :string
#  expiration_date :date
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Poll < ApplicationRecord
  #-----------
  # Includes
  #-----------
  #-----------
  # Callbacks
  #-----------

  # Relationships
  #-----------
  has_many :poll_opinions, class_name: 'PollOpinion'
  has_many :poll_dates, class_name: 'PollDate'

  has_many :answers,
    dependent: :destroy,
    inverse_of: :poll_opinion ,
    foreign_key: "poll_id",
    class_name: 'Answer'
  accepts_nested_attributes_for :answers,
    reject_if: :all_blank,
    allow_destroy: true

  # Validations
  #-----------

  # Scope
  #-----------
  default_scope  -> { order('expiration_date ASC')}
  scope :opinion_polls, -> {where('type = ?' , 'PollOpinion')}
  scope :date_polls, -> {where('type = ?' , 'PollDate')}
  scope :passed_ordered, -> {unscoped.order('expiration_date DESC')}
  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
  # scope :expecting_answer, -> { where(status: [:invited, :googled, :registered])}
  scope :expired, -> { where('expiration_date < ?', Time.zone.now)}
  scope :active, -> { where('expiration_date >= ?', Time.zone.now)} #TODO 
  scope :expecting_answer, -> { where('expiration_date >= ?', Time.zone.now)} #TODO
  # ------------------------
  # --    PUBLIC      ---
  # ------------------------

end
