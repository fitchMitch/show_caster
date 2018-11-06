require 'rails_helper'

RSpec.describe Dashboard, type: :model do
  let(:indicator) do
    Indicator.new(
      role: 0,
      period_label: 'l1',
      period_start_time: Time.zone.now
    )
  end
  let(:indicator2) do
    Indicator.new(
      role: 2,
      period_label: 'l2',
      period_start_time: Time.zone.now - 1.months
    )
  end
  let(:indicator3) do
    Indicator.new(
      role: 1,
      period_label: 'l3',
      period_start_time: Time.zone.now
    )
  end
  let(:indicator4) do
    Indicator.new(
      role: 0,
      period_label: 'l4',
      period_start_time: Time.zone.now - 2.months
    )
  end
  let(:indicator5) do
    Indicator.new(
      role: 0,
      period_label: 'l5',
      period_start_time: Time.zone.now - 1.months
    )
  end
  describe '#sort' do
    let!(:dashboard) do
      Dashboard.new
               .add(indicator)
               .add(indicator2)
               .add(indicator3)
               .add(indicator4)
               .add(indicator5)
    end
    it 'sorts activity first by role, then by decreasing start_time' do
      expect(dashboard.sort.indicator_collection.first).to eq(indicator)
      expect(dashboard.sort.indicator_collection.second).to eq(indicator5)
      expect(dashboard.sort.indicator_collection.third).to eq(indicator4)
      expect(dashboard.sort.indicator_collection.fourth).to eq(indicator3)
      expect(dashboard.sort.indicator_collection.fifth).to eq(indicator2)
    end
  end

  describe '#display' do
    let!(:performance) { create(:performance, event_date: Time.zone.now - 15.days) }
    let!(:performance2) { create(:performance, event_date: Time.zone.now - 45.days) }
    let!(:actor) { create(:actor, stage_role: 0, event_id: performance.id) }
    let!(:actor2) { create(:actor, stage_role: 0, event_id: performance.id) }
    let!(:actor3) { create(:actor, stage_role: 0, event_id: performance2.id) }
    let!(:actor4) do
      create(:actor,
              stage_role: 0,
              event_id: performance2.id,
              user_id: actor2.user.id
      )
    end
    let!(:dashboard) do
      Dashboard.new
               .add(indicator4)
               .add(indicator2)
    end
    it 'collects the indicators from each Users' do
      res = dashboard.display
      mensch = res.find { |act| act[:id] == actor2.user.id }
      expect(mensch[:shows_data]). to eq [[2, 0], [0, 0]]
      mensch2 = res.find { |act| act[:id] == actor.user.id }
      expect(mensch2[:shows_data]). to eq [[1, 0], [0, 0]]
    end
  end
end

RSpec.describe Indicator, type: :model do
  let(:players_one_month) do
    {
      role: 0,
      period_start_time: Time.zone.now - 1.month,
      period_label: 'Over a month'
    }
  end
  describe '#initialize' do
    let(:valid_hash) do
      {
        period_start_time: Time.zone.now,
        role: 0,
        period_label: 'string'
      }
    end
    it 'gets a hash' do
      expect { Indicator.new(1) }.to raise_error(ArgumentError)
    end
    it 'expects a role a start_time and a period_label' do
      expect { Indicator.new(role: 0) }.to raise_error(ArgumentError)
      expect do
        Indicator.new(
          period_start_time: Time.zone.now
        )
      end.to raise_error(ArgumentError)
      expect do
        Indicator.new(
          period_start_time: Time.zone.now,
          role: 0
        )
      end.to raise_error(ArgumentError)
      expect { Indicator.new(valid_hash) }.not_to raise_error
    end

    it 'initializes counts and activity' do
      indicator = Indicator.new(valid_hash)
      expect(indicator.show_with_role_count).to eq(0)
      expect(indicator.average_role_count).to eq(0)
      expect(indicator.person_activity).to be_empty
    end
  end
  describe '#people_performance_count' do
    context 'with performance in the future only' do
      let!(:performance) { create(:performance) } # default is the future
      let!(:actor) { create(:actor, stage_role: 0, event_id: performance.id) }
      let!(:actor2) { create(:actor, stage_role: 0, event_id: performance.id) }
      let(:indicator) { Indicator.new(players_one_month) }
      before do
        indicator.people_performance_count
      end
      it 'cumulates the number of shows with current role and finds zero' do
        expect(indicator.show_with_role_count).to eq(0)
        expect(indicator.average_role_count).to eq(0)
        expect(indicator.person_activity).to be_empty
      end
    end
    context 'with performances in the past' do
      let!(:performance) { create(:performance, event_date: Time.zone.now - 15.days) }
      let!(:actor) { create(:actor, stage_role: 0, event_id: performance.id) }
      let!(:actor2) { create(:actor, stage_role: 0, event_id: performance.id) }
      let(:indicator) { Indicator.new(players_one_month) }
      before do
        indicator.people_performance_count
      end
      it 'cumulates the number of shows with current role and finds zero' do
        expect(indicator.show_with_role_count).to eq(2)
        expect(indicator.person_activity.count).to eq(2)
      end
    end
  end
  describe '#get_person_activity' do
    let!(:performance) { create(:performance, event_date: Time.zone.now - 15.days) }
    let!(:actor) { create(:actor, stage_role: 0, event_id: performance.id) }
    let!(:actor2) { create(:actor, stage_role: 0, event_id: performance.id) }
    let(:indicator) { Indicator.new(players_one_month) }
    before do
      indicator.people_performance_count
    end
    it 'computes the average number of show with current role' do
      expect(indicator.get_person_activity(actor.user.id)).to eq(1)
      expect(indicator.get_person_activity(9999)).to eq(0)
    end
  end
end
