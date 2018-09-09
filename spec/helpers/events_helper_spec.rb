require 'rails_helper'

RSpec.describe EventsHelper, type: :helper do
  let(:event) { create(:performance) }
  describe '#short_label_helper' do
    it 'shall show a label' do
      expr = "<span class='label label-success'>"
      expect(helper.short_label_helper(event.id)).to include(expr)
      expect(helper.short_label_helper(event.id)).to include(event.theater.theater_name[0, 25])
    end
  end

  describe '#photo_indicator' do
    let(:event_pic) { create(:performance_with_picture) }
    it 'shall mute when no photo' do
      expect(helper.photo_indicator(event)).to be(nil)
    end
    it 'shall mute when no photo' do
      expect(helper.photo_indicator(event_pic)).to include('fa-image')
      expect(helper.photo_indicator(event_pic)).to include(event_pic.photo_count
                                                                    .to_s)
    end
  end

  describe '#link_to_event' do
    let!(:future_event) do
      build(:performance, event_date: Time.zone.now + 2.days)
    end
    let!(:passed_event) do
      build(:performance, event_date: Time.zone.now - 2.days)
    end
    let!(:passed_event_with_pic) do
      build(:performance_with_picture, event_date: Time.zone.now - 2.days)
    end
    it 'shall picture an image when event is passed and has picture' do
      expect(helper.link_to_event(passed_event_with_pic)).to include('fa-image')
    end
    it 'shall not picture an image when event is passed and no picture' do
      expect(helper.link_to_event(passed_event)).to include('fa-image')
    end
    it 'shall not picture an image when event is in the future' do
      expect(helper.link_to_event(future_event)).not_to include('fa-image')
    end
  end

  describe '#edit_event_path' do
    it 'shall propose a valid edit path' do
      target = "/performances/#{event.id}/edit"
      expect(helper.edit_event_path(event)).to eq(target)
    end
  end

  describe '#passed_label' do
    it 'shall give a proper passed label to events' do
      expect(helper
        .passed_label([event])).to eq I18n.t('performances.passed_events_title')
    end
  end
end
