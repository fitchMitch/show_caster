# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  event_date :datetime
#  duration   :integer
#  progress   :integer          default("draft")
#  note       :text
#  user_id    :integer
#  theater_id :integer
#  fk         :string
#  provider   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  title      :string
#  type       :string           default("Performance")
#

class Course < Event

  private


end
