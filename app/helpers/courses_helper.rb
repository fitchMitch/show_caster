module CoursesHelper
  def default_duration(event)
    event.duration || '3 h'
  end

  def coach_name(event)
    name = event.courseable.nil? ? event.user.full_name : event.courseable.full_name
    star = fa_icon 'star', class: 'star_coach'
    res = event.courseable_type == 'Coach' ? "#{star} #{name} #{star}" : name
    res.html_safe
  end

  def course_label(event)
    if event.courseable_type == 'Coach'
      "Coach : #{event.courseable.full_name}"
    else
      "Auto coaché par #{event.courseable.full_name}"
    end
  end
end
