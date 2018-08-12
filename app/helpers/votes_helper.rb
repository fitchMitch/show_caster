module VotesHelper
  def updown_icons
    "#{fa_icon("thumbs-up 2x")}#{ image_tag('transp.png') }#{fa_icon("thumbs-down 2x")}".html_safe
  end

  def new_vote_path(poll)
    if poll.type.nil?
      Rails.logger.fatal("poll without type !")
    else
      if poll.type == 'PollOpinion'
        link_to new_poll_opinion_vote_opinion_path(poll) do
          updown_icons
        end
      elsif poll.type == 'PollDate'
        link_to new_poll_date_vote_date_path(poll) do
          updown_icons
        end
      else
        Rails.logger.debug("poll whith unknown type")
      end
    end
  end

  def others_votes_list(answer, user)
    votes = VoteDate
      .where('poll_id = ?', answer.poll_id)
      .where('answer_id = ?', answer.id)
      .where( 'user_id = ?', user.id)
    v = votes.any? ? votes.first.vote_label : "?"
    that_label = "?"
    if v == that_label
      that_label =  "<span class='text-muted'>#{user.first_and_l}</span>"
    else
      case votes.first.vote_label
      when "yess"
        that_label = badge_user_from_id(user.id)
      when "noway"
        that_label = "<strong><strike>#{user.first_and_l} ?</strike></strong>".html_safe
      when "maybe"
        that_label =  "<strong>#{user.first_and_l} ?</strong>"
      end
    end
    that_label
  end

  def new_or_edit_opinion_path(vote)
    vote.try(:answer_id).nil? ? edit_vote_opinion_path(vote) : new_poll_opinion_vote_opinion_path(vote) #TODO not tested at all
  end
end
