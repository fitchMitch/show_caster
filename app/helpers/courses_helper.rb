module CoursesHelper
  def default_duration(event)
     event.duration || '3 h'
  end

  def coach_name(event)
    name  = event.courseable.full_name
    star = fa_icon "star", class: "star_coach"
    res = event.courseable_type == 'Coach' ? "#{star} #{name} #{star}" : name
    res.html_safe
  end
end
