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
    indicators.each do |indic|
      @dashboard.add Indicator.new indic
    end
    @dashboard.sort

    @periods = {
      three_month: 3.months.ago,
      six_month: 6.months.ago,
      a_year: 1.year.ago
    }
    @a_year = { a_year: 1.year.ago }

    @res = display(@dashboard)
  end

  private

  def display(dashboard)
    res = []
    User.active.each do |person|
      identification = {
        firstname: person.firstname,
        lastname: person.lastname,
        id: person.id,
        shows_data: []
      }
      dashboard.indicator_collection.each do |indicator|
        indicator.people_performance_count
        identification[:shows_data] << [
          indicator.get_person_activity(person.id),
          indicator.average_role_count,
          indicator.period_label
        ]
      end
      res << identification
    end
    res
  end
end
