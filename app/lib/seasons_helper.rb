# frozen_string_literal: true

module SeasonsHelper

  SEASONS = %w[spring summer fall winter]

  def season_at(a_date)
    current_year = a_date.year

    (spring_start,
      summer_start,
      fall_start,
      winter_start
    ) = [3, 6, 9, 12].map do |month|
      season_start(current_year, month)
    end

    if (a_date.beginning_of_year...spring_start).cover?(a_date)
      'winter'
    elsif (spring_start...summer_start).cover?(a_date)
      'spring'
    elsif (summer_start...fall_start).cover?(a_date)
      'summer'
    elsif (fall_start...winter_start).cover?(a_date)
      'fall'
    else
      'winter'
    end
  end

  def current_season
    season_at(Date.today)
  end

  def season_start(current_year, month)
    Date.new(current_year, month, 21)
  end

  def next_season
    SEASONS.rotate[SEASONS.index(current_season)]
  end
end
