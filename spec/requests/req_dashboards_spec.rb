require 'rails_helper'
# index only !! according to routes
RSpec.describe 'Dashboards', type: :request do
  let(:performance) do
    create(
      :performance_with_actors,
      event_date: Time.zone.now - 2.months
    )
  end
  let(:performance2) do
    create(
      :performance_with_actors,
      event_date: Time.zone.now - 6.months
    )
  end
  let(:indicator1) do
    Indicator.new(
      role: 0,
      period_label: 'l1',
      period_start_time: Time.zone.now - 3.months
    )
  end
  let(:indicator2) do
    Indicator.new(
      role: 1,
      period_label: 'l2',
      period_start_time: Time.zone.now - 3.months
    )
  end
  let(:dashboard) { Dashboard.new.add(indicator1).add(indicator2) }
  let!(:admin) { create(:user, :admin, :registered) }

  context '/ As logged as admin,' do
    before do
      sign_in(admin)
    end

    describe 'GET #index' do
      it 'renders polls index' do
        get '/dashboard'
        expect(response).to render_template(:index)
      end
    end
  end
end
