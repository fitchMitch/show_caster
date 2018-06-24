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

require 'rails_helper'

RSpec.describe Performance, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:theater) }
  it { should have_many(:actors) }
  it { should validate_presence_of(:event_date) }
  it 'should count an actor at least which stage_role is player'
end