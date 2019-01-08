module SeasonsHelper
  @@seasons = %w[spring summer fall winter]
  def current_season
    now = Date.today
    current_year = now.year

    (spring_start,
      summer_start,
      fall_start,
      winter_start
    ) = [3, 6, 9, 12].map do |month|
      season_start(current_year, month)
    end

    if (now.beginning_of_year..spring_start - 1.day).cover?(now)
      'winter'
    elsif (spring_start..summer_start - 1.day).cover?(now)
      'spring'
    elsif (summer_start..fall_start - 1.day).cover?(now)
      'summer'
    elsif (fall_start..winter_start - 1.day).cover?(now)
      'fall'
    elsif (winter_start..now.end_of_year).cover?(now)
      'winter'
    else
      'fall'
    end
  end

  def season_start(current_year, month)
    Date.new(current_year, month, 21)
  end

  def next_season
    @@seasons.rotate[@@seasons.index(current_season)]
  end
end
