# frozen_string_literal: true

class DashboardsController < ApplicationController
  def index
    @dashboard = Dashboard.new
    indicators = [
      { role: 0, period_label: 'three_month', period_start_time: 3.months.ago },
      { role: 0, period_label: 'six_month', period_start_time: 6.months.ago },
      { role: 0, period_label: 'a_year', period_start_time: 1.year.ago },
      { role: 1, period_label: 'a_year', period_start_time: 1.year.ago },
      { role: 2, period_label: 'a_year', period_start_time: 1.year.ago }
    ]
    indicators.each { |indic| @dashboard.add Indicator.new indic }
    @periods = {
      three_month: 3.months.ago,
      six_month: 6.months.ago,
      a_year: 1.year.ago
    }
    @res = @dashboard.sort.display
  end
end
