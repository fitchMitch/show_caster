class DashboardsController < ApplicationController

  # respond_to :html, :json, :js

  def index
    @periods = {
      three_month: 3.months.ago,
      six_month: 6.months.ago,
      a_year: 1.year.ago
    }
    @a_year = { a_year: 1.year.ago }

    requests = []
    requests << Dashboard.new({role: 0, periods: @periods})
    requests << Dashboard.new({role: 1, periods: @a_year})
    requests << Dashboard.new({role: 2, periods: @a_year})

    @res = set_perfs(requests)
  end

  private
    def set_perfs(requests)
      computed = []
      requests.each do |r|
        r.periods.each do |label_duration, start_date|
          # n_perf is an array, av_perf a scalar
          n_perf, av_perf = init_compute(start_date, r.role)
          computed << [n_perf, av_perf, label_duration ]
        end
      end
      associate_perf_to_people(computed)
    end

    def init_compute(start_date, role_nr)
      # Dashboard returns [count_me, perso (=user_id)]
      n_perf  = Dashboard.played_since( start_date, nil, role_nr)
      av_perf = get_average( n_perf )
      return n_perf, av_perf
    end

    def get_average(n_perf_period)
      total = n_perf_period.inject(0) { |sum, n| sum + n.count_me unless n.count_me.nil?}
      total / User.active.count
    end

    def associate_perf_to_people (computed)
      res = []
      User.active.each do |person|
        identification = {
          firstname: person.firstname,
          lastname: person.lastname,
          id: person.id,
          data: []
        }
        computed.each do |analysis|
          # analysis 0 is the [nr of performances]
          # analysis 1 is average
          # analysis 2 is the period label
          identification[:data] << [getData(person.id, analysis[0]),analysis[1],analysis[2]]
        end
        res << identification
      end
      res
    end

    def getData(user_id, n_perf_period)
      n_perf_period.each do |event|
        return event.count_me if event.perso == user_id
      end
      nil
    end
end
