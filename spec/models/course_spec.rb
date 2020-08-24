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
  it { should validate_presence_of(:duration) }

  describe 'scope next_courses' do
    let!(:now) { Time.zone.now }
    let(:user) { create(:user) }
    let!(:course) { create(:course, event_date: now - 3.days) }
    let!(:course1) { create(:course, event_date: now + 2.days) }
    let!(:course2) { create(:course, event_date: now + 4.days) }
    it 'should give you 2 courses' do
      expect(Course.next_courses.to_a.size).to eq(2)
    end
    it 'should have course1 as first' do
      expect(
          (Course.next_courses.to_a.first.event_date - now - 2.days).abs.round
      ).to be < 1
    end
  end

  describe '.days_threshold_for_first_mail_alert' do
    it { expect(described_class.days_threshold_for_first_mail_alert).to eq 8 }
  end

end
