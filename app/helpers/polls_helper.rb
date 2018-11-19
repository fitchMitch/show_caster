module PollsHelper
  def poll_date(this_date)
    condition = (this_date.is_a? Date) || (this_date.is_a? Time)
    condition ? l(this_date, format: "%a %d %b") : this_date
  end

  def poll_datetime(this_date)
    condition = (this_date.is_a? Date) || (this_date.is_a? Time)
    condition ? l(this_date, format: "%a %d %b | %H:%M") : this_date
  end

  def answers_list(poll)
    return nil unless poll.respond_to?(:type)
    li = []
    case poll.type
    when 'PollOpinion', 'PollSecretBallot'
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
    return nil unless poll.respond_to?(:question) && poll.respond_to?(:type)
    question = "<strong>#{poll.question}</strong>".html_safe
    case poll.type
    when 'PollOpinion'
      panel question,
            heading: panel_header(
              '010-opinion.png',
              'opinion_question',
              poll
            ),
            context: :warning

    when 'PollSecretBallot'
      panel question,
            heading: panel_header(
              '033-woman.png',
              'secret_ballot_question',
              poll
            ),
            context: :danger
    when 'PollDate'
      panel question,
            heading: panel_header(
              '023-calendar.png',
              'calendar_question',
              poll
            ),
            context: :info
    else
      Rails.logger.debug("unexpected poll type : #{poll.type}")
    end
  end

  def panel_header(image, label, poll)
    [
      image_tag("icons/png/#{image}", size: 28),
      t("polls.#{label}"),
      '|',
      "<span class='badge'>#{poll.votes_count}</span>",
      t('polls.responses_sent')
    ].join(image_tag('transp.png')).html_safe
  end

  def link_to_edit(poll)
    if poll.is_a? PollOpinion
      link_to fa_icon('edit 2x'), edit_poll_opinion_path(poll)
    elsif poll.is_a? PollDate
      link_to fa_icon('edit 2x'), edit_poll_date_path(poll)
    end
  end
end
