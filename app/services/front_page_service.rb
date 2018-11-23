class FrontPageService
  def next_performances(n = 5)
    Event.performances
         .future_events
         .limit(n)
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
end
