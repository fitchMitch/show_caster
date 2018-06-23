class Dashboard

  include ActiveModel::AttributeAssignment
  attr_accessor :role, :periods

  def initialize(attributes)
      att = check_attributes(attributes)
      self.role = att[:role]
      self.periods = att[:periods]
  end


  def self.played_since(starting, ending = nil, role_nr = 0)
    # returns [count_me, perso (=user_id)]
    ending ||= Time.zone.now
    Performance
      .select('count(events.theater_id) as count_me', 'actors.user_id as perso' )
      .where('events.event_date > ? and events.event_date < ? ', starting , ending)
      .where('actors.stage_role = ?', role_nr)
      .joins(:actors)
      .group('perso')
      .order('count_me asc')
      # TODO consider active people only
  end

  def check_attributes(attri)
    role = attri.fetch(:role, 0)
    raise 'periods is not a hash' unless attri[:periods].is_a? Hash
    attri[:periods].each do |key,val|
      raise 'dates are not timezoned' unless val.is_a? Time
    end
    { role: role,
      periods: attri[:periods]
    }
  end

end
