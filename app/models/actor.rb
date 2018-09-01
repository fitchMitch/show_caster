# == Schema Information
#
# Table name: actors
#
#  id         :integer          not null, primary key
#  stage_role :integer
#  user_id    :integer
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Actor < ApplicationRecord
  # includes

  # Pre and Post processing

  # Enums
  enum stage_role: {
      player: 0,
      dj: 1,
      mc: 2,
      other: 3
    }

  # Relationships
  belongs_to :performance, foreign_key: "event_id"
  belongs_to :user

  # Validations
  validates_associated :user, :performance

  # Scopes

  # ------------------------
  # --    PUBLIC      ---
  # ------------------------

  # ------------------------
  # --    Protected      ---
  # ------------------------
  # protected
  # ------------------------
  # --    PRIVATE      ---
  # ------------------------
  # private
end
