require 'rails_helper'
RSpec.describe 'FrontPageService', type: :service do
  let!(:fps) { FrontPageService.new }
  describe '#next_performances' do
    before do
      6.times { create :performance_with_actors }
    end
    it 'should show 5 performances maximum' do
      expect(fps.next_performances.count).to eq 5
    end
    it 'should be ordered by performance_date' do
      expect(fps.next_performances.to_a[0..4].each_cons(2).all? do |a, b|
        a.event_date <= b.event_date
      end).to be true
    end
    it 'events should be set in the ' do
      5.times do
        create(:performance_with_actors, event_date: Time.zone.now - 2.days)
      end
      expect(fps.next_performances.to_a.all? do |event|
        event.event_date >= Time.zone.now
      end).to be true
    end
  end

  describe '#players_on_stage' do
    let!(:performance_with_actors) { create(:performance_with_actors_standard) }
    it 'it should list 6 firstnames' do
      expect(fps.players_on_stage(performance_with_actors).count).to eq(6)
    end
    it 'last_name is the mc\'s name' do
      actor_found = performance_with_actors.actors.find do |actor|
        actor.stage_role == 'mc'
      end
      expect(
        fps.players_on_stage(performance_with_actors).last
      ).to eq(actor_found.user.firstname)
    end
  end
end
