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

RSpec.describe Performance, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:theater) }
  it { should have_many(:actors) }
  it { should validate_presence_of(:event_date) }
  it 'should count an actor at least which stage_role is player'

  describe 'scope next_shows' do
    let!(:now) { Time.zone.now }
    let!(:performance0) do
      create(:performance_with_actors, event_date: now + 3.days)
    end
    let!(:performance) do
      create(:performance_with_actors, event_date: now + 2.days)
    end
    let!(:performance2) do
      create(:performance_with_actors, event_date: now - 2.days)
    end
    it 'should return user\'s next show' do
      user1_id = performance.actors.first.user_id
      expect(Performance.next_shows(user1_id).to_a.first.event_date.to_i).to eq(
        performance.event_date.to_i
      )
    end
    it 'should return empty when show\'s in the passed' do
      user2_id = performance2.actors.first.user_id
      expect(Performance.next_shows(user2_id).to_a.size).to eq(0)
    end
  end

  describe 'scope previous_shows' do
    let!(:now) { Time.zone.now }
    let!(:performance0) do
      create(:performance_with_actors, event_date: now - 3.days)
    end
    let!(:performance) do
      create(:performance_with_actors, event_date: now + 2.days)
    end
    let!(:performance2) do
      create(:performance_with_actors, event_date: now - 2.days)
    end
    it 'should return user\'s previous show' do
      user2_id = performance2.actors.first.user_id
      expect(Performance.previous_shows(user2_id).to_a.first.event_date.to_i).to eq(
        performance2.event_date.to_i
      )
    end
    it 'should return empty when show\'s in the passed' do
      user_id = performance.actors.first.user_id
      expect(Performance.previous_shows(user_id).to_a.size).to eq(0)
    end
  end

  describe '#google_event_params' do
    let!(:performance) { build(:performance_with_actors) }
    it 'should return a formatted hash to regiser a google event' do
      attendees_email = []
      performance.actors.pluck(:user_id) do |id|
        email = User.find_by(id: id).email
        attendees_email << { email: email }
      end
      expect(performance.google_event_params).to eq(
        {
          title: I18n.t(
            'performances.g_title_performance',
            name: performance.theater.theater_name
          ),
          location: performance.theater.location,
          theater_name: performance.theater.theater_name,
          event_date: performance.event_date.iso8601,
          event_end: (
            performance.event_date + performance. duration * 60
          ).iso8601,
          attendees_email: attendees_email,
          fk: performance.fk
        }
      )
    end
  end
end
