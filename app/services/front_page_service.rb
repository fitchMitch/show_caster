# frozen_string_literal: true

class FrontPageService
  def next_performances(count = 5)
    Event.performances
         .future_events
         .public_events
         .limit(count)
         .includes(:actors)
  end

  def players_on_stage(very_next_performance)
    next_players = very_next_performance.actors.where(stage_role: 'player')
    mc = very_next_performance.actors.where(stage_role: 'mc').first
    players_firstnames = []
    next_players.each do |player|
      players_firstnames << player.user.firstname
    end
    players_firstnames << mc.user.firstname unless mc.nil?
    players_firstnames
  end

  def photo_list(former_shows_count, photo_count)
    shows = Performance.passed_events
                       .public_events
                       .limit(former_shows_count)
    return if shows.empty?

    res = []
    shows.each do |show|
      res += Picture.last_pictures(show, photo_count)
    end
    res = res.shuffle[0..(photo_count - 1)] if res.size >= photo_count
    res
  end
end
