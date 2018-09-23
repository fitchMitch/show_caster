module VotesHelper
  def updown_icons
    "#{fa_icon('thumbs-up 2x')}#{image_tag('transp.png')}" \
    "#{fa_icon('thumbs-down 2x')}".html_safe
  end

  def vote_date_header(answer_vote)
    render partial: 'vote_dates/date_panel',
           locals: { display_date: answer_vote[:answer].date_answer }
  end

  def new_vote_path(poll)
    case poll.type
    when nil
      Rails.logger.fatal('poll without type !')
      nil
    when 'PollOpinion'
      link_to new_poll_opinion_vote_opinion_path(poll) do
        updown_icons
      end
    when 'PollDate'
      link_to new_poll_date_vote_date_path(poll) do
        updown_icons
      end
    else
      Rails.logger.debug('poll whith unknown type')
      nil
    end
  end

  def others_votes_list(answer, user)
    votes = VoteDate.where('poll_id = ?', answer.poll_id)
                    .where('answer_id = ?', answer.id)
                    .where('user_id = ?', user.id)
    vote_first_label = votes.any? ? votes.first.vote_label : '?'
    output = case vote_first_label
            when '?'
              "<span class='text-muted'>#{user.first_and_l}</span>"
            when 'yess'
              badge_user_from_id(user.id)
            when 'noway'
              "<strong><strike>#{user.first_and_l}</strike></strong>"
            when 'maybe'
              "<strong>#{user.first_and_l} ?</strong>"
            end
    output.html_safe
  end

  def new_or_edit_opinion_path(vote)
    if vote.try(:answer_id).nil?
      edit_vote_opinion_path(vote)
    else
      # TODO not tested at all
      new_poll_opinion_vote_opinion_path(vote)
    end
  end
end
