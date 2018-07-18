module PollsHelper
  def poll_date(this_date)
    condition = (this_date.is_a? Date) || (this_date.is_a? Time)
    condition ? I18n.l(this_date, format:"%a %d %b") : this_date
  end

  def poll_datetime(this_date)
    condition = (this_date.is_a? Date) || (this_date.is_a? Time)
    condition ? I18n.l(this_date, format:"%a %d %b | %H:%M") : this_date
  end

  def answers_list(poll)
    li = []
    case poll.type
      when 'PollOpinion'
        li = poll.answers.map { |a| content_tag :li, a.answer }
      when 'PollDate'
        li = poll.answers.map { |a| content_tag :li, poll_datetime(a.date_answer) } if poll.answers.any?
      else
        Logger.debug("unexpected type : #{poll.type}")
    end
    li.join('').html_safe
  end

  def link_to_edit(poll)
    if poll.is_a? PollOpinion
      link_to fa_icon("edit lg"), edit_poll_opinion_path(poll)
    elsif poll.is_a? PollDate
      link_to fa_icon("edit lg"), edit_poll_date_path(poll)
    end
  end

end
