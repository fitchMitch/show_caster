# == Schema Information
#
# Table name: events
#
#  id                      :integer          not null, primary key
#  event_date              :datetime
#  datetime with time zone :datetime
#  duration                :integer
#  note                    :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :integer
#  location_id             :integer
#  progress                :integer          default("draft")
#  fk                      :string
#  provider                :string
#

require 'rails_helper'

RSpec.describe Event, type: :model do
    it { should belong_to(:user) }
    it { should belong_to(:theater) }
    it { should have_many(:actors) }
    it { should validate_presence_of(:event_date) }
    it "should count an actor at least which stage_role is player"
end
