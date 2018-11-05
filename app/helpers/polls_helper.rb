module PollsHelper
  def poll_date(this_date)
    condition = (this_date.is_a? Date) || (this_date.is_a? Time)
    condition ? I18n.l(this_date, format: "%a %d %b") : this_date
  end

  def poll_datetime(this_date)
    condition = (this_date.is_a? Date) || (this_date.is_a? Time)
    condition ? I18n.l(this_date, format: "%a %d %b | %H:%M") : this_date
  end

  def answers_list(poll)
    li = []
    case poll.type
    when 'PollOpinion'
      li = poll.answers.map { |a| content_tag :li, a.answer_label }
    when 'PollDate'
      if poll.answers.any?
        li = poll.answers.map do |a|
          content_tag :li, poll_datetime(a.date_answer)
        end
      end
    else
      Rails.logger.debug("unexpected type : #{poll.type}")
    end
    tag = "<ul>#{li.join('')}</ul>"
    tag = "<ol>#{li.join('')}</ol>" if poll.type == 'PollOpinion'
    tag.html_safe
  end

  def panel_question(poll)
    common_part = [
      "|",
      "<span class='badge'>#{poll.votes_count}</span>",
      I18n.t('polls.responses_sent')
    ]
    heading_poll_opinion = [
      fa_icon("question-circle lg"),
      "#{ I18n.t('polls.opinion_question')}"
    ] + common_part
    heading_poll_date = [
      fa_icon("calendar lg"),
      "#{ I18n.t('polls.calendar_question')}"
    ] + common_part
    heading_opinion = heading_poll_opinion.join("#{ image_tag("transp.png")}").html_safe
    heading_date= heading_poll_date.join("#{ image_tag("transp.png")}").html_safe
    question = "<strong>#{poll.question}</strong>".html_safe
    case poll.type
      when 'PollOpinion'
        panel question, heading: heading_opinion, context: :warning
      when 'PollDate'
        panel question, heading: heading_date, context: :info
      else
        Rails.logger.debug("unexpected type : #{poll.type}")
        nil
    end
  end

  def link_to_edit(poll)
    if poll.is_a? PollOpinion
      link_to fa_icon("edit lg"), edit_poll_opinion_path(poll)
    elsif poll.is_a? PollDate
      link_to fa_icon("edit lg"), edit_poll_date_path(poll)
    end
  end

end
