class Dashboard
  include ActiveModel::AttributeAssignment
  attr_accessor :indicator_collection, :periods

  def initialize
    self.indicator_collection = []
    self.periods = []
  end

  def add(indicator)
    indicator_collection << indicator
    self
  end

  def sort
    return self if indicator_collection.size <= 1
    # This is inelegant : because ruby would not accept a sorting on date
    # with a desc (minus sign) on Times, I head to reverse the sorting in
    # the end and have the desc part on roles instead.
    self.indicator_collection = indicator_collection.sort_by do |indic|
      [-indic.role, indic.period_start_time]
    end.reverse
    self
  end

  def display
    res = []
    User.active.each do |person|
      identification = {
        firstname: person.firstname,
        lastname: person.lastname,
        id: person.id,
        shows_data: []
      }
      indicator_collection.each do |indicator|
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

  # def get_periods
  #   periods = []
  #   indicator_collection.each do |indi|
  #     periods << indi.period_label
  #   end
  #   periods.uniq
  # end
end

class Indicator
  include ActiveModel::AttributeAssignment
  attr_accessor :role,
                :period_label,
                :period_start_time,
                :show_with_role_count,
                :average_role_count,
                :person_activity

  def initialize(attributes)
    att = check_attributes(attributes)
    self.role = att[:role]
    self.period_label = att[:period_label]
    self.period_start_time = att[:period_start_time]
    self.show_with_role_count = 0
    self.average_role_count = 0
    self.person_activity = []
  end

  def people_performance_count(ending = nil)
    # returns [count_me, perso (=user_id)]
    ending ||= Time.zone.now
    activity = get_performance(ending)
    activity.each do |act|
      self.person_activity << PersonActivity.new(act.perso, act.count_me)
    end
    show_with_role_count_update(activity) && get_average_role_count
  end

  def get_person_activity(user_id)
    targetted_person_activity = person_activity.find do |activity|
      activity.user_id == user_id
    end
    targetted_person_activity.nil? ? 0 : targetted_person_activity.perf_count
  end

  private

  def get_performance(ending)
    Performance
      .select('count(events.theater_id) as count_me', 'actors.user_id as perso')
      .where('events.event_date > ? and events.event_date <= ?', period_start_time, ending)
      .where('actors.stage_role = ?', role)
      .joins(:actors)
      .group('perso')
      .order('count_me asc')
  end

  def show_with_role_count_update(activity)
    self.show_with_role_count = activity.inject(0) do |sum, n|
      sum + n.count_me if n.count_me.present?
    end
    true
  end

  def get_average_role_count
    self.average_role_count = show_with_role_count / User.active.count
    true
  end

  def check_attributes(attri)
    role = attri.fetch(:role)
    raise 'periods is not a hash' unless attri[:role].is_a? Integer
    period_label = attri.fetch(:period_label)
    raise 'periods is not a String' unless attri[:period_label].is_a? String
    period_start_time = attri.fetch(:period_start_time)
    raise 'periods is not a hash' unless attri[:period_start_time].is_a? Time
    {
      role: role,
      period_label: period_label,
      period_start_time: period_start_time
    }
  end
end

class PersonActivity
  attr_accessor :user_id, :perf_count
  def initialize(user_id, perf_count)
    @user_id = user_id
    @perf_count = perf_count
  end
end
