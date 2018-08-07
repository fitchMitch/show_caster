class DashboardsController < ApplicationController

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
          # nr_of_shows is an array, avrg_nr_of_shows a scalar
          nr_of_shows, avrg_nr_of_shows = init_compute(start_date, r.role)
          computed << [nr_of_shows, avrg_nr_of_shows, label_duration]
        end
      end
      associate_perf_to_people(computed)
    end

    def init_compute(start_date, role_nr)
      # Dashboard returns [count_me, perso (=user_id)]
      nr_of_shows  = Dashboard.played_since( start_date, nil, role_nr)
      avrg_nr_of_shows = get_average( nr_of_shows )
      return nr_of_shows, avrg_nr_of_shows
    end

    def get_average(nr_of_shows)
      total = nr_of_shows.inject(0) { |sum, n| sum + n.count_me if n.count_me.present?}
      total / User.active.count
    end

    def associate_perf_to_people (computed)
      res = []
      User.active.each do |person|
        identification = {
          firstname: person.firstname,
          lastname: person.lastname,
          id: person.id,
          shows_data: []
        }
        computed.each do |analysis|
          # analysis 0 is the [nr of performances]
          # analysis 1 is average of performances nr
          # analysis 2 is the period label
          identification[:shows_data] << [getData(person.id, analysis[0]), analysis[1], analysis[2]]
        end
        res << identification
      end
      res
    end

    def getData(user_id, nr_of_shows_period)
      nr_of_shows_period.each do |event|
        return event.count_me if event.perso == user_id
      end
      nil
    end
end
