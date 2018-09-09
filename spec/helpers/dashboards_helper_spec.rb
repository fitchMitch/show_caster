require 'rails_helper'

RSpec.describe DashboardsHelper, type: :helper do
  describe '#show_perf' do
    let(:reci_1) { ['1','2'] }
    let(:reci_2) { ['2','1'] }
    it 'shall give the green block' do
      expect(helper.show_perf(reci_1)).to include('success')
      expect(helper.show_perf(reci_1)).to include('1')
    end
    it 'shall give the red block' do
      expect(helper.show_perf(reci_2)).to include('danger')
      expect(helper.show_perf(reci_2)).to include('2')
    end
  end
end
