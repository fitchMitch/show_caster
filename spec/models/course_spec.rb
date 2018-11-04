# == Schema Information
#
# Table name: events
#
#  id              :integer          not null, primary key
#  event_date      :datetime
#  duration        :integer
#  progress        :integer          default("draft")
#  note            :text
#  user_id         :integer
#  theater_id      :integer
#  fk              :string
#  provider        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  title           :string
#  type            :string           default("Performance")
#  courseable_id   :integer
#  courseable_type :string
#

require 'rails_helper'

RSpec.describe Course, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:theater) }
  it { should validate_presence_of(:event_date) }

  describe '#google_event_params' do
    it 'shoulde set google calendar params ok'
  end
end
