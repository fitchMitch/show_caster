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

class PollOpinion < Poll
  #-----------
  # Includes
  #-----------
  #-----------
  # Callbacks
  #-----------
  # Relationships
  #-----------
  # Validations
  #-----------

  # Scope
  #-----------
  
  # scope :found_by, -> (user) { where('user_id = ?', user_id) }
  # scope :expecting_answer, -> { where(status: [:invited, :googled, :registered])}
  # ------------------------
  # --    PUBLIC      ---
  # ------------------------
end
